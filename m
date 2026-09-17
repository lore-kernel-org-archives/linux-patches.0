Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0861C4F3936;
	Thu, 17 Sep 2026 15:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660521; cv=none; b=JYxb+jHrUDFHAtdMxyx6M6WQvMgZWVJ6Zqd6Q9o+ZD7O+1PUA+z8MR7Z1h6hZMYgPKq09VqDBv1fcXL6hUh7C4mRI1w55CT855egAlpZqDWXPYjQJYfUTmAhthnmLxffS1e3FkFsCNT4Yfs/7bNanCRM3jVToG6264Ucgl9Ebgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660521; c=relaxed/simple;
	bh=PtfGs2dj1GXP024S+7O20OcIdEJYUarCWwuckA/7fR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SKEnbhXmd++27xQ+6pshd4wrzMIsmjXBxjTdDRTkj8wSq36AAdKJFErJ/OxuENzzhCzWBuTek4I2o3IyL4eXrqMuycwfnHl4eu46jSP6+7Ijv/PL4Uoorbo/7uHAd9fPOpx7fpkkCYxJIZScTREv8hgpHFGjmDsLzxSuVI3cNg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Ms83dj5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Ms83dj5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 569051F000FF;
	Thu, 17 Sep 2026 15:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660519;
	bh=aXDl6Yam9/823KUvJ4/jjQSiF7iI97Gcgvwz37CxX6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Ms83dj5ba/dYLaMoRYjb8nxCmfs9pdZ53N7/gb6bCUQJY3ofZCB6qhOJeS/srlxL
	 H5xOYYu1Vvnw9C9/Ph+Pwu311pNZ4bqtjZ2rgxON0KbKXVnwevQGfNRwejPxVH6+Q8
	 po/9N1vuRT6uuEglBEDiVtQ5wPQjLj6uSXKrB45s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 7.2 580/733] s390/crypto: Fix missing scrub of temp buffers with PAES algorithm
Date: Thu, 17 Sep 2026 16:14:48 +0100
Message-ID: <20260917151406.842275906@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harald Freudenberger <freude@linux.ibm.com>

commit 19a218b46b2471d370c11fb52040f36ac8d05d23 upstream.

In function ctr_paes_do_crypt() there is a buffer used to process
remaining bytes < AES_BLOCK_SIZE. This buffer was not scrubbed and
thus could lead to expose of unwanted data. Rework the code to
explicitly scrub the buffer at the end of the function to avoid
exposure of maybe sensitive data.

In function __xts_2keys_prep_param() change the existing scrub to
clean the whole param block instead of just the key field.

Fixes: 6cd87cb5ef6c ("s390/crypto: Rework protected key AES for true asynch support")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Cc: stable@vger.kernel.org # 6.16+
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/crypto/paes_s390.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/s390/crypto/paes_s390.c
+++ b/arch/s390/crypto/paes_s390.c
@@ -1036,6 +1036,7 @@ static int ctr_paes_do_crypt(struct s390
 	}
 
 out:
+	memzero_explicit(buf, sizeof(buf));
 	pr_debug("rc=%d\n", rc);
 	return rc;
 }
@@ -1367,7 +1368,7 @@ static inline int __xts_2keys_prep_param
 		memcpy(param->init, pcc_param.xts, 16);
 	}
 
-	memzero_explicit(pcc_param.key, sizeof(pcc_param.key));
+	memzero_explicit(&pcc_param, sizeof(pcc_param));
 	return rc;
 }
 


