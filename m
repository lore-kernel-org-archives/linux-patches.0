Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522B218DB2A;
	Wed, 25 Feb 2026 01:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983150; cv=none; b=jiff61Y0KyOyxJhStL345Pubqmr05nv3xnfr1M3SiyT75oZKHO40t6/LZ1V1uu36zby98z0VWd7KbyP4P17UbB8r5dYAUy1ZsgVK2A3JaQ7b8jz0sCJRpbv0EBTe380AuWmbnHHR28Q7stJ+QuPOolAosA0eg9GXGI0usZAZXB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983150; c=relaxed/simple;
	bh=xpoXyct8HqqeXJCHPHWL63kppBuJA9PcJXA3aljJ4tA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Musbb5ZCk3K0xJ3ay8FE/9P8IdWwTByFWaYRWa6vAbAtkiH3TrG+Zs4DZz3REv0r9zEQEHjoSegQuH/YI5g5ehsUWb88xcI+CtjZrxdMmYpYY1RfosLL4OrIZyxph5jFrTBi6Kt+aN8WkgeX8y7ORKl5CQy7+pca8yKFAOrv51A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2HMzuScd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2HMzuScd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF536C116D0;
	Wed, 25 Feb 2026 01:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983150;
	bh=xpoXyct8HqqeXJCHPHWL63kppBuJA9PcJXA3aljJ4tA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2HMzuScd/QB6ghQzKSqQaZBNEwTPp780QHlUKFyEJsZxQTDqKuwJBn2AbGLbGK0nM
	 8mRSlIZnwFfqmuQawYJBu+B05h0yivFBYdRgMwP/T738eJNjMRGVK7YWidxKR1hj93
	 v/yELHVgsUDAj+K2f3tG0D7EbzqrkWcSyI+yXjiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Hubbard <jhubbard@nvidia.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Timur Tabi <ttabi@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 260/781] gpu: nova-core: check for overflow to DMATRFBASE1
Date: Tue, 24 Feb 2026 17:16:09 -0800
Message-ID: <20260225012406.079566490@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Tabi <ttabi@nvidia.com>

[ Upstream commit 5cf76277cdec872aef9ff2e9008ae129bb303787 ]

The NV_PFALCON_FALCON_DMATRFBASE/1 register pair supports DMA addresses
up to 49 bits only, but the write to DMATRFBASE1 could exceed that.
To mitigate, check first that the DMA address will fit.

Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Joel Fernandes <joelagnelf@nvidia.com>
Fixes: 69f5cd67ce41 ("gpu: nova-core: add falcon register definitions and base code")
Signed-off-by: Timur Tabi <ttabi@nvidia.com>
Link: https://patch.msgid.link/20260107201647.2490140-1-ttabi@nvidia.com
[ Import ::kernel::dma::DmaMask. - Danilo ]
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/nova-core/falcon.rs | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/nova-core/falcon.rs b/drivers/gpu/nova-core/falcon.rs
index 82c661aef594f..3ab33ea36d9c8 100644
--- a/drivers/gpu/nova-core/falcon.rs
+++ b/drivers/gpu/nova-core/falcon.rs
@@ -8,7 +8,10 @@
 
 use kernel::{
     device,
-    dma::DmaAddress,
+    dma::{
+        DmaAddress,
+        DmaMask, //
+    },
     io::poll::read_poll_timeout,
     prelude::*,
     sync::aref::ARef,
@@ -472,6 +475,12 @@ fn dma_wr<F: FalconFirmware<Target = E>>(
             return Err(EINVAL);
         }
 
+        // The DMATRFBASE/1 register pair only supports a 49-bit address.
+        if dma_start > DmaMask::new::<49>().value() {
+            dev_err!(self.dev, "DMA address {:#x} exceeds 49 bits\n", dma_start);
+            return Err(ERANGE);
+        }
+
         // DMA transfers can only be done in units of 256 bytes. Compute how many such transfers we
         // need to perform.
         let num_transfers = load_offsets.len.div_ceil(DMA_LEN);
-- 
2.51.0



