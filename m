Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D46641B373;
	Wed,  4 Feb 2026 15:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218663; cv=none; b=WJtM/IPQ5X6/PFFf683MIe2bDV+bm7Ys03QLmTRdIYRiqFEDtTwYqf9bljAtgGWWqVIYKAI3OUwuMe/tadLkhLOkl0IOOuuMJ2dG9IC6XXA6+vOtN5sBH3eHEs8WoeFHQ6sOAAjFwhuKLekivkpcNtfcK4b1SS/Jv/dHzXX/Yos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218663; c=relaxed/simple;
	bh=7tc0Kszv4MS5EXWtEq58/RbWgY2of1gdmZJVJBIcEmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VUcRDWai7WcZG4T41tUl8g+2JOBjc8npOtgQG1HD9Py7C9xBbb416l7TZKxdUfMoZ08fRLBkpY3wSXMyAaOY6f16CdsnUvrcbAVfWul6sXBU19bxyIpulsOZMZ/MgpT2mdG3z+y9b9bomk4PqcGLMQ9gEpbqQC/8H7V+Ps7K1gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RHPxw2kw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RHPxw2kw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 703B4C4CEF7;
	Wed,  4 Feb 2026 15:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218662;
	bh=7tc0Kszv4MS5EXWtEq58/RbWgY2of1gdmZJVJBIcEmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RHPxw2kwPV4b393lb3lU8kVbZ69e+9dDqsY8U3a325dUJ+fz/+GfL76OLTpWscitJ
	 bte69U+VYML+hnrBOrG3KqdwcgcKhdtl+BxY95LO/AclwIVz47AsMfBrsv7NMIf7tw
	 C8KemQXxgxJ0u5XaL/tGDUlqxxhvkYL8JrKwkoVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kery Qi <qikeyu2017@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 24/87] scsi: firewire: sbp-target: Fix overflow in sbp_make_tpg()
Date: Wed,  4 Feb 2026 15:40:22 +0100
Message-ID: <20260204143847.780606516@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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

From: Kery Qi <qikeyu2017@gmail.com>

[ Upstream commit b2d6b1d443009ed4da2d69f5423ab38e5780505a ]

The code in sbp_make_tpg() limits "tpgt" to UINT_MAX but the data type of
"tpg->tport_tpgt" is u16. This causes a type truncation issue.

When a user creates a TPG via configfs mkdir, for example:

    mkdir /sys/kernel/config/target/sbp/<wwn>/tpgt_70000

The value 70000 passes the "tpgt > UINT_MAX" check since 70000 is far less
than 4294967295. However, when assigned to the u16 field tpg->tport_tpgt,
the value is silently truncated to 4464 (70000 & 0xFFFF). This causes the
value the user specified to differ from what is actually stored, leading to
confusion and potential unexpected behavior.

Fix this by changing the type of "tpgt" to u16 and using kstrtou16() which
will properly reject values outside the u16 range.

Fixes: a511ce339780 ("sbp-target: Initial merge of firewire/ieee-1394 target mode support")
Signed-off-by: Kery Qi <qikeyu2017@gmail.com>
Link: https://patch.msgid.link/20260121114515.1829-2-qikeyu2017@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/sbp/sbp_target.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index 3b89b5a70331f..ad03bf7929f8b 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -1961,12 +1961,12 @@ static struct se_portal_group *sbp_make_tpg(struct se_wwn *wwn,
 		container_of(wwn, struct sbp_tport, tport_wwn);
 
 	struct sbp_tpg *tpg;
-	unsigned long tpgt;
+	u16 tpgt;
 	int ret;
 
 	if (strstr(name, "tpgt_") != name)
 		return ERR_PTR(-EINVAL);
-	if (kstrtoul(name + 5, 10, &tpgt) || tpgt > UINT_MAX)
+	if (kstrtou16(name + 5, 10, &tpgt))
 		return ERR_PTR(-EINVAL);
 
 	if (tport->tpg) {
-- 
2.51.0



