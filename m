Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038779;
	b=gz4K4xyDmHCmMgY2Y+z3yQMP4b65ihSaGT9nTXaCZdQroHUVuCr+aNvifrMLXpmOlK8g
	 Z9hKoTaq+xbu/2US0gS5/Nr6fR+/+sCA24wqw61viDJl7bjBhyuaNxsdiE1g3AyxAcGD7
	 NB+meQbqJ7VexYaSPl1c+2oc0to1RK6e0IJZon6Xnt9kuVEIqTp/uo1rIvHKPv5ToFr8u
	 3BUvpkjaWEG9jWSNZdK1CTeyC+1puItQl1t7nFcfLz8fdIbdl5s0S/c94lUxC4UsKEj7W
	 vvpH4nQXWZU6tRp85TdR9Krj6DL0clqlpxZauNc9EYQnFz4c/AAbJmy9cFz1Y2eS4Qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038779;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GVOdyMWfrphCiIH9Rl1xwDYUT2Rk6OQHay+/jhMn/ys=;
	b=QwyIPKQZzmvzFYhSzBJvzHYwH//ksSDzJ/HYOTJdRVj1d5Zx2nVQOQxqmwpp0KGoa0q/
	 4aiXZN9IQ5CycBhEBC7hPXDrwxAE7T8I0+xdCU0hdLU1HkCAr6JsmQfXdeswMPgz5buP0
	 zg1oxcNp497SHHa2YD42HTNilR6r9v5JhsabfCkkH2gbRvRgZaSGuolVi7M7P2MdhKsjs
	 GfKpThBv0t/X6H7gexNlIixevEvKzJXPqJMhdYJB7LQiciftZafnUKxxFM6VxeqOYZeIe
	 HQdywznscx+zXNSBkCulw349FbLtEbjHSWBR+QOGj6nh64GATLl81nhB/47IeW/gJSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AM0P9ad8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C0D606A31C;
	Wed, 18 Nov 2026 21:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AM0P9ad8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD1E1F000C4;
	Wed, 18 Nov 2026 21:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038779;
	bh=GVOdyMWfrphCiIH9Rl1xwDYUT2Rk6OQHay+/jhMn/ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AM0P9ad8b9J6T/2ktVxyC3PrcuEcbRtErFx3Eig2UnZE9mmLncESs+YRgG/QSTWxt
	 LP+lECHUdVuwRoMply0eeM8rvwR63lVmKBFB2Ge2zC2C/NrwALCNVZN6szogYuaQsT
	 ync37/DQTBZcn6KIgav2RZs32oXnhyvrAxJ/UdUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Bridges <icb@fastmail.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1863/3318] ksmbd: revert fsids on durable reconnect and replay failure
Date: Wed, 18 Nov 2026 15:41:25 +0100
Message-ID: <20261118150417.809193143@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Bridges <icb@fastmail.org>

[ Upstream commit 539223f18026448f67d33d09719c355b91db7fd0 ]

On a durable handle reconnect or a request replay, smb2_open() switches
to the SMB user's fsids before calling ksmbd_vfs_getattr(). If that call
fails, the code jumps to err_out2 and skips ksmbd_revert_fsids() at
err_out1. The user's credentials then stay installed on the shared ksmbd
worker. Later work on that worker, including other users' requests, runs
with the first user's fsuid, fsgid and supplementary groups.
ksmbd_free_work_struct() also warns, because work->saved_cred is still
set.

Jump to err_out1 instead. No path is held at this point, so skipping the
path_put() at err_out is correct.

Fixes: c8efcc786146 ("ksmbd: add support for durable handles v1/v2")
Fixes: bb8bf7eb13b5 ("ksmbd: add SMB3 request replay support")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
[ sashal: omitted the durable reconnect error-path hunk in smb2_open() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b05774050e096..984e194d83f85 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3101,7 +3101,7 @@ int smb2_open(struct ksmbd_work *work)
 
 			rc = ksmbd_vfs_getattr(&fp->filp->f_path, &stat);
 			if (rc)
-				goto err_out2;
+				goto err_out1;
 
 			goto reconnected_fp;
 		}
-- 
2.53.0



