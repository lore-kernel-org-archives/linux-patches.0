Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950A4248F58;
	Sun, 26 Oct 2025 14:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761490244; cv=none; b=skpoiVD7fO80ruQXs5DeQmxomML23DF09cvOoYPQv3K8NJqa98NPIWBwLar4V7pJzh5zBkYlrSYFFfKCD/NTF8yqmkrVQzTXo/zM5qvUnNBCYGob0PaAGcBBvEWD2WMyTBMYK6TLYEK081FeiBFG1/RaVmf0uxOKBsFgW3WghHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761490244; c=relaxed/simple;
	bh=hItZ/nQ92TYBe6pBH4hVPjO4G4EKPIeoQBm01mngkUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qZZpPPXrcvlaqJM2L/n9mueSMrMynTRffJtsRmIEs9XxGP2iidxYy5Rdynyl27AGf2KzxE78PRRmeU6iguicufNOFx5uudpFOzxEp1Z7iumNdhuok2K/6WghMg44o3OfllYrGq7Xe/5lLmEtx/4V8vGi+gu0uXpGNUL/URkDgV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Spr1Z5PU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Spr1Z5PU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E2F3C4CEE7;
	Sun, 26 Oct 2025 14:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761490244;
	bh=hItZ/nQ92TYBe6pBH4hVPjO4G4EKPIeoQBm01mngkUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Spr1Z5PU84EpzX657iBqm6cwWik5vbViMndsC0Q25wvuZBxlwXuGf7VeoKegI5DSZ
	 ny56iNpul/+OOUuafebJv+tUmXt4eJktAqL6UzdLg8W7SfFW5Ms+Mm33MKoipp2zOJ
	 7xSP4uL2ZadYKAPdXrz556tflK+X0aUOWwyRO18m8WWMMoX1Rsy/9eyWPLtn6I3pRK
	 LaGRz9FKNTj3oRFWyY6fCpVhmABStkavwUzgEFA9oWxxJyLWmt3Ggyuu7K8OyRpQ6P
	 U69n7CX13DCvKJVSs2NEHkCzFOqxjSRoSkvbyAHalmcf1rkveZyE0S/ISezlXhZPm5
	 i/yNMkCWYufUw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ryan Wanner <Ryan.Wanner@microchip.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Sasha Levin <sashal@kernel.org>,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	alexandre.f.demers@gmail.com,
	alexander.deucher@amd.com,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.17-5.15] clk: at91: clk-master: Add check for divide by 3
Date: Sun, 26 Oct 2025 10:48:57 -0400
Message-ID: <20251026144958.26750-19-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251026144958.26750-1-sashal@kernel.org>
References: <20251026144958.26750-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ryan Wanner <Ryan.Wanner@microchip.com>

[ Upstream commit e0237f5635727d64635ec6665e1de9f4cacce35c ]

A potential divider for the master clock is div/3. The register
configuration for div/3 is MASTER_PRES_MAX. The current bit shifting
method does not work for this case. Checking for MASTER_PRES_MAX will
ensure the correct decimal value is stored in the system.

Signed-off-by: Ryan Wanner <Ryan.Wanner@microchip.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES – the change fixes a real bug in the sama7g5 master clock code with
minimal risk.

- `clk_sama7g5_master_recalc_rate()` now treats the special register
  value used for divide-by-3, returning `parent_rate / 3` instead of
  wrongly shifting by `1 << 7` and reporting a 1/128 rate
  (drivers/clk/at91/clk-master.c:583). This corrects `clk_get_rate()`
  for every consumer of the master clock when that divider is active.
- The rest of the sama7g5 clock logic already maps the same register
  value to divide-by-3 (e.g. `clk_sama7g5_master_set_rate()` stores
  `MASTER_PRES_MAX` for a /3 request), so the fix restores consistency
  in the clock framework and prevents child clocks from inheriting a
  bogus rate (drivers/clk/at91/clk-master.c:732).
- Other SoCs using the generic master clock ops are unaffected; the new
  branch lives only in the sama7g5-specific implementation and matches
  existing handling of this divider elsewhere in the driver
  (drivers/clk/at91/clk-master.c:392).

Because the bug misreports hardware frequencies and can break downstream
rate selection, and the fix is self-contained and low risk, this commit
is a good candidate for stable backporting.

 drivers/clk/at91/clk-master.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clk/at91/clk-master.c b/drivers/clk/at91/clk-master.c
index 7a544e429d34e..d5ea2069ec83a 100644
--- a/drivers/clk/at91/clk-master.c
+++ b/drivers/clk/at91/clk-master.c
@@ -580,6 +580,9 @@ clk_sama7g5_master_recalc_rate(struct clk_hw *hw,
 {
 	struct clk_master *master = to_clk_master(hw);
 
+	if (master->div == MASTER_PRES_MAX)
+		return DIV_ROUND_CLOSEST_ULL(parent_rate, 3);
+
 	return DIV_ROUND_CLOSEST_ULL(parent_rate, (1 << master->div));
 }
 
-- 
2.51.0

