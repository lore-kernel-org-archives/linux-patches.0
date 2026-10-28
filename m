Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209472;
	b=Mq75IJfz0VmSnt2b5CZ3WCds54RBcwNCsQfj/wvXhdRwdny1LoLBCvc2Bip/UvsPhGNn
	 cRXI9mnL/u7mfmWUC9q2ccKINhu50IFriT2p7aNh7W1j+5vJ4WDfqA0F5CZ2yYGQ8HNEj
	 AjtiBQ+Y50rgAtMhsxUWmvheNXy44ssUsUEKGH+FarqV3iaQCwWi6SSPHUd+QFJJJiBV4
	 5jw/EpVoyi1GnWQxKY876XFSFt8L1c8luugQOz0MA9vV9+WUsODkodSkfCcvgZMnsGeQi
	 1zT5eHRfVZYPOlSRL2dlXQDH8JUqL8adNZNq30wVyx2oY+7HkxLDjl1CTPwKmCRef5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209472;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pL5N8PEe/XFTklvyvjQdeBhQSEUHr5SpKOk7gIdNzuw=;
	b=TrQ+drbpGd820A9tgCY0ipx8/wyTOaGMdfi+4lujeCSspC4DTFryJiZGPycVvGTAvYMc
	 aBcnO1+WMR5C6ZotuPo+GSF1HcyiJlU2j8H69Pu/rBzofC/INtc7MCCAPWTWdJcFwOo3y
	 bc4iCgMxwDaGlWO/4cRNan/CuAc/CYH5aj/msUaz6l9EygiyyNFoyANPx6Xf17u+VBll7
	 XLSp2wGWz6UGemKeAyXLKy1cEqhjn3u5CFTyT0DXc94SBe482hfsCHFMA6It/7lXpQJH1
	 wy2v7/dBHg+1qkSDsCnLKTjqwr9aoIsy8H1rBe4/NSYsR159bK2cqHUFZWmsUYiRfww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pz+6PDrI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96348606A31A;
	Wed, 28 Oct 2026 17:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pz+6PDrI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966FB1F01828;
	Wed, 28 Oct 2026 17:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209472;
	bh=pL5N8PEe/XFTklvyvjQdeBhQSEUHr5SpKOk7gIdNzuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pz+6PDrIieg72+lwnlrkI0Fw+N0OgUi0yTKzy++XJ1Vos8w4l33+bV1jEQFJU56jw
	 0WPFWJ6WG0kLMoXY/DPPu+2edSYQwOrgVhaIsLkf2yCz2qnV2Pbb2z7x0riN75CL6h
	 5bXe6d06nwX/dacLCD70x9VzZpA6GFv48qESNG1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Oliver Upton <oupton@kernel.org>,
	Aaron Ahmed <aarnahmd@amazon.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 484/516] KVM: arm64: vgic-its: Dont dereference a NULL collection on ITT save
Date: Wed, 28 Oct 2026 18:00:36 +0100
Message-ID: <20261028170014.943694114@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fuad Tabba <fuad.tabba@linux.dev>

[ Upstream commit c6c156d931c33b92362383cf76f6d6e1291dcbfe ]

MAPC with V=0 drops ite->collection but leaves the ITE on the device's
ITT list, and vgic_its_save_ite() dereferences it unconditionally. A
guest that issues MAPD, MAPTI and then MAPC(V=0) therefore oopses the
host when the VMM issues KVM_DEV_ARM_ITS_SAVE_TABLES to migrate it.
That sequence is UNPREDICTABLE per the architecture, but KVM already
handles the resulting state in the translate, MOVI and DISCARD paths.

Save a zeroed entry, which vgic_its_restore_ite() reads back as
invalid. Skipping the ITE instead would leave the ITT slot holding
whatever is in guest memory, and restore rejects an entry naming a
collection the restored collection table does not have.

Fixes: eff484e0298da ("KVM: arm64: vgic-its: ITT save and restore")
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Link: https://patch.msgid.link/20260807104102.2410744-2-fuad.tabba@linux.dev
Signed-off-by: Oliver Upton <oupton@kernel.org>
[aarnahmd: Upstream vgic_its_write_entry_lock() takes in the kind of table
 entry (ite) and looks up its size, while 5.10 takes in the size of an ite
 directly via ite_esz, because commit 3b2c81d5feb2 ("KVM: arm64: vgic-its:
 Add stronger type-checking to the ITS entry sizes") is not in 5.10.]
Signed-off-by: Aaron Ahmed <aarnahmd@amazon.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-its.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index e6ec0701f5616..07b8ca72111f3 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2151,6 +2151,14 @@ static int vgic_its_save_ite(struct vgic_its *its, struct its_device *dev,
 	u32 next_offset;
 	u64 val;
 
+	/*
+	 * MAPC with V=0 keeps the ITEs mapped but drops their collection,
+	 * and with it the ICID. Save a zeroed entry, which the restore path
+	 * reads back as invalid.
+	 */
+	if (!ite->collection)
+		return vgic_its_write_entry_lock(its, gpa, 0ULL, ite_esz);
+
 	next_offset = compute_next_eventid_offset(&dev->itt_head, ite);
 	val = ((u64)next_offset << KVM_ITS_ITE_NEXT_SHIFT) |
 	       ((u64)ite->irq->intid << KVM_ITS_ITE_PINTID_SHIFT) |
-- 
2.53.0



