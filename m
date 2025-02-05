Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062EA487BF;
	Wed,  5 Feb 2025 14:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765868; cv=none; b=ERwEtaeZ9KnPDsk6dHXWkke1urNtr+hbL3ptGp5TAFSZX4U6vATmVaA/rfY5huXex8HHlZ7nkTDGoAcb8nwL9e9Crgk3OW24240g6ldXraW/FScPVsWEzHJndYpipbRQzpgHM3WXWuuCgqDYWpJwNbgednpOCiAISmnbzq3yNew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765868; c=relaxed/simple;
	bh=sTm9wj9hSgp8Jr9fXynMiH1lsJZJELhuIaBYv7xa/oM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YGU4Yozp5ioW1Q1ucumBK3QpY6bgihSaEqlY2H8yRyNRIFPBcNvyOHIBNvmqXD3NPQcX2UbDQ5qbWdK2P8j/+5sLNDp+0kEsuor52BDON4pEhZXcWUCI6uKaPsDhk1iceeNhFT5wgtL0cuTb5jGEvLXkL18hs+0epuw/eYMPqh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u96n1O35; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u96n1O35"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6956CC4CED1;
	Wed,  5 Feb 2025 14:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765867;
	bh=sTm9wj9hSgp8Jr9fXynMiH1lsJZJELhuIaBYv7xa/oM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u96n1O35tbkU7tMRrGEG1BpzoOtedUfkb3lvVE1uigvswfPpU0okFgVw7J3BrUMgj
	 /hVhzPynj69tihHul/CKPno27xE//SOQeC/gEyoJ5JOSIhrxA4NRX8Qda6aYnDYbZm
	 gwDEYpE9mZoksawGqZrIYzGOfpms5ZnZzwyz5woE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 221/623] Bluetooth: btbcm: Fix NULL deref in btbcm_get_board_name()
Date: Wed,  5 Feb 2025 14:39:23 +0100
Message-ID: <20250205134504.679963521@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Han <hanchunchao@inspur.com>

[ Upstream commit b88655bc6593c6a7fdc1248b212d17e581c4334e ]

devm_kstrdup() can return a NULL pointer on failure,but this
returned value in btbcm_get_board_name() is not checked.
Add NULL check in btbcm_get_board_name(), to handle kernel NULL
pointer dereference error.

Fixes: f9183eaad915 ("Bluetooth: btbcm: Use devm_kstrdup()")
Signed-off-by: Charles Han <hanchunchao@inspur.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btbcm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bluetooth/btbcm.c b/drivers/bluetooth/btbcm.c
index a1153ada74d20..0a60660fc8ce8 100644
--- a/drivers/bluetooth/btbcm.c
+++ b/drivers/bluetooth/btbcm.c
@@ -553,6 +553,9 @@ static const char *btbcm_get_board_name(struct device *dev)
 
 	/* get rid of any '/' in the compatible string */
 	board_type = devm_kstrdup(dev, tmp, GFP_KERNEL);
+	if (!board_type)
+		return NULL;
+
 	strreplace(board_type, '/', '-');
 
 	return board_type;
-- 
2.39.5



