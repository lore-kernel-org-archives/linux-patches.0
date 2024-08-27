Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810231BC08A;
	Tue, 27 Aug 2024 15:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771613; cv=none; b=ka1B1p5vwKGqZ+V8sNt6LMBlsfqsfqP4pmz9O/RaNkiIhTEG0oJ0UvnGWC6acGD+n0Nyf4aATueFnnzONQ2ZGcmAr0vWZeEWMDczrDrX1NJ/6bcF/7rOd45GqcQ0aVafqj6D/G+qTIJj3EvuWSzDS2vQ33MnZJHCo3EoLMhqU6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771613; c=relaxed/simple;
	bh=jgCRvSlpT9+WF59VBMFi+PD2973XfhSymFX3gq5SewI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+kKwFytqoCQBYaFbfLMNw0lfEEf7DTGkwKTnnaseoTPzR+95S8nmO1s6pv8sz3rJ0GIECIRH/Sn97TjExackV7Ovr0DbrbN5EOsPypQvHDsWR13qfDkrv2DWN8lOI9EWQLF0iJMH/UyuVsN0qNBC9960/ZRKPketLZrGwoFKHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R8V1yswb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R8V1yswb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B7EC6105E;
	Tue, 27 Aug 2024 15:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771613;
	bh=jgCRvSlpT9+WF59VBMFi+PD2973XfhSymFX3gq5SewI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R8V1yswbK7QiZ7HinCmxQsZl7zBS3kp9vJiDV3o4GgdAYN5c4Xl12Tvg6Fvk6gS4a
	 gI9FjmfoO0tkUusfCWGm+765k3Eif8NrKBPJwYFg9h2Ru9Y+AEKR3kZT8qBMUWBAEf
	 kFiLdlgPXKO0IUVv3hcDVklxHJNAj/K3cnqwN2Jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zenghui Yu <yuzenghui@huawei.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 6.10 242/273] KVM: arm64: vgic-debug: Dont put unmarked LPIs
Date: Tue, 27 Aug 2024 16:39:26 +0200
Message-ID: <20240827143842.611723290@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zenghui Yu <yuzenghui@huawei.com>

commit 2240a50e6294214de791729e9dcba6880fa7e44e upstream.

If there were LPIs being mapped behind our back (i.e., between .start() and
.stop()), we would put them at iter_unmark_lpis() without checking if they
were actually *marked*, which is obviously not good.

Switch to use the xa_for_each_marked() iterator to fix it.

Cc: stable@vger.kernel.org
Fixes: 85d3ccc8b75b ("KVM: arm64: vgic-debug: Use an xarray mark for debug iterator")
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20240817101541.1664-1-yuzenghui@huawei.com
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/vgic/vgic-debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kvm/vgic/vgic-debug.c
+++ b/arch/arm64/kvm/vgic/vgic-debug.c
@@ -84,7 +84,7 @@ static void iter_unmark_lpis(struct kvm
 	struct vgic_irq *irq;
 	unsigned long intid;
 
-	xa_for_each(&dist->lpi_xa, intid, irq) {
+	xa_for_each_marked(&dist->lpi_xa, intid, irq, LPI_XA_MARK_DEBUG_ITER) {
 		xa_clear_mark(&dist->lpi_xa, intid, LPI_XA_MARK_DEBUG_ITER);
 		vgic_put_irq(kvm, irq);
 	}


