Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8841D46A60E;
	Tue, 21 Jul 2026 19:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662397; cv=none; b=lkzDTxmp4FFVqbflm7UQZnAH4BcmrTnCPUQ3f6cchLzob73JEJuGpGGgrOoxqXNHRGW2Qk0CyLr1aP2MezqNRtK8tP+TIVs0+odxpfU3qp8TICrM3oTUYouoR64LPiDljdh5T0PrfIsVj9qxq4qI5qXTFW9dW/Zhk8xy+8O3KWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662397; c=relaxed/simple;
	bh=4mPy3pnxsiGmgh8zmP7il7JeS427hoDBELbK6odoZUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cGXlTy/Zg6wkmZ1l6Cdo5sPDsP3dyPzCpjbFDRNPaaGrTCti/iJ1jNw5gTdmUKfUzS0I522sVZw257BpWKVXG0w0XmBNw3ZYyLd8QKYqgP4L9oY/6hIVZ4WYIhJfj8Rc38tlELsODhvtdwutKU9113io2AOfq++pnJwiqRsRT+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fNJti0hP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fNJti0hP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E84071F000E9;
	Tue, 21 Jul 2026 19:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662396;
	bh=hxQkh7wDlnoYHWm7lBHtg/qsMzWfp/HA8xBMkrczH2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fNJti0hPWkf1XXrRxMv7pbxi/S45ziMVx7a63pZZUqdzxl829pVkvM9Ty6gUMM/Mo
	 rEHOdN8xYRIi4nto2KieyhvWHauvwcO11yeFAZjMOAg/jT6pkMpH8QC4OwfUa4nPgT
	 5wzwIJOe3hjnCUAXoRxq48EqusRWJe9JHAHEIHSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Gan <jie.gan@oss.qualcomm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0430/1276] coresight: Fix source not disabled on idr_alloc_u32 failure
Date: Tue, 21 Jul 2026 17:14:33 +0200
Message-ID: <20260721152455.725796994@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Jie Gan <jie.gan@oss.qualcomm.com>

[ Upstream commit ea2c2b9e2a66e2b4aa0455b2d70058e2f0ea4d23 ]

In coresight_enable_sysfs(), for non-CPU sources (SOFTWARE, TPDM,
OTHERS), the source device is enabled via coresight_enable_source_sysfs()
before idr_alloc_u32() maps the path. If idr_alloc_u32() fails, the
original code jumped directly to err_source, which only calls
coresight_disable_path() and coresight_release_path(). The source device
was left enabled with an incremented refcnt but no path tracked for it,
leaving the device in an inconsistent state.

Disable the source before jumping to err_source so the enable and path
operations are fully unwound.

Fixes: 5c0016d7b343 ("coresight: core: Use IDR for non-cpu bound sources' paths.")
Signed-off-by: Jie Gan <jie.gan@oss.qualcomm.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20260515-arm_coresight_path_power_management_improvement-v14-1-f88c4a3ecfe9@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-sysfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-sysfs.c b/drivers/hwtracing/coresight/coresight-sysfs.c
index a01c9e54e2edbb..f26dcb7a42a578 100644
--- a/drivers/hwtracing/coresight/coresight-sysfs.c
+++ b/drivers/hwtracing/coresight/coresight-sysfs.c
@@ -238,8 +238,10 @@ int coresight_enable_sysfs(struct coresight_device *csdev)
 		 */
 		hash = hashlen_hash(hashlen_string(NULL, dev_name(&csdev->dev)));
 		ret = idr_alloc_u32(&path_idr, path, &hash, hash, GFP_KERNEL);
-		if (ret)
+		if (ret) {
+			coresight_disable_source_sysfs(csdev, NULL);
 			goto err_source;
+		}
 		break;
 	default:
 		/* We can't be here */
-- 
2.53.0



