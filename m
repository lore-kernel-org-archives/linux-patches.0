Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFFEA191F98;
	Tue, 12 Aug 2025 18:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023497; cv=none; b=tszR5JPaxRPB2RzJLkQB4zAnlcBtsUiAOmkp4/91ysMCecFbwJt5tx4D3z/vm05+VMdG5CxDRPHBjYPDDmnsQ9q8s1tlYIPvHeXMTMNF+a88XUjOPKhL2V/LbFfoZ7XEpTIRDei1ViQjszQJhTrl1qxU3X48MNvXbAym5/ClAHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023497; c=relaxed/simple;
	bh=LrUP2KKnFRzh6F97ypQyqM+WPaOcFVqlZ0prvNThaeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JgBSvAXymFdQsvZF1g7IOWGY28IpzGADLvihvYbkswRdqROwVpwtrd0xxzO+ZoOxvAfz8+NWkCyfmjpSdpiTVLxJkTxPK97ef3GcPOjx31Ce3Uwt5LPBqrWYRdlS3Uv0xxfHDL5w0cN9ND7u2QLQoK/ij4eYvNHUY07SxATubN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I8w4y28j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I8w4y28j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC26C4CEF0;
	Tue, 12 Aug 2025 18:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023497;
	bh=LrUP2KKnFRzh6F97ypQyqM+WPaOcFVqlZ0prvNThaeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I8w4y28jHo3nhLTT1ckF/9WDqmZsw9/sWT8GSy8MqHLTLq3Mx4w66VlZMqwBAvrEn
	 uqxt/dFbmDpw5ZYgOvNzF87ltR3xlFKI9P6exhseeGHWYgpcJUdZxkdtI3QBiB4nTm
	 Jprt2di4Tu4ZQ+fYipT6ts8//kh/wqzq0ixTn5+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 064/627] x86/bugs: Allow ITS stuffing in eIBRS+retpoline mode also
Date: Tue, 12 Aug 2025 19:25:59 +0200
Message-ID: <20250812173421.758101515@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

[ Upstream commit ab9f2388e0b99cd164ddbd74a6133d3070e2788d ]

After a recent restructuring of the ITS mitigation, RSB stuffing can no longer
be enabled in eIBRS+Retpoline mode. Before ITS, retbleed mitigation only
allowed stuffing when eIBRS was not enabled. This was perfectly fine since
eIBRS mitigates retbleed.

However, RSB stuffing mitigation for ITS is still needed with eIBRS. The
restructuring solely relies on retbleed to deploy stuffing, and does not allow
it when eIBRS is enabled. This behavior is different from what was before the
restructuring. Fix it by allowing stuffing in eIBRS+retpoline mode also.

Fixes: 61ab72c2c6bf ("x86/bugs: Restructure ITS mitigation")
Closes: https://lore.kernel.org/lkml/20250519235101.2vm6sc5txyoykb2r@desk/
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/20250611-eibrs-fix-v4-7-5ff86cac6c61@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/bugs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 0426500307f0..f2721801d8d4 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1131,7 +1131,8 @@ static inline bool cdt_possible(enum spectre_v2_mitigation mode)
 	    !IS_ENABLED(CONFIG_MITIGATION_RETPOLINE))
 		return false;
 
-	if (mode == SPECTRE_V2_RETPOLINE)
+	if (mode == SPECTRE_V2_RETPOLINE ||
+	    mode == SPECTRE_V2_EIBRS_RETPOLINE)
 		return true;
 
 	return false;
@@ -1286,7 +1287,7 @@ static void __init retbleed_update_mitigation(void)
 
 	if (retbleed_mitigation == RETBLEED_MITIGATION_STUFF &&
 	    !cdt_possible(spectre_v2_enabled)) {
-		pr_err("WARNING: retbleed=stuff depends on spectre_v2=retpoline\n");
+		pr_err("WARNING: retbleed=stuff depends on retpoline\n");
 		retbleed_mitigation = RETBLEED_MITIGATION_NONE;
 	}
 
@@ -1459,6 +1460,7 @@ static void __init its_update_mitigation(void)
 		its_mitigation = ITS_MITIGATION_OFF;
 		break;
 	case SPECTRE_V2_RETPOLINE:
+	case SPECTRE_V2_EIBRS_RETPOLINE:
 		/* Retpoline+CDT mitigates ITS */
 		if (retbleed_mitigation == RETBLEED_MITIGATION_STUFF)
 			its_mitigation = ITS_MITIGATION_RETPOLINE_STUFF;
-- 
2.39.5



