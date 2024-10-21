Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D371E3DDB;
	Mon, 21 Oct 2024 10:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507298; cv=none; b=UY45OCCjRcwzPCatXJrYfGmE6oss+BN/oHGTDMSIkIcW1k69mN823Ckoip2GDKO6xDlW5DKf6TOCG70vXWPYuZLnQuIsZMfWC8EgfyjtR+tKjn0zLByXHBRkCesbWd7ICA/r/HRiod9xPbaaP+4fBoSGwytHwBqZdYlg5driJ/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507298; c=relaxed/simple;
	bh=Z3B6JgeYrmPClc91BKUi6vWmZEDkraGVeaokyqLbkfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y2v7v957UdaSjthBH9IfAiPSi9Vc2dnNlvHznfxyA9iHl87xKNGb/IT5cADCt15OusJwuREqi7bKaOOdBtn5Q7EeBpw0+STRVpDHWqjnbJOC7gwh2LFTYiulP12y0FcI33NBavfpU++2drcU4QZJueoXy5rTIqZXGh73gcdxBtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DngnQFa+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DngnQFa+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7BB0C4CEFA;
	Mon, 21 Oct 2024 10:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507298;
	bh=Z3B6JgeYrmPClc91BKUi6vWmZEDkraGVeaokyqLbkfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DngnQFa+YLR9TUsRhgScNrkQIhJLDgF84oyuzgajrvebBiBZ/ToV2EdteWgSXHQ5W
	 F6NwVe5QW+6UoqHgz5c995fuD9renNehdfnFbvTHPyvPMa+BtopGHthFps48v8alJW
	 7JzWj5JZK/Epvg/j05ZhdQg/z3eULF59K5JRwtL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nianyao Tang <tangnianyao@huawei.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Marc Zyngier <maz@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 6.1 31/91] irqchip/gic-v3-its: Fix VSYNC referencing an unmapped VPE on GIC v4.1
Date: Mon, 21 Oct 2024 12:24:45 +0200
Message-ID: <20241021102251.039092554@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
References: <20241021102249.791942892@linuxfoundation.org>
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
@@ -783,6 +783,7 @@ static struct its_vpe *its_build_vmapp_c
 					   struct its_cmd_block *cmd,
 					   struct its_cmd_desc *desc)
 {
+	struct its_vpe *vpe = valid_vpe(its, desc->its_vmapp_cmd.vpe);
 	unsigned long vpt_addr, vconf_addr;
 	u64 target;
 	bool alloc;
@@ -795,6 +796,11 @@ static struct its_vpe *its_build_vmapp_c
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
@@ -829,7 +835,7 @@ static struct its_vpe *its_build_vmapp_c
 out:
 	its_fixup_cmd(cmd);
 
-	return valid_vpe(its, desc->its_vmapp_cmd.vpe);
+	return vpe;
 }
 
 static struct its_vpe *its_build_vmapti_cmd(struct its_node *its,


