Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82DFB3B1EFE;
	Sat, 12 Sep 2026 18:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238174; cv=none; b=pqOQ/H5AQ/1H9gc0e7pu2eRuu+JKXOP4pzEhxNlUaisiAyr9jJHU7K/Refqtd/tohj0XNj71B1nKL7CnQl7+x5xKWLHi8Tsvx54lgd4PvuCPORXlsSJQQlgt7Knqy4Y6HT+WnMfwqC8gxrl7qDC8PCY+T5HGMIsyYNDhgPn76SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238174; c=relaxed/simple;
	bh=tHO5ZdIyG8V0Q8xK+iQ7nZHFUkCux+9UzN6VhMuUgAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GP2CppRw1LfxVqzbm+vZTqcdIzPwcgmX7W4hHkfY2qGnAs7iwyJ/avDV+gPEFv8BZph0S62M4Zgr4Kt4LWCSA/MFwNKSNQAZ7gFZckD/WCqy1ws8/PS+NuNmkYVWxlOHWZ+ZEro+rZwqH5W4AkvpkcpE2fnh62GTG9+uvc33E14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vc6u8F8s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vc6u8F8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 869AC1F00893;
	Sat, 12 Sep 2026 18:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238168;
	bh=LikINOHpNLHdhcg4g2gsKgb8yFxkVuSu7flF5lutQ7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vc6u8F8sT3DEEbltuy1H1mGN8R+nWQ6O/oIN5NWO8mmuJLc6pyUw30mlqoK38kpwW
	 y4PVuCGiNoLJ2Djggi92+a1fSEfCoA3YZMNsUNYyw1gkJEz1A1PrDc2XYlYCECep3/
	 lSAOi6DQRxoe4SCH3mIAbVunKvkaQg3MuNSav2x8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 408/935] ARM: imx: fix device_node refcount leaks in imx7_src_init()
Date: Sat, 12 Sep 2026 08:57:18 +0200
Message-ID: <20260912065536.180619316@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weigang He <geoffreyhe2@gmail.com>

[ Upstream commit 3de939b2ac843d56d88e2ab1e1b1f667cba9e1d4 ]

imx7_src_init() obtains two device_node references via
of_find_compatible_node() - one for "fsl,imx7d-src" and one for
"fsl,imx7d-gpc" - reusing the same np variable, but never calls
of_node_put() on either. On every i.MX7D boot up to two device_node
refcounts are leaked:

  - The "fsl,imx7d-src" node is leaked both when of_iomap() fails (the
    early return after the mapping) and when it succeeds, because np is
    then overwritten by the second of_find_compatible_node() call
    without releasing the prior reference.
  - The "fsl,imx7d-gpc" node is leaked on every path leaving the
    function after it is acquired.

Release each reference immediately after of_iomap() consumes the node.
of_iomap() maps the node's registers but does not retain a reference to
the device_node, so it is safe to put the node once mapped; this also
drops the first reference before np is reused for the second lookup.

Found by static analysis tool CodeQL.

Fixes: e34645f45805 ("ARM: imx: add smp support for imx7d")
Signed-off-by: Weigang He <geoffreyhe2@gmail.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-imx/src.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-imx/src.c b/arch/arm/mach-imx/src.c
index f28bfb653a88f..c3c80b4c3d53b 100644
--- a/arch/arm/mach-imx/src.c
+++ b/arch/arm/mach-imx/src.c
@@ -196,6 +196,7 @@ void __init imx7_src_init(void)
 		return;
 
 	src_base = of_iomap(np, 0);
+	of_node_put(np);
 	if (!src_base)
 		return;
 
@@ -204,6 +205,7 @@ void __init imx7_src_init(void)
 		return;
 
 	gpc_base = of_iomap(np, 0);
+	of_node_put(np);
 	if (!gpc_base)
 		return;
 }
-- 
2.53.0



