Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C223BB680;
	Tue, 21 Jul 2026 22:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673492; cv=none; b=oEfexB73EpzTzIioqKXhoHuqtT8tpk8qsdX8vD0LQD2E0OGb/WZ1diXmFf4xpFKgqOPufhjf/QHKipBCex6qkm+HysbskzM+f0+k2irpw0zZ7ghck4ZTj1poZXLh4jLwYN27hzLoipHeBkOvP7YJxI7X/2QAaOfjeGzyMXw+UHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673492; c=relaxed/simple;
	bh=/lBL+fVF61F21Z/wqoI74lj8/qNEZBFdpiByIq6sgIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQD3txt3naKdGKU6htMM4wdSmFoPbLgzW34vsMKjeP5aandN1tMv5m6lKobZViDXV6F2XXA0izPq9emGUbumyOSSJpnIfMZrPRBfnjpMZYjA6IhPhV7ykTtMUcz69vSpbELuttVTgQDA1aXhNVdcfFCFnUzuQH6ERLg9smHTQLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MjGiZv8/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MjGiZv8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB0B31F00A3D;
	Tue, 21 Jul 2026 22:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673484;
	bh=mhCfVrEzLiCqBsaurQXSfsKGWzioeG21AC8z8d9E/9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MjGiZv8/3BXFXgZSXwg5xVYkmZj7mtDon0KJGG8Azbo5XZzsQV8CHpNs5sLE8KJzO
	 Zf/03Tergp36s3NHssMYFv/ge4LDs0hL6NxzcIhHG0vJjyQdBeg8rtUT1fz3IUfjHa
	 iFTXwZECv78YzGTi/SrvmV8N861hIAd36CpSeT6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingjing Deng <micro6947@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 173/699] kconfig: fix potential NULL pointer dereference in conf_askvalue
Date: Tue, 21 Jul 2026 17:18:52 +0200
Message-ID: <20260721152359.604363927@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xingjing Deng <micro6947@gmail.com>

[ Upstream commit b9d21c32dca2167a614e66c9e27999b9e1c33d55 ]

In conf_askvalue(), the 'def' argument (retrieved via sym_get_string_value)
can be NULL. While current call sites ensure that 'def' is valid,
calling printf("%s\n", def) is technically undefined behavior and could
lead to a segmentation fault on certain libc implementations if the
function were called with a NULL pointer in the future.

Improve the robustness of conf_askvalue() by providing an empty string
as a fallback.

Additionally, remove the redundant re-initialization of the 'line'
buffer inside the !sym_is_changeable(sym) block, as it is already
properly initialized at the function entry.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xingjing Deng <micro6947@gmail.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Link: https://patch.msgid.link/20260306021709.27068-1-micro6947@gmail.com
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/conf.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index f6e548b8f79556..bc3a396bce99d5 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -94,9 +94,7 @@ static int conf_askvalue(struct symbol *sym, const char *def)
 	line[1] = 0;
 
 	if (!sym_is_changeable(sym)) {
-		printf("%s\n", def);
-		line[0] = '\n';
-		line[1] = 0;
+		printf("%s\n", def ?: "");
 		return 0;
 	}
 
@@ -104,7 +102,7 @@ static int conf_askvalue(struct symbol *sym, const char *def)
 	case oldconfig:
 	case syncconfig:
 		if (sym_has_value(sym)) {
-			printf("%s\n", def);
+			printf("%s\n", def ?: "");
 			return 0;
 		}
 		/* fall through */
-- 
2.53.0



