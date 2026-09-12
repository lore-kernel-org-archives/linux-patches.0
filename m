Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C80927FB37;
	Sat, 12 Sep 2026 16:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228926; cv=none; b=Uqk/dbmgrfte7Hgyc/vN6WdxfRYIiOigUURgUI9xsi6HSsQ8UQDgUfbs3gan+YnpwOkfc2WgArUZwkRrkyu+ViFlm9+BI6SCCGZ0WnwbToWSlnYzd1PMKiLr99V/esNQTFMPcagDSQ5HykGHAKDwaCUVGKZ5VPXF1MLinRDGJg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228926; c=relaxed/simple;
	bh=kys4o2z+Pyhx5BD1ADjS43E0Nq96SwJr1zo5SsPKScY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MSB++ZfhRomnZ1obPG0lzSAodVTdT3aJ7Ol1X5Ya3U2KhKwlyR7XDh3W7AKc5H3EjLREUROTNuXqnen+2ODeQBya/Ohsl98VO0qBApjxj6MjeP/gGyf5PA6gMQUnCJG7xZM3tFL2FciB/mlvqPb/uAQLb3vJ3O6+/m9zPWCfer8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kNEIjBZS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kNEIjBZS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD051F000FF;
	Sat, 12 Sep 2026 16:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228925;
	bh=QdvTQLulxm78McJ0VRyN9L4XIqzljuxmqTmcKmTZMog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kNEIjBZSD6qqpqpVLOO9319iwP/Opqssy4DnLmXU87atJCNBpGyXAGqchdfvquvAu
	 W9ji25ig1w3Fs6GobSKHNyYbiDhjJ9ZhBAMXWqKkn9/MENeKJCJLmSE3A0DdmEIcYY
	 B50dHTLPJAFKZzL0smE+x6dSafuZKhB5PcFmd4xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0485/1191] ARM: imx: fix device_node refcount leaks in imx7_src_init()
Date: Sat, 12 Sep 2026 08:53:33 +0200
Message-ID: <20260912065559.125640512@linuxfoundation.org>
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



