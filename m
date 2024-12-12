Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5FE23E6E3;
	Thu, 12 Dec 2024 16:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021454; cv=none; b=dqpPPBzuifVoHrB0TXtMkcOlkFjDx5mUfK8k8Gtx+Yrr2ipJ5e8GnLgXuCgRsYoZSm9cdYaaK3EjGfI1OrEylpJsY0fdGpDgklN4EYQB9fadHajcld2aPEzHfVG1VfL1uasJQUc3LvYZd+1OJh+H2GhP1h2Jp+bC8pECR1ZMORM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021454; c=relaxed/simple;
	bh=zwnCMkt+7oTdWAuvIyR4XOXGb7V1AvJmgoZFobATmpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QIx1TJh7RGbqQtsbiYug3X5zlbQ8nW5bOM4QlOUaGvCmJ9X3PY2wZPMagmwP4fQJQFbnzLMzYCgniZ/7+2VauAuJdzBWq+UcE6fvZ2I7JwgSpGxqdTmEXWFlFlQ2ookB1DUeLO07V3ZuzB6FNPdNn5y/LuNhXahvzCIV3jerA3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bB1vGSJA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bB1vGSJA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD5AC4CECE;
	Thu, 12 Dec 2024 16:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021454;
	bh=zwnCMkt+7oTdWAuvIyR4XOXGb7V1AvJmgoZFobATmpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bB1vGSJASVrhM38VUghw0SlcbzRIikg5ClMfdpal61tSFdA1F4bHEODbjlHAj6Qwi
	 u9Rm9HNogpjGPcK7jfF9zb18El/MJEmYNKhXSzsT1hvAsF0kUJ5fEemogBHPR1HO1B
	 Wq/PkoQNJsD/NHezoFI2tZTBsRPFhqrsZ7L+8ntU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 6.1 741/772] KVM: arm64: vgic-its: Clear ITE when DISCARD frees an ITE
Date: Thu, 12 Dec 2024 16:01:26 +0100
Message-ID: <20241212144420.550242680@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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


