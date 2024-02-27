Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE02145B09;
	Tue, 27 Feb 2024 13:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041580; cv=none; b=ceCvdveRR80g1eDD56NFN50fAbZmRKZIFFQokjeYFRNZ40WErHyLeWS2xH/7ZssKH/amowRi3fB45nJTgYMP+Kh7/bMJZQjC9vuslwjPI+vwYNDXlmRsx3Qlk/v5ToJukzyGh1i3KXv4cERDpLyugyv7MhwPTPtqQ07RWWK68Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041580; c=relaxed/simple;
	bh=VODQf+nKloXdZ/c7bvd1CQFsIk8GUA/MHFhWVSDsz6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qNKFiRSur15gtAugOeLceILr4Aqf1p/hQ0vOOlxBH3Z8NsZrH40hlCqJHA+ox6rzm6PidyrT848vbq7lShPXTepRMFcTd6LSVYuJiojpyuMEHRjdM0fTxWzWIBMneFEbbvGedVHVZO0Yd50CcFBZwkm4K7Pg/O2nWnwaoX0TZFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PX2I5P2+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PX2I5P2+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 044BAC433B1;
	Tue, 27 Feb 2024 13:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041580;
	bh=VODQf+nKloXdZ/c7bvd1CQFsIk8GUA/MHFhWVSDsz6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PX2I5P2++Sut185J3RHJDIKXxDxoufV8vG6qDhC8tcvei9oCKEZ4Z7GuR/d+r+1WK
	 nPlhUtKniaZxs6s1EXZ0/jdkaGq6QCIKOLPbxQ9lK5ync+9N6pzyysbXi7zzWnJM8W
	 jAgdZNN6JJJTuq7xfjKSUskd4q6eyevU5njblN3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 4.19 50/52] KVM: arm64: vgic-its: Test for valid IRQ in MOVALL handler
Date: Tue, 27 Feb 2024 14:26:37 +0100
Message-ID: <20240227131550.178198134@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131548.514622258@linuxfoundation.org>
References: <20240227131548.514622258@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Upton <oliver.upton@linux.dev>

commit 85a71ee9a0700f6c18862ef3b0011ed9dad99aca upstream.

It is possible that an LPI mapped in a different ITS gets unmapped while
handling the MOVALL command. If that is the case, there is no state that
can be migrated to the destination. Silently ignore it and continue
migrating other LPIs.

Cc: stable@vger.kernel.org
Fixes: ff9c114394aa ("KVM: arm/arm64: GICv4: Handle MOVALL applied to a vPE")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Link: https://lore.kernel.org/r/20240221092732.4126848-3-oliver.upton@linux.dev
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/arm/vgic/vgic-its.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1232,6 +1232,8 @@ static int vgic_its_cmd_handle_movall(st
 
 	for (i = 0; i < irq_count; i++) {
 		irq = vgic_get_irq(kvm, NULL, intids[i]);
+		if (!irq)
+			continue;
 
 		update_affinity(irq, vcpu2);
 


