Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10323269CFD;
	Tue,  8 Apr 2025 11:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111861; cv=none; b=nsSe3m7Ab1zpdLT3rck/v2cgGY4U0XCgUcW2Y4KHAIDvGtOpIh+g6NeKf5A33DBl5StHgU36a8eYuUI1Wwm7ExdU0F+8926suoDtdPp9wg70liiUqg1z7FRGzs8vwPetGtMZBceeXUqLDfUAaOpzCozIWPwkrBbEhZa0sKaHS+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111861; c=relaxed/simple;
	bh=5A9OoX4Ar2Osbds6pjI/E+1Kd5/Zrik09bzBCYSkoZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E6n9rEm2KUP3EgjG9fPfF3hCJ+J7U3g9yZel84x0lDO/L9li7N2Huq19B1PX1/RmfsPYmrPEPXoO44WG2TTt5xX1HcANg25eu8GyTpoBfrAu13LXR9uNDkdJ9drp6ZFyIt+7kANClGCfX4IekMR+9rSrYH2xVAbCRtgzkAV6sb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VLUtGbpR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VLUtGbpR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B85C4CEE5;
	Tue,  8 Apr 2025 11:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111860;
	bh=5A9OoX4Ar2Osbds6pjI/E+1Kd5/Zrik09bzBCYSkoZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VLUtGbpRQwF/Lrv+ZhjAgA25mUwps9kT95cMQzIH8fb2wV2lslIoB7nz6rOUed6t3
	 gka24uB0oqbD54XT8s2wvzNM0c9iak7WbeUFY3v1Hbn6QQjabwBYppLytVjuhOqqfE
	 jsBQllcg8ZnDRAXEFUdMSIjVR3X5lk1WkYDAOqsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Shubin <n.shubin@yadro.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jon Mason <jdmason@kudzu.us>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 586/731] ntb: intel: Fix using link status DBs
Date: Tue,  8 Apr 2025 12:48:03 +0200
Message-ID: <20250408104927.903536542@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



