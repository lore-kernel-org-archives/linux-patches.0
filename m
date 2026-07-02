Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E5E23EAAD;
	Thu,  2 Jul 2026 16:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011297; cv=none; b=lLCHQpy2qQ8XUH3AraYI1freylAUWJFh2DRDbBdGIRNKxG50zfD4Q6Dp/JDdpavqqBJSMyqo5YvX+f6VMGXOp8oOGek3ZFvEsb4snaHi4cb6HQ5CJvlyDXi/L+ZuGdMUWXEpvj5vWq1nnICzsctgM6iRsC+HNl6hWY91AxUDnog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011297; c=relaxed/simple;
	bh=GodmvTqaaWEKz5vUuNEqLd7aKI7H3hBVMwXk3UC6m5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LJhIxZqwW5KBWlAeeiG5c2pPLprrVrsrYzTxDYOUIcTsE8rbvyU0figd7B5na6DsBLuzbQzRr7yQTrcJ11bTGUXnT6RSjWgILEk55lgxW3GTFPLvqPbT0ljOt9ctez+nkTPWc1pion6qv8YA5T4mPlNg2o2BYC4o5W6XVwtrgAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jhgQkZkl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jhgQkZkl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27DA61F000E9;
	Thu,  2 Jul 2026 16:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011296;
	bh=3NBjw7atJU6dsgOFdi+YNpi+5jVk8yKU62EhE4+ppms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jhgQkZkl5YEircjYmrJq0ZZ3zTjQiLeayMu82K5Ncv1dnsgySq61Zkl5ekrFACloL
	 6jC3jDBESEqnybiEeAn4x7hvV/0YbtNnOfcI7D/ZNSY4ncgh7mafaHuVRu1vwiNqlK
	 o/dbTzqZ+MpwplVuKfDoN0HfI/V6j3cuBPeVhH30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alessandro Groppo <ale.grpp@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.18 048/108] KEYS: fix overflow in keyctl_pkey_params_get_2()
Date: Thu,  2 Jul 2026 18:20:45 +0200
Message-ID: <20260702155113.103794798@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.110058792@linuxfoundation.org>
References: <20260702155112.110058792@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


