Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65AF0157E8F;
	Mon, 29 Jan 2024 17:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548375; cv=none; b=XT1OMuHwK9DNDbriRJbXtJerG9LEn8rpC2nkNMEu8+lshKMlohqKSNTZVeCVG536c2CIS11IGpF7C7dzSFVBVhcf3WmUDX9P1V0M8/M6jbyJIRc9sxC3p/tQlrw8iu9Tu9RPnRVrVRpaVIdw/YANzOkCgNyTs/X2LT8swTer70E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548375; c=relaxed/simple;
	bh=ajb/bUZpSlwo1T3F7uN/BCcZ7ixiliZOP1u4SomNMoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d7cLLEy2XxlGHmuMkn7HHjdbTY57okVzZ0JgH5Iu9sYWB7Wlmg93X3o4YflOWMMyj0/+TXTqic/GxRLLfDSspAVaCYF3WIRxe58EjIr0kmoYkOs+HWG0r+urJygLjlEsOPDgh+dF6Rd/1+hbuf2gm8kvc0emXVf19fFig/CbrZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HU6RsCUh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HU6RsCUh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C607C433F1;
	Mon, 29 Jan 2024 17:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548375;
	bh=ajb/bUZpSlwo1T3F7uN/BCcZ7ixiliZOP1u4SomNMoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HU6RsCUhRItfFV8qc+EiaYY6dzag7ZmWAu9gf/hEa1uwx0i0vt7XmnkhhyXUotAFP
	 54X6bbuzjvcN4DmK0LRzpKHf7dyz3nFrv7ya1wGnPoc/lCgrxhuhjbbBLNa9aXbKwF
	 oaxHShVUunHGIjpFMULaDHcnN8CK+QE+L2tBVaRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quanquan Cao <caoqq@fujitsu.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: =?UTF-8?q?=5BPATCH=206=2E7=20341/346=5D=20cxl/region=EF=BC=9AFix=20overflow=20issue=20in=20alloc=5Fhpa=28=29?=
Date: Mon, 29 Jan 2024 09:06:12 -0800
Message-ID: <20240129170026.532306927@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quanquan Cao <caoqq@fujitsu.com>

commit d76779dd3681c01a4c6c3cae4d0627c9083e0ee6 upstream.

Creating a region with 16 memory devices caused a problem. The div_u64_rem
function, used for dividing an unsigned 64-bit number by a 32-bit one,
faced an issue when SZ_256M * p->interleave_ways. The result surpassed
the maximum limit of the 32-bit divisor (4G), leading to an overflow
and a remainder of 0.
note: At this point, p->interleave_ways is 16, meaning 16 * 256M = 4G

To fix this issue, I replaced the div_u64_rem function with div64_u64_rem
and adjusted the type of the remainder.

Signed-off-by: Quanquan Cao <caoqq@fujitsu.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Fixes: 23a22cd1c98b ("cxl/region: Allocate HPA capacity to regions")
Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/core/region.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -525,7 +525,7 @@ static int alloc_hpa(struct cxl_region *
 	struct cxl_root_decoder *cxlrd = to_cxl_root_decoder(cxlr->dev.parent);
 	struct cxl_region_params *p = &cxlr->params;
 	struct resource *res;
-	u32 remainder = 0;
+	u64 remainder = 0;
 
 	lockdep_assert_held_write(&cxl_region_rwsem);
 
@@ -545,7 +545,7 @@ static int alloc_hpa(struct cxl_region *
 	    (cxlr->mode == CXL_DECODER_PMEM && uuid_is_null(&p->uuid)))
 		return -ENXIO;
 
-	div_u64_rem(size, SZ_256M * p->interleave_ways, &remainder);
+	div64_u64_rem(size, (u64)SZ_256M * p->interleave_ways, &remainder);
 	if (remainder)
 		return -EINVAL;
 


