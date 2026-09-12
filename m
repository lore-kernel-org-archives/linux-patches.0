Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7D5431A5C;
	Sat, 12 Sep 2026 12:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214702; cv=none; b=DgsjgM30jshnACzN9SSo4zW+lOnUFeKBIkWHssp2DuVqfyMaysC8mh/xrWjUM96YFu4HFvTn3vvk5TEj8etCdrLArdyP2k+98a5o/+h7ukMLXnMF3NA7FbbcUujYzH/QKYkelng19hXXC/5b9geM0dL5Hgn/pbgZDQDo5CVhDLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214702; c=relaxed/simple;
	bh=6ahqYzi3XE8ql9M9hSdAPiQk8fhdjpsw1H8PMkx/5c0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CfMrDKo+MxbDE1s9YW1GHKscZk2oovopY5yWu8njbIHJfb/iKR3UNQXYXBrF2QPO1PjtpYkuZYXrJwmYYmQ33A+Gf9uIGKgDTvLPHMuDd+eLhq6CS5W0bHnjHcFBobD+RCt9BUeRM6JoQ5cjEEeMHBAVVfDGX9NquV4IaMm+dcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mdhWvT1V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mdhWvT1V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C153E1F000FF;
	Sat, 12 Sep 2026 12:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214700;
	bh=Z4IVSc31ViugL72kH7ISE44IuGo/nybLzqcX/NtOxjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mdhWvT1VlCFc28Tm75NThLDYlEY7pfwmtB36Ak5ZE8TXE3HfsAjhyy4eomG+BY2gJ
	 fPVS8KxLB3soeW5fAWRPv+2GpxBDFbougaIkWPZX4CnsT95qcSoPKX8mEc+jEmgFjf
	 wTGOXVX/j0NLcwNSsjfObWVOEE6x2QEMcGdF/yAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0338/1376] ARM: imx: fix device_node refcount leak in imx_src_init()
Date: Sat, 12 Sep 2026 08:46:04 +0200
Message-ID: <20260912065615.084192998@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



