Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08D24F3913;
	Tue, 13 Oct 2026 11:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892327; cv=none; b=JFpvvl5EEsyYnZ2PcZLvEPTHKdLh/dftovqFY9+EfsxsYWVMni0YV1ajjo9qNTUJJrjpB1UpNYKlRJULHwYZyv5f+OMv5yqbj1Ok9IWZg4gjVReZjKdsIQN5Djobg20FRkufa54QwD3Gs6WfdKqCTjogHFv9BStCQsZjoDobQzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892327; c=relaxed/simple;
	bh=rlEejfLdIOot2lMJbUH3HEM2y5K8LUcn9rL3eiWP+XQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mudBZQs2WGAS6UN2XLpLBKyewWCG1XCF7nTch7RJxMr1J+pqqoMMg5EmIYxjGAS8unzJ5lx1JV9enJUfIjF5tjrQCjnJKveFXXvVRddtnOl7/2apnmtYmRMDX/to1UcgUZ8a+Tga58c7ZA5Gc5WqYQUEwaRVlMRRI0fgLgXMTdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gdyn0F+Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gdyn0F+Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C2871F00893;
	Tue, 13 Oct 2026 11:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892326;
	bh=Zy72z6XbUo6vWPKLSMDvPEelDhZWiv8xQ50aR5sr1CA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gdyn0F+QjHxrOYlzQgg5QrFwjGl31hvrVnNOpG266HNTjDf01w37vasjHKGucX9dc
	 +GuuCwdrVVYGYLisd7Dj8O4QwdzYM9Sj8ds8zT3F48Upek18Y6iWQnP4DIh6wZnf9u
	 ywpsVtwJ751ixvI1Yqwi7nrV+hEMqaVzOjJ39LWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Icenowy Zheng <zhengxingda@iscas.ac.cn>
Subject: [PATCH 7.2 137/281] drm/bridge: th1520-dw-hdmi: Fix remove() callback
Date: Tue, 13 Oct 2026 13:37:33 +0200
Message-ID: <20261013112858.477227629@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

commit 01c83795d50ccdb441f60e89ff50767cb2f6045a upstream.

This driver stores struct th1520_hdmi * in platform drvdata, but
th1520_dw_hdmi_remove() was reading it back as struct dw_hdmi *
and passing it to dw_hdmi_remove(), so teardown runs on the wrong
pointer.

Retrieve struct th1520_hdmi * from platform drvdata and pass
hdmi->dw_hdmi to dw_hdmi_remove().

Fixes: 96f30ee0fb9d ("drm/bridge: add a driver for T-Head TH1520 HDMI controller")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Icenowy Zheng <zhengxingda@iscas.ac.cn>
Link: https://patch.msgid.link/20260321-th1520-v1-2-ec877197770d@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/th1520-dw-hdmi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/th1520-dw-hdmi.c b/drivers/gpu/drm/bridge/th1520-dw-hdmi.c
index 3464720b4e13..2fa7f2d46b3d 100644
--- a/drivers/gpu/drm/bridge/th1520-dw-hdmi.c
+++ b/drivers/gpu/drm/bridge/th1520-dw-hdmi.c
@@ -145,9 +145,9 @@ static int th1520_dw_hdmi_probe(struct platform_device *pdev)
 
 static void th1520_dw_hdmi_remove(struct platform_device *pdev)
 {
-	struct dw_hdmi *hdmi = platform_get_drvdata(pdev);
+	struct th1520_hdmi *hdmi = platform_get_drvdata(pdev);
 
-	dw_hdmi_remove(hdmi);
+	dw_hdmi_remove(hdmi->dw_hdmi);
 }
 
 static const struct of_device_id th1520_dw_hdmi_of_table[] = {
-- 
2.56.0



