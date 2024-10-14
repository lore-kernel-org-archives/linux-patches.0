Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE8B1C57B2;
	Mon, 14 Oct 2024 14:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917425; cv=none; b=Nt+9wVjhUZtyJSASI7y1geWw4ke+3I0anoLwG3IqelTkPzD2/K7t9f467JIX0T/s1eFUhCuA+WghpyzlWBljRd3TeL2HQVzWSic12sV3K04mjrUm85vdqwfnvVgMqLlAGy8M0MJGmRixJqT2ITXwsew72RRHiL9y5aBsQ3f/YAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917425; c=relaxed/simple;
	bh=wZoirIlLhQZhcku4IbbbJDBsCibmbOsKsGC0iwRghnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h2XX6m/M5VReHJuX/fV+fwLlV7g6wTIo9diq6H+aaBIguzj0BsaJGpMCkmCt4vPDBDn1auGIC4YNqDG1ZooJ/+UmTMbEd+TFOFNwDExV/leq7CfKfnsUsvtlOPiZ3ACbTcYwg3+UFIRpj1fWYGmhKjNUsSEGHeBXBSlkwfKZ0zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ipbaBo0s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ipbaBo0s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB63C4CEC3;
	Mon, 14 Oct 2024 14:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917425;
	bh=wZoirIlLhQZhcku4IbbbJDBsCibmbOsKsGC0iwRghnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ipbaBo0sTUA/rcJNeLruNlnUizMUzIir0WEjXn8bKTGPT7R5dpK/F/e0NEp+isj+C
	 UwMy/e6sNANepKv9RK0PZk1d2mVM/HZ+6pdXdqLTbPflqvQVjhbwtjVsYI3YXJIyLf
	 AIr7xhePrWrykoUpDLlD26sEat8R7UTSDFzj37uc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 032/798] perf/arm-cmn: Improve debugfs pretty-printing for large configs
Date: Mon, 14 Oct 2024 16:09:46 +0200
Message-ID: <20241014141219.207603128@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit a1083ee717e9bde012268782e084d343314490a4 ]

The debugfs pretty-printer was written for the CMN-600 assumptions of a
maximum 8x8 mesh, but CMN-700 now allows coordinates and ID values up to
12 and 128 respectively, which can overflow the format strings, mess up
the alignment of the table and hurt overall readability. This table does
prove useful for double-checking that the driver is picking up the
topology of new systems correctly and for verifying user expectations,
so tweak the formatting to stay nice and readable with wider values.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/1d1517eadd1bac5992fab679c9dc531b381944da.1702484646.git.robin.murphy@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Stable-dep-of: e79634b53e39 ("perf/arm-cmn: Refactor node ID handling. Again.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm-cmn.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/perf/arm-cmn.c b/drivers/perf/arm-cmn.c
index 0ab6fe93f5e2b..5ddb6a8611d8c 100644
--- a/drivers/perf/arm-cmn.c
+++ b/drivers/perf/arm-cmn.c
@@ -485,6 +485,7 @@ static void arm_cmn_show_logid(struct seq_file *s, int x, int y, int p, int d)
 
 	for (dn = cmn->dns; dn->type; dn++) {
 		struct arm_cmn_nodeid nid = arm_cmn_nid(cmn, dn->id);
+		int pad = dn->logid < 10;
 
 		if (dn->type == CMN_TYPE_XP)
 			continue;
@@ -495,7 +496,7 @@ static void arm_cmn_show_logid(struct seq_file *s, int x, int y, int p, int d)
 		if (nid.x != x || nid.y != y || nid.port != p || nid.dev != d)
 			continue;
 
-		seq_printf(s, "   #%-2d  |", dn->logid);
+		seq_printf(s, " %*c#%-*d  |", pad + 1, ' ', 3 - pad, dn->logid);
 		return;
 	}
 	seq_puts(s, "        |");
@@ -508,7 +509,7 @@ static int arm_cmn_map_show(struct seq_file *s, void *data)
 
 	seq_puts(s, "     X");
 	for (x = 0; x < cmn->mesh_x; x++)
-		seq_printf(s, "    %d    ", x);
+		seq_printf(s, "    %-2d   ", x);
 	seq_puts(s, "\nY P D+");
 	y = cmn->mesh_y;
 	while (y--) {
@@ -518,13 +519,13 @@ static int arm_cmn_map_show(struct seq_file *s, void *data)
 		for (x = 0; x < cmn->mesh_x; x++)
 			seq_puts(s, "--------+");
 
-		seq_printf(s, "\n%d    |", y);
+		seq_printf(s, "\n%-2d   |", y);
 		for (x = 0; x < cmn->mesh_x; x++) {
 			struct arm_cmn_node *xp = cmn->xps + xp_base + x;
 
 			for (p = 0; p < CMN_MAX_PORTS; p++)
 				port[p][x] = arm_cmn_device_connect_info(cmn, xp, p);
-			seq_printf(s, " XP #%-2d |", xp_base + x);
+			seq_printf(s, " XP #%-3d|", xp_base + x);
 		}
 
 		seq_puts(s, "\n     |");
-- 
2.43.0



