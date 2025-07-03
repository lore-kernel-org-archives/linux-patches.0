Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D353B2E7649;
	Thu,  3 Jul 2025 15:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554908; cv=none; b=JW6IV+k1GSk+HbjdQjHvTSBqkF7HdJTuTBFmAhwdLTwJ6okjMuJOpWNuBd5a3ivRlfW4vo5qHkMQgLp3So9id+JUqbpTJGm6FMT5UGaYrJHRSkgyv27jRIkFSa/ql5a2tZ7i3sUb6n5woNmHgvMXiILwype7EGdxenL4ysyRASk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554908; c=relaxed/simple;
	bh=3G6xCF9gZ0GKtslKKwBR4iYdPifgQaC6mcX3Iu8bAvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OVOfOoI3oG6q6a8l7oTGtALZylk42ipDu/0d9xWz0XBLDmlBR5DtJPlzgtcGHPh/xOH+AYJAcIuMhrKMPBDzp7lHXWXrIuCMG76jWeiuCuWBWxjOI/QAr2WMedHvbLPKLnMhlQ8aZZcHnmZBExtqLqAbssE6vdrrR4OTFvIbEiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pQ0QHFOe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pQ0QHFOe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F472C4CEE3;
	Thu,  3 Jul 2025 15:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554908;
	bh=3G6xCF9gZ0GKtslKKwBR4iYdPifgQaC6mcX3Iu8bAvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pQ0QHFOeIiauLnESi+64cjIWvR/knA1zcLY2ddgLP/f0P4BTkgXrNtAdTgqYLSXpY
	 dHdNs6GTAS6XnhpT6dfa9Wm1k/JaB1SM4k8uhquqFTTjGyA4DjTm++/Da1jpa/6+MV
	 ynvr+25mp6dHsWsTK/VirrQxanuTeKpqjUTXs8Aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Holger Dengler <dengler@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 6.15 116/263] s390/pkey: Prevent overflow in size calculation for memdup_user()
Date: Thu,  3 Jul 2025 16:40:36 +0200
Message-ID: <20250703144008.994854217@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

commit 7360ee47599af91a1d5f4e74d635d9408a54e489 upstream.

Number of apqn target list entries contained in 'nr_apqns' variable is
determined by userspace via an ioctl call so the result of the product in
calculation of size passed to memdup_user() may overflow.

In this case the actual size of the allocated area and the value
describing it won't be in sync leading to various types of unpredictable
behaviour later.

Use a proper memdup_array_user() helper which returns an error if an
overflow is detected. Note that it is different from when nr_apqns is
initially zero - that case is considered valid and should be handled in
subsequent pkey_handler implementations.

Found by Linux Verification Center (linuxtesting.org).

Fixes: f2bbc96e7cfa ("s390/pkey: add CCA AES cipher key support")
Cc: stable@vger.kernel.org
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Link: https://lore.kernel.org/r/20250611192011.206057-1-pchelkin@ispras.ru
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/pkey_api.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/s390/crypto/pkey_api.c
+++ b/drivers/s390/crypto/pkey_api.c
@@ -85,7 +85,7 @@ static void *_copy_apqns_from_user(void
 	if (!uapqns || nr_apqns == 0)
 		return NULL;
 
-	return memdup_user(uapqns, nr_apqns * sizeof(struct pkey_apqn));
+	return memdup_array_user(uapqns, nr_apqns, sizeof(struct pkey_apqn));
 }
 
 static int pkey_ioctl_genseck(struct pkey_genseck __user *ugs)


