Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE5742E417;
	Sat, 12 Sep 2026 10:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209708; cv=none; b=mdoPrI+N+znmM/LI/vqrLSV+K+ICJhfXrZCl7QFl6AOMcz2K7LAFEwWpRdS8d9I39Q/1SlFH7QNEeMQs1bEQ3uMtsAd5KS4Al46jcrTCxbRqG3RbEpy6QwRx5HhCMNRI3hPno6fhCWGXLnVsu5TltfrFOTug3+UgcG/HvdmTX/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209708; c=relaxed/simple;
	bh=hp8pU5CF/5Py4zdu5wyAAby0GL8BptLBadcMKytBZ+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ijKoWf13KajbRhh6jnTlZlP7QoQYeLxImCF6Eswj4U2cxc8Atbx4JBl7Fe2govg1uF6pt4cPbZIuOZfHRzQ0azajLIgcPdyYR8oBtslGUlDXwhhyvLkhhnfpVUtBqLSHiligsATS9nGnCNIXA03ukz1LWLUXDAzpMWDtKRgdLdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N6IVK/gU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N6IVK/gU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D95501F000FF;
	Sat, 12 Sep 2026 10:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209702;
	bh=IejLQbsQffUkjDcHvfrYjyj4GBFEU9JheEgfkudVa9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N6IVK/gU70XqPWN/hLz5+UaZ7yr7mlhY8U441Zs0Vq2/jMzqLkSq1Q9GUY/9Ql0LJ
	 goE4fCiVMKYxxbeNbTGI5zOmoEkhr2iOeFu2ZhOQVUxXtbBFPd0y6LEa2KYst1qd6S
	 +j3leIs8GN68PLCv5ZkJ8PIK49WZSH7zNFjqZxwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0832/1518] soc: fsl: qe: properly scan GPIO nodes at startup
Date: Sat, 12 Sep 2026 08:50:01 +0200
Message-ID: <20260912065642.261691867@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Christophe Leroy (CS GROUP) <chleroy@kernel.org>

[ Upstream commit e2414b289c2b68afab361def612ca3791cd70d12 ]

Before commit 156460811def ("soc: fsl: qe: Change GPIO driver to a
proper platform driver") qe_add_gpiochips() was walking the device
tree to find all nodes with compatible "fsl,mpc8323-qe-pario-bank".

After that commit the discovery is handled by the platform core,
therefore it is necessary to call of_platform_default_populate() on
the par_io node.

Fixes: 156460811def ("soc: fsl: qe: Change GPIO driver to a proper platform driver")
Reviewed-by: Herve Codina <herve.codina@bootlin.com>
Link: https://lore.kernel.org/r/a1db12ef75bf881dd5fba893a37db0c8517eca1b.1785414349.git.chleroy@kernel.org
Signed-off-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/fsl/qe/qe_io.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/soc/fsl/qe/qe_io.c b/drivers/soc/fsl/qe/qe_io.c
index a5e2d0e5ab511..150913fce9818 100644
--- a/drivers/soc/fsl/qe/qe_io.c
+++ b/drivers/soc/fsl/qe/qe_io.c
@@ -15,6 +15,7 @@
 #include <linux/errno.h>
 #include <linux/module.h>
 #include <linux/ioport.h>
+#include <linux/of_platform.h>
 
 #include <asm/io.h>
 #include <soc/fsl/qe/qe.h>
@@ -184,3 +185,17 @@ int par_io_of_config(struct device_node *np)
 	return 0;
 }
 EXPORT_SYMBOL(par_io_of_config);
+
+static int __init par_io_populate(void)
+{
+	struct device_node *np = of_find_node_by_type(NULL, "par_io");
+
+	if (!np)
+		return 0;
+
+	of_platform_default_populate(np, NULL, NULL);
+	of_node_put(np);
+
+	return 0;
+}
+arch_initcall(par_io_populate);
-- 
2.53.0



