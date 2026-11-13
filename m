Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585454;
	b=QF3saXVKRkTUjRy7WO0fU1wZfvTWPm+5x0pkt+YGRi0tyk9q/3n08bB6ir6CHU3SDuYo
	 iigijr/VLA1vwscqMIdV/sbppbG7fCcLu84TS3MLbMVsCLYK3O0riRIbrVaCMyf4z6aoe
	 xlkP62igL6ZL6dCdwxjY+D+drAqH/AwlmpzbzW6OOjArpbqjB+PoD9Calf5szeG3sm1lB
	 H2TRgH0mofDiFn15fqUcRzvuoNo8iHTTvFQLso08MgN4+7s3wGmftxcPdSd5M4vLbITCb
	 2a5yZ7dddeH68YsJbVIP4MUSoZfCymTYuwcityPVLRqNO/hatiVrKy9tLPrZnn9T6+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585454;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IydDwUYnZ7NBcfGyEbGbq2S7w5ybG0Jjx0JDisPx8Bc=;
	b=UePOV68oe9jBPOaO9bjUUCiH/cUoF5/X1WeDJTEsGOnQNNqFBuj9If51dm6oMHPc6Fgq
	 pzrkAjElMB317T1rU9nthLElJqrkvnMC3AVpRtqAWVHfhWC/gMpDAh55dN/jE/XAMJeYg
	 YAyWk++J7gh8xhP/f6UE01MiF7m07HJ5lW8ZrBpzyZiv/he18fS6dukOcmGXvWvqbmjm/
	 gcttn9pRGq9l/RDeMIZfq3U5O1DPBhuiSId00DSqNnj9hgG3/qRuxNZtRmos57WNnMNBa
	 ZYWbZL4rvfhn78pBgh7ObFW/Dpte55sUcrM8Ba8QT8iRRq/f+ncP7TtGY+h/UOtbldw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RnF5sQeI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A98A60A6F43;
	Fri, 13 Nov 2026 15:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RnF5sQeI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 160DF1F000C4;
	Fri, 13 Nov 2026 15:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585454;
	bh=IydDwUYnZ7NBcfGyEbGbq2S7w5ybG0Jjx0JDisPx8Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RnF5sQeIAOq1z1yz7FxTXEHgA5cHK4yV9pGD2JxewHfzTcQrEg8cB1lAioXl3kLsK
	 L+aoiC/JAEc61Owu/C8E27E0uHXWMBhvDVgevIrjIknbNXZfGf4sD7vI0gsBVFfM9m
	 BNbPIgeCsy5K81KIVrjV1KExIVKBgIi2oEbgO0Ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Bridges <icb@fastmail.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 113/507] ksmbd: revert fsids on durable reconnect and replay failure
Date: Fri, 13 Nov 2026 10:46:57 -0500
Message-ID: <20261113153758.157994907@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index abdbe54a2c04a..1c8037c85de95 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4432,7 +4432,7 @@ int smb2_open(struct ksmbd_work *work)
 			file_info = FILE_OPENED;
 			rc = ksmbd_vfs_getattr(&fp->filp->f_path, &stat);
 			if (rc)
-				goto err_out2;
+				goto err_out1;
 
 			goto reconnected_fp;
 		}
@@ -4462,7 +4462,7 @@ int smb2_open(struct ksmbd_work *work)
 
 			rc = ksmbd_vfs_getattr(&fp->filp->f_path, &stat);
 			if (rc)
-				goto err_out2;
+				goto err_out1;
 
 			goto reconnected_fp;
 		}
-- 
2.53.0



