Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3296141C2F0;
	Wed,  4 Feb 2026 14:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217182; cv=none; b=gm1FVNE01c9RIulruwDX2fLKSEClNsnp6GoWK6O1gCGgSMFZN06kDLRpsH6pjGt/0VMVNGfmYCy9/ntdg/lSr47WAYeAXWe/Q/H1H6+tHCpqC4bVCLkXBoKFrAlfPcC5w17ShB6vlBMiqxL6OD9C3tZ5pAroVDmW95NRaORxVJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217182; c=relaxed/simple;
	bh=7Dui+O+ZWgco3ZR/EpGxkmIt24qlIQ9d16qFn6ee70U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iy5ICxTvUwTiPNq9aPwt0PxgWLSMXlvySfAUPKj7UMOgHHz4w/DBckmgSYafjXdFCyWhs8cD3o++GQDDDTYzgTxIP5ISsNf5z+YzWZ2nMM4eM0xRQShkJbyosNNdf8eVOSjtp+WYmC6uPqclm6fOnuPhJrHKK8WPvSO2dILGmfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wwfu1GqO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wwfu1GqO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C30BC4CEF7;
	Wed,  4 Feb 2026 14:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217182;
	bh=7Dui+O+ZWgco3ZR/EpGxkmIt24qlIQ9d16qFn6ee70U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wwfu1GqOlB2B2dvz7KBxovKxOifig4zFKCHH7yQl54c37AGCQIAgSMoZ4Y4E/MGX+
	 PYQ0JKumPLCbsu3PKbjmgD55ZwKZDt8I7O5pY+HclxovlBKHX7tCEfu0dXCQ0tnCIF
	 I5Bh4ZqyAMwWUeL9YVfRMIXpaZH96ffJUmbAASH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kery Qi <qikeyu2017@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 148/206] scsi: firewire: sbp-target: Fix overflow in sbp_make_tpg()
Date: Wed,  4 Feb 2026 15:39:39 +0100
Message-ID: <20260204143903.534911182@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b9f9fb5d7e63e..7e7d32669dfbc 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -1986,12 +1986,12 @@ static struct se_portal_group *sbp_make_tpg(struct se_wwn *wwn,
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



