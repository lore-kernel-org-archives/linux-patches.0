Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F7F3314A9;
	Mon, 29 Dec 2025 16:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025191; cv=none; b=H8kIIcYYP+zKReDzyUkaGXVcaPj3Is82EeBd4NFdrMUyNa5HYKmADJlHTyM/DkxuEzjrHUAR9QC/HHrUGkIYmOHdbiH5mMLPMRNIBvUME99eVtH8ZGaC3muddf0tShwnCFJLTBaHDpw26j1tDy6RD7DGl4F1jQE9RUIxDMaLstk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025191; c=relaxed/simple;
	bh=UcAPgUvZp/TvKm8+iF8gitUNKbj0u2LE3z23JeL3fcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mfhepHuA4EEQ6E9KOWIN1EacGHGc3zE5wQzCWKUXqpRhLgx7Vqk37VoGAoul8Fz1vrYEVI7B/JYCPM7Gw0rTwWPRFNRqOdNCqMJvZLZTEYCD0C5gkRImX/NES6LU99GVLcsGO6L81/pz4BgjpzLL4px+1dae19vPxoikJ5wKnS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PDUpy7Gh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PDUpy7Gh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B7AEC4CEF7;
	Mon, 29 Dec 2025 16:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025191;
	bh=UcAPgUvZp/TvKm8+iF8gitUNKbj0u2LE3z23JeL3fcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PDUpy7GhlXAD2pU9cRtOXdY06YpaYSkeLtqZpI971Z5Y6KnORomGt0qP8FIdCJk3K
	 VAYYp8a9skyg3SicotBYlvA3AWQ7eCW9suHPirm9xk/QqHrAnSn9fWMyv+rKIX5UMt
	 XaY8AbaMJo4m5Deg/iN6Svutox8Gp+WHVDgke0j0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 125/430] MIPS: Fix a reference leak bug in ip22_check_gio()
Date: Mon, 29 Dec 2025 17:08:47 +0100
Message-ID: <20251229160728.966951662@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Haoxiang Li <haoxiang_li2024@163.com>

[ Upstream commit 680ad315caaa2860df411cb378bf3614d96c7648 ]

If gio_device_register fails, gio_dev_put() is required to
drop the gio_dev device reference.

Fixes: e84de0c61905 ("MIPS: GIO bus support for SGI IP22/28")
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/sgi-ip22/ip22-gio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/mips/sgi-ip22/ip22-gio.c b/arch/mips/sgi-ip22/ip22-gio.c
index 5893ea4e382c..19b70928d6dc 100644
--- a/arch/mips/sgi-ip22/ip22-gio.c
+++ b/arch/mips/sgi-ip22/ip22-gio.c
@@ -372,7 +372,8 @@ static void ip22_check_gio(int slotno, unsigned long addr, int irq)
 		gio_dev->resource.flags = IORESOURCE_MEM;
 		gio_dev->irq = irq;
 		dev_set_name(&gio_dev->dev, "%d", slotno);
-		gio_device_register(gio_dev);
+		if (gio_device_register(gio_dev))
+			gio_dev_put(gio_dev);
 	} else
 		printk(KERN_INFO "GIO: slot %d : Empty\n", slotno);
 }
-- 
2.51.0



