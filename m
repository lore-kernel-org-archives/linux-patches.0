Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DD8415B8E;
	Sat, 12 Sep 2026 09:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206346; cv=none; b=mNpXPMvKOv8D/9Q4RF6xvMpYUlBmnaAw9f3svQbhLcPHytF5A7l8CRUd4l46KR+BcrxTSvrKVmctDuv8GgOfx1+u/1DNXSSpTBY9VyqkbdQ4mtpI9dj4+CNc29JE7dWuJW2BAERHBIXN5zCywADt+YdvTpoAXaedp9gX0BEc8RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206346; c=relaxed/simple;
	bh=wyelDxhaFazhLWGgVNMT7KI2usSOW0wLDbL2SAPKeC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FAIZn8u9UJgWbptT9wKn07sr4K3YRXqm4Zj4lLTew5tX7pWU3UreaFY2pbgbw5Fx9mI4EYUQMeVbSXANTef915tITx6I+sJdLZuASKUQ6sSY2wAHijp9wOx9k/BJuwWL12FgSXYM5j+UCR7Iy4NEyQ6tL35TM4E1Esbqn2wbSbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Ra/u4Dr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Ra/u4Dr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD34D1F000FF;
	Sat, 12 Sep 2026 09:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206345;
	bh=De+09WO3dMM14xwiip3UnN8U+eA47gza7wp8t3cZD00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Ra/u4DroOMyh7kHtlTlGYW02oLYJL8kEUProjennVoZrlqhkdxdGJZecW7zunYI2
	 8ZDhJqtxyivcdDF5nZLZoRVXyTPghh9I0242QI1t3Di3cVTvNakRI65PwD3aKOiq2g
	 Hed5xA+g2C3ri9oq2UGFypqri9/S6jB/VhmC/erA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0136/1518] ARM: imx: fix device_node refcount leaks in imx7_src_init()
Date: Sat, 12 Sep 2026 08:38:25 +0200
Message-ID: <20260912065626.571010043@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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



