Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B2112A17F;
	Tue, 23 Jan 2024 00:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968782; cv=none; b=Joj/qXccUKEj5HrP1H4pfgUE1BeLMp/o6RVxfFjrwAtKU7L/tMDGZyjnHES4358zHi984Sc2oxMmOKabHf4IPxtd33CZRYq+9WBYl7mkEd5HwLZSupBiaCyAEIBpBJdJldxdCvuVerpef4ThgFPih/qqFmHBEpX3KjBC+vmOQU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968782; c=relaxed/simple;
	bh=BEExfRLLbv0pKZR6GhZclYae3Amv2cR+VG6syLd0hnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j39mUYkoZN8LbbXJExgxzAULY0kypt0hVcu4wiLfkvUXsokAueaWBlgRaEZlQVvwmHIddrLXCHQzMWP/9fTlZ73N1ksDJkeU+ObDYWZfqnW0tcti37QYeQCdDTbc24fYKAqjSpNuzbEM9tK0gWCFAmHMBM7ALX0d6unvZHebnSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fv6J7607; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fv6J7607"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A53C43390;
	Tue, 23 Jan 2024 00:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968781;
	bh=BEExfRLLbv0pKZR6GhZclYae3Amv2cR+VG6syLd0hnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fv6J7607XbqHK/nIEuzWDFWXmAXvzPh2A7Ow3luuoSQK1X9toTBxz/605xjz5BruC
	 IaXAKHEeCXi4Ubl0FezjfQAHXmsa1xqfGYmoDq5MVovjfK21Z8fP8GhwzqYyOJUeo+
	 2gG4bIFLwrDe+svu3seTx/OZfDH6ORqKUq3N+qsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 048/194] powerpc/powernv: Add a null pointer check in opal_event_init()
Date: Mon, 22 Jan 2024 15:56:18 -0800
Message-ID: <20240122235721.273332041@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index c164419e254d..dcec0f760c8f 100644
--- a/arch/powerpc/platforms/powernv/opal-irqchip.c
+++ b/arch/powerpc/platforms/powernv/opal-irqchip.c
@@ -278,6 +278,8 @@ int __init opal_event_init(void)
 		else
 			name = kasprintf(GFP_KERNEL, "opal");
 
+		if (!name)
+			continue;
 		/* Install interrupt handler */
 		rc = request_irq(r->start, opal_interrupt, r->flags & IRQD_TRIGGER_MASK,
 				 name, NULL);
-- 
2.43.0



