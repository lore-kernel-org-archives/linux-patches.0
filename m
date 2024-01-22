Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5133C0C;
	Tue, 23 Jan 2024 00:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968178; cv=none; b=fKH8LJmLRrnWrt8SVXy0NBo2o/rGOudkTcR7iotZljgm2/AhSS+46mTbsKmkpn/C5ArPwd/9TehBNn0YR6Zqe0peOgWBNmI+3KVW8+91ZzWqnVR69QQJdLwKleOdeDiMM4yQjR/zI5gQDdMplNnWgBSmd82GKhu7D4mXqnJ/hwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968178; c=relaxed/simple;
	bh=jGHd4BrGmaEaU9flj73qq5ZwKwvXHts0LQKsYKcwheU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HFSfeDkSks4dEt/fWc6wQUmd9oV1E6BJDBgRo7A679qYcxIOTnmAXHYgiWfHYrRqFyObO4BoexXk3XDU+K/5gDtPdiWO3WeKcyQDjU05mf8SCkppUPlRSdrXyzFBotSc3eW+xRuyOqs1YM1X5ubXVerCnifFlrO0g5Pv8g+d0UU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=okntFTN0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="okntFTN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A2FC433F1;
	Tue, 23 Jan 2024 00:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968178;
	bh=jGHd4BrGmaEaU9flj73qq5ZwKwvXHts0LQKsYKcwheU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=okntFTN0hXRBGNXo9tRyHddakhzJPRc2q1H9aqPn/1j1boOtAOb1lyKDrFURBdwNl
	 r4eSYzhuMQObjgpSCtYVEhXQNC+/NEjC14RUIlK+XPvIA0pB9Gr3SfqGRysnA+VxVX
	 iaN2gI9U+MxDllw+KFflhmAmOWSszsVuvw45v5Dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 035/148] powerpc/powernv: Add a null pointer check in opal_event_init()
Date: Mon, 22 Jan 2024 15:56:31 -0800
Message-ID: <20240122235713.824299387@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index bc97770a67db..e71f2111c8c0 100644
--- a/arch/powerpc/platforms/powernv/opal-irqchip.c
+++ b/arch/powerpc/platforms/powernv/opal-irqchip.c
@@ -282,6 +282,8 @@ int __init opal_event_init(void)
 		else
 			name = kasprintf(GFP_KERNEL, "opal");
 
+		if (!name)
+			continue;
 		/* Install interrupt handler */
 		rc = request_irq(r->start, opal_interrupt, r->flags & IRQD_TRIGGER_MASK,
 				 name, NULL);
-- 
2.43.0



