Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC596168D0;
	Sat,  3 Feb 2024 04:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933875; cv=none; b=nHBfJlKniAIJOu+JyTb1srGhrMyl7LGAmS2ZLMaAaInO3mj7zCWCmBx0MMth/osWLdgkHAFPIgpWEaPePp3XRR5d5DqV9v9dBJRVMexhSDDXx5gdBv29Q3sW+Wu9/2WrsWBTzYsz2O9ygBo6vzx7VCTrzf5P+Js8d6G6kntUixw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933875; c=relaxed/simple;
	bh=hCBM3aAu2ZtYEVH1PhbxF2FJCZ18qze0Tm4WipilN0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TSt2GAAkqe15BApcNld+r8YqGthNPOrzNy9nHrs0WHAJD8XWj0jwOvY4M3ikUsSJutnGkih30CaeBNaxZArBMAsqtMQwBXy85jx6zMhTOO4Zh7BO88qiy9Kk2aIqdAbN+uyt3oyC0Gh7v3T09vdEOO+iG/Mjangtj4eMW4fNN2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EN7Wo8Z4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EN7Wo8Z4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839ACC433F1;
	Sat,  3 Feb 2024 04:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933875;
	bh=hCBM3aAu2ZtYEVH1PhbxF2FJCZ18qze0Tm4WipilN0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EN7Wo8Z44+jks+WpaUiEwDkwr0GoN9NVfjaEMO6sLIMym0dypqvH3HXqzA9pUNWYQ
	 RMHjUPMYUJPpEuYu7aIB6BJuebfZPTe/JwM3FniyjvhM994Ah4dO4VHXK3yNg3OaC+
	 Y54FQ+aGoTSjby95SNwUJSo/9GYQd5Y6+XqNyw2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 214/353] clk: mmp: pxa168: Fix memory leak in pxa168_clk_init()
Date: Fri,  2 Feb 2024 20:05:32 -0800
Message-ID: <20240203035410.461730145@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



