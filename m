Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B2F3ABD9F;
	Wed, 23 Sep 2026 14:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174937; cv=none; b=K01BCu8QtRnKSn2pt4ecQSUhA1ke6cGHfyNNq2hgHPbif+2WjRxtAxc6cZNG6E0Ab/cu2OJXQRCxBlPRKpIKqJxV357pudP88DX3+k/wZPpH9qGuYmEIhl4CRzPmR5EvFKVKIpEZoIFyzdyAlVhHONOyuwIwHzpflOo6CuSBqcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174937; c=relaxed/simple;
	bh=HFwMdBVWdMey9S0++DNzeQIBRV0H/WBdUMOb59LOyx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W0WQ8gg2zY321cGjsRs280cLOKXtHIkM4oTtjJCVEtdq8WiZrHsKL7eQSni7L0l6UU0K6BcyO8mbRBtVoOfk8YnKljZZUihwJ/yyqEFVsayI0BlQuUIWFK6pRYgJcFpkyVkcKnT3RpNeL7lWDwWnviO+VAamdY0lIprp0gSZ+vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hOH1i6E4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hOH1i6E4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7271F000FF;
	Wed, 23 Sep 2026 14:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174936;
	bh=BuBcU+wNP186sFrjKeHf9tC3mVA52bsMrjwcPAVq5Q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hOH1i6E4rJfePmYnxz/AomiYRtjrcASgv7J99Oqk6ti3pgAssifMw4b5z7xCxD/II
	 IQ1bcMwEtpb47ymhxgJr5j+XGXhaz4NdWGpiF4mfyHV9yuz54TSlBCxsRsIG39UcvF
	 u4BSkwJfI6m8KokXvnUxqCCzCroBZ3UQHieOu5gE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.18 270/398] i2c: imx: disable autosuspend on remove
Date: Wed, 23 Sep 2026 16:05:44 +0200
Message-ID: <20260923140650.415590428@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

commit e0c3e9d76adbe522dd420a766ce42d03ce887c29 upstream.

i2c_imx_probe() enables runtime PM autosuspend with
pm_runtime_use_autosuspend(). The probe error path correctly undoes
this setting with pm_runtime_dont_use_autosuspend(), but the normal
remove path only disables runtime PM.

The runtime PM API requires pm_runtime_use_autosuspend() to be undone
with pm_runtime_dont_use_autosuspend() at driver exit unless runtime PM
was enabled with devm_pm_runtime_enable(). Leaving the autosuspend flag
set therefore leaves the runtime PM state incompletely cleaned up after
the driver is unbound.

Add the missing pm_runtime_dont_use_autosuspend() call to the remove
path.

This issue was found by manual code inspection.

Fixes: 588eb93ea49f ("i2c: imx: add runtime pm support to improve the performance")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Cc: <stable@vger.kernel.org> # v4.5+
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/20260914091544.1667137-1-lgs201920130244@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-imx.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -1922,6 +1922,7 @@ static void i2c_imx_remove(struct platfo
 
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+	pm_runtime_dont_use_autosuspend(&pdev->dev);
 }
 
 static int i2c_imx_runtime_suspend(struct device *dev)


