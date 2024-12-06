Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0016813AA5F;
	Fri,  6 Dec 2024 15:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498084; cv=none; b=jEs2sqp1a6BNBE97N7WSfrVe6/dTTr4rp19GPrhKJeyzjA1R+ohWE3AM62BBJdN2AEmUx9b2ylkywd3xJxDH/Um09isJPpjZt3wEzQeSzdGse508Z2viPSqRNoQDAfdQOUglXtS8/z0g3oODRpAKF7pLTCNrDAfy79r53n3K0fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498084; c=relaxed/simple;
	bh=FNyNaK2UVhC5ncPkMbM3KUgWJ+gAbu5qP6HQkJKANkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=isnhKyhngv/3kgk674L/791l3yeEhA++nqtA6u2nS8Vt6EUXDeYZTp15mcxaEhvIllC31zas7huPG8AVGOMRJP8Zq+EtnOK0p4VSx8YSj/np11x9qyjTl5Md91h0JT1Xbo275hxTF4izlISINU8UIe+BOoriGsJP/W+Nk2SbZmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a5VG0874; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a5VG0874"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38B3C4CED1;
	Fri,  6 Dec 2024 15:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498083;
	bh=FNyNaK2UVhC5ncPkMbM3KUgWJ+gAbu5qP6HQkJKANkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a5VG08743uMxlBkc0yQwIYCJoRxPoADeC1n5eFNoYVXH0WAGqnEHkyuql9NsWn4wo
	 VoprNtLfRoaw/AH1sHGEvAseVVz8B0ck+gkP9BTcvMUZeDg5cnzalxK9gTz7Hfralr
	 IqHiKcWNqlkt/AC31v/N4wBlPjzO2WfeRfmKX6jI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 6.6 480/676] KVM: arm64: vgic-its: Clear ITE when DISCARD frees an ITE
Date: Fri,  6 Dec 2024 15:34:59 +0100
Message-ID: <20241206143712.110914850@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kunkun Jiang <jiangkunkun@huawei.com>

commit 7602ffd1d5e8927fadd5187cb4aed2fdc9c47143 upstream.

When DISCARD frees an ITE, it does not invalidate the
corresponding ITE. In the scenario of continuous saves and
restores, there may be a situation where an ITE is not saved
but is restored. This is unreasonable and may cause restore
to fail. This patch clears the corresponding ITE when DISCARD
frees an ITE.

Cc: stable@vger.kernel.org
Fixes: eff484e0298d ("KVM: arm64: vgic-its: ITT save and restore")
Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
[Jing: Update with entry write helper]
Signed-off-by: Jing Zhang <jingzhangos@google.com>
Link: https://lore.kernel.org/r/20241107214137.428439-6-jingzhangos@google.com
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/vgic/vgic-its.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -855,6 +855,9 @@ static int vgic_its_cmd_handle_discard(s
 
 	ite = find_ite(its, device_id, event_id);
 	if (ite && its_is_collection_mapped(ite->collection)) {
+		struct its_device *device = find_its_device(its, device_id);
+		int ite_esz = vgic_its_get_abi(its)->ite_esz;
+		gpa_t gpa = device->itt_addr + ite->event_id * ite_esz;
 		/*
 		 * Though the spec talks about removing the pending state, we
 		 * don't bother here since we clear the ITTE anyway and the
@@ -863,7 +866,8 @@ static int vgic_its_cmd_handle_discard(s
 		vgic_its_invalidate_cache(kvm);
 
 		its_free_ite(kvm, ite);
-		return 0;
+
+		return vgic_its_write_entry_lock(its, gpa, 0, ite_esz);
 	}
 
 	return E_ITS_DISCARD_UNMAPPED_INTERRUPT;


