Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA00F2F291B;
	Tue, 12 Aug 2025 18:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024204; cv=none; b=Na/Gf6Ny+B0wMwpVGBJbOBVpFbNiHJ508o6jg/7L3BvlSdTrL4Y3OYN0RSztO8RsVtB9sa1bRf0oGYaKulN7fxRpk2uXpoNKW0pqIy8d2/h6rENECee3eS+a0O+hyPAOmQVbtVK6rYMrvVI1TXrES5R61aaaV1NLDD8ntgk0nlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024204; c=relaxed/simple;
	bh=WweE8xjqWSsbxlBZ6dXJY5uJ8EqjhsFciXgMhrck5kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pCwq+iMXwkjUo13EL1CfRihLxO4MnMnc4NyyU0aEU+SGifFXeU/DoKt3TXC6Kv+IQHHuDeJ8yNh11FYF6EYkifBjo+K09IxHdODw+lsSE2ANW1V/l1C9D+g0sOnb3sdENv3oITdSgkU5fPo9oQARIIf1yqMmuRA/F/W6s2TAh2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0PzqNbB+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0PzqNbB+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52885C4CEF0;
	Tue, 12 Aug 2025 18:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024203;
	bh=WweE8xjqWSsbxlBZ6dXJY5uJ8EqjhsFciXgMhrck5kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0PzqNbB+ZwVuj2oC0hC23vwC9vS1dtqiwNrf73k24Ei+aLp4z5FjHtNpdjpfZRVq2
	 7H+iKbWgzyNkLZXDB0QHP9tN643MWQGGu4PQB5weYZ3nAGPxppSyzOjWcv2j5y8dHF
	 UiICnPVfY0tZDKhOWSluttJzkaLhCqsz1zSQnEUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 303/627] crypto: qat - use unmanaged allocation for dc_data
Date: Tue, 12 Aug 2025 19:29:58 +0200
Message-ID: <20250812173430.839706802@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index c285b45b8679..0a77ca65c8d4 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_compression.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_compression.c
@@ -196,7 +196,7 @@ static int qat_compression_alloc_dc_data(struct adf_accel_dev *accel_dev)
 	struct adf_dc_data *dc_data = NULL;
 	u8 *obuff = NULL;
 
-	dc_data = devm_kzalloc(dev, sizeof(*dc_data), GFP_KERNEL);
+	dc_data = kzalloc_node(sizeof(*dc_data), GFP_KERNEL, dev_to_node(dev));
 	if (!dc_data)
 		goto err;
 
@@ -234,7 +234,7 @@ static void qat_free_dc_data(struct adf_accel_dev *accel_dev)
 	dma_unmap_single(dev, dc_data->ovf_buff_p, dc_data->ovf_buff_sz,
 			 DMA_FROM_DEVICE);
 	kfree_sensitive(dc_data->ovf_buff);
-	devm_kfree(dev, dc_data);
+	kfree(dc_data);
 	accel_dev->dc_data = NULL;
 }
 
-- 
2.39.5



