Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730366BB29;
	Thu, 11 Apr 2024 10:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832192; cv=none; b=ZChrU40HUz7LGoEcPJLEhTP1V1F3n9L9bDnCXTEdD7FzFOAoIujpKDwP8+eVoj9Imy1VI7C3uqJhlXAgAnH4eSSp8/0u5Y7BAdPjdIHs/fON+jKwU85eQdZBRBm6c3NVRBPCTxs1sbcTwEZdrRAZP5qguVnIiEakUDqj4vEjzKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832192; c=relaxed/simple;
	bh=9jqSkq6zquHd449jIvhm5CbUXoWIzuOqS+YaSOLHjCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FKBg1Bqj66hqx7jZqjdPYxoiP6hZWi7w/orN2PS66hOV84uh4lxgORzPadcj60togYYTdAV9lgakBeasTzOz2Fcrdhl6frTFdMiv3fnytieC+DCdhm9Hn6Nhj1oyqL0f/dH2SmC80xA4me+t6s0+egwMf5f3UY1V8bVcPoa/D3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p3AbCP6z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p3AbCP6z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEB3BC433C7;
	Thu, 11 Apr 2024 10:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832192;
	bh=9jqSkq6zquHd449jIvhm5CbUXoWIzuOqS+YaSOLHjCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p3AbCP6zfidUBzCzcfoBF42T8NSNhTlmwlD0eVg9zlVmoLCldUEf9KE74Ha6dch9A
	 QE4DmsE6gvJ/HExHbfuF4cSCubRAxe+arNeCxC830KBtEvg+W3luQnfxAlZzwhcq5d
	 ZeMRADSvdSqaOG8ozpK2NgSi73yK5rnl8egB5h4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 259/294] pinctrl: renesas: checker: Limit cfg reg enum checks to provided IDs
Date: Thu, 11 Apr 2024 11:57:02 +0200
Message-ID: <20240411095443.359353709@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 3803584a4e9b65bb5b013f862f55c5055aa86c25 ]

If the number of provided enum IDs in a variable width config register
description does not match the expected number, the checker uses the
expected number for validating the individual enum IDs.

However, this may cause out-of-bounds accesses on the array holding the
enum IDs, leading to bogus enum_id conflict warnings.  Worse, if the bug
is an incorrect bit field description (e.g. accidentally using "12"
instead of "-12" for a reserved field), thousands of warnings may be
printed, overflowing the kernel log buffer.

Fix this by limiting the enum ID check to the number of provided enum
IDs.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/c7385f44f2faebb8856bcbb4e908d846fc1531fb.1705930809.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/renesas/core.c b/drivers/pinctrl/renesas/core.c
index 54f1a7334027a..c390854483680 100644
--- a/drivers/pinctrl/renesas/core.c
+++ b/drivers/pinctrl/renesas/core.c
@@ -868,9 +868,11 @@ static void __init sh_pfc_check_cfg_reg(const char *drvname,
 		sh_pfc_err("reg 0x%x: var_field_width declares %u instead of %u bits\n",
 			   cfg_reg->reg, rw, cfg_reg->reg_width);
 
-	if (n != cfg_reg->nr_enum_ids)
+	if (n != cfg_reg->nr_enum_ids) {
 		sh_pfc_err("reg 0x%x: enum_ids[] has %u instead of %u values\n",
 			   cfg_reg->reg, cfg_reg->nr_enum_ids, n);
+		n = cfg_reg->nr_enum_ids;
+	}
 
 check_enum_ids:
 	sh_pfc_check_reg_enums(drvname, cfg_reg->reg, cfg_reg->enum_ids, n);
-- 
2.43.0



