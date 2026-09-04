Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E03D3F58C4;
	Fri,  4 Sep 2026 05:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499806; cv=none; b=o02UwGLiBlMNqMPhd1zp3cEBU0Dvwm9TyAIZhIHYiAkA54006cEqx6VoYbX38RCyS2PBdm2CZlscbSAlcSFSVNj/C5+/xs1rntZw3syDCctBxmieIReMd/oOg8tGekNJyLYBoPuu+EY7PRUrY0k65khiEW3b8GqeLHhbhg9FgZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499806; c=relaxed/simple;
	bh=xeYKYbN5DemdLRRdHVWkMasHmlpvEImaA2n/x8rcUtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Py5czMkUNPyiFVWaPQv7xWupWtwQZeUYABGQq+IgPHNSkH48c13n10xKu2SElobF4aMzRkTo8WAMQAa/19BoOqRVlkcBizDcaPTCF8qYYoesEQFGgXeoeojPqLFv36ZuKFKIl5EfFfmOvE6V72k9ruSjNFiT/h1SA+pSUBrfoow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PBme43Dt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PBme43Dt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B13D01F00A3D;
	Fri,  4 Sep 2026 05:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499805;
	bh=KtIpb4ybAxZzj9npDKdWHxf6XXLX1S9LRbiEjBv6leU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PBme43Dt6oBAEnmOVrngnfYAGDMFHo9OxxWDZD0kcdjitQ5B1iTktjmIwqfphBgLY
	 R5zvq9/Qw+Y4XSZwZ0CigGXMFxxfwn8Wxx5+bzkr/MBn3gfdBoO2eiyz1T9TVDN+rT
	 6fFbvCsl0+8uFVMscxc3D7rq6WUS0F34FpdgD4pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 7.2 540/713] iommu/tegra241-cmdqv: Reject a vSID wider than the SID_MATCH field
Date: Fri,  4 Sep 2026 06:58:28 +0200
Message-ID: <20260904045815.925044587@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolin Chen <nicolinc@nvidia.com>

commit 4379610c79bd88ddbea10e7f6c21e16d4b338c6b upstream.

tegra241_vintf_init_vsid() programs the guest-provided vSID into SID_MATCH,
whose VIRT_SID field spans bits [20:1] with bit 0 as the match-enable flag.
The HW therefore matches only a 20-bit Stream ID.

The bound check rejects only virt_sid > UINT_MAX, which admits a value far
wider than the field. The write "virt_sid << 1 | 0x1" then drops every bit
above 20: a virt_sid of 0x80000000 lands as SID_MATCH = 0x1, a valid match
on vSID 0, so the entry aliases the wrong Stream ID. Because vdev->virt_id
is guest-controlled, a VMM can trigger it.

Validate virt_sid against the field width with FIELD_MAX(), and program the
register with FIELD_PREP() so the value and the field stay consistent.

Fixes: 4dc0d12474f9 ("iommu/tegra241-cmdqv: Add user-space use support")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
+++ b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
@@ -56,6 +56,8 @@
 #define  VINTF_ENABLED			BIT(0)
 
 #define TEGRA241_VINTF_SID_MATCH(s)	(0x0040 + 0x4*(s))
+#define  VINTF_SID_MATCH_VIRT_SID	GENMASK(20, 1)
+#define  VINTF_SID_MATCH_ENABLE		BIT(0)
 #define TEGRA241_VINTF_SID_REPLACE(s)	(0x0080 + 0x4*(s))
 
 #define TEGRA241_VINTF_LVCMDQ_ERR_MAP_64(m) \
@@ -1189,7 +1191,7 @@ static int tegra241_vintf_init_vsid(stru
 	u64 virt_sid = vdev->virt_id;
 	int sidx;
 
-	if (virt_sid > UINT_MAX)
+	if (virt_sid > FIELD_MAX(VINTF_SID_MATCH_VIRT_SID))
 		return -EINVAL;
 
 	WARN_ON_ONCE(master->num_streams != 1);
@@ -1201,7 +1203,9 @@ static int tegra241_vintf_init_vsid(stru
 		return sidx;
 
 	writel(stream->id, REG_VINTF(vintf, SID_REPLACE(sidx)));
-	writel(virt_sid << 1 | 0x1, REG_VINTF(vintf, SID_MATCH(sidx)));
+	writel(FIELD_PREP(VINTF_SID_MATCH_VIRT_SID, virt_sid) |
+		       VINTF_SID_MATCH_ENABLE,
+	       REG_VINTF(vintf, SID_MATCH(sidx)));
 	dev_dbg(vintf->cmdqv->dev,
 		"VINTF%u: allocated SID_REPLACE%d for pSID=%x, vSID=%x\n",
 		vintf->idx, sidx, stream->id, (u32)virt_sid);


