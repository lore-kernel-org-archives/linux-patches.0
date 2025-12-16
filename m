Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B56344030;
	Tue, 16 Dec 2025 11:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884424; cv=none; b=Sot4JPlax8eLK8wh4y8WE+shMQqHzOo08iwb1nFfZLrhwpJV4eUcQBp+o0SZ/YZFlMXfPYznzQta3gQgVV8ViG3QkV8hXhLvkPha3DwuXyJmQfJa4fVaDTTqWeFWaRFL1Jbez0NLC+1HBV0tvee8J3UBZB+d4B/1b8PUOGJ90SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884424; c=relaxed/simple;
	bh=gwgIwHswNRC3TrN8+CerLF1Sy+CynAt7QSVn/KT45MQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mayDhjOboqCAL77/KDajFLKtWfc7UkITydsnVCpqVqHZ59TECGKyfr/t0tUAf2mgbMmh11nyO9YMw8KRH7tIr1S8wS543fcvFj6ovypixtWdtx4JrNcfxRF5mTBH2y1rZxVF4XpLQv0MoLJp6Tuaw2BK4jnMZF1DROWYJPNJ+tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JpkLukMt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JpkLukMt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07429C19422;
	Tue, 16 Dec 2025 11:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884424;
	bh=gwgIwHswNRC3TrN8+CerLF1Sy+CynAt7QSVn/KT45MQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JpkLukMtupbuOl0MOjhE7A16nnDRM0ucX+LxUoLcgLHP4a4SpYrszStwkTfqbB+fq
	 +v5RNaWLxU11Fy+hwbd3ee5pioiAVJDgWARgsnN7hXjgFGCMyupM8tJhpUKIY5i1/C
	 uLziisrku4CgyzxXXadHUUJnd1IAnWmkmshEaRyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 190/354] mfd: mt6397-irq: Fix missing irq_domain_remove() in error path
Date: Tue, 16 Dec 2025 12:12:37 +0100
Message-ID: <20251216111327.797501822@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit b4b1bd1f330fdd13706382be6c90ce9f58cee3f5 ]

If devm_request_threaded_irq() fails after irq_domain_create_linear()
succeeds in mt6397_irq_init(), the function returns without removing
the created IRQ domain, leading to a resource leak.

Call irq_domain_remove() in the error path after a successful
irq_domain_create_linear() to properly release the IRQ domain.

Fixes: a4872e80ce7d ("mfd: mt6397: Extract IRQ related code from core driver")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20251118121500.605-1-vulab@iscas.ac.cn
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/mt6397-irq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/mt6397-irq.c b/drivers/mfd/mt6397-irq.c
index 886745b5b607c..1e83f7c7ce145 100644
--- a/drivers/mfd/mt6397-irq.c
+++ b/drivers/mfd/mt6397-irq.c
@@ -208,6 +208,7 @@ int mt6397_irq_init(struct mt6397_chip *chip)
 	if (ret) {
 		dev_err(chip->dev, "failed to register irq=%d; err: %d\n",
 			chip->irq, ret);
+		irq_domain_remove(chip->irq_domain);
 		return ret;
 	}
 
-- 
2.51.0



