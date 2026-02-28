Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340C233507A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302063; cv=none; b=aOlzgM8dXc5iSzj+V03hbuXivj0ZfY20VCHi75xQ5BMDs49EAKkpXMPvWia+SWc2jmgr8DPRjUrh9uJUUEoRZIUtHfzGQhJmqX9JDJNaokJcH08JmyjPJgnoDi2tjqlx+75oa52zdzBcrJAj1SDkt5eAx5QIBIg3fmr12gMds2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302063; c=relaxed/simple;
	bh=fLX0tZK+KSqHYElel2FCFO3jIywL0CUf/fVfoCuOckg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DBl0hy3ELTqsuoFs/PduyPt+DZpWqHaPMNKGjhE9uWR8FrqKOBrb5eN+IJM26U15wMz9ep66P4HrknnA3WFPSOrNlcD7jyT0xA4WXnZC99rOILbhyiLnWGXrWU77RWWMxGieDCQEdnQwU+SdKbI9L7ZC56TGDvsattwDA8vv8Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WcPwr094; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WcPwr094"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E693C19423;
	Sat, 28 Feb 2026 18:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302063;
	bh=fLX0tZK+KSqHYElel2FCFO3jIywL0CUf/fVfoCuOckg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WcPwr094/XcT8p0IIk0QIKCgriPMXCg5UNWyQrtDATG4gbaqJrp8uiUW+wR3EFJRH
	 XOfRMHUnvA3crGEFEbhFr+dri1It7uMpmz4QJULrp/NHWIuezNjwnSSza6AWPrb2Uy
	 WxB5Qelh5ZjdeY/nJC7qQL6GvsccichmXZejL5+JzKB8wsyhkCJrxQlDViOkzdFIzM
	 kAbPNznNmaSTZH3yDqKORq4JEYi/353QbdH6K/NhCyTEL72IuXBCu2QcUsuMz37XIC
	 cdGvn7hET7gz/Z1RlwHBQE2S7azaPpGV/ZVGdJ/UAEWPtX23GSCEBIIj+1e5rHaqE1
	 eBInchl9ZglLg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 040/283] ARM: VDSO: Patch out __vdso_clock_getres() if unavailable
Date: Sat, 28 Feb 2026 13:03:02 -0500
Message-ID: <20260228180709.1583486-40-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit b9fecf0dddfc55cd7d02b0011494da3c613f7cde ]

The vDSO code hides symbols which are non-functional.
__vdso_clock_getres() was not added to this list when it got introduced.

Fixes: 052e76a31b4a ("ARM: 8931/1: Add clock_getres entry point")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20251223-vdso-compat-time32-v1-6-97ea7a06a543@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/vdso.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/kernel/vdso.c b/arch/arm/kernel/vdso.c
index f297d66a8a762..32b6683b45956 100644
--- a/arch/arm/kernel/vdso.c
+++ b/arch/arm/kernel/vdso.c
@@ -176,6 +176,7 @@ static void __init patch_vdso(void *ehdr)
 		vdso_nullpatch_one(&einfo, "__vdso_gettimeofday");
 		vdso_nullpatch_one(&einfo, "__vdso_clock_gettime");
 		vdso_nullpatch_one(&einfo, "__vdso_clock_gettime64");
+		vdso_nullpatch_one(&einfo, "__vdso_clock_getres");
 	}
 }
 
-- 
2.51.0

