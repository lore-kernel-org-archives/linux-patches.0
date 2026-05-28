Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A5E2459DD;
	Thu, 28 May 2026 20:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001252; cv=none; b=PKvFEb/4Iq63lkwtzyYNAg3t9TiYIqoh0OTF8HctouucFPfYzUEXJB5UQUxXxXUb8pz8BpkmG7Hic7UvQpGaDaXH6gqtM3xMV1qXea+6ktj7/e87OVdZzkljiYu63GkI3Ene3/lBXgt1OU0MkP8gjJfSDE6WTDCGWNee7TQLTbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001252; c=relaxed/simple;
	bh=U7lkXEJKaT5wEYfqNvvLV0xN50cctG87zBHR9wVdlgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AmD4co69OLvB3zPPexLTZLyZksFLxNUBoljyFyhG4q8BtdrNAWY85LtRs5HGHk3Bzx1yNbj6SlwGvpjN62RYIW5O64N/vSc6BGKmrB/1x42N7xibRQ+WuMWZfB1TiPuy9cfI2AnSzegbV0DXQ6a2mkj0gt89ckvjhfjPmaMRr38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ohA2vJqJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ohA2vJqJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B05291F000E9;
	Thu, 28 May 2026 20:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001251;
	bh=2Vbc2su3x8KfE4lUUxhQTl6K9adH6Z1nozC1hDDAM3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ohA2vJqJsJJyBpVACashH3QEfE/BuUg4P1GfctfZ/oglSbhocjd7AkIP+ujj1+6iM
	 IYVDTM07t4vIb4VrcKgHlwsSiBxCKt+cxaU1EW+tCr5h1q8ElIwFpKSDI/vj+5E0R0
	 73Dk3qUf8nlGV1rvZDe124OL6aVngY725XypcdgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.6 060/186] KVM: arm64: vgic-its: Reject restored DTE with out-of-range num_eventid_bits
Date: Thu, 28 May 2026 21:49:00 +0200
Message-ID: <20260528194930.589296458@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 9ce754ed8e7ab4e3999767ce1505f85c449ccb07 upstream.

Userspace can restore an ITS Device Table Entry whose Size field encodes
more EventID bits than the virtual ITS supports.  The live MAPD path
rejects that state, but vgic_its_restore_dte() accepts it and stores the
out-of-range value in dev->num_eventid_bits.

Reject restored DTEs with num_eventid_bits > VITS_TYPER_IDBITS before
allocating the device.  This mirrors the MAPD check and prevents the
restored state from reaching vgic_its_restore_itt(), where the unchecked
value can be converted into an oversized scan_its_table() range.

Fixes: 57a9a117154c ("KVM: arm64: vgic-its: Device table save/restore")
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Link: https://lore.kernel.org/r/20260519132519.2142458-1-michael.bommarito@gmail.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/vgic/vgic-its.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2413,6 +2413,10 @@ static int vgic_its_restore_dte(struct v
 	/* dte entry is valid */
 	offset = (entry & KVM_ITS_DTE_NEXT_MASK) >> KVM_ITS_DTE_NEXT_SHIFT;
 
+	/* Mimic the MAPD behaviour and reject invalid EID bits. */
+	if (num_eventid_bits > VITS_TYPER_IDBITS)
+		return -EINVAL;
+
 	if (!vgic_its_check_id(its, baser, id, NULL))
 		return -EINVAL;
 


