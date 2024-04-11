Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9BD62EAE5;
	Thu, 11 Apr 2024 10:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832720; cv=none; b=eFae+VvvBIgZWKup7JDXepMTUz+pdiNe68+VSBdQ7gGdxEZebaz+w7Xwfh+rBCihgXbexVUBa9oP+y/I3eA4MuJ2eFKO+BZzM3/1kTt8lBdmmO7y8FDoavtKEDy/AJC5t0Thy4OAI0SN+bzOeMO+KM+vOkx8vUH6/I95SxoyxG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832720; c=relaxed/simple;
	bh=1J93E/afZNCthVmeH02jAU9Cr86qqRVQTHWLCPzcr3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2rbRVJTVUG8B0D5dZ4gsUFScbwScgqM5xeJ0Zu5Ma/gFkkRe5ZJ0X1kjR3C+aRIKU+nz1s8koqrTK7el+PaCkXWjQHy99JPafgvuKQuReyOC2yy+QtBzlmzXa7/xGr7zFr3to9Ys35E1gSITWz4fuJEPY3vs7UTbqZRmaWzGH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pYG7bMU4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pYG7bMU4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F70CC433F1;
	Thu, 11 Apr 2024 10:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832720;
	bh=1J93E/afZNCthVmeH02jAU9Cr86qqRVQTHWLCPzcr3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pYG7bMU43cdkAAdhlH5QoEzt2sTuZbq10wWmNeG+QlLzToA4OV0WvgA7aZBda6TEZ
	 plTvOrPq7OJGhcwTPhMhlWNktONWP5njCZY/7mJHQ0eKK5eJx9WiqipFD+XL4DW0K7
	 PSvG1IpqNL0GotufhJQXvuxOsAcMsdQSGfzg7Anc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 21/57] pinctrl: renesas: checker: Limit cfg reg enum checks to provided IDs
Date: Thu, 11 Apr 2024 11:57:29 +0200
Message-ID: <20240411095408.637703245@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095407.982258070@linuxfoundation.org>
References: <20240411095407.982258070@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 75fc420b6bdf1..8d3b75231f39e 100644
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



