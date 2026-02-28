Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B16636C9D2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302227; cv=none; b=r/HGe03XzbwrJcZQP5GMvvbvNqoEwPMhWaDeeYzQzeNGM08HPQ3aLEdMGdmz5LmqJdDekFETr4T0uemT80gj8Gd3ZSfG2GLPI5VwiaxOkaIS83Yvk5o0JXfgQfi0mOsoeq7fn6ZY8LXOZLSKBrvprsNlR6VJKO4bP7Pj9T6LBko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302227; c=relaxed/simple;
	bh=+U6bCg4py1qF7HpHbTmb8Jep9Va56degYb3IbwIbBys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jvt2souwawCRhyGlOhsy2t6v52EQN4Qt4bMvtp4EV8rSb7Q24J1hD4l8mPZtFl/hT7Roq6mHE7OQZ1M3gTpsTcn096r9izkvl2UylFK7eKCelRlVqBcW0uahjXL63qwMmgQYd0yD5StShPMqNjrYCGtZ/Iqh115hNxDo7sWOp1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DZ36pvSF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DZ36pvSF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D7DC19424;
	Sat, 28 Feb 2026 18:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302227;
	bh=+U6bCg4py1qF7HpHbTmb8Jep9Va56degYb3IbwIbBys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DZ36pvSFlxaSCvgxfpKGn7HJ/l10UH0sDaZ//hBXTg6T+ETwnCxaaY+rdAVPS+8bT
	 avK6vdfOvfOPJH+0HA6Vd5mjdlpxqPZ20KuWYKP0sqCngzO1jmgjxSBQQ/p+xF+ZT/
	 MkoqlMsQqFVtT8reVqoaT3U9El4PpRfV2XbvtPMvjXLawEBpWOiT/zhlzGRU/KtaCP
	 2ozBhF4/VhBxF2STmajOddUpxXkbTaUlj+sNKWvXE8EK4rFY39XC6bMahe4dgocCl6
	 ucDzkEsxVV075DftErGeT7dkdVK5H+zgX+kl9cbjviikxW+6c91PLhUtryaSMGQOU6
	 l9GFZ6Wh5DyFA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haotian Zhang <vulab@iscas.ac.cn>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 236/283] mfd: arizona: Fix regulator resource leak on wm5102_clear_write_sequencer() failure
Date: Sat, 28 Feb 2026 13:06:18 -0500
Message-ID: <20260228180709.1583486-236-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 4feb753ba6e5e5bbaba868b841a2db41c21e56fa ]

The wm5102_clear_write_sequencer() helper may return an error
and just return, bypassing the cleanup sequence and causing
regulators to remain enabled, leading to a resource leak.

Change the direct return to jump to the err_reset label to
properly free the resources.

Fixes: 1c1c6bba57f5 ("mfd: wm5102: Ensure we always boot the device fully")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20251214145804.2037-1-vulab@iscas.ac.cn
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/arizona-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 19a0adf8ce3db..35f516d934c8b 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -1100,7 +1100,7 @@ int arizona_dev_init(struct arizona *arizona)
 		} else if (val & 0x01) {
 			ret = wm5102_clear_write_sequencer(arizona);
 			if (ret)
-				return ret;
+				goto err_reset;
 		}
 		break;
 	default:
-- 
2.51.0

