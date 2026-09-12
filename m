Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5BF416115;
	Sat, 12 Sep 2026 08:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202318; cv=none; b=cI66NiaLeGnANMCeIzQiSXpXpa/d0En0g+IuVK428+nAhpOp9HIMR01gQa+R25aSnzooDazRRjxauaDRMXFwBhHCAbiUqYpmby7wsK097ztMMaD81GuGqeihIvbeBe/IljaI07W5CGEdTY2CIJQ1+DpjDnnpXt/xMwIUylfFvD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202318; c=relaxed/simple;
	bh=be8rT2UvwNQ3+SlEvVH59zplPn8uB6r1GFN0N52iedc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JLMZgBWAvHJQFaG4kyc85II9gVGy+kK2v6mIPln1dSdo3k02QwoxkFjfCRkrponeMZkOvMzd33BMnlqFBzovBSNxPhDHyuA2Zgk/Nkp0cYHJHK8B5gUL8DMMMfGoPvc5Kd6qneDPY070w2qWRCpDaYC6ETL5e/l+2uhbWQM+7N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QvMM5xSz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QvMM5xSz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775981F000FF;
	Sat, 12 Sep 2026 08:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202317;
	bh=88JsNLsW4fldWhxLxePSNblALElLexw9c0k+zNsRbNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QvMM5xSzziYy+fJKjutjjOqPhNnKqwEcK/dupxg9CvZ/uPvM/x4dIEUUaxx+X9mFj
	 m8pJ9dvwbFrunzJ2ABlRB4OvGa0U8cPGaMmWys93SrzqKEwVi8oRaKIst4NI3DsLCc
	 OBqvG+y4Nbjt5/gHSt61dT5wZIMpz2xmxafVe0oY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Glass <sjg@chromium.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1177/1815] pinctrl: rockchip: Restrict the RV1103B 2-bit drive type to bank 2
Date: Sat, 12 Sep 2026 08:48:47 +0200
Message-ID: <20260912065716.645596251@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Glass <sjg@chromium.org>

[ Upstream commit 35ff52e54b38b01914be62ece27899665a46af56 ]

The RV1103B override in rockchip_get_drive_perpin() forces the 2-bit
level drive type for every pin above 11, but only bank 2 has the
2-bit fields; banks 0 and 1 use the 8-bit level type for all pins,
as the corresponding check in rockchip_set_drive_perpin() shows.

Today this is harmless, since neither level type is decoded in the
get function and both paths fail with -EINVAL. It becomes an active
problem once decoding is added, as the pins of banks 0 and 1 would
be truncated to 2-bit values. Add the missing bank check, matching
the set path.

Fixes: 6d3ea3120eaa ("pinctrl: rockchip: Add RV1103B pinctrl support")
Link: https://sashiko.dev/#/patchset/20260729132736.3807082-1-sjg@chromium.org?part=1
Assisted-by: Claude:claude-opus-5
Signed-off-by: Simon Glass <sjg@chromium.org>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-rockchip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index 8bfc7ab5de153..08084ed2cf1bc 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -3212,7 +3212,7 @@ static int rockchip_get_drive_perpin(struct rockchip_pin_bank *bank,
 	u8 bit;
 	int drv_type = bank->drv[pin_num / 8].drv_type;
 
-	if (ctrl->type == RV1103B && pin_num >= 12)
+	if (ctrl->type == RV1103B && bank->bank_num == 2 && pin_num >= 12)
 		drv_type = DRV_TYPE_IO_LEVEL_2_BIT;
 
 	ret = ctrl->drv_calc_reg(bank, pin_num, &regmap, &reg, &bit);
-- 
2.53.0



