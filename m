Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5805647A53;
	Mon,  1 Apr 2024 15:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986647; cv=none; b=jpL6Z1bPVnazYU/lIQFxrcVgHtCDB8VPxLlsmZAuC6uJVOFVpL9z/d3ANyw/4VTmt9ZghBEUi6pgHr4yfkvamnhzEbpbAWibJb6pzGVXjapmUZI+lxcW9FPcI0hCx1OH9rPBY5tQSmYZNit7UyMqBZJRLiB6cm3lPv6/Idl4MCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986647; c=relaxed/simple;
	bh=t6IQDJw8NjqZUIceXoKvI31PuxrhhbqTSzbAPwg9a0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWjXTlrcyumr/Phw5/bDws/b8H3A2nbObiuxRn2NdTxfD4Ly7Ba5g9pSXlbQsl83v8j6UptRHR/x0LQfygCzVFzOfzg0QfgAL+Q46tzvZ/QTQTZcQCXe3orgE6ZsSnqzgEdMzU9FBpbCMNcB1qRKSpphXY0saBBoS694BTurM1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YVuTIlXX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YVuTIlXX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5635C43390;
	Mon,  1 Apr 2024 15:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986647;
	bh=t6IQDJw8NjqZUIceXoKvI31PuxrhhbqTSzbAPwg9a0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YVuTIlXXsqaaV1cPiFLQnzH0TDbNOHEikv4WyNONKucuGb5UsJv8juPz98d3yHkZU
	 QvwpqJFZUogBcCg4ayshNQ2PbQeTZFuRgQjFiWFZXTxZTGp28g1l4VwTF7Aztrb5KX
	 hZ0W9i574wD1QbVFOp41RGF1O/4wf+9FB5JyvtSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 033/399] powercap: intel_rapl_tpmi: Fix System Domain probing
Date: Mon,  1 Apr 2024 17:39:59 +0200
Message-ID: <20240401152550.154325593@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

[ Upstream commit 903eb9fb85e32810f376a2858aad77c9298f9488 ]

Only domain root packages can enumerate System (Psys) domain.
Whether a package is domain root or not is described in the Bit 0 of the
Domain Info register.

Add support for Domain Info register and fix the System domain probing
accordingly.

Fixes: 9eef7f9da928 ("powercap: intel_rapl: Introduce RAPL TPMI interface driver")
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Cc: 6.5+ <stable@vger.kernel.org> # 6.5+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/powercap/intel_rapl_tpmi.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/powercap/intel_rapl_tpmi.c b/drivers/powercap/intel_rapl_tpmi.c
index f1c734ac3c349..f6b7f085977ce 100644
--- a/drivers/powercap/intel_rapl_tpmi.c
+++ b/drivers/powercap/intel_rapl_tpmi.c
@@ -131,6 +131,12 @@ static void trp_release(struct tpmi_rapl_package *trp)
 	mutex_unlock(&tpmi_rapl_lock);
 }
 
+/*
+ * Bit 0 of TPMI_RAPL_REG_DOMAIN_INFO indicates if the current package is a domain
+ * root or not. Only domain root packages can enumerate System (Psys) Domain.
+ */
+#define TPMI_RAPL_DOMAIN_ROOT	BIT(0)
+
 static int parse_one_domain(struct tpmi_rapl_package *trp, u32 offset)
 {
 	u8 tpmi_domain_version;
@@ -140,6 +146,7 @@ static int parse_one_domain(struct tpmi_rapl_package *trp, u32 offset)
 	enum rapl_domain_reg_id reg_id;
 	int tpmi_domain_size, tpmi_domain_flags;
 	u64 tpmi_domain_header = readq(trp->base + offset);
+	u64 tpmi_domain_info;
 
 	/* Domain Parent bits are ignored for now */
 	tpmi_domain_version = tpmi_domain_header & 0xff;
@@ -170,6 +177,13 @@ static int parse_one_domain(struct tpmi_rapl_package *trp, u32 offset)
 		domain_type = RAPL_DOMAIN_PACKAGE;
 		break;
 	case TPMI_RAPL_DOMAIN_SYSTEM:
+		if (!(tpmi_domain_flags & BIT(TPMI_RAPL_REG_DOMAIN_INFO))) {
+			pr_warn(FW_BUG "System domain must support Domain Info register\n");
+			return -ENODEV;
+		}
+		tpmi_domain_info = readq(trp->base + offset + TPMI_RAPL_REG_DOMAIN_INFO);
+		if (!(tpmi_domain_info & TPMI_RAPL_DOMAIN_ROOT))
+			return 0;
 		domain_type = RAPL_DOMAIN_PLATFORM;
 		break;
 	case TPMI_RAPL_DOMAIN_MEMORY:
-- 
2.43.0



