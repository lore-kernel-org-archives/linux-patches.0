Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EAB4411A1C;
	Fri,  4 Sep 2026 05:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501422; cv=none; b=I5e3da7jVrCjHck1aVMK+/2BSM9a4VF05Koy3q4bOPZw4Fanx8Gjovmk5OElLrzfMNhDBzm/tA/fuvem9myVarcDW0Ah5E/FZrtk55WyNePjFSj11eCqpKFoJCrOwKEZR+TG5nAcHKMylMMeww7/5H2r57dC2YtfHXVc6yPGp8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501422; c=relaxed/simple;
	bh=y9O/z4TNhZk5vk4r3r7FWKmNBE0a++j7JsKmgokswpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SKy0olQkX2w/eXR1Xg9sket8jf/vr7hAdjJcQbaDo2YZ6tDHdrz19jL5vvuKvnEpgYwqBt1O/p7BDAgfcX1d9GsLLXRz9wfp3BljUN8Khq8Mb2TxfxBmYdLUA1eKmKE9eVY3vCD5gQvlKzz32eIl2fSfNE2bchJxgtr50oJraR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KsQX43nu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KsQX43nu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E986A1F00A3D;
	Fri,  4 Sep 2026 05:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501421;
	bh=bFOon7VTCateFjxQbly0ugs6N8qS7gbLKaTyuA8iAw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KsQX43nuQQWEaLcN1gYoWtozpHRYR+ZJC9NhyohU0mRBLyBbtK8YyXbgVlPufQgza
	 Bl5ylAPQZAKhTpE1olG5F6d3kTSobFv5RLz1Nd5XJ189x2Uv1HC+lN6ckgTn0F7ocD
	 r8e5L2+T8nyEWCEvvhAC2bxt/QUggiJiO2lOcQmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.18 405/552] iommu/tegra241-cmdqv: Reject a vSID wider than the SID_MATCH field
Date: Fri,  4 Sep 2026 06:59:22 +0200
Message-ID: <20260904045759.721902884@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -58,6 +58,8 @@
 #define  VINTF_ENABLED			BIT(0)
 
 #define TEGRA241_VINTF_SID_MATCH(s)	(0x0040 + 0x4*(s))
+#define  VINTF_SID_MATCH_VIRT_SID	GENMASK(20, 1)
+#define  VINTF_SID_MATCH_ENABLE		BIT(0)
 #define TEGRA241_VINTF_SID_REPLACE(s)	(0x0080 + 0x4*(s))
 
 #define TEGRA241_VINTF_LVCMDQ_ERR_MAP_64(m) \
@@ -1249,7 +1251,7 @@ static int tegra241_vintf_init_vsid(stru
 	u64 virt_sid = vdev->virt_id;
 	int sidx;
 
-	if (virt_sid > UINT_MAX)
+	if (virt_sid > FIELD_MAX(VINTF_SID_MATCH_VIRT_SID))
 		return -EINVAL;
 
 	WARN_ON_ONCE(master->num_streams != 1);
@@ -1261,7 +1263,9 @@ static int tegra241_vintf_init_vsid(stru
 		return sidx;
 
 	writel(stream->id, REG_VINTF(vintf, SID_REPLACE(sidx)));
-	writel(virt_sid << 1 | 0x1, REG_VINTF(vintf, SID_MATCH(sidx)));
+	writel(FIELD_PREP(VINTF_SID_MATCH_VIRT_SID, virt_sid) |
+		       VINTF_SID_MATCH_ENABLE,
+	       REG_VINTF(vintf, SID_MATCH(sidx)));
 	dev_dbg(vintf->cmdqv->dev,
 		"VINTF%u: allocated SID_REPLACE%d for pSID=%x, vSID=%x\n",
 		vintf->idx, sidx, stream->id, (u32)virt_sid);


