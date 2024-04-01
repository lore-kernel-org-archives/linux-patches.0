Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B44438DE5;
	Mon,  1 Apr 2024 17:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991175; cv=none; b=XojNw+Ej95lnu5npbwfXs7Gnf4QE7Tihjw5C2jLiw5waNO9n9S5oYwjLwPNhSiSV8OIqoK4P3sRI9Oc9yZvH8q253tgYOr/zkdjHi5Gdr6oBNHcqRkma228A0cSyUm6/dr6aVuzhfAWsPdR/Vq73IPUJlLo0tt9PCBdXvPxum2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991175; c=relaxed/simple;
	bh=WYFNX9S9Dc5FKKG1whSuqGrQ/0Z3g6THAiRZEoIDZKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NGY8Y11ffg1tDv7Xl4iI6ysTiQO4HacPgsZfo0bOeoJRqFXwyiDuH/Unb57iEAu3hkj04Q2zljST1YAdXkf8vOSVxeWPO2tHrauhCzCcCTidlCoNLUwcA5p0ePew8zeCORE+QOPA/PiL83fDUdfCr1OD5p+tqqxd1pJwan/erU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JBO89rZ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JBO89rZ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D459AC433C7;
	Mon,  1 Apr 2024 17:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991175;
	bh=WYFNX9S9Dc5FKKG1whSuqGrQ/0Z3g6THAiRZEoIDZKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JBO89rZ/mHtMteMF3g7CA9PqMFMWGQX9YRslPTJEWYuy+YOai+6GHxTjK2TawYXHN
	 l6O5f9kBvPrIGGGlvB2tSiA5q+z91erVKAe60rxQIy1CBhBIftEvcyJhn3KpuU7jcj
	 TMy90ZYowsceCE0pPtHpENBKjufwvxcXOJ4Bg/7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charan Teja Kalla <quic_charante@quicinc.com>,
	Nikhil V <quic_nprakash@quicinc.com>
Subject: [PATCH 6.1 178/272] iommu: Avoid races around default domain allocations
Date: Mon,  1 Apr 2024 17:46:08 +0200
Message-ID: <20240401152536.344429916@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charan Teja Kalla <quic_charante@quicinc.com>

This fix is applicable for LTS kernel, 6.1.y. In latest kernels, this race
issue is fixed by the patch series [1] and [2]. The right thing to do here
would have been propagating these changes from latest kernel to the stable
branch, 6.1.y. However, these changes seems too intrusive to be picked for
stable branches. Hence, the fix proposed can be taken as an alternative
instead of backporting the patch series.
[1] https://lore.kernel.org/all/0-v8-81230027b2fa+9d-iommu_all_defdom_jgg@nvidia.com/
[2] https://lore.kernel.org/all/0-v5-1b99ae392328+44574-iommu_err_unwind_jgg@nvidia.com/

Issue:
A race condition is observed when arm_smmu_device_probe and
modprobe of client devices happens in parallel. This results
in the allocation of a new default domain for the iommu group
even though it was previously allocated and the respective iova
domain(iovad) was initialized. However, for this newly allocated
default domain, iovad will not be initialized. As a result, for
devices requesting dma allocations, this uninitialized iovad will
be used, thereby causing NULL pointer dereference issue.

Flow:
- During arm_smmu_device_probe, bus_iommu_probe() will be called
as part of iommu_device_register(). This results in the device probe,
__iommu_probe_device().

- When the modprobe of the client device happens in parallel, it
sets up the DMA configuration for the device using of_dma_configure_id(),
which inturn calls iommu_probe_device(). Later, default domain is
allocated and attached using iommu_alloc_default_domain() and
__iommu_attach_device() respectively. It then ends up initializing a
mapping domain(IOVA domain) and rcaches for the device via
arch_setup_dma_ops()->iommu_setup_dma_ops().

- Now, in the bus_iommu_probe() path, it again tries to allocate
a default domain via probe_alloc_default_domain(). This results in
allocating a new default domain(along with IOVA domain) via
__iommu_domain_alloc(). However, this newly allocated IOVA domain
will not be initialized.

- Now, when the same client device tries dma allocations via
iommu_dma_alloc(), it ends up accessing the rcaches of the newly
allocated IOVA domain, which is not initialized. This results
into NULL pointer dereferencing.

Fix this issue by adding a check in probe_alloc_default_domain()
to see if the iommu_group already has a default domain allocated
and initialized.

Cc: <stable@vger.kernel.org> # see patch description, fix applicable only for 6.1.y
Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
Co-developed-by: Nikhil V <quic_nprakash@quicinc.com>
Signed-off-by: Nikhil V <quic_nprakash@quicinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1741,6 +1741,9 @@ static void probe_alloc_default_domain(s
 {
 	struct __group_domain_type gtype;
 
+	if (group->default_domain)
+		return;
+
 	memset(&gtype, 0, sizeof(gtype));
 
 	/* Ask for default domain requirements of all devices in the group */


