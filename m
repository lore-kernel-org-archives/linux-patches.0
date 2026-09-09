Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F475519A2;
	Wed,  9 Sep 2026 14:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962536; cv=none; b=ZrTs82myBNJrCQcFYrcHPMGmo8MYZcKQ38eqmvvJ8RI4fe56BxviUPnZQSaI09ofVF3Exz8mmbP54Pci/Esl4FTL/aObHRY+tJRoyH6LQnBQx80+UjfuLqiu+1zVG0oLr+JHoeKjjELMX9IsOcIGcw+W8cI9P3SGBk2yFcTvBoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962536; c=relaxed/simple;
	bh=9y1Bh/mCXPWaAFBx68cjTYpu7OEDlj1d96zpyN5y2s8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bK20LCcSirtUfXfe8b2wClCfO8Le8IGC6UIzH21F93BD+dQau4clTwUOtLBYmzsFhJTzCQEwQDgWp8QxWoUctovH+qs24OY39wyqNoQAxUD9WQ4TU74yKJ/KS1KMgMnn6nVjmxIrJqwe1lLU9ZiLM9SlP9Ol8xpmehkH4n9o+ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jl++zF0V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jl++zF0V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC291F00A3D;
	Wed,  9 Sep 2026 14:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962535;
	bh=2Fu6SExGaKjx2iP3GEx+nFMAcdsJ7+mcrmOsExEv4uY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jl++zF0VyAZhrFFvIFEZcTgO5fROmEoFSaWU4vKmDzt927H4CF0obz3YEfZdvFakI
	 zPbxiBuyRLiRXDzWtf0RLK0mF56nhWvqWwzpb4sDvtBkWGczD6Lxfo2KCchV2JfbLZ
	 Ar1XFNNcsp4TisMUs0cYvFca+geXEKhQQMPH1BS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 7.2 324/556] KVM: arm64: vgic-its: Dont dereference a NULL collection on ITT save
Date: Wed,  9 Sep 2026 15:40:04 +0200
Message-ID: <20260909134242.056520257@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: Fuad Tabba <fuad.tabba@linux.dev>

commit c6c156d931c33b92362383cf76f6d6e1291dcbfe upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/vgic/vgic-its.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2119,6 +2119,14 @@ static int vgic_its_save_ite(struct vgic
 	u32 next_offset;
 	u64 val;
 
+	/*
+	 * MAPC with V=0 keeps the ITEs mapped but drops their collection,
+	 * and with it the ICID. Save a zeroed entry, which the restore path
+	 * reads back as invalid.
+	 */
+	if (!ite->collection)
+		return vgic_its_write_entry_lock(its, gpa, 0ULL, ite);
+
 	next_offset = compute_next_eventid_offset(&dev->itt_head, ite);
 	val = ((u64)next_offset << KVM_ITS_ITE_NEXT_SHIFT) |
 	       ((u64)ite->irq->intid << KVM_ITS_ITE_PINTID_SHIFT) |


