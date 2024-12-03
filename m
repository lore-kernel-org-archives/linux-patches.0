Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B021AB6C9;
	Tue,  3 Dec 2024 15:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241385; cv=none; b=DZg6C2ku4gqnipYyEusH2csQ7/0wwI1Zmd2T2eGuTDPpQ8VAcZ4pD/oKEy1MSXHHZReGY9R11SFi7cVrv+sJavbHnKhpUCEfMKSxCKNshDhrdebHayJ/Qzt+x765afNfEEqL+nB0kj0SmQGgh+7YDFpv0afzGb0zMEynyIZD0lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241385; c=relaxed/simple;
	bh=J8JllLVVJKA0eHIWAGthMypUMFsasO8NpGZAgtZz+lM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a6yqIfrhl5IjoKJo8XNlH4NX8VWljmtcRW+g5GTcX+PCgR6Md4piAUB4ZktGykn0EDgEEHW1Zha/3XJVChSwX6B3kP1PyL/K0sZ9ZEOTnywzHLoGx6ptpYm9HoLsL2zC+wcUgviNkY+MVhTIKpgLCmtfkfWpZTuhG2+aKvmrQTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VEZrLwtU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VEZrLwtU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39D5EC4CECF;
	Tue,  3 Dec 2024 15:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241385;
	bh=J8JllLVVJKA0eHIWAGthMypUMFsasO8NpGZAgtZz+lM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VEZrLwtU5sU47rk1uhMH8AHuwX0EmfVg6xz2CN2KKycouU4BfR8c7o9EjhbvANQAw
	 +2SS9N5+4wcUmv5c63kbLbEkYztJzAgaoN3U04Vi8UGE0399xNwo78MgRGg2dggAMH
	 OLX2HUaI9Kf7N5BDWz4xhMYPgnw1689sqMyQOBQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Vincent Chen <vincent.chen@sifive.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 403/826] RISC-V: KVM: Fix APLIC in_clrip and clripnum write emulation
Date: Tue,  3 Dec 2024 15:42:10 +0100
Message-ID: <20241203144759.481767092@linuxfoundation.org>
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
index da6ff1bade0df..f59d1c0c8c43a 100644
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



