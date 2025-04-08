Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5731311AC;
	Tue,  8 Apr 2025 11:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110177; cv=none; b=osGnELk7tEKMOUIsmt4QDFBwC63coo4Z9RQFozPyrn/ViEuHeOSF+OY6bV7If3LlGIu1iLymfgImfsOgtSFb7p/ZnjnvZie5pck6zxhGmbFKPV70TQb00JIxkUW4OvoVjJtUj9wqnOn9IRggMn2yOZtDxaS+4Lf//wTFBZrkkIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110177; c=relaxed/simple;
	bh=ZEBQLC6mOmhvsnfHm3rAJMYy+iO5XSiF/nyDnT2Cc5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LmCNcrtYmsovxg9vc894jBkrKiXL4r/hMUUMydn5Sby0eHRPV4eumc9vZrg71LCCxzUPXW5HyZhVo1nD9d2vNGO4YEwPz/rIGugJMyutv06qrGmebvuczfsETn59WwrP782hCQ2POu1SIUPtxpvdx7OmMlaFp9tG80AzSsTR7YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oXBJjuBR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oXBJjuBR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D10A5C4CEE5;
	Tue,  8 Apr 2025 11:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110177;
	bh=ZEBQLC6mOmhvsnfHm3rAJMYy+iO5XSiF/nyDnT2Cc5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oXBJjuBRa8sUFEI7CNk0Hl8O7X91C0lHiWR7WTWrsjoAhIKZU4F2utgiN/+kBlPbb
	 f2tiZkeCi1x1K6giSm9/jVRrV/s/k0SHakQhCd8LxKOqFlnNH3zz9d3s1pZwaa5uUV
	 oaCF+UxinOWSXL4XFM2ATREuOM+ddPIBkgzxF2vU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Shubin <n.shubin@yadro.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jon Mason <jdmason@kudzu.us>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 196/227] ntb: intel: Fix using link status DBs
Date: Tue,  8 Apr 2025 12:49:34 +0200
Message-ID: <20250408104826.178950931@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Shubin <n.shubin@yadro.com>

[ Upstream commit 8144e9c8f30fb23bb736a5d24d5c9d46965563c4 ]

Make sure we are not using DB's which were remapped for link status.

Fixes: f6e51c354b60 ("ntb: intel: split out the gen3 code")
Signed-off-by: Nikita Shubin <n.shubin@yadro.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/hw/intel/ntb_hw_gen3.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ntb/hw/intel/ntb_hw_gen3.c b/drivers/ntb/hw/intel/ntb_hw_gen3.c
index ffcfc3e02c353..a5aa96a31f4a6 100644
--- a/drivers/ntb/hw/intel/ntb_hw_gen3.c
+++ b/drivers/ntb/hw/intel/ntb_hw_gen3.c
@@ -215,6 +215,9 @@ static int gen3_init_ntb(struct intel_ntb_dev *ndev)
 	}
 
 	ndev->db_valid_mask = BIT_ULL(ndev->db_count) - 1;
+	/* Make sure we are not using DB's used for link status */
+	if (ndev->hwerr_flags & NTB_HWERR_MSIX_VECTOR32_BAD)
+		ndev->db_valid_mask &= ~ndev->db_link_mask;
 
 	ndev->reg->db_iowrite(ndev->db_valid_mask,
 			      ndev->self_mmio +
-- 
2.39.5



