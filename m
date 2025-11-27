Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E65A334C14;
	Thu, 27 Nov 2025 14:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255293; cv=none; b=SdehsV34mH5mW5u9hLZM8uUr3N4HRE9RO47Pyyr9CElvaDlASOTwzfBjCtTu7Ercz3bdNS7NzSiMyVTxihf59uZo4LvovY5CiEP+KQnD/s9KyqSz0LPG29KQOb5a60msmKbVa6XR/9N0H7ACQZlnKJnqEjY/08JRe5aVyOLf6xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255293; c=relaxed/simple;
	bh=hJ9NQwCYRTZrhmO6ENF3Ak7jgLXtAr/am2ikfCKEnwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h57cmIi98bH5UcvvfXoELUWnMwYo/gGNkc/vSmIn1XZMMy/0Qa9F0SBFDFQ5/6gv+p6I6XEn2kaAzI5DC2sovkw/tjjpUv1gZIGcm/4ve0TCO1O1xZJpa9T6/uR3/3wOqR11NA3RRiEQGIKV/070p2wNZcbdNkXTm2ghiNfHwAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M1Fxe8Ml; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M1Fxe8Ml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42FDAC113D0;
	Thu, 27 Nov 2025 14:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255292;
	bh=hJ9NQwCYRTZrhmO6ENF3Ak7jgLXtAr/am2ikfCKEnwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M1Fxe8MlxiaEznYV+kYGqq1MCjMAH6lgk5nEbpClYZ+tOupEk8mOKwA+oA5Yw2mwT
	 7XqTq24M/D//0iYEOnvOg1GQ4mp44Grq0IJizKS/QdnYpt86a1dPJf8TObXsOy7wHp
	 zK5AEZpnUdn4ee2KYsn4ESKu698A4sEljiiE5fhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jared Kangas <jkangas@redhat.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 075/112] pinctrl: s32cc: initialize gpio_pin_config::list after kmalloc()
Date: Thu, 27 Nov 2025 15:46:17 +0100
Message-ID: <20251127144035.587218112@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

From: Jared Kangas <jkangas@redhat.com>

[ Upstream commit 6010d4d8b55b5d3ae1efb5502c54312e15c14f21 ]

s32_pmx_gpio_request_enable() does not initialize the newly-allocated
gpio_pin_config::list before adding it to s32_pinctrl::gpio_configs.
This could result in a linked list corruption.

Initialize the new list_head with INIT_LIST_HEAD() to fix this.

Fixes: fd84aaa8173d ("pinctrl: add NXP S32 SoC family support")
Signed-off-by: Jared Kangas <jkangas@redhat.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/nxp/pinctrl-s32cc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/nxp/pinctrl-s32cc.c b/drivers/pinctrl/nxp/pinctrl-s32cc.c
index 51ecb8d0fb7e8..35511f83d0560 100644
--- a/drivers/pinctrl/nxp/pinctrl-s32cc.c
+++ b/drivers/pinctrl/nxp/pinctrl-s32cc.c
@@ -392,6 +392,7 @@ static int s32_pmx_gpio_request_enable(struct pinctrl_dev *pctldev,
 
 	gpio_pin->pin_id = offset;
 	gpio_pin->config = config;
+	INIT_LIST_HEAD(&gpio_pin->list);
 
 	spin_lock_irqsave(&ipctl->gpio_configs_lock, flags);
 	list_add(&gpio_pin->list, &ipctl->gpio_configs);
-- 
2.51.0



