Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4596A10965;
	Sat,  3 Feb 2024 04:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933626; cv=none; b=TQM/OfUcsnqOWkmDdGjNyrc8C0R666asZ6n+JzlXPZVBmH5EicBWibY1+N7/V0TLsqsaLT2Fus9xF4a+AYi2cJWCQTW6p+Dw5d18rRHSGrkugP9oqNLoecQ0H2STiyjjRg1jmiGRf8j5FA2DhZXP010rsZHCSQMzSBYvTWE7bK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933626; c=relaxed/simple;
	bh=0pVcqtz0wc/LKMfiiwYxoRxQtZ37gSooxSG3Hnho+AY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pPegEZR5fDBieSimeg1vQi46gcmHJ9W6V6MHB9Zx5JBoVv7yb/HbFK9amA9BYEb9v6LdIW3WGVCZ4/KTwGt9PqXPcB2vq81mKuoWmnBEwIqv/nM4OwQucwgz+daHmRm5ZYjIAb7APeFpMwnLz7jyyzKkozqxT2IQ76aWAicwYes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sPsHaS9s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sPsHaS9s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0625CC433F1;
	Sat,  3 Feb 2024 04:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933626;
	bh=0pVcqtz0wc/LKMfiiwYxoRxQtZ37gSooxSG3Hnho+AY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sPsHaS9sA5ok5P4+FSuAe1IotZHaLQm6KSx2oB7oLZbSrqbMKvvKhEfO99B3s2FE3
	 QlR6mCwHH+tPQGP1O4GkLN4x4RrVhHnm74IhaJIkv7cWmEySMuPlqHzsXMfvg3NKNs
	 43Je7ZaAhYp+W6fv/jX031rrHL7emV9QY0aTuj40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 202/322] clk: mmp: pxa168: Fix memory leak in pxa168_clk_init()
Date: Fri,  2 Feb 2024 20:04:59 -0800
Message-ID: <20240203035405.762466444@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

From: Kuan-Wei Chiu <visitorckw@gmail.com>

[ Upstream commit 2fbabea626b6467eb4e6c4cb7a16523da12e43b4 ]

In cases where mapping of mpmu/apmu/apbc registers fails, the code path
does not handle the failure gracefully, potentially leading to a memory
leak. This fix ensures proper cleanup by freeing the allocated memory
for 'pxa_unit' before returning.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Link: https://lore.kernel.org/r/20231210175232.3414584-1-visitorckw@gmail.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mmp/clk-of-pxa168.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clk/mmp/clk-of-pxa168.c b/drivers/clk/mmp/clk-of-pxa168.c
index fb0df64cf053..c5a7ba1deaa3 100644
--- a/drivers/clk/mmp/clk-of-pxa168.c
+++ b/drivers/clk/mmp/clk-of-pxa168.c
@@ -308,18 +308,21 @@ static void __init pxa168_clk_init(struct device_node *np)
 	pxa_unit->mpmu_base = of_iomap(np, 0);
 	if (!pxa_unit->mpmu_base) {
 		pr_err("failed to map mpmu registers\n");
+		kfree(pxa_unit);
 		return;
 	}
 
 	pxa_unit->apmu_base = of_iomap(np, 1);
 	if (!pxa_unit->apmu_base) {
 		pr_err("failed to map apmu registers\n");
+		kfree(pxa_unit);
 		return;
 	}
 
 	pxa_unit->apbc_base = of_iomap(np, 2);
 	if (!pxa_unit->apbc_base) {
 		pr_err("failed to map apbc registers\n");
+		kfree(pxa_unit);
 		return;
 	}
 
-- 
2.43.0



