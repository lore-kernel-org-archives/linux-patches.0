Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3413033C0;
	Tue, 31 Mar 2026 17:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976585; cv=none; b=GB6bUkK2FG5WZl5N3GnIpJuQJNwzan8yDdVod1jQU1MarouafQV2yG205xD0wTvBEXJUTZMXmmKgODlJxZh+o6S05CqQD/xRpnyakC778SUMrGrysVI4cmslf5eg2N+edPumvfhX86B9aINaP98ZctKD7Z3pBcMMbEbcq1wBe6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976585; c=relaxed/simple;
	bh=d31+b8pDICBheP3pGh2iRJBwQ9BT7vtYvuivFbzgwG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N7brEQw88w16uUdpVM13CfbcwxSt5Zf0rcN79iBLFTjacRH67gBL/1h5EZuPoKe99D2p/Sf2gi3f+VWAa+N8X+noYof1X6QufM46Pd1MAruZ43CBuk9u07hfiCvRC9KIs8AMAlbyMyqcQM6bMCxO84hSGhh1xMuA2GesVlMQ2UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sa25Xqxh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sa25Xqxh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 944CCC2BCB1;
	Tue, 31 Mar 2026 17:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976584;
	bh=d31+b8pDICBheP3pGh2iRJBwQ9BT7vtYvuivFbzgwG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sa25XqxhOhArxufUOr/pDrqhBVJ8/1aa5xlmYLZ6cIZ0hrByQdwlmubRaL/2TPO8u
	 NZK1OFl/nP5gNIE2dgxmc5zvj9Q41Lt1V4K3+v0THCT5wGSPfjTUEP/WGM3rlfoKo7
	 k/COoyhvWNaLnD0DffchoEqqR3WJVqS2JDC8eIQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 149/309] ASoC: fsl: imx-card: initialize playback_only and capture_only
Date: Tue, 31 Mar 2026 18:20:52 +0200
Message-ID: <20260331161758.954906070@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit ca67bd564e94aaa898a2cbb90922ca3cccd0612b ]

Fix uninitialized variable playback_only and capture_only because
graph_util_parse_link_direction() may not write them.

Fixes: 1877c3e7937f ("ASoC: imx-card: Add playback_only or capture_only support")
Suggested-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20260318102850.2794029-3-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/imx-card.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/fsl/imx-card.c b/sound/soc/fsl/imx-card.c
index 05b4e971a3661..a4518fefad690 100644
--- a/sound/soc/fsl/imx-card.c
+++ b/sound/soc/fsl/imx-card.c
@@ -710,6 +710,8 @@ static int imx_card_parse_of(struct imx_card_data *data)
 			link->ops = &imx_aif_ops;
 		}
 
+		playback_only = false;
+		capture_only  = false;
 		graph_util_parse_link_direction(np, &playback_only, &capture_only);
 		link->playback_only = playback_only;
 		link->capture_only = capture_only;
-- 
2.53.0



