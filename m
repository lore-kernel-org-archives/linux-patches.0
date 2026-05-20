Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AFF731F9BE;
	Wed, 20 May 2026 16:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295911; cv=none; b=jefNRni5/hE86w3dAGGOwkOEcPMpia5ZGO4zAp9Yf+1hom4jMMvUwJz0tVAgjac1b5bGMunkDlKZirB1W/v6mH2tDEXVPJdOt0qgjQsBoc/ihd50S/FBQpfuHJt7jiqgOKfyu61AWF5Rrq8hlPqfuhrW0g1OUmr5wis91Q5P2ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295911; c=relaxed/simple;
	bh=V/uH4oaX0BbOsTbsdJulD1r8pDs3mAoL/7m39dkmRIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZwGKpyLoVGkUcTvTqNsphBfShJtZ5a5oM0Wmqm25MI0i5Mrqkud7LMpugVc0wvIdSOWP2cntaDqDObz31FFbOU7xQLXeMOis5nHUdhk417NiXWWdO1UTJGrYPFcIlmh4eHdpaaqN3Ey0Hf9Bs+Z9OnaBGIWI7u6GQNIu1T8OAyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H60Z7vl1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H60Z7vl1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D995E1F000E9;
	Wed, 20 May 2026 16:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295910;
	bh=2DdSyT0/ofYlCiZOClBQ7bTQXq1bMyJKj4ou0yiBtgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H60Z7vl17yiGLdPNzxrjw9vHgXTRz3rI4Gy1VeI+z7Z30Hw4UsEaarNs8/gUARulg
	 ByrX4vQkIltBYhRAOUjHsC1IBSMKWVrUTG6u94KSX7ZUmDNnWIV3cqq3Td31VXehoS
	 3UXfrDPGF1RC92FkS8p28EtYMh3ED48+m4RIC/yk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>,
	Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0598/1146] mtd: parsers: ofpart: call of_node_put() only in ofpart_fail path
Date: Wed, 20 May 2026 18:14:08 +0200
Message-ID: <20260520162201.711830134@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>

[ Upstream commit 0c87dea1aab86116211cb37387c404c9e9231c39 ]

ofpart_none can only be reached after the for_each_child_of_node() loop
finishes. for_each_child_of_node() correctly calls of_node_put() for all
device nodes it iterates over as long as we don't break or jump out of
the loop.

Calling of_node_put() inside the ofpart_none path will wrongly decrement
the ref count of the last node in the for_each_child_of_node() loop.

Move the call to of_node_put() under the ofpart_fail label to fix this.

Fixes: ebd5a74db74e ("mtd: ofpart: Check availability of reg property instead of name property")
Signed-off-by: Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>
Tested-by: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/parsers/ofpart_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/parsers/ofpart_core.c b/drivers/mtd/parsers/ofpart_core.c
index 0029bda165bde..181ae9616b2e3 100644
--- a/drivers/mtd/parsers/ofpart_core.c
+++ b/drivers/mtd/parsers/ofpart_core.c
@@ -195,11 +195,11 @@ static int parse_fixed_partitions(struct mtd_info *master,
 ofpart_fail:
 	pr_err("%s: error parsing ofpart partition %pOF (%pOF)\n",
 	       master->name, pp, mtd_node);
+	of_node_put(pp);
 	ret = -EINVAL;
 ofpart_none:
 	if (dedicated)
 		of_node_put(ofpart_node);
-	of_node_put(pp);
 	kfree(parts);
 	return ret;
 }
-- 
2.53.0



