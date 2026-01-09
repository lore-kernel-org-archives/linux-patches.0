Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933AF22F77B;
	Fri,  9 Jan 2026 11:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959584; cv=none; b=th3ARPa6LLbGsbS/2FYxH6Keexw4i0sjmsF94M1bG9RMhKr+IhHM9sICzG7UJ3UtXnvBJbRbsF6fzss8QnVv/lOjHowzwKpvWJf4TplAa/W7Gvbq//W4YLvnm+Gqdg+GdWLpPjactIGRHzQhxcD7fHdkhNFQ/yHHZNBfAJKR3Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959584; c=relaxed/simple;
	bh=Uta6LbCW3+KOG42/z0umJQY+eL8zqRD8ty6jHtIM320=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hp7nAVUUPYucl41+Ptme5Z7KDqR/YeNdEDZIym5cucof81xsDuzhaCMRfx6u6zpoYCZFv1WL0i1jjS33Z+dp/iuiAE/DKWhPQPi1j8K/qNjxtBn2yuOQVHRbMtDODnRJXyNxCI1w3QJG5bok3R4aiS0fdw1f6SwWgQR2/AcpLYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fUenKQ8N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fUenKQ8N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A377C19423;
	Fri,  9 Jan 2026 11:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959584;
	bh=Uta6LbCW3+KOG42/z0umJQY+eL8zqRD8ty6jHtIM320=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fUenKQ8NsxJL1U05PMeFVq9HAvqVDdbqgOZ4DLsAXtFtxeY6EqNp/zTCTesBQVRC7
	 TQnBFrmmiWkKSdr5hpAwNcsdDr2tHF/ZMqFlqowGfUyB/EHLZg3VON8KbSu+9G0qLe
	 mPAleR3XSTWp12ZFvJf0Ejz56JUEqAjDmEo9Pt4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Antonio Borneo <antonio.borneo@foss.st.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 102/737] pinctrl: stm32: fix hwspinlock resource leak in probe function
Date: Fri,  9 Jan 2026 12:34:01 +0100
Message-ID: <20260109112137.838629138@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 67c2791ee246f..ac96523e07b8d 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -1550,7 +1550,7 @@ int stm32_pctl_probe(struct platform_device *pdev)
 		if (hwlock_id == -EPROBE_DEFER)
 			return hwlock_id;
 	} else {
-		pctl->hwlock = hwspin_lock_request_specific(hwlock_id);
+		pctl->hwlock = devm_hwspin_lock_request_specific(dev, hwlock_id);
 	}
 
 	spin_lock_init(&pctl->irqmux_lock);
-- 
2.51.0



