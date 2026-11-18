Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020422;
	b=GM0YCfHhDSF6Zk943j0Q9sMKhkDgax93LWeH0XZ4KJxsScWxlLfLz3WsdHEqKX+WRAsd
	 D0nwOgoXkMc/cZy2483aZA8r81S/7SI0XQOE3ZrbyIe3s6Z8dWttRDgfpCgoCbcbg6rPU
	 z4VyLeT0LEKUnhV+S9HKGrSiI1KnGWsaM5mFWJaH6D50uJqkgCdHBlWgH3Ix57ZxKqUzK
	 SYkxy3hOjSRNcPwzyQLt95EbAwOozun8UTYvmGe8oCQFyG0CNAushdl6yJX3mUkvXygeS
	 8MxCj+bGV9bjIbCeRcegDA9777fI60raEinBUh5YpEB2GdDTUSLoWoazhILwzoxpGOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020422;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v4HDk/DqbuptjoB0DodhVU2kaAiYxnARCrkzYXHLoMM=;
	b=Uzk26mW0qVfmPeaAHdCsw4cECjarrLFJA252Fv/GqsAva+4ATfgS9wxReqAI72wMmGr8
	 f0IrmofeZeqT0wOeC5UFpy0GrQ6MWn3/Bx7laXcQfdFqKBkGPTzood/jUx4EXkE+WxCLK
	 cFQ8+RjCqV38eTfoqRCZQKSjDWiERObbVW1mOwM7o+w8tI1Gw5tortJQBrQdM6cm9RVKm
	 dSznQ2j70saw01+W2OOhJE4dIlvQRQnfLTnd/RpV/WgCkqa79zQaXo7Fx4sVf5BEFo5dm
	 SblhqsPL72LDjGkeoaYu3vdhpgTcTyjf8yTms7cBUvawR9FETzpUKTqelpMcagWsfHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wa23Mp40;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB989606A320;
	Wed, 18 Nov 2026 16:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wa23Mp40
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7240E1F000C4;
	Wed, 18 Nov 2026 16:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020422;
	bh=v4HDk/DqbuptjoB0DodhVU2kaAiYxnARCrkzYXHLoMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wa23Mp403MtOmfzHVENSGzDWPJVHeBsgmlynFys/AVh/dQ6t1x8bQawAIBAO4lhKF
	 1z7kQ4MeG9LuajJi8Ce0jfBYAXmWWtJuPt470rm66lIQsFhYEID6HCSIpO1owoC6Gf
	 3MiOFaUqWdc1zk2YaARCRYQ9PtpTumjXOT77PNKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Thomas Gleixner <tglx@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1946/2651] irqchip/gic-v3-its: Dont free the tables of an enabled ITS
Date: Wed, 18 Nov 2026 15:53:06 +0100
Message-ID: <20261118150356.659607697@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fuad Tabba <fuad.tabba@linux.dev>

[ Upstream commit d09b36d8e0e60f35bd1cd7d63aadc6dfad61700c ]

its_probe_one() enables the ITS before its_init_domain(), the last step
that can fail, and the unwind from there frees the tables and the
command queue without disabling it. The kernel comes up with an enabled
ITS pointing at freed pages.

Enable the ITS last. Nothing reaches the new domain before then: this
runs from init_IRQ(), and the ITS joins its_nodes only after the enable.

Fixes: 4c21f3c26ecc2 ("irqchip: GICv3: ITS: DT probing and initialization")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://patch.msgid.link/20260925085000.753400-3-fuad.tabba@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 73bce111d202f..011415f59b34e 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -5334,16 +5334,18 @@ static int __init its_probe_one(struct its_node *its)
 	}
 
 	gits_write_cwriter(0, its->base + GITS_CWRITER);
+
+	err = its_init_domain(its);
+	if (err)
+		goto out_free_collection;
+
+	/* Enable last: the unwind frees memory an enabled ITS may access */
 	ctlr = readl_relaxed(its->base + GITS_CTLR);
 	ctlr |= GITS_CTLR_ENABLE;
 	if (is_v4(its))
 		ctlr |= GITS_CTLR_ImDe;
 	writel_relaxed(ctlr, its->base + GITS_CTLR);
 
-	err = its_init_domain(its);
-	if (err)
-		goto out_free_collection;
-
 	raw_spin_lock(&its_lock);
 	list_add(&its->entry, &its_nodes);
 	raw_spin_unlock(&its_lock);
-- 
2.53.0



