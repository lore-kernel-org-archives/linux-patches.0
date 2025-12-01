Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7226F3081C7;
	Mon,  1 Dec 2025 11:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588450; cv=none; b=TDvFc6VAD5GDOi989U8PdrrDKCwEpoxGcIHTl+Y0RJNeQm2SaR+UKORv0SnLWjN9lk/qaY5kMGf18Gw4/Nn68c46qECExuKm/5ZDqNlv1MgGAAp1ujy1rqcAZSPH44yjivPgLShRaohbnQtI9dpKoF56FqcmTQum3qI/jNbDThQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588450; c=relaxed/simple;
	bh=SHbk2BtyCQ8dCHUTkvWC5t5uUqkPmlT7DEmCbcC8474=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DM0LpMreORKqR6OlKMk1WTreGOOn5oEkq0WCsqV03dTb56wvXeTS4w6qqy4TOKpxGhiQWs4F51tqIhlifRIKPaZlBCmmXwVb5VcMBMYhOXxIoJABHb33bsParr40L0G2nhvaHSHcGYQnBC+igEzM82cEzQJ/yOD++8s0Xvl0Nlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mFqIdp+d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mFqIdp+d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C00B9C113D0;
	Mon,  1 Dec 2025 11:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588450;
	bh=SHbk2BtyCQ8dCHUTkvWC5t5uUqkPmlT7DEmCbcC8474=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mFqIdp+dhePHUrdxRQBlF+XraKGTz2GqpPBo6cIlerJDSDxZnFpeANUxPVfR5R4LS
	 18SRoutrK2tPcXaNPJwvlIdDWCkpx1B/r2t/QT31pX9ark1j6IecV0MEt9XxkNOAwf
	 +yFmjp0ulwR+Jf2wWR4fv8HqPlShriZiDZBYzSAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 045/187] mfd: stmpe: Remove IRQ domain upon removal
Date: Mon,  1 Dec 2025 12:22:33 +0100
Message-ID: <20251201112242.876427862@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 7f758fb60c1fa..70ca3fe4e99ee 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -1494,6 +1494,9 @@ int stmpe_probe(struct stmpe_client_info *ci, enum stmpe_partnum partnum)
 
 int stmpe_remove(struct stmpe *stmpe)
 {
+	if (stmpe->domain)
+		irq_domain_remove(stmpe->domain);
+
 	if (!IS_ERR(stmpe->vio) && regulator_is_enabled(stmpe->vio))
 		regulator_disable(stmpe->vio);
 	if (!IS_ERR(stmpe->vcc) && regulator_is_enabled(stmpe->vcc))
-- 
2.51.0



