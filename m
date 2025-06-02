Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F4022A7EA;
	Mon,  2 Jun 2025 14:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873782; cv=none; b=pydywr1luo6Axk8U4EAkmKEA1dXpiLAmH/B9Yu8x9P41TkrKy6Sz2j3186o7+2ZV5SOesx7ckwHa+w+UvBDyfFuurC8EEd4jWO1ZW1gxk4xq6U0O4jWhNsix2cYBBk7tPXJC+yEfIbt0tN1Y3s+2phDAzMwD7IVLPZdbXTxH8TQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873782; c=relaxed/simple;
	bh=lPhLDvBVdQyQo1v/iQ9R+k9bNBliWCxmH/Z0PAPjIaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dg274KdtTnJSLcMir9zuQ/vdzU7TmPU36YJJeLnqaz9V//bnEE4BWwmQ64S9j/F2UjGXmiA1+QIeB5X4dLIpYhRsjj/xxEVrQutSLUo+s5Fd+4cTCDQAuXagPFSPK8ehAw+HEG9xjY764Di28rzmhlpfhKXUwjz6N7KpHm/LmG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IkOlvHFn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IkOlvHFn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 344C7C4CEEB;
	Mon,  2 Jun 2025 14:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873782;
	bh=lPhLDvBVdQyQo1v/iQ9R+k9bNBliWCxmH/Z0PAPjIaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IkOlvHFndPnhrb9143FzGjI7bJ2V2sYa0fAE1txQaFdmEmNFama/lkVaKFss9oBj7
	 vQF/m8TufDTT8aWdSyrDNjc+myTIH7wN/g+eEYGvHur5ZavF59PQ9KziKxX3NJtBGr
	 +1xNWiOzm05xiOWZ4JXl0SOFmaSa5dNwnAUuPd/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaohai Chen <wdhh66@163.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 251/444] scsi: target: spc: Fix loop traversal in spc_rsoc_get_descr()
Date: Mon,  2 Jun 2025 15:45:15 +0200
Message-ID: <20250602134351.112505512@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f110f932ba054..675f774be1d30 100644
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



