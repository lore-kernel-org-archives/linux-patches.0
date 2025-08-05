Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D5BE55B;
	Tue,  5 Aug 2025 13:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399531; cv=none; b=dgJC8FH0tMrtNDNp5SaQPaLx0OA7CvQ/tfqscHODUtvlQc5LtMIrSUez4NBTDv5w3utZnDNvQABRfK1pJM8V48t8nmCnrdWraxdoT2gm690EV1PqA5VwwAicROtdpSNwD4wcwYc/DTJPAEdPZ0BumNk/VWH05+6aR3zt7134wes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399531; c=relaxed/simple;
	bh=a0lQpsk/xS1ajJ18OrE+G9s9LSxPGNbwa6Dhcq4b3s8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LAGja557j2VZbYosUND1/EbntSc2svugcmJoiU83pB3+daZyEufYtjRPVJQxpP66lK+vHSQ3t0xl50ePTgZkMVLh2qs0GdFUQftcWEbV7LrDI33rGg8Wf+uXHL5PdcBlYImaK96EnjzQ1G2NSMwMpDJhV6aYBQeF0xJKOA5VuM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=medRtpDS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="medRtpDS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20CBFC4CEF7;
	Tue,  5 Aug 2025 13:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754399531;
	bh=a0lQpsk/xS1ajJ18OrE+G9s9LSxPGNbwa6Dhcq4b3s8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=medRtpDS2eTudlvWUqRKPl4mRPionel5HQnTTm2URRrwBlQZilO21j/4IGNyaf3tu
	 I9RY2+PjQK9UQV5Isc6wQ0+YB6iNXanIZWjDUOY+fZMVlDE4Dx2MVv8D78DDRm/JJ/
	 fwHDOTxY1zKhC2kUmhP0HAsx6HxZNvQ6PnT+TBqky4HExpmmBFu/pTZS4esKewVNBd
	 up9ca4XXSxZ+ur13vtwOe/T3Dz+m14IamGifm7D0jKcBUHitVfvc27ScYSyvFFxBid
	 c8cx1TKDE2CHuArNEzwxzLU5DGTrJA1ySVSRtinONPbZk8fMXozEuWJuvCCdsZwq3+
	 O5y5dBFe6D4ww==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Bharat Bhushan <bbhushan2@marvell.com>,
	Srujana Challa <schalla@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	saikrishnag@marvell.com,
	linux@treblig.org,
	sbhatta@marvell.com,
	krzysztof.kozlowski@linaro.org
Subject: [PATCH AUTOSEL 6.16-5.15] crypto: octeontx2 - add timeout for load_fvc completion poll
Date: Tue,  5 Aug 2025 09:09:38 -0400
Message-Id: <20250805130945.471732-63-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250805130945.471732-1-sashal@kernel.org>
References: <20250805130945.471732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bharat Bhushan <bbhushan2@marvell.com>

[ Upstream commit 2157e50f65d2030f07ea27ef7ac4cfba772e98ac ]

Adds timeout to exit from possible infinite loop, which polls
on CPT instruction(load_fvc) completion.

Signed-off-by: Srujana Challa <schalla@marvell.com>
Signed-off-by: Bharat Bhushan <bbhushan2@marvell.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Let me look at the exact code changes from the diff provided:

**YES**

This commit should be backported to stable kernel trees for the
following reasons:

## Bug Fix Analysis

1. **Critical Bug Fixed**: The commit fixes a **potential infinite
   loop** in the `otx2_cpt_discover_eng_capabilities()` function. The
   original code had:
```c
while (lfs->ops->cpt_get_compcode(result) ==
OTX2_CPT_COMPLETION_CODE_INIT)
    cpu_relax();
```
This loop could spin forever if the hardware fails to respond or gets
stuck.

2. **Real-World Impact**: An infinite loop in kernel space is a severe
   issue that can:
   - Cause system hangs/freezes
   - Make the CPU core unresponsive
   - Prevent proper driver initialization
   - Lead to denial of service conditions

3. **Simple and Contained Fix**: The patch adds:
   - A timeout counter (10000 iterations with 1μs delay = 10ms timeout)
   - Proper error handling with `-ENODEV` return
   - Clear warning message to help diagnose hardware issues
   - Proper cleanup path (`error_no_response` label)

4. **Minimal Risk**: The changes are:
   - Limited to a single function
   - Only add timeout logic without changing the core functionality
   - Include proper error handling and resource cleanup
   - Don't introduce new features or architectural changes

5. **Hardware Interaction Context**: This function polls hardware for
   completion of a CPT (cryptographic processor) instruction. Hardware
   polling without timeouts is a classic source of kernel hangs,
   especially when:
   - Hardware malfunctions
   - Firmware issues occur
   - Power management transitions happen
   - PCIe communication errors occur

6. **Stable Tree Criteria Met**:
   - ✓ Fixes a real bug (infinite loop)
   - ✓ Small change (~20 lines)
   - ✓ No new features added
   - ✓ Low regression risk
   - ✓ Fixes a potential system stability issue

The timeout value of 10ms (10000 × 1μs) is reasonable for hardware
polling operations, providing sufficient time for normal operations
while preventing indefinite hangs in error conditions.

 .../crypto/marvell/octeontx2/otx2_cptpf_ucode.c  | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
index 78367849c3d5..9095dea2748d 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
@@ -1494,6 +1494,7 @@ int otx2_cpt_discover_eng_capabilities(struct otx2_cptpf_dev *cptpf)
 	dma_addr_t rptr_baddr;
 	struct pci_dev *pdev;
 	u32 len, compl_rlen;
+	int timeout = 10000;
 	int ret, etype;
 	void *rptr;
 
@@ -1554,16 +1555,27 @@ int otx2_cpt_discover_eng_capabilities(struct otx2_cptpf_dev *cptpf)
 							 etype);
 		otx2_cpt_fill_inst(&inst, &iq_cmd, rptr_baddr);
 		lfs->ops->send_cmd(&inst, 1, &cptpf->lfs.lf[0]);
+		timeout = 10000;
 
 		while (lfs->ops->cpt_get_compcode(result) ==
-						OTX2_CPT_COMPLETION_CODE_INIT)
+						OTX2_CPT_COMPLETION_CODE_INIT) {
 			cpu_relax();
+			udelay(1);
+			timeout--;
+			if (!timeout) {
+				ret = -ENODEV;
+				cptpf->is_eng_caps_discovered = false;
+				dev_warn(&pdev->dev, "Timeout on CPT load_fvc completion poll\n");
+				goto error_no_response;
+			}
+		}
 
 		cptpf->eng_caps[etype].u = be64_to_cpup(rptr);
 	}
-	dma_unmap_single(&pdev->dev, rptr_baddr, len, DMA_BIDIRECTIONAL);
 	cptpf->is_eng_caps_discovered = true;
 
+error_no_response:
+	dma_unmap_single(&pdev->dev, rptr_baddr, len, DMA_BIDIRECTIONAL);
 free_result:
 	kfree(result);
 lf_cleanup:
-- 
2.39.5

