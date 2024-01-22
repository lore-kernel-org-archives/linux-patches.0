Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2485C13175E;
	Tue, 23 Jan 2024 00:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969094; cv=none; b=gjfIb9ImXdMENPdR6lxJFyYjo+VraHJVtf7vL8bg+9CfreVIBlYrL5Oe9NX5TTe2uiZZIT0D+d9T76T5YHz7Ein8HESx7ClnkgC0ziYQF9QYeVwNCUwTJ2e/uC0WbecQR5yCWWgASFstjhEjPBZ0MyUtth9OwUosFSCNzJga4sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969094; c=relaxed/simple;
	bh=SmINGP33mJUTJp5W+URtRX1auTn+ykCJNGVjHd44D9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sKw8fRaHx5NX1Su1LPGoyP6jhOew3A0QcB7j4PhLzMKqMH81C8z/K8v5iU5fIpl3yZ2d5qqqYiPxSPR4o2UiyeM3O7jegTHZeZdFkN0qPqsu5HMXwcLABg9+Sp57dnRYVDSBnGSVRuFB9iO7ZMQXCVmJpspWdiNtrwfaBtxhLWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q6ql85C6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q6ql85C6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B05FFC43390;
	Tue, 23 Jan 2024 00:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969094;
	bh=SmINGP33mJUTJp5W+URtRX1auTn+ykCJNGVjHd44D9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q6ql85C6zVelkhnLF9YUdku9KS3hmcfWY6okL9cqq86uXSyK8fIkXeVMI1QOL10vT
	 mygGPay0qM8KlFLn8R3A5HdYdDdKst7o47XE2QOFLWNuK5D3/0kctTRITHb6ZR3Tm4
	 SBf8d2dG9tycjCWVEChbW7vipW1if9gOOne0ngC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 017/641] powerpc/powernv: Add a null pointer check in opal_event_init()
Date: Mon, 22 Jan 2024 15:48:41 -0800
Message-ID: <20240122235818.647259977@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kunwu Chan <chentao@kylinos.cn>

[ Upstream commit 8649829a1dd25199bbf557b2621cedb4bf9b3050 ]

kasprintf() returns a pointer to dynamically allocated memory
which can be NULL upon failure.

Fixes: 2717a33d6074 ("powerpc/opal-irqchip: Use interrupt names if present")
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20231127030755.1546750-1-chentao@kylinos.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/powernv/opal-irqchip.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/platforms/powernv/opal-irqchip.c b/arch/powerpc/platforms/powernv/opal-irqchip.c
index f9a7001dacb7..56a1f7ce78d2 100644
--- a/arch/powerpc/platforms/powernv/opal-irqchip.c
+++ b/arch/powerpc/platforms/powernv/opal-irqchip.c
@@ -275,6 +275,8 @@ int __init opal_event_init(void)
 		else
 			name = kasprintf(GFP_KERNEL, "opal");
 
+		if (!name)
+			continue;
 		/* Install interrupt handler */
 		rc = request_irq(r->start, opal_interrupt, r->flags & IRQD_TRIGGER_MASK,
 				 name, NULL);
-- 
2.43.0



