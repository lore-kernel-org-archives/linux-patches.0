Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1FB0265CDD;
	Tue, 21 Oct 2025 20:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077214; cv=none; b=Q57GtjaYx1BYH/L4GKOnUGRyLf4AhBXsciM9nekojgOwjWmBecx2LPD1q3qBYIs4VrggmBWZEjYVRsJrlMmd0CF9gnzoPVGzElJrb8qJ3nTFG9vMwRZB8+RHIOHZLvhzQu2u8q7b6Dc4sJ4XuScPi87lk69Kr5mRNKqgITubzgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077214; c=relaxed/simple;
	bh=iG4mrDt0BcWH0Y1Fm6ParEKGdd675sF3ZK6SBkz/5/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nXJdIgNksnf205GcE9FipnGq1sp/EwZmuuzN+e66NExGo6W1CnD+DF05d5QDUa68K8WqKkog/+loJc0RKs8hEdUv5SGdhL+1DhV+4fUnCcqYoKOf0hE2PScFnrC6xt7a9SJeFlbT3aMF8Nt0+MdYouBP5wJac4AxE8JLn2Stins=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ubEhet+r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ubEhet+r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7FABC4CEF1;
	Tue, 21 Oct 2025 20:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077214;
	bh=iG4mrDt0BcWH0Y1Fm6ParEKGdd675sF3ZK6SBkz/5/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ubEhet+r4LUK0tYHntleDicd52si/1rk1kIPO6JSYOafyAuBl752Yb2NRcF9FOlS6
	 X5UK+q8ORujKmQhIYpQNPgGLHgXIyGDIVcOCcY/FZ3PZJcKhng8S4mFkZc2rLf1xWg
	 QA84bcweLHxGcpwfMpFmx6NPeJizbE349hhfajBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregory Price <gourry@gourry.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH 6.17 034/159] cxl/acpi: Fix setup of memory resource in cxl_acpi_set_cache_size()
Date: Tue, 21 Oct 2025 21:50:11 +0200
Message-ID: <20251021195044.016408773@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

commit 2e41e5a91a37202ff6743c3ae5329e106aeb1c6c upstream.

In order to compare the resource against the HMAT memory target,
the resource needs to be memory type. Change the DEFINE_RES()
macro to DEFINE_RES_MEM() in order to set the correct resource type.
hmat_get_extended_linear_cache_size() uses resource_contains()
internally. This causes a regression for platforms with the
extended linear cache enabled as the comparison always fails and the
cache size is not set. User visible impact is that when 'cxl list' is
issued, a CXL region with extended linear cache support will only
report half the size of the actual size. And this also breaks MCE
reporting of the memory region due to incorrect offset calculation
for the memory.

[dj: Fixup commit log suggested by djbw]
[dj: Fixup stable address for cc]

Fixes: 12b3d697c812 ("cxl: Remove core/acpi.c and cxl core dependency on ACPI")
Cc: stable@vger.kernel.org
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/acpi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -345,7 +345,7 @@ static int cxl_acpi_set_cache_size(struc
 	struct resource res;
 	int nid, rc;
 
-	res = DEFINE_RES(start, size, 0);
+	res = DEFINE_RES_MEM(start, size);
 	nid = phys_to_target_node(start);
 
 	rc = hmat_get_extended_linear_cache_size(&res, nid, &cache_size);


