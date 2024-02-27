Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9821468F1;
	Tue, 27 Feb 2024 13:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041652; cv=none; b=e85ZqcZevqHLYOqobOO5KPabk72IEaH6UPqlLBHh7zA9WCiuXBih/Cz4AcuKe9NEIDKUB/UQxhTLNqohgnxLTQkK1sPzF9RvtCZrCZB3VOB5DQV36/1NofXDxAM/onQoU+hFtKXaQTGPOiO66uX04op9xCpvPp/ft+I8Clh6EBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041652; c=relaxed/simple;
	bh=5VVdVAND8t/S/j9xyo0N0OgPpiHevQU7ozLrPaxfHmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qDhDIxc+8v7XhN+nYw488YBeThf4NEi5VZea2Sfz/fE8BeSL1s4iHi0WofUsrY1q69Dj/QIMbCB9dAutrayHCtZeS0xtiyOYbzZET71DAWYxifHFfOQNVm74cGlkCssGQqaHUJDDcyrJMtsnwTS4MZ6I4qkKMmya/Oktu2HukDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=acCYL3eH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="acCYL3eH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24E5C433C7;
	Tue, 27 Feb 2024 13:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041652;
	bh=5VVdVAND8t/S/j9xyo0N0OgPpiHevQU7ozLrPaxfHmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=acCYL3eHesDwSVQxkMW1GW/2ZfqGNGNmJrHDyJx9r/29hvt3Djjw0/xwb+0B+3xYk
	 GsfUDpYERd/iO4friglyFejzEUo9nQ687aK71NFgJxu+WgvTXW6kMwy0eF+ZtopL6z
	 fW/91x5bJWx2RXaVk27cSqxj92sQXN9QbrShxR3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/299] cifs: cifs_pick_channel should try selecting active channels
Date: Tue, 27 Feb 2024 14:22:14 +0100
Message-ID: <20240227131626.575899569@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit fc43a8ac396d302ced1e991e4913827cf72c8eb9 ]

cifs_pick_channel today just selects a channel based
on the policy of least loaded channel. However, it
does not take into account if the channel needs
reconnect. As a result, we can have failures in send
that can be completely avoided.

This change doesn't make a channel a candidate for
this selection if it needs reconnect.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/transport.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 4f717ad7c21b4..8695c9961f5aa 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -1026,6 +1026,9 @@ struct TCP_Server_Info *cifs_pick_channel(struct cifs_ses *ses)
 		if (!server || server->terminate)
 			continue;
 
+		if (CIFS_CHAN_NEEDS_RECONNECT(ses, i))
+			continue;
+
 		/*
 		 * strictly speaking, we should pick up req_lock to read
 		 * server->in_flight. But it shouldn't matter much here if we
-- 
2.43.0



