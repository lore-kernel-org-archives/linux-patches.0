Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B8F23B612;
	Mon, 23 Mar 2026 14:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277529; cv=none; b=H3xuSmyLuy/IQbHChY5RAgbZmGLKKBDy/gfVV1CIY84TnNfMVsqmyx5yX4ErH+JUUImBWAhzCuMwgeTgcoBLoJcktTBuymDK6ADL8mJHwOROam8o8HNYGXJTmt6hhvL6wTWrsgiMu4TOd1GJ7vAZfghW4Hh1Syf/jvhhkJY7Nqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277529; c=relaxed/simple;
	bh=15feyfXLamrmXZ/Sze8NiZp8M3IjcH/FsaUcoTCfNmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PsrNGBt7nm/8cZUSgy+tlzfrMVId5TmJSEAMeitF+2KT1+Ur5RkT8XpJ7hK2GTfxe/YxyfnQcxFKzsFmqOorOCNyjwBjgfZJbteN8DnmCrpY3X6Rg/SJ1VWDChMw6LQVjW2aEC1lQOXpafKk87wp/EJqPXOwY8K4ohHdKAqjaHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s6TK6oR6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s6TK6oR6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF22DC4CEF7;
	Mon, 23 Mar 2026 14:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277529;
	bh=15feyfXLamrmXZ/Sze8NiZp8M3IjcH/FsaUcoTCfNmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s6TK6oR6jjaijgwMl7bpAoWWTtFuB+SbjWuSquDt9gsnL5qntK+dJu9aReUvxNfYm
	 TdH4LileYlF7HMQ1oiqoQPd/qyWsfuJXZa7JvpZa7qa3y4cVmUBJQKdrBq6WDSdzKn
	 tvcSe26m2oknKlcTAnR2ETYLrR+4ksM5Eccchnns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yong Wu <yong.wu@mediatek.com>,
	Miaoqian Lin <linmq006@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 019/481] memory: mtk-smi: fix device leak on larb probe
Date: Mon, 23 Mar 2026 14:40:01 +0100
Message-ID: <20260323134525.715500024@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 9dae65913b32d05dbc8ff4b8a6bf04a0e49a8eb6 ]

Make sure to drop the reference taken when looking up the SMI device
during larb probe on late probe failure (e.g. probe deferral) and on
driver unbind.

Fixes: cc8bbe1a8312 ("memory: mediatek: Add SMI driver")
Fixes: 038ae37c510f ("memory: mtk-smi: add missing put_device() call in mtk_smi_device_link_common")
Cc: stable@vger.kernel.org	# 4.6: 038ae37c510f
Cc: stable@vger.kernel.org	# 4.6
Cc: Yong Wu <yong.wu@mediatek.com>
Cc: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20251121164624.13685-3-johan@kernel.org
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/mtk-smi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/memory/mtk-smi.c b/drivers/memory/mtk-smi.c
index 1326119288c98..95f1bf2c37785 100644
--- a/drivers/memory/mtk-smi.c
+++ b/drivers/memory/mtk-smi.c
@@ -574,6 +574,7 @@ static void mtk_smi_larb_remove(struct platform_device *pdev)
 	device_link_remove(&pdev->dev, larb->smi_common_dev);
 	pm_runtime_disable(&pdev->dev);
 	component_del(&pdev->dev, &mtk_smi_larb_component_ops);
+	put_device(larb->smi_common_dev);
 }
 
 static int __maybe_unused mtk_smi_larb_resume(struct device *dev)
-- 
2.51.0



