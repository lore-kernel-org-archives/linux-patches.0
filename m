Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229A91CB32E;
	Wed,  2 Oct 2024 13:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877286; cv=none; b=Q2sM1E8s6L3rHiNiGOXZibGxqetC7be7vioo/PKpKMRnD5S9Wdz7dN+FxHPtNyKy3mp6qEo1wuMrjqJiCmzEOfv+FNhmw5YMlEmQmL1n31wba+CVAO7KmxZEzumjfU73TsZXcCABQ8wzVx8UOjjeeykGjzN1rbt4362IIMuaTEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877286; c=relaxed/simple;
	bh=jhysiYH3OQf1cpAXSJU6N8E2YD6fz5Ik+gmolWOsaFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=llzHgBDC8ABdrlUH5RTD1dWXAmXuszZgNgTZcppnQluAwTppjlyF+F7Qom3OQ8sMquTIIZifY4/gRxt8bIfatO7C1geYLYLs76OO+JJZHFWSD8tpeajJos6PWItT0MJD61jiJassqeeqkPhyl/nRu60jsoaevYq4xJO3R16b9Nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EblyrWG8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EblyrWG8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97BEDC4CEFB;
	Wed,  2 Oct 2024 13:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877286;
	bh=jhysiYH3OQf1cpAXSJU6N8E2YD6fz5Ik+gmolWOsaFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EblyrWG8PFInQKdO8DT5rjExwh6VdKl6pkX3wKj/JNBeN2XpIl4o+h48VvFSBhrss
	 ukMP1w/lJoyoFYNURhEjhBasDbcbiKhEouj4UbckSBL4CX6mLupcDHlrvuEiP5PQK6
	 mTOR/Q8CBwo9wvEforvmpGCK4qf6dqvoz4hw3o2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Witwicki <michal.witwicki@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 005/634] crypto: qat - disable IOV in adf_dev_stop()
Date: Wed,  2 Oct 2024 14:51:45 +0200
Message-ID: <20241002125811.299710500@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Witwicki <michal.witwicki@intel.com>

[ Upstream commit b6c7d36292d50627dbe6a57fa344f87c776971e6 ]

Disabling IOV has the side effect of re-enabling the AEs that might
attempt to do DMAs into the heartbeat buffers.
Move the disable_iov() function in adf_dev_stop() before the AEs are
stopped.

Fixes: ed8ccaef52fa ("crypto: qat - Add support for SRIOV")
Signed-off-by: Michal Witwicki <michal.witwicki@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/adf_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_init.c b/drivers/crypto/intel/qat/qat_common/adf_init.c
index 74f0818c07034..55f1ff1e0b322 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_init.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_init.c
@@ -323,6 +323,8 @@ static void adf_dev_stop(struct adf_accel_dev *accel_dev)
 	if (hw_data->stop_timer)
 		hw_data->stop_timer(accel_dev);
 
+	hw_data->disable_iov(accel_dev);
+
 	if (wait)
 		msleep(100);
 
@@ -386,8 +388,6 @@ static void adf_dev_shutdown(struct adf_accel_dev *accel_dev)
 
 	adf_tl_shutdown(accel_dev);
 
-	hw_data->disable_iov(accel_dev);
-
 	if (test_bit(ADF_STATUS_IRQ_ALLOCATED, &accel_dev->status)) {
 		hw_data->free_irq(accel_dev);
 		clear_bit(ADF_STATUS_IRQ_ALLOCATED, &accel_dev->status);
-- 
2.43.0



