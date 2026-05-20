Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F6A3F65E6;
	Wed, 20 May 2026 18:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300558; cv=none; b=REMKAjNXJFUhPPSjfpSoDjZkLezIV2z1apBsLS++t2gT3cbBeKjxSuhwwObBFmYJfX7NQ2tXIy8Knujr7NKOxZyhoXfsBUK+emum1BWCfgFPb++2kFovmrUJmLm+m8FNfNS8YsrlS3u3ePu4u1eo6qCQNk2dpL306FQGb4fzGWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300558; c=relaxed/simple;
	bh=qJGQhPF7NAo0KjTkL3oMNxGumeRflEJxFDR2VNvGVjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SnlwQumBgCOMujbJ2ZK3klnKRbbcgPs9TVeMkQfrLCUUUJuMt0E1OcwWx4xruYCjbw+JOoi2xUK9K+6q2qJVPm7We3NKM7BjVR0p1uuGnU6OZbARLtvMlZOd3FNL5GaoP6BbXsVgIwqB+VzPifqTeWLxpAiC9Eg5S2PcadxLkZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1vyd5zw6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1vyd5zw6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B02F1F000E9;
	Wed, 20 May 2026 18:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300557;
	bh=PJY9aoT0OJ/DGXRM1YefqCslhBOzXBX5b812Be1qUdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1vyd5zw6hCUrogOWpeAgUliHtm5EdltU36eOSjuKIezmcDeDFP1QdkRIjQgBKBbh7
	 /3hA19aanwmnz+rJA4U4boh5ucHVzB8DujxQvTaBSM8Y5fjNjaVStdeF1Xm42xiI0v
	 5N9OEoSp1rtVSFWmuAwL7h/P7VtqPoCgV/cdKMxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 221/666] crypto: qat - fix type mismatch in RAS sysfs show functions
Date: Wed, 20 May 2026 18:17:12 +0200
Message-ID: <20260520162116.000070829@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit ec23d75c4b77ae42af0777ea59599b1d4f611371 ]

ADF_RAS_ERR_CTR_READ() expands to atomic_read(), which returns int.
The local variable 'counter' was declared as 'unsigned long', causing
a type mismatch on the assignment. The format specifier '%ld' was
consequently wrong in two ways: wrong length modifier and wrong
signedness.

Use int to match the return type of atomic_read() and update the
format specifier to '%d' accordingly.

Fixes: 532d7f6bc458 ("crypto: qat - add error counters")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../intel/qat/qat_common/adf_sysfs_ras_counters.c    | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_sysfs_ras_counters.c b/drivers/crypto/intel/qat/qat_common/adf_sysfs_ras_counters.c
index e97c67c87b3cf..6abb57bfd3285 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sysfs_ras_counters.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sysfs_ras_counters.c
@@ -13,14 +13,14 @@ static ssize_t errors_correctable_show(struct device *dev,
 				       char *buf)
 {
 	struct adf_accel_dev *accel_dev;
-	unsigned long counter;
+	int counter;
 
 	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
 	if (!accel_dev)
 		return -EINVAL;
 
 	counter = ADF_RAS_ERR_CTR_READ(accel_dev->ras_errors, ADF_RAS_CORR);
-	return scnprintf(buf, PAGE_SIZE, "%ld\n", counter);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", counter);
 }
 
 static ssize_t errors_nonfatal_show(struct device *dev,
@@ -28,14 +28,14 @@ static ssize_t errors_nonfatal_show(struct device *dev,
 				    char *buf)
 {
 	struct adf_accel_dev *accel_dev;
-	unsigned long counter;
+	int counter;
 
 	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
 	if (!accel_dev)
 		return -EINVAL;
 
 	counter = ADF_RAS_ERR_CTR_READ(accel_dev->ras_errors, ADF_RAS_UNCORR);
-	return scnprintf(buf, PAGE_SIZE, "%ld\n", counter);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", counter);
 }
 
 static ssize_t errors_fatal_show(struct device *dev,
@@ -43,14 +43,14 @@ static ssize_t errors_fatal_show(struct device *dev,
 				 char *buf)
 {
 	struct adf_accel_dev *accel_dev;
-	unsigned long counter;
+	int counter;
 
 	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
 	if (!accel_dev)
 		return -EINVAL;
 
 	counter = ADF_RAS_ERR_CTR_READ(accel_dev->ras_errors, ADF_RAS_FATAL);
-	return scnprintf(buf, PAGE_SIZE, "%ld\n", counter);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", counter);
 }
 
 static ssize_t reset_error_counters_store(struct device *dev,
-- 
2.53.0



