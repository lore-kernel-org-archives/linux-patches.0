Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3CC520125F;
	Tue, 13 Oct 2026 12:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791896010; cv=none; b=WegF1HNffWwSK+ccY0dUDATH10wy7H0bSQS+Y4DH9xQTCQO6vC2kfl+RuZO9N6sZj4wF/cGTO3patb2/QrTL8MzlVER+0iuloKPSWBsQOSj45rNzcYkbb0flxD5KDCXswNIwJOiDMH0MM7y/c9vCoaaqord/ZjUXWCEHIfeLUEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791896010; c=relaxed/simple;
	bh=ZeAIffLWwazMANkcFcCtLpqkJrTWfkOiFu4cf2oEP7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aF0+Gz3K29H091g5a58mlLgmL9MWwfx8a8r9qfYK6pWKSuPNi9j1kFI5hDUxpX4LlmXDO3rWGPO8P+oWJwsZw4dVkbX4m9iVXWmzTFWheCFTnkePlitoUnNPbQk5GNg7IZfj6DvJogDwbVtzXaHTvXn0XK89FPqZrEDU5sFm+zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KEE7jwxx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KEE7jwxx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 002F61F00893;
	Tue, 13 Oct 2026 12:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791896009;
	bh=rtwQdoV4dvEijnUEG7RtASRNt8D+djx8TL7C907hQAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KEE7jwxxQyk6CXBEPVv079aJOepCPLJR/LtevMievfCjwcxIcJrLXyjVoV6HVWlf7
	 5RqSeizd3ffGJRFKzvdOHxLcN2UhRJsPd+YGSLPmwa1rO7gl4MtMERUHf/AK6dWOX6
	 lHd0prtc+1tb1YmT+AlQIp+u4bSfdHXMAF+UQmp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.12 413/497] pmdomain: rockchip: dont ignore clock lookup errors on attach
Date: Tue, 13 Oct 2026 13:39:40 +0200
Message-ID: <20261013112917.692649373@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Shawn Lin <shawn.lin@rock-chips.com>

commit 4c66c423593e26273ea0d644906ed007630c6f6d upstream.

rockchip_pd_attach_dev() treated every of_clk_get() error as the end
of the clock list, so a clock that exists but is not available yet
(e.g. -EPROBE_DEFER) was silently skipped and the device ended up
without pm_clk management.  Only -ENOENT means there are no more
clocks.

Fixes: 7c696693a4f5 ("soc: rockchip: power-domain: Add power domain driver")
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/rockchip/pm-domains.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/pmdomain/rockchip/pm-domains.c
+++ b/drivers/pmdomain/rockchip/pm-domains.c
@@ -640,7 +640,19 @@ static int rockchip_pd_attach_dev(struct
 	}
 
 	i = 0;
-	while ((clk = of_clk_get(dev->of_node, i++)) && !IS_ERR(clk)) {
+	while (1) {
+		clk = of_clk_get(dev->of_node, i++);
+		if (IS_ERR(clk)) {
+			error = PTR_ERR(clk);
+			if (error == -ENOENT)
+				break;
+
+			dev_err(dev, "failed to get clock %d: %d\n", i - 1,
+				error);
+			pm_clk_destroy(dev);
+			return error;
+		}
+
 		dev_dbg(dev, "adding clock '%pC' to list of PM clocks\n", clk);
 		error = pm_clk_add_clk(dev, clk);
 		if (error) {


