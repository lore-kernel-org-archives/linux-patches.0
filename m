Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C831420A2;
	Tue, 27 Feb 2024 13:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040567; cv=none; b=C7nykPMn+Kj+WB6gVquQyPzBMyfaGXI5H8j4yX2UsWlOqa6TSsD1SOyPmr0Aliw63D6HUHAuCqqMTIuXTnsW8DjNs8wcWlqfOxnamedP9ZVvXq3rbrabGayNp+fdud2Bt85tWq1dZYY9S7fu90NI3glBreJe7IZlNK7YN0nA9Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040567; c=relaxed/simple;
	bh=2gkuU4OGZJSQhnw0inBmYIe/aEqO/9KN9OL8xt2QplI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kd3weYGx55mGHMTYo/PASwGZ4awDabqjTIyGfSXRonslrSOBbY+yqrgh5W2b5xIaHKjFjh4QMndPeQQekRu4puASpwxjFDGwONsryvsp+IQtpogO+RZq4qoiM+gRxrgn4ETTqPpvkQQwlmeLJCsNpTtRRV+AYrLHVJQN0jsqwG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JmjN8SM2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JmjN8SM2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24608C43394;
	Tue, 27 Feb 2024 13:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040567;
	bh=2gkuU4OGZJSQhnw0inBmYIe/aEqO/9KN9OL8xt2QplI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JmjN8SM2flsjuutxwA+6X7UarhujvGSVJaQv4sULxvEhRcZqksuA2rK4lf5RW4oli
	 DNbjfR0v5TBsC3oR8TNSdU9Cm3QvGwHM+2HtWbB7spM0NTzMCgejfaWZrcrSbEpyt+
	 OvIRf9TJLaoSmQCeRS7DvB9PAFRaZB2clNKZJ5rY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 023/334] cifs: cifs_pick_channel should try selecting active channels
Date: Tue, 27 Feb 2024 14:18:01 +0100
Message-ID: <20240227131631.354226136@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



