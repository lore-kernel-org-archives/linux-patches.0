Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8646F2F12D4;
	Fri,  9 Jan 2026 11:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959539; cv=none; b=FlCTTEoKSMNq/WfbZQdh0Uh03mdTvuCaDflu3fav+Z/75ADmeMg0uZ4srrljJqQknsYyG1q8yYwn7l/f08U0h8Ypx4VxHDx8sj8iHTzWysEfYodhKlJB8SQGM7baVweCbDo0tAlpUM0puNF7TZmGAPogHOfn8mDnybyhmLrq2ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959539; c=relaxed/simple;
	bh=pZjD4Bkdp1+zTTqWXZ40btNHIl+LD7VRLX3wUGfv36E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FKIKU5JzZj8j5WFhkpIVWhce0N1K7ei9emnohseoYrv1C65t7AVCh5eY/osyG0ZhJB3M+pR/Fx9PTQJN6rgNfp5LSG9nI/ljtfvqGcFRtyD3+j6c0I+YW2RnIDOzpeMcdrVtZurXKhcDcdLUwo4ciZnuuu1uNDnjoHx0T9+6W/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=toYAULKo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="toYAULKo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4304C4CEF1;
	Fri,  9 Jan 2026 11:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959539;
	bh=pZjD4Bkdp1+zTTqWXZ40btNHIl+LD7VRLX3wUGfv36E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=toYAULKoAg4g42Yr1Jx6tsaYbRqprpL8Q+Ie/lwCadMPUe4lfN7c/7PRUKH2WbRiq
	 X70/ixUkP7YRDqrV0Tpph86KTWA0D8lhyLky24EZDJ+d9PfVK23C+yxm8f3iRy+THW
	 p3iDFfR7gKBRENSkjTJ/fqQ38m4lUEn6UHzBZDBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 088/737] firmware: imx: scu-irq: fix OF node leak in
Date: Fri,  9 Jan 2026 12:33:47 +0100
Message-ID: <20260109112137.308516205@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit ee67247843a2b62d1473cfa4df300e69b5190ccf ]

imx_scu_enable_general_irq_channel() calls of_parse_phandle_with_args(),
but does not release the OF node reference. Add a of_node_put() call
to release the reference.

Fixes: 851826c7566e ("firmware: imx: enable imx scu general irq function")
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/imx/imx-scu-irq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/imx/imx-scu-irq.c b/drivers/firmware/imx/imx-scu-irq.c
index 6125cccc9ba79..f2b902e95b738 100644
--- a/drivers/firmware/imx/imx-scu-irq.c
+++ b/drivers/firmware/imx/imx-scu-irq.c
@@ -226,8 +226,10 @@ int imx_scu_enable_general_irq_channel(struct device *dev)
 	INIT_WORK(&imx_sc_irq_work, imx_scu_irq_work_handler);
 
 	if (!of_parse_phandle_with_args(dev->of_node, "mboxes",
-				       "#mbox-cells", 0, &spec))
+				       "#mbox-cells", 0, &spec)) {
 		i = of_alias_get_id(spec.np, "mu");
+		of_node_put(spec.np);
+	}
 
 	/* use mu1 as general mu irq channel if failed */
 	if (i < 0)
-- 
2.51.0



