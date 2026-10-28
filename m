Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208400;
	b=H2OzqSZCjDTpBbuDA0jOGWtBLpShT6R1c3FDeKmprYOOBavW2nesLGOXdpzkyIw5IJUn
	 byO93XBKjMlTSNXMtlKJAjw/AUjgYp3vq+fhORsOPyJ07dM/GIRoZ0kAEtpwq3GZfXX8R
	 uyvjfqlJp9HvXz769R77UBkt0mQt6i04Hun8ZrNCeUu2hV9jDGCI6aVISOsVpWGn78dAv
	 iThKRJMJKWlGTSGummEogJvY9G5XrIt0sIC0EMBONU3kYEFEMapUiME65Gi9hVRtcjn6Z
	 FyFklWUQUV5jcQtt6hU0cFfsZ9kCxNl5tnSu38Rmd8pXKB8TVbcLLq1TtLjSzYKszlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208400;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qdPHbH8P/ZKj52oZDFLhh33olv353WnafnYNuZkSNGY=;
	b=hq6nJTUZDdJRS9/nw4STz9bn4KDA/Bhrrn2ONzzuZGa8Bk0uzUDhaMQX4WiQzIRucTSV
	 febalHH/257uOQBrhQYYiub/tUFdwVmHeZWxAuLSHC3hDfd5QnFb8c8GeRm74Zw0jHMbw
	 w3+Q1yVn6mGA4aK6XEJ5CJX4gd1Ol0rTmpkvq0sQUfRR9oCxNUhCtXmXziVobucCZohuS
	 8EXKsQRrvyHLYoA6tVgaR7cKpMOJF11g1rr/3SNWKdqEEbDncdAsa0XfFZck5JZd1A95r
	 45e+jPR42KB+yPTw17cnORDaR0j9RVLdv9OFH+rEMinM+YbMepF8BIwAifRNYwrTd0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v+zTB3yA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B0F606A31A;
	Wed, 28 Oct 2026 17:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v+zTB3yA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC61B1F01825;
	Wed, 28 Oct 2026 17:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208400;
	bh=qdPHbH8P/ZKj52oZDFLhh33olv353WnafnYNuZkSNGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v+zTB3yA7ld2Rw4Sh+gcKyVNwm5tvXgd2g5M/Bwq/GaamdyBexUtNRVKxFFi3JiOw
	 EKcJmObUIw/424zyFrbekEa2C0xJRVpywPQCdgvjIlprl74LmIU6VHZY7mUeB0QqFp
	 1Sxfpgp68vL1ANH8LZAxAIP5w0E7fF+QSXeU0wRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Tom Talpey <tom@talpey.com>,
	Stefan Metzmacher <metze@samba.org>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 107/516] smb: client: fix smbd_connection leak on cifs_get_tcp_session() error
Date: Wed, 28 Oct 2026 17:54:19 +0100
Message-ID: <20261028170006.051548113@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit e75c96157d45e498970158c8f7373d90102e33b9 ]

When an RDMA connection is successfully established via
smbd_get_connection() but cifs_get_tcp_session() later fails (e.g.
kthread_create() returns an error), the error path frees tcp_ses
without first destroying the smbd_connection.

Fix this by calling smbd_destroy() in the out_err cleanup path before
kfree(tcp_ses).  smbd_destroy() safely handles the case where
smbd_conn is NULL, so it can be called unconditionally.

Closes: https://sashiko.dev/#/patchset/20260912165503.521597-1-pc%40manguebit.org
Fixes: 2f8946464b11 ("CIFS: SMBD: Upper layer connects to SMBDirect session")
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: Stefan Metzmacher <metze@samba.org>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index a95b9d2318fa2..db54cbbe8cc5e 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2676,6 +2676,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 			kfree(tcp_ses->hostname);
 		if (tcp_ses->ssocket)
 			sock_release(tcp_ses->ssocket);
+		smbd_destroy(tcp_ses);
 		kfree(tcp_ses);
 	}
 	return ERR_PTR(rc);
-- 
2.53.0



