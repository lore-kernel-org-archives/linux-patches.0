Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97DC3064B7;
	Mon, 13 Oct 2025 14:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367304; cv=none; b=DSnL2UBxiTSGC4GvgCx669BLAnxvTokksLCKjqUkf0tBajyJjDcCPByGj7GMBy6AoPUlGDkW1J0AtJiKubN2G/TnmbajCxgHcUjKSl9BLWhAMapYUBNdaoEkluyk3Qtv2X1c3qwi8YxCQqQJ685lm1K1+y2yTX0GZDsVtnwCz/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367304; c=relaxed/simple;
	bh=+r0YGKvSwzDCAC1nxSyBrOy37f+OLXm1LqeEHYoRdJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ln+ZYHSTFygKfUiZKXwR43+nwbDYRqlW9PrFB6nmIl2P26exBTPsEp0QDxyPAL9booC9w/vnIg4Xk5aIaDNioORkbx/MkdAZrVMq90LIrD59dUJ+xuE2gehUF/HaH3axsorKtQ86mmjvD2laotiHleFO1WbtfwXN6Mgf6EwkQzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dtO+WYNF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dtO+WYNF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74269C4CEE7;
	Mon, 13 Oct 2025 14:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367303;
	bh=+r0YGKvSwzDCAC1nxSyBrOy37f+OLXm1LqeEHYoRdJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dtO+WYNFq89sxD6z/+8BDbYQ8uMg5jAOE9a1kAxjEyS+VTL1NLROm2De5Wun0eP04
	 Hol8w1Aa6jsnt09yzxnwohHKdwvsZvLjeFchw2kWOKkyklNm5VzUKs14M+uVUCD4sh
	 Kw5+Uyt2xcH/lvHL12fczWKxKqy0d2Li+TtJQ4B0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 129/196] ACPI: NFIT: Fix incorrect ndr_desc being reportedin dev_err message
Date: Mon, 13 Oct 2025 16:45:02 +0200
Message-ID: <20251013144319.361290844@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit d1a599a8136b16522b5afebd122395524496d549 ]

There appears to be a cut-n-paste error with the incorrect field
ndr_desc->numa_node being reported for the target node. Fix this by
using ndr_desc->target_node instead.

Fixes: f060db99374e ("ACPI: NFIT: Use fallback node id when numa info in NFIT table is incorrect")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/nfit/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 129c503b0951e..78c9f56b4ba34 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -2643,7 +2643,7 @@ static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
 	if (ndr_desc->target_node == NUMA_NO_NODE) {
 		ndr_desc->target_node = phys_to_target_node(spa->address);
 		dev_info(acpi_desc->dev, "changing target node from %d to %d for nfit region [%pa-%pa]",
-			NUMA_NO_NODE, ndr_desc->numa_node, &res.start, &res.end);
+			NUMA_NO_NODE, ndr_desc->target_node, &res.start, &res.end);
 	}
 
 	/*
-- 
2.51.0



