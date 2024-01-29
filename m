Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA107159591;
	Mon, 29 Jan 2024 17:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548255; cv=none; b=uk1XD1xQSPk971Dhgrk9Q64Sz6C5R2lAhjqPBE7ATnv4DeZW8WWGQMBaPz+PnVTra1W1nTDdjflOGKdgfrZUE0Yx+LFF0rYjCsAd6EWkIsLDu34FDD2QR+P752y99hL5DMroPXGc2VXdERR7JOuwBVoVt56pwF9+X5VZY6UuVrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548255; c=relaxed/simple;
	bh=gpbMNiQRhelBtM9j+XLO7h4w75nQOFQZsm7fq2ilgvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uK3/OESfys/J8tPm24m2+VyRc/J8KTMBiizd2mqlUNcl+pigWn+dQxumLa9oUe709FwA8oLXCfquTVkOMYXb2V8aaqkM84AE5FCBnnt4jg8gVU44D5jRmrA1RyBGxCq2tjHJwMfGanVVB6jPDBR0wgSxLJsaA0ILupZ5OeFpQX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x2RoDbD3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x2RoDbD3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A25B0C433C7;
	Mon, 29 Jan 2024 17:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548255;
	bh=gpbMNiQRhelBtM9j+XLO7h4w75nQOFQZsm7fq2ilgvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x2RoDbD3i0VCpF80Eb9iDa8k8igngMstA08RU8vP80ISFBatLNjTZycGjenkTwdb1
	 lqZh0KDo86HCcAakn8z+8qxW80dDUZcNKMjElBTuH8z2dZhisQRBzeG/m0GRmoqTvS
	 4VslCQhMSeX3SBsnnDMjvsq9AiGb1zZf1rkQ1JYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.7 276/346] drm/amdgpu: Show vram vendor only if available
Date: Mon, 29 Jan 2024 09:05:07 -0800
Message-ID: <20240129170024.498791838@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

commit 89a7c0bd74918f723c94c10452265e25063cba9b upstream.

Ony if vram vendor info is available, show in sysfs.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.7.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
index 08916538a615..8db880244324 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
@@ -221,8 +221,23 @@ static struct attribute *amdgpu_vram_mgr_attributes[] = {
 	NULL
 };
 
+static umode_t amdgpu_vram_attrs_is_visible(struct kobject *kobj,
+					    struct attribute *attr, int i)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct drm_device *ddev = dev_get_drvdata(dev);
+	struct amdgpu_device *adev = drm_to_adev(ddev);
+
+	if (attr == &dev_attr_mem_info_vram_vendor.attr &&
+	    !adev->gmc.vram_vendor)
+		return 0;
+
+	return attr->mode;
+}
+
 const struct attribute_group amdgpu_vram_mgr_attr_group = {
-	.attrs = amdgpu_vram_mgr_attributes
+	.attrs = amdgpu_vram_mgr_attributes,
+	.is_visible = amdgpu_vram_attrs_is_visible
 };
 
 /**
-- 
2.43.0



