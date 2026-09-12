Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE6F2ECD1D;
	Sat, 12 Sep 2026 14:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223603; cv=none; b=iWtVu2ItBa0O4eUcS5LOhqtaA9KKXBY8tKUvSb9Y9W2OiYj2YPM3oq60YkOwV5SGrIIpREY0vS3uMmEJzCklPvRpdkHCMJQkhQXVnxQtPJ3GHGz2YsAdbov1Nu3s+kjDXkeqqknZ0HSAD0Ku0MacGmPyEskAQk42rgDnC++dw1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223603; c=relaxed/simple;
	bh=16S0tZxTAHFbAlteLCNIDVKVITyx7N84TCKq09l/7QI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GpaYxX2sRNmhmti+/OQ2RNcJZQgdVaL27NpDCdaemELIM3qkmukYz97Udx91q44JlMcVC9hQTF4tIL3bTpvzzDb7QCqIVLAzRnmwC5SAJmmaIm9db7h+fHcJjAk28N7O3o4sqYn5KBqE09Ayu9jC9djC2mM5alfPXRn2Y9e0NjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VBssw5zU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VBssw5zU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBFE21F000FF;
	Sat, 12 Sep 2026 14:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223602;
	bh=ZUNo6S5eaKz6CWNFbq82nOcMXSEb1oRBbQd9KZ22Qd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VBssw5zUGzeg3AT63VmKRVaYdRKrgUF6ylbUP6WzSJBXT+tOMc3cwlIx49N/KP8Xz
	 6aZM3JlLyLih2Bw+9KPZiA6JTTqmbMAossKF+AmM6C8ZPY0Nd9Kqvz3QBTN7CWW+ck
	 T+BkMTGKFkKSJYVwi+86elE8fs/fS/2IpXuv4LlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0824/1424] irqchip/gic-v3-its: Prevent leak in its_vpe_irq_domain_alloc()
Date: Sat, 12 Sep 2026 08:54:16 +0200
Message-ID: <20260912065625.758564091@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit 325ff3e78c64cd619d52b99f7c8b09a3f31e1495 ]

When its_irq_gic_domain_alloc() fails, the following
its_vpe_irq_domain_free() fails to invoke its_vep_teardown() for the
corresponding interrupt, which leaks the resource.

Invoke its_vpe_teardown() in the error handling path to avoid the leak.

[ tglx: Massaged change log ]

Fixes: 7d75bbb4bc1ad ("irqchip/gic-v3-its: Add VPE irq domain allocation/teardown")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Acked-by: Marc Zyngier <maz@kernel.org>
Link: https://patch.msgid.link/20260721063241.52549-2-shikemeng@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index b79a018f79dc1..53ca99b9d261f 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -4474,6 +4474,13 @@ static int its_vpe_init(struct its_vpe *vpe)
 
 static void its_vpe_teardown(struct its_vpe *vpe)
 {
+	/*
+	 * If vpt_page is NULL, then its_vpe_init() has failed, and
+	 * there is nothing to do as no resource has been allocated.
+	 */
+	if (vpe->vpt_page == NULL)
+		return;
+
 	its_vpe_db_proxy_unmap(vpe);
 	its_vpe_id_free(vpe->vpe_id);
 	its_free_pending_table(vpe->vpt_page);
@@ -4553,8 +4560,10 @@ static int its_vpe_irq_domain_alloc(struct irq_domain *domain, unsigned int virq
 		irqd_set_resend_when_in_progress(irq_get_irq_data(virq + i));
 	}
 
-	if (err)
+	if (err) {
+		its_vpe_teardown(vm->vpes[i]);
 		its_vpe_irq_domain_free(domain, virq, i);
+	}
 
 	return err;
 }
-- 
2.53.0



