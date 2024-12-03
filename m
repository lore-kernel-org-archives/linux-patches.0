Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BAD81ADA;
	Tue,  3 Dec 2024 16:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242336; cv=none; b=rY+7B/+DcDSvUm0EV9oGUkgPmdFe4Q97DuO5zwUvBFzh9rpNcrRlRGSMR9Z2zRqaNECzeeCblk8GYknnkIErkJWhzFts4BcqqBH7+tqvEdV9IuB2tRU+hgTicujly1s03w7ZU+GIeuVCgHG4bUmj3WlN0yk5NTtxBn+GNM7eexo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242336; c=relaxed/simple;
	bh=RJ3FMkLbu7yLb2aQ7QYVdjbmWjvAW8Tduh+Kye34CNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uVxM3638gPYAaENRcCSa6KftXELafUvqiIcwg8QIAAtKxXxMTyiMwNQ9un/uL2CL1vWCOowbTQ1H2s5bMIL2YjxeoWjYbQDB5vMC+1SGjGdCRUC/zAI/ixM7NSpUberhn0lAsHDdaMKo+bvOFh5YcG/AC4LbRyIPc53aCBWtJdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lQmaSsqm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lQmaSsqm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088F8C4CECF;
	Tue,  3 Dec 2024 16:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242336;
	bh=RJ3FMkLbu7yLb2aQ7QYVdjbmWjvAW8Tduh+Kye34CNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lQmaSsqmN1bfi19uoFb3ziGyo8YMmL3vehLo/umhXLAd1KGxyHYdvyXag2E4eDEdq
	 D39Pzm2Ah1nYjktF/L7TuzUHzfr33kP2crZgL6CzcxVe0043xeDd7fIEsT75O3WOJv
	 qHOfBJiz1vUVsUms9If459fEk94R8DMELYawdmQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 6.12 649/826] KVM: arm64: vgic-its: Clear ITE when DISCARD frees an ITE
Date: Tue,  3 Dec 2024 15:46:16 +0100
Message-ID: <20241203144809.069262519@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -782,6 +782,9 @@ static int vgic_its_cmd_handle_discard(s
 
 	ite = find_ite(its, device_id, event_id);
 	if (ite && its_is_collection_mapped(ite->collection)) {
+		struct its_device *device = find_its_device(its, device_id);
+		int ite_esz = vgic_its_get_abi(its)->ite_esz;
+		gpa_t gpa = device->itt_addr + ite->event_id * ite_esz;
 		/*
 		 * Though the spec talks about removing the pending state, we
 		 * don't bother here since we clear the ITTE anyway and the
@@ -790,7 +793,8 @@ static int vgic_its_cmd_handle_discard(s
 		vgic_its_invalidate_cache(its);
 
 		its_free_ite(kvm, ite);
-		return 0;
+
+		return vgic_its_write_entry_lock(its, gpa, 0, ite_esz);
 	}
 
 	return E_ITS_DISCARD_UNMAPPED_INTERRUPT;


