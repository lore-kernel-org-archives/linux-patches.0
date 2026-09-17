Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA3E4ED1A4;
	Thu, 17 Sep 2026 15:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660011; cv=none; b=m0F815StEPQyAmzq0nBh7SCCCrDFXT7ejsc6xlXK/R1cc/uG2adJdMLftx2wNr5ARIlZj5dRm8bbd6SmHbEFw43LGA4P8YgQYxZCj7T+Pp09jYbZoe8C/0ogkpPwg57b5JMNGtPCIYOZpBLWYUYhFPH8Pl6HETL7P4U9TktybNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660011; c=relaxed/simple;
	bh=UUkP+zd8Ze8grXfsXZTsR+iJTNl3If73AGj3Y5FYa/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VjsVBWXnbQ/ThqRSAb0KtRjP4SFcduHSK1/UqjeIH4qZPdrZRh3KnIP1ivrMQIPr8LS+Gi7cI/L3pnjI/jKQR82u2tZrglOGStl1bM1gxJKT/RBfJWDw22Yi7CK8Ek7cuzkdAuwwvTlF1J3tQC3LJ8xK/B3dh8LOJ7D8jaQ9A9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z8HOeQox; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z8HOeQox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84BA31F00893;
	Thu, 17 Sep 2026 15:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660000;
	bh=omDbppcLIX0R47x7upb8n6QuS8aPoDsG+PBwPXGuE3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z8HOeQoxqQsajDitU5QvOvsObpC3DrM6N3FVFiOAMaVlFmLoQ/B54O3Mu+IVhWTUz
	 kqFe+AM8gd4a+HhjFPfruxnfkaMZzcBp8b8bBC1jaea+mFqVWQDYZUT7jqtCfLrBNi
	 P67m78VuMdq1lI/A1FrHpp79AQ8RlTPfe7aO4aAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 444/733] scripts/mksysmap: fix escape of $ in the __pi_ pattern
Date: Thu, 17 Sep 2026 16:12:32 +0100
Message-ID: <20260917151402.944492139@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

[ Upstream commit 59351365ac271b5e0eb180f211c531476a36221f ]

Commit b18b047002b7 ("kbuild: change scripts/mksysmap into sed script")
converted scripts/mksysmap from a shell script to a sed script.

However an error was made - escaping of '$' required \\ escaping in shell
but only \ in a sed script.

This was mostly corrected in commit 7a6c355b55c0 ("scripts/mksysmap: Fix
escape chars '$'"), but this fix missed arm64 PIE namespace local symbols
like __pi_$x and __pi_$d which appear in System.map and /proc/kallsyms:

$ grep __pi_\\$ /proc/kallsyms | sort -u
0000000000000000 d __pi_$d
0000000000000000 t __pi_$x

Fix the escaping properly.

Fixes: b18b047002b7 ("kbuild: change scripts/mksysmap into sed script")
Assisted-by: LLM
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nicolas Schier <nsc@kernel.org>
Link: https://patch.msgid.link/20260908-build-speedup-v1-2-5dc1ac01672d@kernel.org
Signed-off-by: Nicolas Schier <nsc@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/mksysmap | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/mksysmap b/scripts/mksysmap
index 56a8b8bbdb373..856b26ba2ac02 100755
--- a/scripts/mksysmap
+++ b/scripts/mksysmap
@@ -35,7 +35,7 @@
 / __efistub_/d
 
 # arm64 local symbols in PIE namespace
-/ __pi_\\$/d
+/ __pi_\$/d
 / __pi_\.L/d
 
 # arm64 local symbols in non-VHE KVM namespace
-- 
2.53.0



