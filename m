Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B65733B975;
	Thu,  2 Jul 2026 16:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009466; cv=none; b=pfNIJ6NyvA0qycEM5H3co+2PsutWudxPaILRyxHXVeotWDtAyuFp7xnWV20NJ+W3xckYVHe/PmFfm+isx59wCEUSYN61+heTpI3O+Iz4WWSGUnpxMG1JzK8BFVwDFoei3KghLPa+XwxoDVgXKxlz0pcI+R/SJsZFL3ATnh9gFtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009466; c=relaxed/simple;
	bh=IMjTsh8RrN+CBuWbFFsHqe1DAMFkw12y9Ja8oJDs0ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQnWgAHYv9Q2QxW4YQ3UpZtEhP1smOLaKXpvbvcyasL0QnTbN9mPV01qx6PIkpLl5x8fXu1XkFR2C1v1b8inxIZmCaryANh4fKh6LRiY1ha9oEXVtIQOxUqIWFaPWwdNFRFzAQazmepGupjDVChpfGKpZGSFdKnsF9dh2uji5sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jDeuiz0x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jDeuiz0x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A3C1F00A3D;
	Thu,  2 Jul 2026 16:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009463;
	bh=QKC8JNYZcHWYFko7OP8gnuxxsYBHdcpoVEGL7GICTEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jDeuiz0x71EnwAYL/FhJ5zIpWmCHIHxWaKa5aX9NbECsMSSI7f/Xe1fex6bta3SbK
	 2OcNWXzR6ttAog6oTlyYKM4sOQGS3zvRRyTdCeB3i8LJV54j3AQS6Gz3BoByFlRxvm
	 axbMkNbaKzgYEJenEbzqf8uBywWG3oDN2CHlEamU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alessandro Groppo <ale.grpp@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.10 62/96] KEYS: fix overflow in keyctl_pkey_params_get_2()
Date: Thu,  2 Jul 2026 18:19:54 +0200
Message-ID: <20260702155110.285249834@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155108.949633242@linuxfoundation.org>
References: <20260702155108.949633242@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarkko Sakkinen <jarkko@kernel.org>

commit cb481e59ea6cae3b7796ac1d7a22b6b24c3f3c0b upstream.

The length for the internal output buffer is calculated incorrectly, which
can result overflow when a too small buffer is provided.

Fix the bug by allocating internal output with the size of the maximum
length of the cryptographic primitive instead of caller provided size.

Link: https://lore.kernel.org/keyrings/20260531024914.3712130-1-jarkko@kernel.org/
Cc: stable@vger.kernel.org # v4.20+
Fixes: 00d60fd3b932 ("KEYS: Provide keyctls to drive the new key type ops for asymmetric keys [ver #2]")
Reported-by: Alessandro Groppo <ale.grpp@gmail.com>
Tested-by: Alessandro Groppo <ale.grpp@gmail.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/keys/keyctl_pkey.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/security/keys/keyctl_pkey.c
+++ b/security/keys/keyctl_pkey.c
@@ -138,28 +138,35 @@ static int keyctl_pkey_params_get_2(cons
 		if (uparams.in_len  > info.max_dec_size ||
 		    uparams.out_len > info.max_enc_size)
 			return -EINVAL;
+
+		params->out_len = info.max_enc_size;
 		break;
 	case KEYCTL_PKEY_DECRYPT:
 		if (uparams.in_len  > info.max_enc_size ||
 		    uparams.out_len > info.max_dec_size)
 			return -EINVAL;
+
+		params->out_len = info.max_dec_size;
 		break;
 	case KEYCTL_PKEY_SIGN:
 		if (uparams.in_len  > info.max_data_size ||
 		    uparams.out_len > info.max_sig_size)
 			return -EINVAL;
+
+		params->out_len = info.max_sig_size;
 		break;
 	case KEYCTL_PKEY_VERIFY:
 		if (uparams.in_len  > info.max_data_size ||
 		    uparams.in2_len > info.max_sig_size)
 			return -EINVAL;
+
+		params->out_len = info.max_sig_size;
 		break;
 	default:
 		BUG();
 	}
 
 	params->in_len  = uparams.in_len;
-	params->out_len = uparams.out_len; /* Note: same as in2_len */
 	return 0;
 }
 


