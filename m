Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D1F526AC5;
	Sat, 12 Sep 2026 16:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230824; cv=none; b=ATE5PDlepk0/E0UYX3Yt0sBtaGJmt8D+EjqysBrR0CbJEYPpCgO3NHZoldwMreauVCRdNHS8L7dSGqQGlfpgJNz99/5e+shEsK2gKYjK4GkklHO9xFBdfKUp8qrKOvjaNThm1X3meMWwufwiTfsijJKUXZxiGQIr0v6cmOfESko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230824; c=relaxed/simple;
	bh=tPGcJGyuE9+pF9A1kICwXPEOjuBs+yEp8h+WLiSDz8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lkYK/v6N2qtxImwDXjDihvrwjRHF9qzOlkicsz0j9o21C1+8R98gN2DU4MLi/rVV0CJjIHcvy3uYRDVK+4QCj9AwLJVHiK60m7d2UKJTPgDQVjEoPEyoTHX87HSGAelSHkGCkAes0yQncMaDfIs+dAG1JmkPUzCGDJraApUkYSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SLH2gMFy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SLH2gMFy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5F11F000FF;
	Sat, 12 Sep 2026 16:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230823;
	bh=iytB+CZ0sD90vcbcEg5O/PVg6Hlq9QSDC9klsQhAat4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SLH2gMFyaQr6Yew5sSnIHOjvT0cPUGA7OlHQWsEkugd9cnTvLNvPm8fAYBY4TYdyI
	 JJoRufupINHFTmqc4kufAweV5dxIyJvqRgNXlsNypnD3WC/isum/ccxbSbVudUPVXU
	 DPXvRsjMvC1nippcdj3IVoZa1rVBkez64rE2KeiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robertus Diawan Chris <robertusdchris@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0871/1191] modpost: prevent leak when early return no suffix .o in read_symbols()
Date: Sat, 12 Sep 2026 08:59:59 +0200
Message-ID: <20260912065607.817677845@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robertus Diawan Chris <robertusdchris@gmail.com>

[ Upstream commit 9a5b76027ed91680e10f90111d9cba300f96d1ab ]

The allocation for elf info symsearch and hdr from parse_elf() haven't
been released when return because of modname didn't have suffix ".o".
And it seems like the suffix ".o" check did not depends on parse_elf()
to succeed first. So, move the suffix ".o" check before checking
parse_elf() result to prevent resource leak when the modname didn't have
suffix ".o" and return early.

This is reported by Coverity Scan as "Resource leak".

Fixes: 8c9ce89c5b63 ("modpost: simplify mod->name allocation")
Signed-off-by: Robertus Diawan Chris <robertusdchris@gmail.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Link: https://patch.msgid.link/20260624044742.144852-1-robertusdchris@gmail.com
Signed-off-by: Nicolas Schier <nsc@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/mod/modpost.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 06adeff43b5eb..b2388814fe976 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1754,14 +1754,14 @@ static void read_symbols(const char *modname)
 	struct elf_info info = { };
 	Elf_Sym *sym;
 
-	if (!parse_elf(&info, modname))
-		return;
-
 	if (!strends(modname, ".o")) {
 		error("%s: filename must be suffixed with .o\n", modname);
 		return;
 	}
 
+	if (!parse_elf(&info, modname))
+		return;
+
 	/* strip trailing .o */
 	mod = new_module(modname, strlen(modname) - strlen(".o"));
 
-- 
2.53.0



