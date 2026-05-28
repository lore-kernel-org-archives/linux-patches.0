Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63CB282F17;
	Thu, 28 May 2026 20:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999556; cv=none; b=TlBP3i2zJsJ6mz0JF2eCrxsiLb/6c+jO0QE8BWKF374mrEKE3MeWVnjZWRCYeq09EVuQKrXNq1nzzdpzVcDkMwewxgpA1iwEFME8efqE6gG9mFHsAMgPC7/UWQU29QRGgbfOkFdio7BUZbMzluiny6Pro/xXH1Rfc4BIcWGzg/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999556; c=relaxed/simple;
	bh=1GuxvibzjpNumt29qTsyO3y+ZDPIpN4eZDgRy9uL22A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PQYsRmDr6Z6feZWM8pGrq68dNSPjR4ZZqi449nXdjmW8y+aP93SbPHxkzeGnCZj0LrSe0nj2BFTIaDd9UfvQ+l9KebZnj0ad6+gBqk74WXVZUs8YhC/vuunISZCp/ObqTERgTwhZiij5cROiaNIKxij6AGSagOMlP0CJNO3heNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=plBFVcVd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="plBFVcVd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FDFA1F000E9;
	Thu, 28 May 2026 20:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999554;
	bh=dEvKYdpvy3WI42rk6gtXQvwyKygHVUAkVZrTNHUbMLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=plBFVcVdt7bteRTvccVgyB2j4MYEqX0192ISZmWzs6npA95E7kQLUdeTacy8oN6jo
	 yIgsBJ1r9CV5ABVEbod2ZiHKRLmWzLHxaLzAtrutnu0tWm/8h0U46jq+xWvw3QgpiM
	 vL30B0xoZQGMZ6E+ss7MB69PqNDfvKeBkUNCkZ2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.18 107/377] KVM: arm64: vgic-its: Reject restored DTE with out-of-range num_eventid_bits
Date: Thu, 28 May 2026 21:45:45 +0200
Message-ID: <20260528194641.439227321@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


