Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC25B7474
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:35:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F29EC433D2;
	Tue, 10 Jan 2023 18:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673375715;
	bh=J5I9JluBjtCKbXSKLrqvWXsHv8uYX3bcAC4MnfH991g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o5WB6YoUSbWFkLtX8xtwzKJ3mEpXHkkie68t2yhskarC4wtLhpBV6m4p+ijnFWB5p
	 G5VLkwR/FoIJUEVLQaM1YUEdjkjE6S2Vl78khPAAZa6womuViacIL6B7sb7HW0NPyb
	 NfQT2I+5ekRNk5/+XeMqLqCJt5UHYCap/+3F83vY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Liu <will@willsroot.io>,
	=?UTF-8?q?Hrvoje=20Mi=C5=A1eti=C4=87?= <misetichrvoje@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 279/290] ksmbd: check nt_len to be at least CIFS_ENCPWD_SIZE in ksmbd_decode_ntlmssp_auth_blob
Date: Tue, 10 Jan 2023 19:06:11 +0100
Message-Id: <20230110180041.549885304@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: William Liu <will@willsroot.io>

commit 797805d81baa814f76cf7bdab35f86408a79d707 upstream.

"nt_len - CIFS_ENCPWD_SIZE" is passed directly from
ksmbd_decode_ntlmssp_auth_blob to ksmbd_auth_ntlmv2. Malicious requests
can set nt_len to less than CIFS_ENCPWD_SIZE, which results in a negative
number (or large unsigned value) used for a subsequent memcpy in
ksmbd_auth_ntlvm2 and can cause a panic.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: William Liu <will@willsroot.io>
Signed-off-by: Hrvoje Mišetić <misetichrvoje@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/auth.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ksmbd/auth.c
+++ b/fs/ksmbd/auth.c
@@ -319,7 +319,8 @@ int ksmbd_decode_ntlmssp_auth_blob(struc
 	dn_off = le32_to_cpu(authblob->DomainName.BufferOffset);
 	dn_len = le16_to_cpu(authblob->DomainName.Length);
 
-	if (blob_len < (u64)dn_off + dn_len || blob_len < (u64)nt_off + nt_len)
+	if (blob_len < (u64)dn_off + dn_len || blob_len < (u64)nt_off + nt_len ||
+	    nt_len < CIFS_ENCPWD_SIZE)
 		return -EINVAL;
 
 	/* TODO : use domain name that imported from configuration file */


