Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2195547253D;
	Tue, 21 Jul 2026 19:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663439; cv=none; b=pogdmiYrRU6ClLboOuk//pKTsat47y7q0dSfPx4qokT4WTEgRfEI3oPHrTb9EJNtjw/XEniaoukdz1SO4Sl/QXO80NY04jho5/6n0i2cpd/HllCOogzUNS4rWiB3m1Sj7pt9RNyUsy+n45XEVGQCPHQi96stdiGFolOASO0j1to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663439; c=relaxed/simple;
	bh=MXyFN9CMu7b64uuD0awuGSiD1Nq+aMfK23y6pX8V8kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CdLlPDfnBK3QgJDXmOXtop+EYoGRcCfFR+s94BJHQvuKQcWmNJ+Lbm64OmpCwwPRlLk7HX7qkCQ6ts9XAPx5bOW2AOR19S61k2unYcp9B8H4w4VuIdRyRNO4OLCPAJ2dqDJjsqs6Fldc08pzRIAVtXvW+N7o9M/OAzWJVyZQHW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=brDTtce8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="brDTtce8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8676B1F000E9;
	Tue, 21 Jul 2026 19:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663438;
	bh=OE/lJX6cnvcfB4JvrPjTw9oQljG+MhKA1ieU/qHWDSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=brDTtce8JXsoAe28wCDwH11B10y27/WZRZouHjKZsTJbyWr3D7CE87qsZhsuKbIi0
	 /hDJ64QvbkqersDABRsw9RdjNvoIhrks+E4I4qE+HCT7brpDDDQzSeMpjnNG27TZge
	 Z25UZw9U+/oK8cleJsZRWBzsW5k4Pwc0CKQmTCkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0786/1276] gpio: mvebu: free generic chips on unbind
Date: Tue, 21 Jul 2026 17:20:29 +0200
Message-ID: <20260721152503.669039565@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit b11c513ad943f35cf5e8007d3a56279c79b7ed4b ]

irq_alloc_domain_generic_chips() allocates generic chip data that must
be freed via irq_domain_remove_generic_chips(). The devres action
mvebu_gpio_remove_irq_domain() only called irq_domain_remove(), which
only frees the generic chips if IRQ_DOMAIN_FLAG_DESTROY_GC is set.
Call irq_domain_remove_generic_chips() explicitly before
irq_domain_remove() instead.

Fixes: 812d47889a8e ("gpio/mvebu: Use irq_domain_add_linear")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Link: https://patch.msgid.link/20260707232358.1218077-1-rosenp@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mvebu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-mvebu.c b/drivers/gpio/gpio-mvebu.c
index 60895272d904e6..e554bd0fb1a8fc 100644
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@ -1116,6 +1116,7 @@ static void mvebu_gpio_remove_irq_domain(void *data)
 {
 	struct irq_domain *domain = data;
 
+	irq_domain_remove_generic_chips(domain);
 	irq_domain_remove(domain);
 }
 
-- 
2.53.0



