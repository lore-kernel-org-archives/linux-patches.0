Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA2030C141;
	Thu,  2 Jul 2026 16:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011148; cv=none; b=G52LchjNQkTlzWuGj0b5xmPa5JrWt8O4aMu1ru/S0KHGGWz8VNBnb1NAjhHaFOcOh0wPcHJY0eK7Miu20mqXF7AuLPVb7/+zknU67HjyuGqKD4f0QCiKPof00IX8gm3g3AinIBC1Su8UcTUgHDG8S+mot6SXlxuYjK4qtc6EncU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011148; c=relaxed/simple;
	bh=3yOqxkb9GmmWgxkVPNIKhufMZ7tw1qGFclI6Ue4600Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JL0wvQJnxNfjMel4hilZ1mCh/5NHJcQgIJcdBw9QIgeMwgAB0S2ioTR6MaVaFuPvge4tf4yWvq2Un8s4KcfdXnuPp0MOpiUQJdqSaXTwbfwMbLAjsp9O9x9nKPjP2W9tFjfH6w3BlB0jCOgmP+gJuVYE3BYcQQKJBNWzIiQcPPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lwHozzjo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lwHozzjo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE031F00A3A;
	Thu,  2 Jul 2026 16:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011147;
	bh=wrN6XOzJv5HVZKSEs0ZYe+DYoBGcwutoPblbCH5gLtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lwHozzjok+IhF+ilYcwG4WPCcdON23v7Dkmw8+OC7SZRTCScKyjAsH30VOSRLbUgR
	 Iiq+Ea0W5Ulhkse4Bq1ElDw9OwRJoA8oXfXo4OggxMoKulTBrouWlPvuvPtuqMuLqR
	 EMgfodq25Qs0qK2fo+ITtLaRG+FMQC//EPeDm6tQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 173/175] crypto: qat - Replace kzalloc() + copy_from_user() with memdup_user()
Date: Thu,  2 Jul 2026 18:21:14 +0200
Message-ID: <20260702155119.427120162@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

--- a/drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c
@@ -91,17 +91,10 @@ static int adf_ctl_alloc_resources(struc
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


