Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036406;
	b=azXGLicgOmCnOgEIMi5QtLQv0Wq6gkX+5uR+p/ip5D06p3dQy4NERdykr62IQapO33aY
	 pYk9g5pK9a+NOSZwMWVE3CPqYVr4WYK/8VschHk26TrpNQi+JXfBIaETQgrlqq/wO9Mcr
	 +fkTBhRTRuliOsoVJBCP+Epp/50ssrbvUaYNKtv3SKwR9YVcwNNAlj56jZ1T53RawDUkm
	 1oa00fgkeebNR22OCmBvuFvEV0OMgvS/1v+c8hetTBwJV/UNoIo77nd3+xV+8GQ/smPh6
	 ZzhZj3JSuZi+Q9GMWrnmHbbM0SnrzwJ3KLIUM1G5mfghcmfyFiQraAB4FlYxKKHM4kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036406;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JuUDziUGdTOZM1rByFjkjCQymgdSAbU+sX9tWpf5xLM=;
	b=2xII/7mRBfAjYHTT80LhimGX1DuF1a/QOIXaXm+kh/XedlozW4RsqcbvV+XpJjD337Nj
	 iXB8tRHknYkUCyPjnPVD87R4oyVbbCvRfUBq0QgDxAbH98+gmR2FSfcRBINLtfpqigBGS
	 qg2+fL+Jp96ZH66GlD5VGLxbVk6CvQMpBCFfhcjNvXIHEFQyA4/tF/zbvS93+hGi4DZbg
	 9oa07P4D3U0xmoBxx9ZlpaaYasF7RszZAVKrgGkFz3rHhmYq7UhjAoLjqR+dXtfJf142Z
	 pMlEPoDt+sQaeAf+YWpr1Pc3Dd4boAdmoJxeGVnLUCpEWO91H9Mmg7s+69KZ49D2t/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HBiwi81o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C6E606A32C;
	Wed, 18 Nov 2026 21:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HBiwi81o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6757D1F000C4;
	Wed, 18 Nov 2026 21:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036405;
	bh=JuUDziUGdTOZM1rByFjkjCQymgdSAbU+sX9tWpf5xLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HBiwi81oGmxwsxh7oruM9OzrRUS5OZrgyZoSFkB/2MBmUgH1Q97wbiO80PyJt58sm
	 yQOMh/++/QVrNvJL/XoKSJVRnXAX7vHVd3DY31jSiQ7CxXcn4DK1NUTTwdpavhit1q
	 UGeU1s/A89K/sPaRsyFV/N1ws+2plsy3vb7Ffg+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Herve Codina <herve.codina@bootlin.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1047/3318] soc: fsl: cpm1: tsa: Fix clock leak in tsa_of_parse_tdms()
Date: Wed, 18 Nov 2026 15:27:49 +0100
Message-ID: <20261118150351.328064821@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 46201d760c48e771fa2febfcb0787f22c3b71387 ]

The error cleanup loop puts l1rsync_clk and l1rclk_clk a second time
and never puts l1tsync_clk or l1tclk_clk, because the branches that
guard the transmit clocks use the receive clock field names.

Use the matching field in each branch so every clock acquired by
tsa_of_parse_tdms() is released exactly once.

Fixes: 1d4ba0b81c1c ("soc: fsl: cpm1: Add support for TSA")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Herve Codina <herve.codina@bootlin.com>
Link: https://lore.kernel.org/r/20260917152719.2160395-1-vulab@iscas.ac.cn
[chleroy: Fixed the same in tsa_remove()]
Signed-off-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/fsl/qe/tsa.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/soc/fsl/qe/tsa.c b/drivers/soc/fsl/qe/tsa.c
index 1bbc9af1e50b8..3bd0dcfe783f0 100644
--- a/drivers/soc/fsl/qe/tsa.c
+++ b/drivers/soc/fsl/qe/tsa.c
@@ -620,12 +620,12 @@ static int tsa_of_parse_tdms(struct tsa *tsa, struct device_node *np)
 			clk_put(tsa->tdm[i].l1rclk_clk);
 		}
 		if (tsa->tdm[i].l1tsync_clk) {
-			clk_disable_unprepare(tsa->tdm[i].l1rsync_clk);
-			clk_put(tsa->tdm[i].l1rsync_clk);
+			clk_disable_unprepare(tsa->tdm[i].l1tsync_clk);
+			clk_put(tsa->tdm[i].l1tsync_clk);
 		}
 		if (tsa->tdm[i].l1tclk_clk) {
-			clk_disable_unprepare(tsa->tdm[i].l1rclk_clk);
-			clk_put(tsa->tdm[i].l1rclk_clk);
+			clk_disable_unprepare(tsa->tdm[i].l1tclk_clk);
+			clk_put(tsa->tdm[i].l1tclk_clk);
 		}
 	}
 	return ret;
@@ -721,12 +721,12 @@ static int tsa_remove(struct platform_device *pdev)
 			clk_put(tsa->tdm[i].l1rclk_clk);
 		}
 		if (tsa->tdm[i].l1tsync_clk) {
-			clk_disable_unprepare(tsa->tdm[i].l1rsync_clk);
-			clk_put(tsa->tdm[i].l1rsync_clk);
+			clk_disable_unprepare(tsa->tdm[i].l1tsync_clk);
+			clk_put(tsa->tdm[i].l1tsync_clk);
 		}
 		if (tsa->tdm[i].l1tclk_clk) {
-			clk_disable_unprepare(tsa->tdm[i].l1rclk_clk);
-			clk_put(tsa->tdm[i].l1rclk_clk);
+			clk_disable_unprepare(tsa->tdm[i].l1tclk_clk);
+			clk_put(tsa->tdm[i].l1tclk_clk);
 		}
 	}
 	return 0;
-- 
2.53.0



