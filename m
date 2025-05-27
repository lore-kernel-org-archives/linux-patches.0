Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C2D25A627;
	Tue, 27 May 2025 17:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367804; cv=none; b=lobfc46atXFaL8nUb4ddVgptAxfxMjHjyXlZ3lWkGUDNU8w3/PcsUDMpmmNezK+qKbhdteeeeBPOP9Fm/sqorHeyH/9rlCvBGjDwSattsg7qnjho32j2UV6tRLdg8szZyBH4z2V7IZXx6SGQGWoi4I6Fo0N6JcVYHIYHyoGrYEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367804; c=relaxed/simple;
	bh=KGi0YT5W1b0Wz+Fsgi45hxodSv2SH2thtIn2+LEkwu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SF07U1EL4cRZO7F9un8McvfEMmgWSVVl0i986t+qgSjTpVoHG/38Ik4skSWlPR24KOA0E7YBKNYGJ9qHjyFEm53O5LnVoqd37SilUnE+KENtzP5ok1rNCFuzHLrXiVh/pPGxpz35sWSi3ADfEO8Gy4MaOyFPeyHVlfgE6edJerU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HDN380Tz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HDN380Tz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC20EC4CEE9;
	Tue, 27 May 2025 17:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367804;
	bh=KGi0YT5W1b0Wz+Fsgi45hxodSv2SH2thtIn2+LEkwu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HDN380TzmTuqM/AZWHUaaaZAzBLXpn+G/cIm5B77cUKJUzAr90DjE+Qu8tFwAawji
	 /nLHmtz8lG5J7wbOc/xkyx+F6nH/wfUVGeRbCtidn/K1yosLiyUirjO5D7/k8nYJlS
	 HH5GRRgbr5/+Tpu3p6bFV3Qu+6/qtWIs+ssgV4As=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaohai Chen <wdhh66@163.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 504/783] scsi: target: spc: Fix loop traversal in spc_rsoc_get_descr()
Date: Tue, 27 May 2025 18:25:01 +0200
Message-ID: <20250527162533.662550571@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chaohai Chen <wdhh66@163.com>

[ Upstream commit 04ad06e41d1c74cc323b20a7bd023c47bd0e0c38 ]

Stop traversing after finding the appropriate descriptor.

Signed-off-by: Chaohai Chen <wdhh66@163.com>
Link: https://lore.kernel.org/r/20250124085542.109088-1-wdhh66@163.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_spc.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 785a97536212b..0a02492bef701 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -2151,8 +2151,10 @@ spc_rsoc_get_descr(struct se_cmd *cmd, struct target_opcode_descriptor **opcode)
 			if (descr->serv_action_valid)
 				return TCM_INVALID_CDB_FIELD;
 
-			if (!descr->enabled || descr->enabled(descr, cmd))
+			if (!descr->enabled || descr->enabled(descr, cmd)) {
 				*opcode = descr;
+				return TCM_NO_SENSE;
+			}
 			break;
 		case 0x2:
 			/*
@@ -2166,8 +2168,10 @@ spc_rsoc_get_descr(struct se_cmd *cmd, struct target_opcode_descriptor **opcode)
 			if (descr->serv_action_valid &&
 			    descr->service_action == requested_sa) {
 				if (!descr->enabled || descr->enabled(descr,
-								      cmd))
+								      cmd)) {
 					*opcode = descr;
+					return TCM_NO_SENSE;
+				}
 			} else if (!descr->serv_action_valid)
 				return TCM_INVALID_CDB_FIELD;
 			break;
@@ -2180,13 +2184,15 @@ spc_rsoc_get_descr(struct se_cmd *cmd, struct target_opcode_descriptor **opcode)
 			 */
 			if (descr->service_action == requested_sa)
 				if (!descr->enabled || descr->enabled(descr,
-								      cmd))
+								      cmd)) {
 					*opcode = descr;
+					return TCM_NO_SENSE;
+				}
 			break;
 		}
 	}
 
-	return 0;
+	return TCM_NO_SENSE;
 }
 
 static sense_reason_t
-- 
2.39.5



