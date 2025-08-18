Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF41731E10F;
	Mon, 18 Aug 2025 13:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522324; cv=none; b=ZYj6m4HDZM8or+lzsnG63PghGzN1/9d38AhJtmpFx033sI4XUXQ1ock4HI27HRTifntXc6IDZRsbWOQgk7KuNhULrHOeabpEc9d+qu3Yl4ZJ58qQZBr3k3mnyqOBJxWPMNzeNyVhL6EjCx1nVXznlPqG9USpLBSTVc5GUG+uk+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522324; c=relaxed/simple;
	bh=3RyiJk7Tkn2xviZ8KZMVN+UD72jrCRz1ogOrrzMx9kI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tzG408uBsXMHLjF6Tvzqv0mg9Yapq3q6OIIVzDehIT0NM4MwU9fHSum0GgKc9++gORqCeX+ff8L6LhODarJoXNpwspzykBO8leJkvvJstQO54PPOnbfPIhGTsaou+rnujgTcbTtFJG6wr6DJ5g6LMjTG7WOTj6o+xM2WeMSFEMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F6IeI14w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F6IeI14w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E4BAC4CEEB;
	Mon, 18 Aug 2025 13:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522324;
	bh=3RyiJk7Tkn2xviZ8KZMVN+UD72jrCRz1ogOrrzMx9kI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F6IeI14w8cknYSwfs/58piITDsdrFHjNQfWlA9B1PBp8bK5+uxqw/bPTusMKnY2iE
	 S7FVAjTXKIZle1qEPJlS4h9fqZiagk5VX8KqGwFoLkEKXKXgpI8XwKpq+tk5ax1DVQ
	 WnrD87a2ETdLuUj+m/TzjCVRg8q1WBhdoKqvLiZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wens@csie.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 282/444] mfd: axp20x: Set explicit ID for AXP313 regulator
Date: Mon, 18 Aug 2025 14:45:08 +0200
Message-ID: <20250818124459.539580632@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit 88828c7e940dd45d139ad4a39d702b23840a37c5 ]

On newer boards featuring the A523 SoC, the AXP323 (related to the
AXP313) is paired with the AXP717 and serves as a secondary PMIC
providing additional regulator outputs. However the MFD cells are all
registered with PLATFORM_DEVID_NONE, which causes the regulator cells
to conflict with each other.

Commit e37ec3218870 ("mfd: axp20x: Allow multiple regulators") attempted
to fix this by switching to PLATFORM_DEVID_AUTO so that the device names
would all be different, however that broke IIO channel mapping, which is
also tied to the device names. As a result the change was later reverted.

Instead, here we attempt to make sure the AXP313/AXP323 regulator cell
does not conflict by explicitly giving it an ID number. This was
previously done for the AXP809+AXP806 pair used with the A80 SoC.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Link: https://lore.kernel.org/r/20250619173207.3367126-1-wens@kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/axp20x.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/axp20x.c b/drivers/mfd/axp20x.c
index 378092903971..cbf1029d0333 100644
--- a/drivers/mfd/axp20x.c
+++ b/drivers/mfd/axp20x.c
@@ -1034,7 +1034,8 @@ static const struct mfd_cell axp152_cells[] = {
 };
 
 static struct mfd_cell axp313a_cells[] = {
-	MFD_CELL_NAME("axp20x-regulator"),
+	/* AXP323 is sometimes paired with AXP717 as sub-PMIC */
+	MFD_CELL_BASIC("axp20x-regulator", NULL, NULL, 0, 1),
 	MFD_CELL_RES("axp313a-pek", axp313a_pek_resources),
 };
 
-- 
2.39.5



