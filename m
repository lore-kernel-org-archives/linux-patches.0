Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720152DC34C;
	Tue,  8 Jul 2025 16:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993911; cv=none; b=kXrfaPRkLYFWaFId1RwViXBVXW6w6i7IkNW3nkhUj/crDNvm03W7PBc4KmGgP/uYsT6rnN3Ry+C88XsPMScp/VHCCuk4X1gV4WCUFXyMAcbVDFySahtV2o0rdCshOyVQEQrt4PBZruhMFt6VHn71Jo+0AWp5dpXSbz/pSePGEG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993911; c=relaxed/simple;
	bh=S9BlATTaOfhzkEZpMKLkx27SHTSQgGjxINl/FT7Ip3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m6KtJD36jRHDkNKZcn6HjoHSHFoGZAF8BmthJjld9H7+JHhnJexf+D731OggGs/qTI+QmAiXgSAaw5ZhHsZ8sh1M6Q2yRHi8Ha3RAYzHA6KxBfE6YsFZ8wiCPnXU3kJW6aSuvgk2wuYUo8hva/lGGC1cExP8+9McnAXN4TRlA1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dHhCbaRQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dHhCbaRQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1ECFC4CEED;
	Tue,  8 Jul 2025 16:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993911;
	bh=S9BlATTaOfhzkEZpMKLkx27SHTSQgGjxINl/FT7Ip3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dHhCbaRQ5RaWspQonu8tCj2EQn/GBhFjwzcsmqcbNH6q1acxUUx1QxRMLg9+D5072
	 ffHEp5DVOCLhL8YG84duIzeALafRGMpt1q6dt1xpeFW2+YugTKRhtfW3bZJcOVM5yw
	 ZPhk1yBxeSjZMJlfJ8E5MXuGndDH4JCFwLaMkoG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Holger Dengler <dengler@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 5.15 060/160] s390/pkey: Prevent overflow in size calculation for memdup_user()
Date: Tue,  8 Jul 2025 18:21:37 +0200
Message-ID: <20250708162233.212561374@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1134,7 +1134,7 @@ static void *_copy_apqns_from_user(void
 	if (!uapqns || nr_apqns == 0)
 		return NULL;
 
-	return memdup_user(uapqns, nr_apqns * sizeof(struct pkey_apqn));
+	return memdup_array_user(uapqns, nr_apqns, sizeof(struct pkey_apqn));
 }
 
 static long pkey_unlocked_ioctl(struct file *filp, unsigned int cmd,


