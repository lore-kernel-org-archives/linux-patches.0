Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE5D33711F;
	Fri, 17 Oct 2025 15:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714074; cv=none; b=Tzc0a/EqiEtEiThnxKiNujVxe3S4kFw21sDbLZI+yjEE2pTFEqzEmkUC+kKO1MrLTF2bbmkUvUDV2jow4wXqXHTvi/MsiEp8h98FVR/bxvQmOd0kwjUg9z+ws904F9aoaR0EP75BiX+BfsrTOISub0RxDFGiSF2id3DVQio1C70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714074; c=relaxed/simple;
	bh=MS1tc/jjsvpYCTjexqy0g9ry6FbPATnixCe7OOa4cSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mpFehDmZ6kH4MAmt0vj7veu0X7Df09yHu36N4I8Kv96LnfUOvstuYIplFGl5NmrBdBJ8B54xs4WJXHxAWWTuARbPuLPIuSL/7P4oadcy1JWpQbxqV555ZkJFbVzT4p5HPdKxAgE8TmVRR5lgODx1SC5PGkjJ6W2fDhBV7Lp082E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A1BkDOWM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A1BkDOWM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C68AC4CEE7;
	Fri, 17 Oct 2025 15:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714073;
	bh=MS1tc/jjsvpYCTjexqy0g9ry6FbPATnixCe7OOa4cSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A1BkDOWMMlGzaCAvhk0Nn9LBGjJ7f76DuMDYry63O+nhqZEo0EMQYwQkaNrwv6hF7
	 7UGT24SajmaDSDVLPX2YEjIwxJU19PfbGu6M3S3QvIvhzoDx+/0cU1Sry4vxioFZu3
	 htUjEFv9Je++EB/OaY9fsmYgM7ueZMyu+0cpad4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@gmail.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 018/277] clk: at91: peripheral: fix return value
Date: Fri, 17 Oct 2025 16:50:25 +0200
Message-ID: <20251017145147.814184173@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

From: Brian Masney <bmasney@redhat.com>

[ Upstream commit 47b13635dabc14f1c2fdcaa5468b47ddadbdd1b5 ]

determine_rate() is expected to return an error code, or 0 on success.
clk_sam9x5_peripheral_determine_rate() has a branch that returns the
parent rate on a certain case. This is the behavior of round_rate(),
so let's go ahead and fix this by setting req->rate.

Fixes: b4c115c76184f ("clk: at91: clk-peripheral: add support for changeable parent rate")
Reviewed-by: Alexander Sverdlin <alexander.sverdlin@gmail.com>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/at91/clk-peripheral.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/at91/clk-peripheral.c b/drivers/clk/at91/clk-peripheral.c
index c173a44c800aa..629f050a855aa 100644
--- a/drivers/clk/at91/clk-peripheral.c
+++ b/drivers/clk/at91/clk-peripheral.c
@@ -279,8 +279,11 @@ static int clk_sam9x5_peripheral_determine_rate(struct clk_hw *hw,
 	long best_diff = LONG_MIN;
 	u32 shift;
 
-	if (periph->id < PERIPHERAL_ID_MIN || !periph->range.max)
-		return parent_rate;
+	if (periph->id < PERIPHERAL_ID_MIN || !periph->range.max) {
+		req->rate = parent_rate;
+
+		return 0;
+	}
 
 	/* Fist step: check the available dividers. */
 	for (shift = 0; shift <= PERIPHERAL_MAX_SHIFT; shift++) {
-- 
2.51.0



