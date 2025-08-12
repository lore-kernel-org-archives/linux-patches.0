Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7142F5E;
	Tue, 12 Aug 2025 18:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022440; cv=none; b=iDSMYCajlKQKplWR70heLh6Q+lV/0b56q92N+kVjxZtTYYBLRP5DIw2s9n8VlE5FTG7DsjH+h+ZZhWNJgxIjV89YI4vX23IGb7QH8ILGrLXhYbA/MEOtEuwYESxPrUkku1x+VGPwtmYX+agiMDsfI/5ScqIsqRHnUUGWEopYpRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022440; c=relaxed/simple;
	bh=EVFmGHgL1BZ1hhWCCsWYCeUOdhaOIyZ3qPh+TtVS/Hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IBoHWYeJc0zDQHwAPpcNljtkjMT+/RNejb9aKTi/XiJJAQgf9exzlHgwKAaJmUrWWBOa8Yx9lt+d5CCqjWZhV/oT2ZDFRKZYQxGWjN4nHCN/IId4jwYhkR+FvRQxClw3gk1zKFnT7MGSlIvPKQXnWf9Kp79qzxDVvbBpUAnmw5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XyQca4By; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XyQca4By"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F41FC4CEF0;
	Tue, 12 Aug 2025 18:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022438;
	bh=EVFmGHgL1BZ1hhWCCsWYCeUOdhaOIyZ3qPh+TtVS/Hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XyQca4ByG/LDSph/ZTpn273to65Vr4t/Ol+dauNylKnCmr6v4ShA2o9t86/3h9sxv
	 g3Toa3tHBtExU9xyqOoW6XM1+NgFUY3SJXS9VlahH1HlGsnV/ZKewIr585VUjjLGh0
	 /KTa49loV+TsuuP5vUFsvn0qs7Qsk50gomhsXnUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 156/369] crypto: qat - use unmanaged allocation for dc_data
Date: Tue, 12 Aug 2025 19:27:33 +0200
Message-ID: <20250812173020.640171995@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>

[ Upstream commit 4cc871ad0173e8bc22f80e3609e34d546d30ef1a ]

The dc_data structure holds data required for handling compression
operations, such as overflow buffers. In this context, the use of
managed memory allocation APIs (devm_kzalloc() and devm_kfree())
is not necessary, as these data structures are freed and
re-allocated when a device is restarted in adf_dev_down() and
adf_dev_up().

Additionally, managed APIs automatically handle memory cleanup when the
device is detached, which can lead to conflicts with manual cleanup
processes. Specifically, if a device driver invokes the adf_dev_down()
function as part of the cleanup registered with
devm_add_action_or_reset(), it may attempt to free memory that is also
managed by the device's resource management system, potentially leading
to a double-free.

This might result in a warning similar to the following when unloading
the device specific driver, for example qat_6xxx.ko:

    qat_free_dc_data+0x4f/0x60 [intel_qat]
    qat_compression_event_handler+0x3d/0x1d0 [intel_qat]
    adf_dev_shutdown+0x6d/0x1a0 [intel_qat]
    adf_dev_down+0x32/0x50 [intel_qat]
    devres_release_all+0xb8/0x110
    device_unbind_cleanup+0xe/0x70
    device_release_driver_internal+0x1c1/0x200
    driver_detach+0x48/0x90
    bus_remove_driver+0x74/0xf0
    pci_unregister_driver+0x2e/0xb0

Use unmanaged memory allocation APIs (kzalloc_node() and kfree()) for
the dc_data structure. This ensures that memory is explicitly allocated
and freed under the control of the driver code, preventing manual
deallocation from interfering with automatic cleanup.

Fixes: 1198ae56c9a5 ("crypto: qat - expose deflate through acomp api for QAT GEN2")
Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/qat_compression.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_compression.c b/drivers/crypto/intel/qat/qat_common/qat_compression.c
index 7842a9f22178..2c3aa89b316a 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_compression.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_compression.c
@@ -197,7 +197,7 @@ static int qat_compression_alloc_dc_data(struct adf_accel_dev *accel_dev)
 	struct adf_dc_data *dc_data = NULL;
 	u8 *obuff = NULL;
 
-	dc_data = devm_kzalloc(dev, sizeof(*dc_data), GFP_KERNEL);
+	dc_data = kzalloc_node(sizeof(*dc_data), GFP_KERNEL, dev_to_node(dev));
 	if (!dc_data)
 		goto err;
 
@@ -235,7 +235,7 @@ static void qat_free_dc_data(struct adf_accel_dev *accel_dev)
 	dma_unmap_single(dev, dc_data->ovf_buff_p, dc_data->ovf_buff_sz,
 			 DMA_FROM_DEVICE);
 	kfree_sensitive(dc_data->ovf_buff);
-	devm_kfree(dev, dc_data);
+	kfree(dc_data);
 	accel_dev->dc_data = NULL;
 }
 
-- 
2.39.5



