Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462C037204A;
	Sat, 12 Sep 2026 07:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197136; cv=none; b=REbnSFERbQ7lveXo+0+D8SG+9EO3GJWmua+uW7VUREF6d+5MoGwNmhURbh/CHjpigqnf+h1PAQy9ax7TGIXOJCLE07LgvvcsOjv4pfXd+JbDIsWKRQthKotYwZ2B50KDA4N3jkJ1bR460zB0Qux19YbNZ9wU84Sa/BzWo/2gCgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197136; c=relaxed/simple;
	bh=PSY+2AFCWHVJhE660xCSSPnBrx+zFFITGrhQV3fe3rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mGI4cwcS0xCGCwp5SBFHrC7CtGuP4fb6fvfLC77p8zQY5JxkHECSgP+YjJJqYP+q875WI47PzaOSTwzm9HxBpWj26q33J6tOLfw0xC+2DkKlLvA+4x28LmLI9wvmo39iJU5waBiDjwqX5Av68SXi2+88q41Yy3ynZHOrCF9CdzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ve+fWTrD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ve+fWTrD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BAF11F000FF;
	Sat, 12 Sep 2026 07:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197135;
	bh=2fz+VJP5cZqJevqOn24bF4RVoqiLaX+NlANhyZNJSlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ve+fWTrDHGlPp/dcsHBhW4ecNPlhjbx9Aq3yUGYhENduMOJkbFAwMDmz2dJ2nJKpM
	 KDzCvChqLrNcVyVtLXIEC0Ip97RHVGIlB/OuRu6iX5A1mershldd59TLu8xi+jTugw
	 ZS8Fq/xCXVJsbh7/k8RFRvdjQm0FjBzY9HcF6Hzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0091/1815] ARM: imx: fix device_node refcount leaks in imx7_src_init()
Date: Sat, 12 Sep 2026 08:30:41 +0200
Message-ID: <20260912065651.144625648@linuxfoundation.org>
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



