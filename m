Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8DD4148832;
	Fri,  6 Dec 2024 15:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497425; cv=none; b=Piun3yLwhTj4tTgpN7NkhDyZEWlNcY5VWeKvib3JUQZSzigTsgYlbh3DDREJoHrudpL01eo/0z4Ko1zCStwhToBzz082Pp2WiHTB8PzKKrrlg23MLqT6Xik3GzqMt7sj4rFq/7YvSU1ZSDnmih4POXM5cnXrPYzUbaROg7OrfpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497425; c=relaxed/simple;
	bh=nJvNqgivCtzLxBcZ+pSnuipZSAOVuqHSpZEnJc8JI8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R8H8TXOQz5EKK2aGEYCv0f4bX74oGd43yN2adbffYEjbI0G7qF2boyTvQl4rT2KwnYGMQbj4+/Ev7pgg556ZaNtmheMYnAK6btZhttWZHFTu9kBg2X/35wh2qgcs4uf2qO8O8ZdJKHzAb89opDMUUnetZPAf1byhhLNPvhuEiYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uG/AJGDm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uG/AJGDm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 434B7C4CED1;
	Fri,  6 Dec 2024 15:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497425;
	bh=nJvNqgivCtzLxBcZ+pSnuipZSAOVuqHSpZEnJc8JI8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uG/AJGDmz4jX1ZUK14e74yln3GEyAZc4RoflE1nTQgpV/8I5f6Oxbd5Qxr4c4ZORP
	 XZ5nvLNIdhhDhFWuu410Ge2KVWcy/u2/8hiayrl5N9gpuOxnaXIIox8vOkVqLSsX9w
	 vDITvDfwppXWf48z22IQ1Bvtd0lUcuUemChVxGqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Vincent Chen <vincent.chen@sifive.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 289/676] RISC-V: KVM: Fix APLIC in_clrip and clripnum write emulation
Date: Fri,  6 Dec 2024 15:31:48 +0100
Message-ID: <20241206143704.629615182@linuxfoundation.org>
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

From: Yong-Xuan Wang <yongxuan.wang@sifive.com>

[ Upstream commit 60821fb4dd7345e5662094accf0a52845306de8c ]

In the section "4.7 Precise effects on interrupt-pending bits"
of the RISC-V AIA specification defines that:

"If the source mode is Level1 or Level0 and the interrupt domain
is configured in MSI delivery mode (domaincfg.DM = 1):
The pending bit is cleared whenever the rectified input value is
low, when the interrupt is forwarded by MSI, or by a relevant
write to an in_clrip register or to clripnum."

Update the aplic_write_pending() to match the spec.

Fixes: d8dd9f113e16 ("RISC-V: KVM: Fix APLIC setipnum_le/be write emulation")
Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Reviewed-by: Vincent Chen <vincent.chen@sifive.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/r/20241029085542.30541-1-yongxuan.wang@sifive.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/aia_aplic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/aia_aplic.c b/arch/riscv/kvm/aia_aplic.c
index b467ba5ed9100..9d5b04c971c4d 100644
--- a/arch/riscv/kvm/aia_aplic.c
+++ b/arch/riscv/kvm/aia_aplic.c
@@ -143,7 +143,7 @@ static void aplic_write_pending(struct aplic *aplic, u32 irq, bool pending)
 	if (sm == APLIC_SOURCECFG_SM_LEVEL_HIGH ||
 	    sm == APLIC_SOURCECFG_SM_LEVEL_LOW) {
 		if (!pending)
-			goto skip_write_pending;
+			goto noskip_write_pending;
 		if ((irqd->state & APLIC_IRQ_STATE_INPUT) &&
 		    sm == APLIC_SOURCECFG_SM_LEVEL_LOW)
 			goto skip_write_pending;
@@ -152,6 +152,7 @@ static void aplic_write_pending(struct aplic *aplic, u32 irq, bool pending)
 			goto skip_write_pending;
 	}
 
+noskip_write_pending:
 	if (pending)
 		irqd->state |= APLIC_IRQ_STATE_PENDING;
 	else
-- 
2.43.0



