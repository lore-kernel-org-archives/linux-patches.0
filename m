Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047484;
	b=cb9Yod0ATRgYnDddmxeKwjaNDMO63PNaSzsOvcUhbkgrPTg85DlbXlxXrnmJXfxCvbia
	 fn74xEjxHmbvpNvr4+n2K3qpRqE+TY0o8I2MN1E2Vif8A32C6RFAdNGI2qqKbnz0BcbGp
	 OcBWepyJlAKbCiWrKxMNq0u1/LQCwJb1BhD1rfpqRWFpec7OC1J98+CvL/ZSrkShf+h8z
	 ftQg0I/pclq/6m/qmoA8aMfLUVCeoWmbz7DugRkUIiY16n6jU88gxkSceoEaGvo6WIHZu
	 Zh7Vpdmv1oho1mmk9DCP2cJ0HU/jFw3KLbJbAWBNeX4k015fWy+Ql6V9pHcXWg8go/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047484;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LFi0tSQE98c0oMQhMUbUD+aalKcd0iBLLEanAE/fuNA=;
	b=WMTSyRoqZOApxjVIwMxZcYTWXACShMEYiGq47iud1XUGNHdDO+je0EeJAu0gGZSpidpk
	 MvyCHT4zTtEYHHBL1wKUTc4p9ppHUm4/Vz+wMg6TcnnFkKLiWRsTmbUEwn3Wfqa4Y41Ck
	 vVUbgHbiucLs1jcHlRcfQSyX/nLXYEHrGMxwqWNCGSwv2TBZQiQ8vP9NqjUycWciIQfc3
	 4T1YDt7vF2PVYP1qGkrzDRJJp6bxxzuWhl965DWNjXWhGThY2/eaVKn9ucyuTPRTmcm6n
	 PWrnVHVjWvRy0L5ZillYyHd4+zCdge06rdqjFzvpcsuI1jh56QqbXalTueFE1SpxZuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kR5ORe4y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53EE6606A325;
	Thu, 19 Nov 2026 00:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kR5ORe4y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70ECD1F000C4;
	Thu, 19 Nov 2026 00:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047484;
	bh=LFi0tSQE98c0oMQhMUbUD+aalKcd0iBLLEanAE/fuNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kR5ORe4y/zrgz2Z26GrQsgy87CJiJbq2zCLOwyOSgHAEaDbFVnHb8fNt4SyWDJxkX
	 vQG3DAzyEHxENKEOJQB6lEEZLPFnWDdA2xYKhKxbB1cWJU6PtpQiQsYtQFzjaeSBWT
	 ScY+fk0hS+eD3XW10vYsJLGq+fqxjEF+H8de1ZV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Bridges <icb@fastmail.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1656/2857] ksmbd: do not read past the DACL in the access denied debug message
Date: Wed, 18 Nov 2026 15:44:50 +0100
Message-ID: <20261118150300.958724676@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Bridges <icb@fastmail.org>

[ Upstream commit 8296a64df5448548f410fb246c1d88a93609602b ]

When smb_check_perm_dacl() falls back to the POSIX ACL and then denies
the request, its debug message prints the access mask of the ACE that
the second DACL walk stopped at. On that path the walk ran to the end
of the DACL, so the pointer is one past the last ACE. If the DACL is
the last part of the stored security descriptor, the message reads 4
bytes past the buffer, and KASAN reports a slab-out-of-bounds read in
smb_check_perm_dacl().

Print the requested and allowed masks instead. They are what the check
compares.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
[ sashal: adjusted context for the broader access mask at check_access_bits ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smbacl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index f0ec137e4efce..d3314b516e274 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1626,8 +1626,8 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 check_access_bits:
 	if (granted &
 	    ~(access_bits | FILE_READ_ATTRIBUTES | READ_CONTROL | WRITE_DAC | DELETE)) {
-		ksmbd_debug(SMB, "Access denied with winACL, granted : %x, access_req : %x\n",
-			    granted, le32_to_cpu(ace->access_req));
+		ksmbd_debug(SMB, "Access denied with winACL, requested : %x, allowed : %x\n",
+			    granted, access_bits);
 		rc = -EACCES;
 		goto err_out;
 	}
-- 
2.53.0



