Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C19C79DAE;
	Wed, 21 Feb 2024 13:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522691; cv=none; b=J/OMaQFFSOc7qf84kK07vGgAN0xYzGnoEZsU3BgZM1SjNKkiHGd+B4MPfX3na/BY7U4lFo5jAUj91mRIciUvqS3oN4rVukroigo+JnmsyWfxEEhSZpU9PJxYLjGyZ5lznC8mLJXZvhCMtwQu+uWz+JVIxf/1su1GrM7Mm5EQAv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522691; c=relaxed/simple;
	bh=r9pwTylsLMakuzZMrdD8R5LY+q468eQDG5Kx8EL3SKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PhcMRWNpknIPeOJoBjcRFgQBJIY2oJYLzeJJOs0Q9oQxN7K58iaf9t+kGx8w3HGmpZa/YZlAAeXUwtYr/jFHzDnv3iltPxaNzGDn1dBUGAK6M6lYnLOQRoOeZ86oe7g9osILi229z14/5jVf30RbTFhD3RieC7KfE5S8YZuS6pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FbSLl+wy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FbSLl+wy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A80ADC433F1;
	Wed, 21 Feb 2024 13:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522691;
	bh=r9pwTylsLMakuzZMrdD8R5LY+q468eQDG5Kx8EL3SKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FbSLl+wyi/QB7N7kchx7IZsMMzgMznjKIzp0/2XmWY47LhPt/OnoCaCVjNIJbXNek
	 sTBeQ3eqOpl+6dpLBfnD75na462oQFaSdxQaqdTIM5W0ISuBi1qffhDrzOEhfQLGZO
	 2BRUN+Cr99HHMrAKIkqp13b5BeF4OAmSWnwFG0OM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 232/476] clk: mmp: pxa168: Fix memory leak in pxa168_clk_init()
Date: Wed, 21 Feb 2024 14:04:43 +0100
Message-ID: <20240221130016.464331179@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f110c02e83cb..9674c6c06dca 100644
--- a/drivers/clk/mmp/clk-of-pxa168.c
+++ b/drivers/clk/mmp/clk-of-pxa168.c
@@ -258,18 +258,21 @@ static void __init pxa168_clk_init(struct device_node *np)
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



