Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0952B222D7C;
	Thu, 12 Dec 2024 17:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025905; cv=none; b=ilJIERbR6HeqzGDY/Gjqs+t5e2ZMX/VQ4sgD91PUxxhm24yXoBW6flt+LcRp4+3MQaoi+BNtvL3yZeKZwWfQc9eNIdiweGNFQvOZcnRqUJXZd20uZdr79pGnZH2GQ8SgzUfg2q0R5VlC2alcn6FK6YZvBB0Kak2BODaNqBx1UR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025905; c=relaxed/simple;
	bh=ZRkiOWSIHjXazLdRwJtmdXc29gUmjVOisTU38/6tOoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X2jV4cQRySVw/RLfoA3UfJpHH2aT/eSwVJQvekvQv5WxAP80y8Ea6AfMXMUKdgfa2hbnERFNHCJUrghSGsH83eqY4yRJCL8h8JIz6aOGuFG41WNeCtFWxmEhvjEbVIvlczaQGeDWVqeH8TmaUeQXJybPI3dmicwWj1Mq8IevSX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VJHPa5rN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VJHPa5rN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F284C4CECE;
	Thu, 12 Dec 2024 17:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025904;
	bh=ZRkiOWSIHjXazLdRwJtmdXc29gUmjVOisTU38/6tOoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VJHPa5rN6ehvR6vXwcU39tJFbaJ7uaK5fp4JilR9ePwO9dv1W/zoGoCPh2LZsYpQC
	 8Js4swyfMnVad2vQ/NpfsgtH/5csdRtwXNv+vqF6elaZog0p0daWWfwEiEg/p+kBWa
	 VjIsifFGaYRxwb94thQWPsM7QK7VL4BMupoz4UAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shusen Li <lishusen2@huawei.com>,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 5.4 312/321] KVM: arm64: vgic-its: Clear DTE when MAPD unmaps a device
Date: Thu, 12 Dec 2024 16:03:50 +0100
Message-ID: <20241212144242.307913900@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kunkun Jiang <jiangkunkun@huawei.com>

commit e9649129d33dca561305fc590a7c4ba8c3e5675a upstream.

vgic_its_save_device_tables will traverse its->device_list to
save DTE for each device. vgic_its_restore_device_tables will
traverse each entry of device table and check if it is valid.
Restore if valid.

But when MAPD unmaps a device, it does not invalidate the
corresponding DTE. In the scenario of continuous saves
and restores, there may be a situation where a device's DTE
is not saved but is restored. This is unreasonable and may
cause restore to fail. This patch clears the corresponding
DTE when MAPD unmaps a device.

Cc: stable@vger.kernel.org
Fixes: 57a9a117154c ("KVM: arm64: vgic-its: Device table save/restore")
Co-developed-by: Shusen Li <lishusen2@huawei.com>
Signed-off-by: Shusen Li <lishusen2@huawei.com>
Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
[Jing: Update with entry write helper]
Signed-off-by: Jing Zhang <jingzhangos@google.com>
Link: https://lore.kernel.org/r/20241107214137.428439-5-jingzhangos@google.com
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/arm/vgic/vgic-its.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1181,9 +1181,11 @@ static int vgic_its_cmd_handle_mapd(stru
 	bool valid = its_cmd_get_validbit(its_cmd);
 	u8 num_eventid_bits = its_cmd_get_size(its_cmd);
 	gpa_t itt_addr = its_cmd_get_ittaddr(its_cmd);
+	int dte_esz = vgic_its_get_abi(its)->dte_esz;
 	struct its_device *device;
+	gpa_t gpa;
 
-	if (!vgic_its_check_id(its, its->baser_device_table, device_id, NULL))
+	if (!vgic_its_check_id(its, its->baser_device_table, device_id, &gpa))
 		return E_ITS_MAPD_DEVICE_OOR;
 
 	if (valid && num_eventid_bits > VITS_TYPER_IDBITS)
@@ -1204,7 +1206,7 @@ static int vgic_its_cmd_handle_mapd(stru
 	 * is an error, so we are done in any case.
 	 */
 	if (!valid)
-		return 0;
+		return vgic_its_write_entry_lock(its, gpa, 0, dte_esz);
 
 	device = vgic_its_alloc_device(its, device_id, itt_addr,
 				       num_eventid_bits);


