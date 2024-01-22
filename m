Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF5D77636;
	Tue, 23 Jan 2024 02:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975512; cv=none; b=L+ZF+l3cPtfBneof/hgM0vPv/uuw4V1ziEHgfuQ8mu2gXqKbwMFPJQj3quv2bxJOWt13kJiVmZDdmwEkivOFaqSxmD22xjfjeu2ccglCroCX6bmcZcDSEvnpcFQGmJYfD35PJwYkhOvPWT+9a2qze6sFPqYHCevKT3Mo/PPILbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975512; c=relaxed/simple;
	bh=0G6LILvVxTYkwbPTSBP6ygx+Y2YxS2XUD7MYStiNvk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qDuC3oWMH1jwyJ43DGixr7otY0mtcGQeEZckpo9pV/d7/4MmQ/E/gaoJg9zK5pcOc0k+o913lLC6UZlBE27YaTgUHs8TQvO1xoO8P7d9z5F2zP4LB/R7qp3Qzt6a3XdyhEuTZukYBaqDIYXRBh2/ZDMXys9UDfw/pS2GJWbtk7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PQ5qRh7M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PQ5qRh7M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E84C43399;
	Tue, 23 Jan 2024 02:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975511;
	bh=0G6LILvVxTYkwbPTSBP6ygx+Y2YxS2XUD7MYStiNvk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PQ5qRh7Ml1nkzoqf0CoOXcgBngK8+0k8WBTShC/0wtP10deA6pwiFWuP95z0CWYJa
	 IoU3Db1dP35BI/7WWNiqJWLJe7bKehSaSodVi8RR5K86SMiiv6NP0yctSt9Cveawhw
	 h333TX8T0rAWv7TQ/owAZWApqS6xPOgIN87C42BY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Arnd Bergmann <arnd@arndb.de>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 440/583] mfd: syscon: Fix null pointer dereference in of_syscon_register()
Date: Mon, 22 Jan 2024 15:58:11 -0800
Message-ID: <20240122235825.446705216@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Kunwu Chan <chentao@kylinos.cn>

[ Upstream commit 41673c66b3d0c09915698fec5c13b24336f18dd1 ]

kasprintf() returns a pointer to dynamically allocated memory
which can be NULL upon failure.

Fixes: e15d7f2b81d2 ("mfd: syscon: Use a unique name with regmap_config")
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20231204092443.2462115-1-chentao@kylinos.cn
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/syscon.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
index 57b29c325131..c9550368d9ea 100644
--- a/drivers/mfd/syscon.c
+++ b/drivers/mfd/syscon.c
@@ -105,6 +105,10 @@ static struct syscon *of_syscon_register(struct device_node *np, bool check_res)
 	}
 
 	syscon_config.name = kasprintf(GFP_KERNEL, "%pOFn@%pa", np, &res.start);
+	if (!syscon_config.name) {
+		ret = -ENOMEM;
+		goto err_regmap;
+	}
 	syscon_config.reg_stride = reg_io_width;
 	syscon_config.val_bits = reg_io_width * 8;
 	syscon_config.max_register = resource_size(&res) - reg_io_width;
-- 
2.43.0



