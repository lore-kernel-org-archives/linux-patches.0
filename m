Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9F9330B2D;
	Thu, 28 May 2026 19:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998231; cv=none; b=YgN2ohoQnxXC3MlhOBvbrbWyp/HvN9taGtR7LYTODLgblsPWibqUg9bbIoJNX/7l4JYSSO6VF2osufPraFeGAScF+AHL8nPK871vFWpmcV3lJ6zCgOIKdhbx3f7ZWx4gxhQqQpTQlfZO1XdtWi9yKgsGbcf1QIoVSnaGlB9lIcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998231; c=relaxed/simple;
	bh=MGu+I3qH9SQ4EO8mPaMpezWT8bs3MQpeeLABPST5iOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AifMwjA+8zi5Aa8NkXCj67DBkLcQroXYNXdsz0N4s/p3cxB53LyTGxB49e9schmPY7quBDyI2ivQAf6v8FuJeBcpiBVmHnFtjKx6AcejZ4aD2T0rA6coA8tNNuvgbHErbfewUhRVKtDuMzSmAr9GObSMpmRA4A+nn/dLiSGCs1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zGIccXM6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zGIccXM6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16EBB1F000E9;
	Thu, 28 May 2026 19:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998230;
	bh=gzt7vToilFvQYmf6qCILiDki9wVJd19ff4KS5TnFfJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zGIccXM6IkCX33VXUHnUQkaMxfbWiBa3D5v4IfA6Z93/iAeZzQY4PeoHlof3i2Q/p
	 FiCgQN8c8M5un5y2DoxN4lVmDdYlUtveeraJQmlf57CApfBiV1CF9AHlCN95U5KOrj
	 1rrGkJizgrHT1+QJHknZogEzx2paJfwbHJN3/chc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 7.0 100/461] KVM: arm64: vgic-its: Reject restored DTE with out-of-range num_eventid_bits
Date: Thu, 28 May 2026 21:43:49 +0200
Message-ID: <20260528194649.847258581@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2307,6 +2307,10 @@ static int vgic_its_restore_dte(struct v
 	/* dte entry is valid */
 	offset = (entry & KVM_ITS_DTE_NEXT_MASK) >> KVM_ITS_DTE_NEXT_SHIFT;
 
+	/* Mimic the MAPD behaviour and reject invalid EID bits. */
+	if (num_eventid_bits > VITS_TYPER_IDBITS)
+		return -EINVAL;
+
 	if (!vgic_its_check_id(its, baser, id, NULL))
 		return -EINVAL;
 


