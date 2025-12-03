Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B592DA769;
	Wed,  3 Dec 2025 15:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776136; cv=none; b=DI6eJFObggd+2hD5z8j+VU6fH3fTbU+eCRv0VjfySjHQUmj+pJ4TZp3Nuzwx0lJbwsrig6fafXinQ7OoAtmkpl538wPrmX2DLoideVEo7RWzxjAH1lo6dSOoUkgd7bAIblysgCA5AZ2DRXMdgDJGeQwzVqNwCDwW2e9SQG9oTIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776136; c=relaxed/simple;
	bh=iVyKqYvYZQTw4ijQK9MzlcdMVJeJUlSdMKeAK92CgIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebkCYChydDRsTdVRcoSE8FjPC/bdk/xh2cy76f2tSZFUzlAZJ1K/q3qONTTuiC8qUHq4Jb+dpiR7m2gZYW7o/TVGDlX3TLBD8eQvBXSRzxLorGtzs5QpGcHAc/QO7fua7I3ufvuLZiiEYItH1WAspbPtqWHNRz9rohp/3IX+P9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I34bCVQL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I34bCVQL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23823C4CEF5;
	Wed,  3 Dec 2025 15:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776136;
	bh=iVyKqYvYZQTw4ijQK9MzlcdMVJeJUlSdMKeAK92CgIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I34bCVQLcsHV0YogdnV1ExDaVVVS0BsZeRK+o5FvxBe4BGHYjmt+hIJn8b30daURa
	 KYiHsx/gb8040gV5negziPmJp6ddgtgWyijbQq/dethfky9tMpRxVb29YT+OrER5Kp
	 T9wNDdiZHoQee2Ig1M14x1+8OpXd1dbhJmWbCjK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 064/300] mfd: stmpe: Remove IRQ domain upon removal
Date: Wed,  3 Dec 2025 16:24:28 +0100
Message-ID: <20251203152402.992766759@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



