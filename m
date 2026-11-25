Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625119;
	b=CCzvdBDb1Cz8cf6N/v6GXpmLvtuYpgf0+CDPV+YYMeZIGJkWzMXdbgqd4B9HJZtRWpln
	 +0IKC0f8fc8NOjWUkScFycq6kLVTCm6XHb48OhL0/w+qjM+pIhqJpC/0v1XseWg9jypsd
	 F5GrY5P9xLNMxIpgcFTMgd6j1bZeCFsucDvvZKYmGHGETNcbJxxvG7J9zwJDxW2ZRlxQ3
	 265Rz7x/CzNsYT3tkH96s+8tr3bRb4idwB50SdxrXAPdTFtOVVK/cCIeZTjJhDM++z1LT
	 5uWUmlydyf23nT+U289Osis59bODr98Oc43oum+MsqanbF+EL7WW12XmPJ51JOr/AAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625119;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2R58eHg7WCeE/UCAuMBzTrsdPoPMhouf33HM5ySndGY=;
	b=C/b67MM46SZU2c2F0tfYa05hrpf0qbUP6EA+9qOfBxsZwO7cPKJjLL0RwcIyJgwjqP0Z
	 WT/iT6N3A64th65y+AEVTWwCOMlV8cXWqzIQajgd09TgiHLz/ZYZvilUyIaXNWIAYrl18
	 8741rjx2TVB0/fLqG459CYdzIFCJ0Qk6exbHJhq0NqJ4ng5Ax55+SMkVuO78rjBxeLKSE
	 6cLuPlLBApHLxXxyhHlF7IN2CrJgx7CEhCjVkv5X7IKQUkUWCVoHlf2c7QIWANt8bKNiO
	 pq3uiVLP/e1vNzk6zX6SSwNfy6MYUbjw8Uur3gBwLOOGys9ZuAdmC7rixKxKl3DOWcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="KDqaxL/Q";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706E3606A32C;
	Wed, 25 Nov 2026 16:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KDqaxL/Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0781F000C6;
	Wed, 25 Nov 2026 16:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625119;
	bh=2R58eHg7WCeE/UCAuMBzTrsdPoPMhouf33HM5ySndGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KDqaxL/QFfSoHa9sWcDaN3gOdzxbjBR70HNRclrrmAoTsc+2aWU8nQ3W4zu34Ae97
	 SXhQvi7TjfYU0j3k+2LZZVBXfSy7HE8OOofkygiRMo+AHXk9FqGhDnr/TIwZuJCyhz
	 e41jFcxSZ6yCL+qyljQoJ2FlPNggOvY8DoHf47hA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Richard Cheng <icheng@nvidia.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 411/816] cxl/cdat: Fix uninitialized stack use in bandwidth gathering
Date: Wed, 25 Nov 2026 15:32:39 +0100
Message-ID: <20261125143858.708430079@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 97b74de26c81885a6447f5fe87641a2a136f8c7c ]

cxl_endpoint_gather_bandwidth() and cxl_switch_gather_bandwidth() declare
access_coordinate arrays on the stack and rely on their helpers to fill
them. The helpers assign only the bandwidth members, and the combine step
assigns even those only when both inputs are non-zero. The latency members
are summed from stack residue on every call, and the bandwidth members
keep that residue into the region access coordinate sysfs attributes when
the endpoint CDAT reports no bandwidth.

Zero initialize the arrays. Zero is the value this code already uses for
"not reported", so an unset member now reads back as unknown rather than as
a plausible number.

Found by code inspection. Tested on a QEMU CXL topology with two endpoints
sharing a switch upstream link and HMAT generic-port coordinates for the
host bridge, which the calculation requires to run at all: with temporary
printk at the combine sites, the unpatched kernel summed 0xfefefefe, the
CONFIG_INIT_STACK_ALL_PATTERN stack filler, into the latency members, while
the patched kernel reports the CDAT latency values there.

Fixes: a5ab0de0ebaa ("cxl: Calculate region bandwidth of targets with shared upstream link")
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Reviewed-by: Richard Cheng <icheng@nvidia.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Link: https://patch.msgid.link/20260831092216.540644-2-kanie@linux.alibaba.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
[ sashal: Kept the tree's existing kzalloc(sizeof(*res_xa), GFP_KERNEL) context line instead of upstream's kzalloc_obj, and applied the same = { } initializer changes. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/cdat.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/cxl/core/cdat.c b/drivers/cxl/core/cdat.c
index e9cd7939c407a..0bf7819e8a750 100644
--- a/drivers/cxl/core/cdat.c
+++ b/drivers/cxl/core/cdat.c
@@ -629,9 +629,9 @@ static int cxl_endpoint_gather_bandwidth(struct cxl_region *cxlr,
 	struct cxl_port *endpoint = to_cxl_port(cxled->cxld.dev.parent);
 	struct cxl_port *parent_port = to_cxl_port(endpoint->dev.parent);
 	struct cxl_port *gp_port = to_cxl_port(parent_port->dev.parent);
-	struct access_coordinate pci_coord[ACCESS_COORDINATE_MAX];
-	struct access_coordinate sw_coord[ACCESS_COORDINATE_MAX];
-	struct access_coordinate ep_coord[ACCESS_COORDINATE_MAX];
+	struct access_coordinate pci_coord[ACCESS_COORDINATE_MAX] = { };
+	struct access_coordinate sw_coord[ACCESS_COORDINATE_MAX] = { };
+	struct access_coordinate ep_coord[ACCESS_COORDINATE_MAX] = { };
 	struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
 	struct cxl_dev_state *cxlds = cxlmd->cxlds;
 	struct pci_dev *pdev = to_pci_dev(cxlds->dev);
@@ -754,7 +754,7 @@ static struct xarray *cxl_switch_gather_bandwidth(struct cxl_region *cxlr,
 {
 	struct xarray *res_xa __free(free_perf_xa) =
 		kzalloc(sizeof(*res_xa), GFP_KERNEL);
-	struct access_coordinate coords[ACCESS_COORDINATE_MAX];
+	struct access_coordinate coords[ACCESS_COORDINATE_MAX] = { };
 	struct cxl_perf_ctx *ctx, *us_ctx;
 	unsigned long index, us_index;
 	int dev_count = 0;
-- 
2.53.0



