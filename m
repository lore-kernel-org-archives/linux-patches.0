Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DDE837CD3E;
	Sat, 12 Sep 2026 19:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242272; cv=none; b=mFwvO35gVNT6Op9xPq8t2Zl2HIo1jOKxSGetwm9dTHof+ONhB/tzgFKaKg/d3K5H+9kWDagZ8f/mJy7iiYKCUdrq5yufsaoFyaZVR/vs/yWAuef7inMA+gI4OA+eEyAs3SdBUYCmJQkkJ4W9vT7zyxp4/E3OSuV8zWDv6sKxElM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242272; c=relaxed/simple;
	bh=f086I75VVLFzA4hNXtwZXwS7zsqfHqccreWSHE13jUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J9gJ6pOLojykh82PgP2oPjU7ilg6tL/AsHXSrH6XjL1deQu6BvNw8WYW8Ph6DmUdSoBZmJO9WPKWh+D3RZA1gmYljo8uFKeaquluT7N+W43SzR17gTlUDe2tLOHzUs24y5I7jheaFdkRzYmrlfLTZHoosvIK30nGujqrcfp2xj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xut9ADDT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xut9ADDT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E661F000FF;
	Sat, 12 Sep 2026 19:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242271;
	bh=qzE9ajVyhZ3aAIPa062fzOU/BU8thd9mX8L7ij7t9kM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xut9ADDTS1axQk7HncSJtNStjQ28A6b3J8k/hwBtXLevHOWZrsv7X+fyt5vGA60yW
	 o9yj655tVOAjfbJM1HHC0GyMoyjPO2kLI7nqYBiTejZKh1LKWic35Oyf9q9a3okHHM
	 Q2OVZWrH3TYJoRCtxrRFGLF6SVr6bv+px3REwGL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 347/798] ARM: imx: fix device_node refcount leak in imx_src_init()
Date: Sat, 12 Sep 2026 08:59:35 +0200
Message-ID: <20260912065525.114464423@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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
index f52f371292ac3..8501cea165bde 100644
--- a/arch/arm/mach-imx/src.c
+++ b/arch/arm/mach-imx/src.c
@@ -115,6 +115,7 @@ void __init imx_src_init(void)
 	if (!np)
 		return;
 	src_base = of_iomap(np, 0);
+	of_node_put(np);
 	WARN_ON(!src_base);
 
 	imx_reset_controller.of_node = np;
-- 
2.53.0



