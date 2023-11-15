Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651E33DBBF
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rseNpShj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A58C433C9;
	Wed, 15 Nov 2023 19:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076577;
	bh=WVpHQzROduxxs05jTAZT0O+eKIy4iL6P583hJ2h8gpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rseNpShjQmpkTY07Fy+RhyIPRgQoTL49vngMRLYTxjxKpc2u1c74FO8XKolbbJPT1
	 NZ13zXqpBBilu8oD5/YLh51WhLhXlgM8XdPb9uNNA6hTAyQGwtpLpcqokbZV0d3rv6
	 E/B4HGpbXp8YwPwJ8REURi32+3Jn3G+GgdAypniM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Adam Guerin <adam.guerin@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 317/550] crypto: qat - ignore subsequent state up commands
Date: Wed, 15 Nov 2023 14:15:01 -0500
Message-ID: <20231115191622.750809088@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit 9c20cb8b1847dedddec3d5163079290542bf00bf ]

If the device is already in the up state, a subsequent write of `up` to
the sysfs attribute /sys/bus/pci/devices/<BDF>/qat/state brings the
device down.
Fix this behaviour by ignoring subsequent `up` commands if the device is
already in the up state.

Fixes: 1bdc85550a2b ("crypto: qat - fix concurrency issue when device state changes")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Adam Guerin <adam.guerin@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/adf_sysfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_sysfs.c b/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
index a8f33558d7cb8..8880af1aa1b5b 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
@@ -68,7 +68,9 @@ static ssize_t state_store(struct device *dev, struct device_attribute *attr,
 		dev_info(dev, "Starting device qat_dev%d\n", accel_id);
 
 		ret = adf_dev_up(accel_dev, true);
-		if (ret < 0) {
+		if (ret == -EALREADY) {
+			break;
+		} else if (ret) {
 			dev_err(dev, "Failed to start device qat_dev%d\n",
 				accel_id);
 			adf_dev_down(accel_dev, true);
-- 
2.42.0



