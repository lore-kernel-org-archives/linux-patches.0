Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5642DC32D;
	Tue,  2 Sep 2025 13:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819354; cv=none; b=gz/wU9BDyUcif+cjthqJAQZ2Mq+vHihwwWiLrBdjwo1Y/XItZc7BDYHor0nkHw72pG8R8y1MMDBtiHsFms0Eo4lEI+2THX3awNuylQtsMYXs847NZVxVtK7GcY5XyE8G3YFjzpVmwBsiGhE85RNKZUaYBX50iYD0SxUA6TjtcII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819354; c=relaxed/simple;
	bh=VRqi9I7xRXEdVd6917FIdPvnomaPc3/K59gCaKgaApU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IgnbesDc6DNxfod4W9+rm0KFzVz4AaY740UsuZpqr61Va7qsdx+q7cnnW42u9W76Mm2x7czDUNlL1tEAceRemb+AokGLzt7rGJrZvgb5kI8r6zunoJiKDNX8675AtXby0pvWL3r1ejWf+/YamX53MPP4wq7W7SC0mjXIR6/HlQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t11t0Flm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t11t0Flm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C10C4CEF5;
	Tue,  2 Sep 2025 13:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819354;
	bh=VRqi9I7xRXEdVd6917FIdPvnomaPc3/K59gCaKgaApU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t11t0FlmAfx/CDxW0P5tLnmENLEdfnkyjUYi68B1czwOf1UHVRJlaKSDbnbSEv+GY
	 Ugz6F2yqgD5xY8PQlzyVI686+GMlln4sQ83pJRFLRMZokeGZBpsjlyGKXmZSPnkcee
	 GF+AVNO9PL/bP5TK99y3RnIHPBE1yW8eMc0Hf3ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 011/142] of: dynamic: Fix use after free in of_changeset_add_prop_helper()
Date: Tue,  2 Sep 2025 15:18:33 +0200
Message-ID: <20250902131948.589592718@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index dd30b7d8b5e46..2eaaddcb0ec4e 100644
--- a/drivers/of/dynamic.c
+++ b/drivers/of/dynamic.c
@@ -935,13 +935,15 @@ static int of_changeset_add_prop_helper(struct of_changeset *ocs,
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



