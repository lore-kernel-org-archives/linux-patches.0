Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48FC4359A96
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302473; cv=none; b=rCqutZtWmv0azIQ6h6QUGeHlPTfzNK+Pyft5mlHe9Bc0An/qI2+Z3lSCQ//3tI3rHT3ARx4ZanExVcmFWXwtHWuuPyFaNmyW/Is+q4vTQzAFsd2uBMPBVj98pECR3wvq1K+yhC0klkOyDRKxNJtznbAtGCa1hun3ifqNNovP3cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302473; c=relaxed/simple;
	bh=k+u0KsvoX8eNjkDBcFpt5tkXP3+pXPdwX4iInp3y71s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gRGEgJm9yiSxPGW1ygTR3pi2owWHNXvR+UlcViZP77I+xppZmXAVA0sEig3ovQpPE01PFYt87Sx3g05fc+zoXXbllbOzW7/dTQLhwaiKoBHVsYV3TNfHyyqX9LmFjsTdVX0Fl0bMjlxbGXXf/8YX2ADt04UA0XsgXKFckqM8zyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HZqcgt66; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HZqcgt66"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4ACC19424;
	Sat, 28 Feb 2026 18:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302473;
	bh=k+u0KsvoX8eNjkDBcFpt5tkXP3+pXPdwX4iInp3y71s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HZqcgt66uquNtcGsEFxR2d1TkSYm+IHzmguPFzRYxK3OKrKXsxz37kNLzJUuTOydl
	 COFQtIuWk9/peQH84FQmdmoGvHlMa6apZUE+g9fYf5cFZpaJK5qO6B0X5ZVt7ATyLx
	 sSa/mqw5f5QysVyqUUCW6vTJvSeG1hMjK5/sD95QxssfLH8L9/tJL7042eECRX/67F
	 +OthuajRqwPgpCM6HwnQdH/jAeGVN9kSrJT6sGOCnreojyAgm+2AdUG6OxJuPi355/
	 IBs00TDdtiYzJ4pXdyRX7hkK3WL71ovluBLxQvA0illa6CfvNtoHXFlPKeqtSZ2U72
	 xqzURsm48br3A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Daniel Machon <daniel.machon@microchip.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 218/232] net: sparx5/lan969x: fix PTP clock max_adj value
Date: Sat, 28 Feb 2026 13:11:11 -0500
Message-ID: <20260228181127.1592657-218-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Daniel Machon <daniel.machon@microchip.com>

[ Upstream commit a49d2a2c37a6252c41cbdd505f9d1c58d5a3817a ]

The max_adj field in ptp_clock_info tells userspace how much the PHC
clock frequency can be adjusted. ptp4l reads this and will never request
a correction larger than max_adj.

On both sparx5 and lan969x the clock offset may never converge because
the servo needs a frequency correction larger than the current max_adj
of 200000 (200 ppm) allows. The servo rails at the max and the offset
stays in the tens of microseconds.

The hardware has no inherent max adjustment limit; frequency correction
is done by writing a 64-bit clock period increment to CLK_PER_CFG, and
the register has plenty of range. The 200000 value was just an overly
conservative software limit. The max_adj is shared between sparx5 and
lan969x, and the increased value is safe for both.

Fix this by increasing max_adj to 10000000 (10000 ppm), giving the
servo sufficient headroom.

Fixes: 0933bd04047c ("net: sparx5: Add support for ptp clocks")
Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260212-sparx5-ptp-max-adj-v2-v1-1-06b200e50ce3@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c b/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
index 69e76634f9aa8..9c602f19d43b0 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
@@ -565,7 +565,7 @@ static int sparx5_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 static struct ptp_clock_info sparx5_ptp_clock_info = {
 	.owner		= THIS_MODULE,
 	.name		= "sparx5 ptp",
-	.max_adj	= 200000,
+	.max_adj	= 10000000,
 	.gettime64	= sparx5_ptp_gettime64,
 	.settime64	= sparx5_ptp_settime64,
 	.adjtime	= sparx5_ptp_adjtime,
-- 
2.51.0

