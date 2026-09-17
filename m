Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37794FD78B;
	Thu, 17 Sep 2026 17:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666172; cv=none; b=JYdYTO1LrjLdM9cuBzuvboJcO80SLzH3fZmJXr4RZUzhn3afklZ+vOuSPsyNvP0QqZAtL696nrNI5TJob+dxJaf3shZRcq78hNUMFpEGVe9osO61D2dhLulKDfcE8INZ1+PurLgGY++ez3WzMFkXclchPkvYkVWS/CpV30jlLX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666172; c=relaxed/simple;
	bh=boVEaVxqX9uqUv/p5Ulb4HKOAhuHcLG1Fy9R2Yxe9aA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DLuHmRDE+8Uc1gdIVEDRfPoif/vkXtcqpbjF+o5R4M7Vs6ZM3FL1K/szahsgz20A6RbWuQ+KVYKLJbvZ7blsaZsdYKlRmHjWcyiaCPQJINcAimgpL54UPo3817qTo5xEFUopCG02L2nJrg87Wx8+d1JUfyXOHySmeF6vHI789vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x0v7SwWS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x0v7SwWS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40DBF1F000FF;
	Thu, 17 Sep 2026 17:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666170;
	bh=ZzCztV/xr6kcYv3pR8bSEOl1akE+LZZfCDBOPmaAKx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x0v7SwWSKyVqrBmg/dijb2Hrus8yDva/twPToev2TBlEeAMY+iMsHToRBySf92vBQ
	 l1U7bi2Lbzz09AuE/hIcpMjPDjjb+6HdOvVyR48xQaepOykyZ+56fLFCZsQo+nySnO
	 lt0FAo+/KPQ1E3gK7++v3OChGg4wT0OTF5ehB6cU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0949/1250] scripts/mksysmap: fix escape of $ in the __pi_ pattern
Date: Thu, 17 Sep 2026 16:12:24 +0100
Message-ID: <20260917151617.746636880@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



