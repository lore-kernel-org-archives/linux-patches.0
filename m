Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E422F49E4;
	Fri, 10 Oct 2025 13:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102313; cv=none; b=RDcWUVaLpVPQwD1LpV6oAEx+t8iCXxDa6K306Qx+4nW2bh1D3mjqImlEU+Vf556A9AJLb67WpY4yVF+ezrx3DyloWAHzvsPdS6pCOHodg5diqsyCA39yaFfMlkyenRM6pxMTPO0Uvf3XR+PtEmGH4xlgAu1Yp8nQanLAlGn2mxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102313; c=relaxed/simple;
	bh=pIMKGxwc6v6q2eScJ/eNV3tHvtKjyRLzW8Bh8C6ue7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bgOKsOpYtHpckzL/mKWl2Bt1VmakTGrv5uyCSPAdSsRlXWdIBmUeqjyhKUV5CkB1QCoXsBy0rJrkHg6IEvvNwOFKHFvuXiuU7iApyrMgzViqpoDlSv8OPp6eU/fPcfn4xCqp8oUtBDIm0XDi1MVFAVr6oZtLhWAneuVgymNCdL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ij2sPNa8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ij2sPNa8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11EE3C4CEF1;
	Fri, 10 Oct 2025 13:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102313;
	bh=pIMKGxwc6v6q2eScJ/eNV3tHvtKjyRLzW8Bh8C6ue7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ij2sPNa8z7VO9E23qqY6Dvb0tZJzz+Hdye2zFepkoHurMDTIYgd/FNh65wMKu5WzS
	 k3QH4BO2ToMCzLeMvpjXVZggsURoZUfUN1TcNxy3UOak/esiJZHHVvqPKz79xw19+E
	 tecMQPZAmcYTWyGSsrPDS1Zc7mMyFmbFuYQdSzS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuming Fan <shumingf@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 13/41] ASoC: rt712: avoid skipping the blind write
Date: Fri, 10 Oct 2025 15:16:01 +0200
Message-ID: <20251010131333.904940414@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131333.420766773@linuxfoundation.org>
References: <20251010131333.420766773@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuming Fan <shumingf@realtek.com>

[ Upstream commit f54d87dad7619c8026e95b848d6ef677b9f2b55f ]

Some devices might not use the DMIC function of the RT712VB.
Therefore, this patch avoids skipping the blind write with RT712VB.

Signed-off-by: Shuming Fan <shumingf@realtek.com>
Link: https://patch.msgid.link/20250901085757.1287945-1-shumingf@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt712-sdca.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/rt712-sdca.c b/sound/soc/codecs/rt712-sdca.c
index 570c2af1245d6..0c57aee766b5c 100644
--- a/sound/soc/codecs/rt712-sdca.c
+++ b/sound/soc/codecs/rt712-sdca.c
@@ -1891,11 +1891,9 @@ int rt712_sdca_io_init(struct device *dev, struct sdw_slave *slave)
 
 		rt712_sdca_va_io_init(rt712);
 	} else {
-		if (!rt712->dmic_function_found) {
-			dev_err(&slave->dev, "%s RT712 VB detected but no SMART_MIC function exposed in ACPI\n",
+		if (!rt712->dmic_function_found)
+			dev_warn(&slave->dev, "%s RT712 VB detected but no SMART_MIC function exposed in ACPI\n",
 				__func__);
-			goto suspend;
-		}
 
 		/* multilanes and DMIC are supported by rt712vb */
 		prop->lane_control_support = true;
-- 
2.51.0



