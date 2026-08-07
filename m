Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19535346AFB;
	Fri,  7 Aug 2026 15:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116727; cv=none; b=tTlsW9mY+eFNbEKjyiDY2qtNprx+6u7SL3S+cvy1eCIgY1D5ucXe/uyYYjEpb1HL9igD2vstZAy6mk415rd0NC5756+hKi/Hf0AIRZ/7uoBPo6SJNThtcXPVVGFS8bMFxC3+xmOsbEEwn2tlPK6o/1ToY6F8i7lhEzCOfZQvksI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116727; c=relaxed/simple;
	bh=n6e+inZ7Uq+Nb8UO5eP0yodCPyI1n2/5nczCTw4r1dQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JCwC7kK6fqYkjcIXHt6QerbJxtVXBfAX2YvbfbIdywhgxicP2OCzNK2D9Xtlfq1gCbJ3xxoC7SydjR/juqKNAg1l9gaV2jJHySWxCAQsIDqdTI7yUIT6T6Uop4F51AuOTKBR/VN4Hu1cGEAwZU3x0pilomXrVHRTWXHHeDB9fg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HEPHQhSj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HEPHQhSj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342B71F00ACA;
	Fri,  7 Aug 2026 15:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116725;
	bh=7hxCE5FbufJM2Oe8yB+SUVhYc4LDmMwm7c9VM17hxvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HEPHQhSjVkLW6bEcd37YjB6vWVUntli8wMgMggFFUlUELNX2TiVqyHCceNiJV8muw
	 ro9CNSRuBtJYrB/GnDS+gvZ2E7WHq7hbE8T1xCNkzWh5IdI5FEZrXLH+ee64yYLlNF
	 g+5WdY0WEh7R3E8zA4NlRCeVqn376ylXEgvm/ZvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 024/438] of: reserved_mem: prevent OOB when too many dynamic regions are defined
Date: Fri,  7 Aug 2026 16:33:40 +0200
Message-ID: <20260807143428.523899188@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index deaea58c74f2a..47041d195dff8 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -351,6 +351,7 @@ int __init fdt_scan_reserved_mem(void)
 		err = __reserved_mem_reserve_reg(child, uname);
 		if (!err)
 			count++;
+
 		/*
 		 * Save the nodes for the dynamically-placed regions
 		 * into an array which will be used for allocation right
@@ -358,10 +359,17 @@ int __init fdt_scan_reserved_mem(void)
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



