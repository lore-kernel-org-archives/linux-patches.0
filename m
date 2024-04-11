Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515D8145B2C;
	Thu, 11 Apr 2024 10:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830190; cv=none; b=lBttIi0aWMIea/jFMuQ1VhhbBf3J2jP1Hws9bK6BgeihbJXEsbuZPU+OjRXGa0F+C01aHZkLnqgGY1+6ARx2p3VKdakmzFS5NSxZliCBPCFw+4xOoURBDfYv0ZMKbDcSgz+fcGv3RgBbbqYwbETNApqrxmkaiLkQ4Sgs3/HOUXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830190; c=relaxed/simple;
	bh=t984g4jlyexiD/IGKRvOxt/fzhXDeUIBS1Ss3z+UceI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CeCDHUF4hUESVBcpxqBAyWacVTmB4Nx6HWGpV8XODoZIEYA0cZCTuBhS27KJxfmtQvOuZkDGzXI21VDw2YyTg9hLOU4h6K09bvfxysrTl4b8Php4zW1vh86036jgxP52p1+nvkdQxaSi9n1/XdYYMBypsX4S3SPoXdJLvt3rh/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jH2Rrg8O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jH2Rrg8O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAE86C433C7;
	Thu, 11 Apr 2024 10:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830190;
	bh=t984g4jlyexiD/IGKRvOxt/fzhXDeUIBS1Ss3z+UceI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jH2Rrg8ONrkbVBvDRQ5ffhuSziofVu6papOGALtYBVsAsvDZ6MT/VowctPlaJ9eal
	 WWuK1wKWFVgjjWYt/nZ5yfn++7G3q2K+qOIa8YSIr6ZYWA5DbjeYLIxNlLEB8UOIBZ
	 vVahbJ4v8kg3/91+6hQ6IZN6hATan3O+w+a14Gao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 066/143] pinctrl: renesas: checker: Limit cfg reg enum checks to provided IDs
Date: Thu, 11 Apr 2024 11:55:34 +0200
Message-ID: <20240411095422.902963458@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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
index d1e92bbed33ad..757bbc549b0e2 100644
--- a/drivers/pinctrl/renesas/core.c
+++ b/drivers/pinctrl/renesas/core.c
@@ -909,9 +909,11 @@ static void __init sh_pfc_check_cfg_reg(const char *drvname,
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



