Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE9C37204A;
	Sat, 12 Sep 2026 07:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197082; cv=none; b=aYdtmAiWlyLE9A7bDXl6D7P1ulUrotJ/kBGfY30s6SgfWWaLYXEVE/NLrRNBaOy7Un9U4oEVrUeDkRzv+5/qSgn5tOgC5iPL6IZU8Z2lt5KdLOsz4Qa8BDtNqBleDUKcLY+9xetQ4Y3VO/tWiMW5/O2jsLeTqlnyNcbqMiKm2H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197082; c=relaxed/simple;
	bh=IBDaGvgakyBTSwLzzlZUmjTREOwDPcuPaiN/Fa7xTAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aqZV3GPL/DKZu8bZ2wG/B/bcxHOM6yNcvvX5ATYF9YFvywaJxt28wJGB7bPMbirx2abK1aAJ3lzcTRnrCPWmfffFW6CtWQneChoRugVxxm8vmuQeslm8oBenikIc08ZPbQ5EnWa9/fh6/Bey8KoNvXd1A1Q8LOI7MEJTq+Axu6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fA74YLF2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fA74YLF2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391F61F000FF;
	Sat, 12 Sep 2026 07:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197081;
	bh=dUlIU4u5aPJCPH4bmxTWPwsFHkUtp41L77tIyuVxBE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fA74YLF2GZTRuG3qTvRhT/Q6PFXjo6TVvwdG9VNALBwoSRQ6foRCkNFvhDfdeI1Mn
	 Qp1Uz91DsMh8JALWEnIxIejSe2Ot60JEyBFXL/qYmv6pZo8ZaTeIc1Gx4ErPZGo4FK
	 BiAop6tKUd5IE0pcPsmpBSkZRgT4cMiUBot2i2jU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0090/1815] ARM: imx: fix device_node refcount leak in imx_src_init()
Date: Sat, 12 Sep 2026 08:30:40 +0200
Message-ID: <20260912065651.117859715@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Weigang He <geoffreyhe2@gmail.com>

[ Upstream commit 936407c3563ac745cbbb9953c0cf2472128a22f4 ]

imx_src_init() obtains a device_node reference via
of_find_compatible_node() matching "fsl,imx51-src" and uses it only to
call of_iomap(). It never releases that reference: on the success path
the function returns at the end without of_node_put(np), leaking one
device_node refcount on every boot of an i.MX5/6 platform.

Release the reference right after of_iomap(). of_iomap() maps the
node's registers but does not retain a reference to the device_node, so
the node can be put once the mapping is done. The early return on a NULL
np needs no put.

Found by static analysis tool CodeQL.

Fixes: bd3d924d71a4 ("ARM i.MX5: Add System Reset Controller (SRC) support for i.MX51 and i.MX53")
Signed-off-by: Weigang He <geoffreyhe2@gmail.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-imx/src.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-imx/src.c b/arch/arm/mach-imx/src.c
index 59a8e8cc44693..f28bfb653a88f 100644
--- a/arch/arm/mach-imx/src.c
+++ b/arch/arm/mach-imx/src.c
@@ -171,6 +171,7 @@ void __init imx_src_init(void)
 	if (!np)
 		return;
 	src_base = of_iomap(np, 0);
+	of_node_put(np);
 	WARN_ON(!src_base);
 
 	/*
-- 
2.53.0



