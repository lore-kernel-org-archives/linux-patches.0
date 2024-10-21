Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBF71F9428;
	Mon, 21 Oct 2024 10:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507816; cv=none; b=EyMC+vS9FD78GzD3S5gpGO0pphrXxZb5jrkQkWMgIdxhaJknAeSmvFpbViGtFllo5Go9mSXmc4CwB6ukVPTV1lowRfYlesdbGfHCo0QDeO3L4RUIiH1Y0eyl4hPl3RvM5mFTHySGfwf63FrdRmEFyTiJM69COX2wDXBXM6+dNnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507816; c=relaxed/simple;
	bh=QreQJ0E5eSxO/iI4wBoFy+o61q+gpx1SUty8hU98O8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fr84G1ZNlYvttGpEO2PoFQk2Db/hjwKTr0Ec7vyjMn9/fMudMCj/Sf+XsEn93X4qqx1BnjF+Jinr4PKsvpQk4YkW8eaPNWciB62eqa1jiw6EjhYl20PbGsA6vVM0woPG0BS4hTnY//JHKnNk6iqvbTwv+/2k8xF82Y2d7bav8mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lDOHrlc8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lDOHrlc8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D459C4CEC3;
	Mon, 21 Oct 2024 10:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507816;
	bh=QreQJ0E5eSxO/iI4wBoFy+o61q+gpx1SUty8hU98O8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lDOHrlc8nzKq+UXltt9Iy+qLOlOxi4W6eVddptDiGPmKjvaCwHOVC0dcr932Zxxeb
	 LOBC3C3tYFhp2JkgQoJ4663avAXgHdqhUSD+A7RMrJW6bvraicGik9GQSLOVyLU0vX
	 w7e7Vnum+EREhW+KG81TN/UJ1MEE7/AZQ9/ikru8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nianyao Tang <tangnianyao@huawei.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Marc Zyngier <maz@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 5.10 07/52] irqchip/gic-v3-its: Fix VSYNC referencing an unmapped VPE on GIC v4.1
Date: Mon, 21 Oct 2024 12:25:28 +0200
Message-ID: <20241021102241.914540507@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102241.624153108@linuxfoundation.org>
References: <20241021102241.624153108@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nianyao Tang <tangnianyao@huawei.com>

commit 80e9963fb3b5509dfcabe9652d56bf4b35542055 upstream.

As per the GICv4.1 spec (Arm IHI 0069H, 5.3.19):

 "A VMAPP with {V, Alloc}=={0, x} is self-synchronizing, This means the ITS
  command queue does not show the command as consumed until all of its
  effects are completed."

Furthermore, VSYNC is allowed to deliver an SError when referencing a
non existent VPE.

By these definitions, a VMAPP followed by a VSYNC is a bug, as the
later references a VPE that has been unmapped by the former.

Fix it by eliding the VSYNC in this scenario.

Fixes: 64edfaa9a234 ("irqchip/gic-v4.1: Implement the v4.1 flavour of VMAPP")
Signed-off-by: Nianyao Tang <tangnianyao@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Link: https://lore.kernel.org/r/20240406022737.3898763-1-tangnianyao@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-gic-v3-its.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -779,6 +779,7 @@ static struct its_vpe *its_build_vmapp_c
 					   struct its_cmd_block *cmd,
 					   struct its_cmd_desc *desc)
 {
+	struct its_vpe *vpe = valid_vpe(its, desc->its_vmapp_cmd.vpe);
 	unsigned long vpt_addr, vconf_addr;
 	u64 target;
 	bool alloc;
@@ -791,6 +792,11 @@ static struct its_vpe *its_build_vmapp_c
 		if (is_v4_1(its)) {
 			alloc = !atomic_dec_return(&desc->its_vmapp_cmd.vpe->vmapp_count);
 			its_encode_alloc(cmd, alloc);
+			/*
+			 * Unmapping a VPE is self-synchronizing on GICv4.1,
+			 * no need to issue a VSYNC.
+			 */
+			vpe = NULL;
 		}
 
 		goto out;
@@ -820,7 +826,7 @@ static struct its_vpe *its_build_vmapp_c
 out:
 	its_fixup_cmd(cmd);
 
-	return valid_vpe(its, desc->its_vmapp_cmd.vpe);
+	return vpe;
 }
 
 static struct its_vpe *its_build_vmapti_cmd(struct its_node *its,


