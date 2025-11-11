Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35502248F6A;
	Tue, 11 Nov 2025 01:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823073; cv=none; b=fueugpi3IzBaifYdfGC9+n4KPBVB01jGQZLiitUt6C0gEvOgs3oPgLbT3gzgS94Ewg3iebYSwJ8RzSh/rS4Ubq5S/I2Ll3lF5SF8nZy1LiLmMvfZFHt2JeDy7OzYFbjL2dQ4jUUNXYOxXNO/85no7mtLIAXOrqaH+F0/WP71e6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823073; c=relaxed/simple;
	bh=Ypw79DOPCc4II0B4MjrRYrY1izB9W7h+K/aKK9OF6KY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l3FuYSaKO4Rmq5Fnj+INODndbQESg7nZJRB6Ct78Uyz7A+IOu6eGjk87PTQv5F41II/9VMlCuSCNGMAI7nQ2havOmviUSOrGnTUPvdbDL31/TMLQFqltVazWzlW14cH3cfx9fpwaMFew8FEEKOMhk5ERtnAmgMhxhTHK6y32Sjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZVnOxR6e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZVnOxR6e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8629C19421;
	Tue, 11 Nov 2025 01:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823073;
	bh=Ypw79DOPCc4II0B4MjrRYrY1izB9W7h+K/aKK9OF6KY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZVnOxR6eNObzVncSYFBBMPbVG36n6Y9dX8g2YezzX3LCzPq9fOXfvo1qhLKkFlXzY
	 1iR+iodSxJsa1jNcMz7n9+l1JuhUW7hYhtW4nCTKrgVKrvUjFwa7I6ZywbnL68lRts
	 5Qqmf52FW8we/6JH2Np97cGL656MMJaoWp6rVU/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 166/565] mfd: stmpe: Remove IRQ domain upon removal
Date: Tue, 11 Nov 2025 09:40:22 +0900
Message-ID: <20251111004530.671072073@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 57bf2a312ab2d0bc8ee0f4e8a447fa94a2fc877d ]

The IRQ domain is (optionally) added during stmpe_probe, but never removed.
Add the call to stmpe_remove.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://lore.kernel.org/r/20250725070752.338376-1-alexander.stein@ew.tq-group.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/stmpe.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index 9c3cf58457a7d..be6a84a3062cc 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -1485,6 +1485,9 @@ int stmpe_probe(struct stmpe_client_info *ci, enum stmpe_partnum partnum)
 
 void stmpe_remove(struct stmpe *stmpe)
 {
+	if (stmpe->domain)
+		irq_domain_remove(stmpe->domain);
+
 	if (!IS_ERR(stmpe->vio) && regulator_is_enabled(stmpe->vio))
 		regulator_disable(stmpe->vio);
 	if (!IS_ERR(stmpe->vcc) && regulator_is_enabled(stmpe->vcc))
-- 
2.51.0



