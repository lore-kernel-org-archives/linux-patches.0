Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26A3341AC7;
	Thu,  2 Jul 2026 16:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010143; cv=none; b=tirKJFaAaMSY/OfFI36tXgjrDhMoPr0ok7E5I9xFuaswMuyT2E2g93dnH8k+Vf2QsKlGlE2Pxe3JQq+icbG4arsjU1FdSopI+U0fDAhKD/MZr0MZBe/ycQIy1wdRCE1gbjkb5nRKflYyG76nP8aKLxW+7wt/eVm6vnJeQnwtf7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010143; c=relaxed/simple;
	bh=RW9eJlx/LhvfW276yK7+8qAFKyKkfkESYUJg0Ztffvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TAAndzc8/2NAWnWAFiBPcClpxnSE5UQqnlWq9LaVImK310x8YRCW2v9JAuSQpS2k4hqZRPj+D5EwOXg8U+3EGJQChFyJSlngRNcPi/VweXcrVjJTpQDuO/9Xy1NkLRX25KT8NY+OnMDjCFzYueIx+yeXTT7bFAzWQCpiQ7S5/r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=itBAg+jV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="itBAg+jV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5404A1F00A3A;
	Thu,  2 Jul 2026 16:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010140;
	bh=z36T8lBx+UWljlSpweQ1Yz9FS1w5eZmiF7Ap3pMthsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=itBAg+jVnF+m+0gYozzdIs9EOZDZDugd791KbitVPAAxw1Ok7q1zd9j6m1vnvgFFC
	 QYvvdtFqu+k9coMyiwiZKBgN8vPqekn8dRYIz3k/9omcrQnjD6nSbXDamVg2NevOfx
	 OZUcFBdC9I1ZNwSk4XWB0zIMxbovIOKvGkHQFyW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 126/129] crypto: qat - Replace kzalloc() + copy_from_user() with memdup_user()
Date: Thu,  2 Jul 2026 18:20:45 +0200
Message-ID: <20260702155114.759704655@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit 1e26339703e2afd397037defa798682b2b93dcc0 ]

Replace kzalloc() followed by copy_from_user() with memdup_user() to
improve and simplify adf_ctl_alloc_resources(). memdup_user() returns
either -ENOMEM or -EFAULT (instead of -EIO) if an error occurs.

Remove the unnecessary device id initialization, since memdup_user()
(like copy_from_user()) immediately overwrites it.

No functional changes intended other than returning the more idiomatic
error code -EFAULT.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: d237230728c5 ("crypto: qat - remove unused character device and IOCTLs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/qat/qat_common/adf_ctl_drv.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

--- a/drivers/crypto/qat/qat_common/adf_ctl_drv.c
+++ b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
@@ -90,17 +90,10 @@ static int adf_ctl_alloc_resources(struc
 {
 	struct adf_user_cfg_ctl_data *cfg_data;
 
-	cfg_data = kzalloc(sizeof(*cfg_data), GFP_KERNEL);
-	if (!cfg_data)
-		return -ENOMEM;
-
-	/* Initialize device id to NO DEVICE as 0 is a valid device id */
-	cfg_data->device_id = ADF_CFG_NO_DEVICE;
-
-	if (copy_from_user(cfg_data, (void __user *)arg, sizeof(*cfg_data))) {
+	cfg_data = memdup_user((void __user *)arg, sizeof(*cfg_data));
+	if (IS_ERR(cfg_data)) {
 		pr_err("QAT: failed to copy from user cfg_data.\n");
-		kfree(cfg_data);
-		return -EIO;
+		return PTR_ERR(cfg_data);
 	}
 
 	*ctl_data = cfg_data;


