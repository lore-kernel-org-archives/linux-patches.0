Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC963314AC;
	Tue, 16 Dec 2025 11:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886035; cv=none; b=Vdmi/ZH6zrRM+i6ZiqbbgeBJ9QjIGHynNGN7XE0XJhPJygg/PJw6EURS2lJ8DWvMMwrokAPg2kcfZaMpZjO3ekaqfMSbnv5RV59tBFQE4oCvVXoug85Xhro297+iSo/l2SDhP4Dlgly5R/9X0m7wMWjDHRrcVp11mAkg8kXvhng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886035; c=relaxed/simple;
	bh=aneJxBffyeFNtSH8RRHCZRzuoskX6sQ3DIS0gzc33v8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lKGr5wYNYySLd/SvNFVg7eS7LrlKHj9g6tXVY9yRo3MfbNvOYI72i7lu7Dn003pP10YSZr50RpKkqFUpmkO3HGvbUjXZBOA+GGhQ4EjPJyztbj1QUOb0YsaK0R7+5nSHA2OrSEa2WI+mpsZa1dRYeyMGaCgi7XrDiY4uF04uCZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NChqFZPX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NChqFZPX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05314C4CEF5;
	Tue, 16 Dec 2025 11:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886035;
	bh=aneJxBffyeFNtSH8RRHCZRzuoskX6sQ3DIS0gzc33v8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NChqFZPXgQhDcdc6allNByO43qVBBbSjJbpjlpXD00Umv8aUkBLOe4u1bX7p6HX/T
	 1Wh+TkfXYuxjru+Oi+V1zgFlA2MzjCtI5I8Qn5S1heja9kJDWQekBhEVVtHFVoFUGQ
	 PC0WMz2b7Tie50XyeFuKJv6zsoz7F8dJhrzsubsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 285/507] mfd: mt6358-irq: Fix missing irq_domain_remove() in error path
Date: Tue, 16 Dec 2025 12:12:06 +0100
Message-ID: <20251216111355.803859376@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 384bd58bf7095e4c4c8fcdbcede316ef342c630c ]

If devm_request_threaded_irq() fails after irq_domain_add_linear()
succeeds in mt6358_irq_init(), the function returns without removing
the created IRQ domain, leading to a resource leak.

Call irq_domain_remove() in the error path after a successful
irq_domain_add_linear() to properly release the IRQ domain.

Fixes: 2b91c28f2abd ("mfd: Add support for the MediaTek MT6358 PMIC")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20251118121427.583-1-vulab@iscas.ac.cn
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/mt6358-irq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/mt6358-irq.c b/drivers/mfd/mt6358-irq.c
index f467b00d23660..74cf208430440 100644
--- a/drivers/mfd/mt6358-irq.c
+++ b/drivers/mfd/mt6358-irq.c
@@ -285,6 +285,7 @@ int mt6358_irq_init(struct mt6397_chip *chip)
 	if (ret) {
 		dev_err(chip->dev, "Failed to register IRQ=%d, ret=%d\n",
 			chip->irq, ret);
+		irq_domain_remove(chip->irq_domain);
 		return ret;
 	}
 
-- 
2.51.0



