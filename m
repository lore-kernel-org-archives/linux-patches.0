Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61A7328638;
	Tue, 16 Dec 2025 12:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887175; cv=none; b=j4rrndBi/ed21Q4YgFXHdmyL1I1b6f67R+W1TP318x2X/rLkegCS9zrSqs5g9gsLGdAO5VH4C46hvfNYwxpeELoGE0NPwJ8GOKMC6wr2pzAJgvJK9pjuMppCyhOkkvEbaDSNia1Iyy6cCWuargYQoV+fVi/trdUptSI9WspzCEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887175; c=relaxed/simple;
	bh=TtstS9XmtZavdfFnUaDd1tSfNCaoBq7mp0r9m3AKvf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XobTWO442bnSmvGZ3PCqkCM5b6g08zBnyJr14ES+OQCaVfqrxrcMgcB++yllT20yq/KjqtQieIPvlYrAifsiUJBLOColHIHU2pYRcO6P4sbQZP4kr9FNh5UrmjpR/2ZlODKymAJSRtw3kaWYDj3uJIasprzkdC0CeCtzBwGprhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C53IVLv2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C53IVLv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 108CFC4CEF1;
	Tue, 16 Dec 2025 12:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887175;
	bh=TtstS9XmtZavdfFnUaDd1tSfNCaoBq7mp0r9m3AKvf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C53IVLv24FZ1Yd2q39a4gnCBqile8dVQTj+9KB9+hg7OFpKgcROxfPL4Nu3UmNYLc
	 KQkOps28UGa89ljkxEnF+TFARrhZMk7fmSi6GQdUdWNe5ZoFbcCEHaZ+kSb7efnOi9
	 rEpMewv+ySoihBdjiRuBxHlXkFrasEiFz5gH1l+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Antonio Borneo <antonio.borneo@foss.st.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 150/614] pinctrl: stm32: fix hwspinlock resource leak in probe function
Date: Tue, 16 Dec 2025 12:08:37 +0100
Message-ID: <20251216111406.769563021@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 002679f79ed605e543fbace465557317cd307c9a ]

In stm32_pctl_probe(), hwspin_lock_request_specific() is called to
request a hwspinlock, but the acquired lock is not freed on multiple
error paths after this call. This causes resource leakage when the
function fails to initialize properly.

Use devm_hwspin_lock_request_specific() instead of
hwspin_lock_request_specific() to automatically manage the hwspinlock
resource lifecycle.

Fixes: 97cfb6cd34f2 ("pinctrl: stm32: protect configuration registers with a hwspinlock")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Antonio Borneo <antonio.borneo@foss.st.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/stm32/pinctrl-stm32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/stm32/pinctrl-stm32.c b/drivers/pinctrl/stm32/pinctrl-stm32.c
index 3ebb468de830d..e73feb8ac90d1 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -1671,7 +1671,7 @@ int stm32_pctl_probe(struct platform_device *pdev)
 		if (hwlock_id == -EPROBE_DEFER)
 			return hwlock_id;
 	} else {
-		pctl->hwlock = hwspin_lock_request_specific(hwlock_id);
+		pctl->hwlock = devm_hwspin_lock_request_specific(dev, hwlock_id);
 	}
 
 	spin_lock_init(&pctl->irqmux_lock);
-- 
2.51.0



