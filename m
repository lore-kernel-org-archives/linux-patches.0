Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902783074B2;
	Tue,  2 Sep 2025 13:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820225; cv=none; b=WOmacnJW8S+ffUQwVmX7OoSSTVlm5f2BX5nXgm46/9Ucw6cKTXvMRZkjO+6cKT7NdqRy7XkV/0uVgsyrBMrpYpiqBYYNY2818XuyO2XPE2sFsXkSZmkYJfaIHNpP3lLJJWLH/qp+7rC1aDP3GjouXx78fyGyMMsjOBtYwbr7ApE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820225; c=relaxed/simple;
	bh=pGtSVY3UO+1l+6tB32oSQ159PWDx96uS8m0kDPA0/G0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JlYS8gqjBqCFhVEC9zLFI5IsQtd4AoSsoysGXZ791EPlMUukVpqbCGWwmXuMBjQ968eMZ9QwdOQLWl+vApi6HSrsQj4PobkT9gydYeHwwxMFQO1mBX9ROd9GvZrL9QGm965Rg0yqTDE4an7KuJfPzsRMcpBcEaiBrGYf3TerSMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hrnx8W2B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hrnx8W2B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 156F2C4CEED;
	Tue,  2 Sep 2025 13:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820225;
	bh=pGtSVY3UO+1l+6tB32oSQ159PWDx96uS8m0kDPA0/G0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hrnx8W2BLWZhjsvR2Dh8o0+tmo8BauR53kneJi2x9HVAkplcBroELm6p2h8ykJXv1
	 7sEAwkAipQ2fYWRdiSIxDW7XpNi+JAIOahEEhV7r0kXtzGPNHx5zs01xGt1gIVPO3a
	 wdHWRpX2qsh9Kw3dwGs1S8II4G3CYelo6ZAh713E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 06/75] of: dynamic: Fix use after free in of_changeset_add_prop_helper()
Date: Tue,  2 Sep 2025 15:20:18 +0200
Message-ID: <20250902131935.363655117@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
References: <20250902131935.107897242@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 80af3745ca465c6c47e833c1902004a7fa944f37 ]

If the of_changeset_add_property() function call fails, then this code
frees "new_pp" and then dereference it on the next line.  Return the
error code directly instead.

Fixes: c81f6ce16785 ("of: dynamic: Fix memleak when of_pci_add_properties() failed")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/aKgljjhnpa4lVpdx@stanley.mountain
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/dynamic.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/of/dynamic.c b/drivers/of/dynamic.c
index 72531f44adf09..18393800546c1 100644
--- a/drivers/of/dynamic.c
+++ b/drivers/of/dynamic.c
@@ -934,13 +934,15 @@ static int of_changeset_add_prop_helper(struct of_changeset *ocs,
 		return -ENOMEM;
 
 	ret = of_changeset_add_property(ocs, np, new_pp);
-	if (ret)
+	if (ret) {
 		__of_prop_free(new_pp);
+		return ret;
+	}
 
 	new_pp->next = np->deadprops;
 	np->deadprops = new_pp;
 
-	return ret;
+	return 0;
 }
 
 /**
-- 
2.50.1



