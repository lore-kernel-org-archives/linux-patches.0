Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF49F1E3797;
	Mon, 21 Oct 2024 10:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506882; cv=none; b=uYtmlyMBQo+xP035jnvAOOt7oQhqx9rbJBlSYtsGiHUIfhtpSdw9k3Vz/wVJVZgeZeTZFrjHqZMHYYrHadJU1XQJypwFXBVVSB4CrYThJVRYMCQDCQhbjeIL9SqFa3WzBjsex3nEQpJ9av4QR953Arn/eLndflndYJ3EiCDXvzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506882; c=relaxed/simple;
	bh=Ky8fcxZFYRUhIjastPmWvN1mUc1IH0I817QrNBjlOOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GGoeP0QQVrTxjQ+RqvkMAQ4r+AT8yS7P/WLCK0yRfoAqrNqYXnsJY24P5P4RD4c0Xjdxca7AHu2ctiymAwZt+nMqHrucUA4REjvFVJ8tD74pqMfKQWV8bimyUJ6JDr1grSHpgLtLwhsWscfI0xpdEyFx0CRpccu6kmPGmOg7cwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k+MJpcAQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k+MJpcAQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D1E2C4CEC3;
	Mon, 21 Oct 2024 10:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506881;
	bh=Ky8fcxZFYRUhIjastPmWvN1mUc1IH0I817QrNBjlOOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k+MJpcAQKoH5Kr92dbeUAbGdBKAK/Wz2fVCN4IsmyeRwt8aIJYNAaYG3aHqSM80mP
	 yx4NLqKo1yeRPJfCc3z4Ynwm7RjX5RRmUxmxdg4Bvbh43B8hP3AotUTesw7pTmSNIe
	 JiA4eBwpVq7gT3OABitbAEfhe9AxONjfkhz+NbYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nianyao Tang <tangnianyao@huawei.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Marc Zyngier <maz@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 6.6 017/124] irqchip/gic-v3-its: Fix VSYNC referencing an unmapped VPE on GIC v4.1
Date: Mon, 21 Oct 2024 12:23:41 +0200
Message-ID: <20241021102257.390315649@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
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
@@ -786,6 +786,7 @@ static struct its_vpe *its_build_vmapp_c
 					   struct its_cmd_block *cmd,
 					   struct its_cmd_desc *desc)
 {
+	struct its_vpe *vpe = valid_vpe(its, desc->its_vmapp_cmd.vpe);
 	unsigned long vpt_addr, vconf_addr;
 	u64 target;
 	bool alloc;
@@ -798,6 +799,11 @@ static struct its_vpe *its_build_vmapp_c
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
@@ -832,7 +838,7 @@ static struct its_vpe *its_build_vmapp_c
 out:
 	its_fixup_cmd(cmd);
 
-	return valid_vpe(its, desc->its_vmapp_cmd.vpe);
+	return vpe;
 }
 
 static struct its_vpe *its_build_vmapti_cmd(struct its_node *its,


