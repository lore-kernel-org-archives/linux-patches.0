Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD7A2DEA6F;
	Fri,  9 Jan 2026 11:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959902; cv=none; b=ivJkNIEwS7yhnmdWD+RMRdqP/lh+4bnrslck5YdOSnlNw/S46gf3s/a6UUJbqWjluGbu+U5FAxht8+s7kysvclbvuUIDFADgNtpr3DlrrzFmRtiZlLBvFze2fTwLYzRShXuCoTGHYAqVUMy+5GzoRaBwEb+T5XBc1ZmZyXuZZxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959902; c=relaxed/simple;
	bh=uyMcUj2fnMgP7hvzmJCKm7jHE5ecqdEnNZpA0o0pOCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T2DOM9gpoWMAm92hpR/RYBMhRy+i6vqB3sDLvd8PRAEyu2qwFg55FazMFZ573phXh0cvDxMA+g7yOJxnZiLoKY4Q3plN+iTDYPnAdnwRmXeKJQJBhURFJX568DpSn9yDIUkBdlv5ZAI5m0Fr798L2gLAgvXX1BZirnyzT/cuVJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UnSKbqQF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UnSKbqQF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBFE0C19421;
	Fri,  9 Jan 2026 11:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959902;
	bh=uyMcUj2fnMgP7hvzmJCKm7jHE5ecqdEnNZpA0o0pOCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UnSKbqQFQVE87MkCgAewaBaShmUEaI4G8C9pi//g3YdnyNDKtZ70mGunjy7WCo2mR
	 8Yuo/c+RyPpxn878fQQpqtrdfFU8ghlbrttTyikaVRoMLVvuDeUKNZ/Oi8eUSVgscN
	 iVjFiy2lpQTNgqrH8/Ax3Sdo16Pw2WiaYNgPMZyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 183/737] mfd: mt6358-irq: Fix missing irq_domain_remove() in error path
Date: Fri,  9 Jan 2026 12:35:22 +0100
Message-ID: <20260109112140.879380362@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 384bd58bf7095e4c4c8fcdbcede316ef342c630c ]

If devm_request_threaded_irq() fails after irq_domain_add_linear()
succeeds in mt6358_irq_init(), the function returns without removing
the created IRQ domain, leading to a resource leak.

Call irq_domain_remove() in the error path after a successful
irq_domain_add_linear() to properly release the IRQ domain.

Fixes: 2b91c28f2abd ("mfd: Add support for the MediaTek MT6358 PMIC")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20251118121427.583-1-vulab@iscas.ac.cn
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/mt6358-irq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/mt6358-irq.c b/drivers/mfd/mt6358-irq.c
index 49830b526ee88..10a0952615a17 100644
--- a/drivers/mfd/mt6358-irq.c
+++ b/drivers/mfd/mt6358-irq.c
@@ -286,6 +286,7 @@ int mt6358_irq_init(struct mt6397_chip *chip)
 	if (ret) {
 		dev_err(chip->dev, "Failed to register IRQ=%d, ret=%d\n",
 			chip->irq, ret);
+		irq_domain_remove(chip->irq_domain);
 		return ret;
 	}
 
-- 
2.51.0



