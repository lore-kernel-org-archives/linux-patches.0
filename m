Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6B041F7FD;
	Fri,  7 Aug 2026 14:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114728; cv=none; b=PTlz2RF2dHJ6ehPyDtkemxqrt49KRK1Jbd7u+CiDrqdBhxWGE/Q1gbrEFJ7G8kvYrqbc/KjDmFCpsjlwMOECurwERmAGdUS28KB7rEQ/sP61xy0WjIK/Gz+gTm3IYFjV5Yp1QHuUP3HwZaM+zUVFHysj1h/N8jMDeuQktPnMHtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114728; c=relaxed/simple;
	bh=IOX3iDQMYZs5S2mLztXgJCyIIT6BDr0g7QfH6qWHeIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CR7fpQCnehedG0yvAItu2TfES9NKPqssWyzYd92nTtyxfUEKbvcnZmHA7KJla82YbRpXq1aIyQdtmeZbAC0AEKVge55ZLs+NORO4HcZUgNH7MRAL+7QGhTrnZEZXUmcryOMqJDohOCsm8PapoS+JbwJFmkZxxODi1oNGePnj3Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u/9TWEtl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u/9TWEtl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71681F000E9;
	Fri,  7 Aug 2026 14:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114727;
	bh=0T33nZFvbOvGmZoCGKrHuiPbZtTdmYNynjAU+LXIzdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u/9TWEtljLwnadXh+1DXVNpsk1B3vQz2HsTLKRb8UgoUg5LQR+6Jd6gClyZfFd5/k
	 t0Mf71dPUpxcPvHJ/YtH8DrSTFzdPNsdUEgQP/z1TEWyHdMaL/arxLWlOlXGHVcAQm
	 Smw7x9BQPVLeBNzbHbqCTmr1a4p3SZGmEObKYbsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 027/396] of: reserved_mem: prevent OOB when too many dynamic regions are defined
Date: Fri,  7 Aug 2026 16:33:07 +0200
Message-ID: <20260807143424.859294945@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Sang-Heon Jeon <ekffu200098@gmail.com>

[ Upstream commit db3dbdfea1b8f38774419c5c2c14e4b81c48708d ]

On boot, fdt_scan_reserved_mem() saves each dynamically-placed
/reserved-memory subnode into a local array of size
MAX_RESERVED_REGIONS.

If the device tree defines more than MAX_RESERVED_REGIONS
dynamically-placed regions, fdt_scan_reserved_mem() writes past the
end of the local array.

Add a bounds check that logs an error and skips the excess regions,
restoring the original behavior.

Fixes: 8a6e02d0c00e ("of: reserved_mem: Restructure how the reserved memory regions are processed")
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Link: https://patch.msgid.link/20260614133807.2165124-2-ekffu200098@gmail.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/of_reserved_mem.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 39d8305a16800..56c2a1e4e86c1 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -326,6 +326,7 @@ int __init fdt_scan_reserved_mem(void)
 		err = __reserved_mem_reserve_reg(child, uname);
 		if (!err)
 			count++;
+
 		/*
 		 * Save the nodes for the dynamically-placed regions
 		 * into an array which will be used for allocation right
@@ -333,10 +334,17 @@ int __init fdt_scan_reserved_mem(void)
 		 * or marked as no-map. This is done to avoid dynamically
 		 * allocating from one of the statically-placed regions.
 		 */
-		if (err == -ENOENT && of_get_flat_dt_prop(child, "size", NULL)) {
-			dynamic_nodes[dynamic_nodes_cnt] = child;
-			dynamic_nodes_cnt++;
+		if (err != -ENOENT || !of_get_flat_dt_prop(child, "size", NULL))
+			continue;
+
+		if (dynamic_nodes_cnt == MAX_RESERVED_REGIONS) {
+			pr_err("too many defined dynamic regions, skip '%s'\n",
+			       uname);
+			continue;
 		}
+
+		dynamic_nodes[dynamic_nodes_cnt] = child;
+		dynamic_nodes_cnt++;
 	}
 	for (int i = 0; i < dynamic_nodes_cnt; i++) {
 		const char *uname;
-- 
2.53.0



