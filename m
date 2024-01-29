Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9957C160881;
	Mon, 29 Jan 2024 17:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548339; cv=none; b=kK9JmE9GJS4QMbncl1+AAXkj63tmk6CtrG/keuBGljt3hP5RjNpoABbj5sAAzrNNVKvEAnHYreFZwrDFL7Tf0yupI2bXBZ1G39d+EHSFZEdFHkYJVkwUukPTtNpkveJb8agpxJkO/JubDTnNbkBpo1zgo1o+Yob/A2ESeIVsCc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548339; c=relaxed/simple;
	bh=dWUT98CDH8jyHTycO3bZyrUF4yT/QpAP5+rFl1cUVyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Osl/PrG0n0tVOaHmukb6eMJNdzCbXdLpvF/rGZLzgvoL9JyUdS1wMugzpt1vGwz/3ZHP1s+wtAetWCHtFtCSq6Tr8K/Qyo+qPG7EIxw7Eh+V7N2YcqXIWjbEAbXl608aKWbtmtZyKex7oh6k9G+dvIDX3OVgU3eKOBb76FTuHgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZEampNUJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZEampNUJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F744C433F1;
	Mon, 29 Jan 2024 17:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548339;
	bh=dWUT98CDH8jyHTycO3bZyrUF4yT/QpAP5+rFl1cUVyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZEampNUJqZZeYOW6SUIc6trbvB0JO5BH9Iz07KKDsw4QrIdnzDvG7ba8AYGwr5jjL
	 m760JL3E3vUxzXCoRWUIXr5lW2GTSA9owHssrXmiUuZyJrSSpHwgeYd3pGu97QVuzy
	 wwa8d8Em1zfnGTOJfyna4RiFvTxNtyl84r8a2fyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 334/346] cifs: fix stray unlock in cifs_chan_skip_or_disable
Date: Mon, 29 Jan 2024 09:06:05 -0800
Message-ID: <20240129170026.302780565@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

[ Upstream commit 993d1c346b1a51ac41b2193609a0d4e51e9748f4 ]

A recent change moved the code that decides to skip
a channel or disable multichannel entirely, into a
helper function.

During this, a mutex_unlock of the session_mutex
should have been removed. Doing that here.

Fixes: f591062bdbf4 ("cifs: handle servers that still advertise multichannel after disabling")
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2pdu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index bfec2ca0f4e6..f5006aa97f5b 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -195,7 +195,6 @@ cifs_chan_skip_or_disable(struct cifs_ses *ses,
 		pserver = server->primary_server;
 		cifs_signal_cifsd_for_reconnect(pserver, false);
 skip_terminate:
-		mutex_unlock(&ses->session_mutex);
 		return -EHOSTDOWN;
 	}
 
-- 
2.43.0



