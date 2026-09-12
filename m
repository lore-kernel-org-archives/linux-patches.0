Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798DB429CC6;
	Sat, 12 Sep 2026 12:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217914; cv=none; b=H/j5LjXvCSEQXGJ1PbVVeBztMBbopYNQf/Tq930CZYZXcdjjRTu/pl51OlJkz+vmMtEr/z59CndNaXXTskUGJt8FuUbzAK0zgv+vAcdBT2UKqXPTCLrOrsD38c74lDtAFFxxyPz3s+7qCFP7Ym4YdWQLNZK6Yb/hBMlk1TgAqko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217914; c=relaxed/simple;
	bh=RwOqsfduRtGlaTlW9CDV4RWMdMbYaNhf/hgU4kVjifk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=olTDu8qsnVaNdgT6waeegJbhw1RbFEzGFOWbYhTnqHOMD01OuDknzwwFfRsjcmsyP3kf9QvyZMs7JOuh3L5VAGHs74Esh7EIdzpP/ZS2xZWAbghmEW2EwLsSZsffpoldSuwmaIvsBKUNXgK4MfPUfOWfoHTiQXovzGg5BFuAEuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NSD9ojn3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NSD9ojn3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 310F11F00893;
	Sat, 12 Sep 2026 12:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217913;
	bh=9TMB01RdEU8gpa+LxdfHH8F65B/xG5xECKwVnGzCy3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NSD9ojn3wJgctWZgknUYHXuo26NIsDcKjDCmyFLVUQ7p+/8/aQOD/lajBhqyy1fih
	 ForR2i0h/6sVDzKe5KeKSfBk76K0vuwoWjkb8px0EOA3PaTg4B5jLzYuXpk9ALspK7
	 HWzSWg7P5lStmZgs16jlM62/Nfu+eR2EqkUkbl80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>,
	Ankit Soni <Ankit.Soni@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1037/1376] iommu/amd: Fix incorrect device ID in invalid PASID error message
Date: Sat, 12 Sep 2026 08:57:43 +0200
Message-ID: <20260912065630.671724459@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasant Hegde <vasant.hegde@amd.com>

[ Upstream commit 5322e19fc5acf013784207bc38191cd418a8bb48 ]

The IO page fault notifier handler logs pdev->dev.id when reporting an
invalid PASID, but pdev->dev.id is the kernel-internal device ID and
not the IOMMU device ID (BDF). Use dev_data->devid instead, which
reflects actual devid.

Fixes: 978d626b8f1a ("iommu/amd: Add IO page fault notifier handler")
Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Ankit Soni <Ankit.Soni@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/ppr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/ppr.c b/drivers/iommu/amd/ppr.c
index 00d9a52ccb6f6..0e46a47ea4c4c 100644
--- a/drivers/iommu/amd/ppr.c
+++ b/drivers/iommu/amd/ppr.c
@@ -140,7 +140,7 @@ static void iommu_call_iopf_notifier(struct amd_iommu *iommu, u64 *raw)
 	if (event.fault.prm.pasid == 0 ||
 	    event.fault.prm.pasid >= dev_data->max_pasids) {
 		pr_info_ratelimited("Invalid PASID : 0x%x, device : 0x%x\n",
-				    event.fault.prm.pasid, pdev->dev.id);
+				    event.fault.prm.pasid, dev_data->devid);
 		goto out;
 	}
 
-- 
2.53.0



