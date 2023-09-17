Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE21963DE
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:26:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A28C433C8;
	Sun, 17 Sep 2023 20:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982407;
	bh=gbqdj+Qn+G3UR9RR4Y5NAkEyVCI2EtLnlphmXNLNlq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SFdWrR7wy24Sank/GFUhZrTI4Ts2DXXy81R29mF8b+xuObGBkCIeLgBn7qZo4z+AJ
	 uaD8lozMaeBbzhufy4uDL1bHupxfvdkoexYH7xrUQgTlBBscKbCvzBq3EcF9NRBgBo
	 NNYFaSMXzQ2aN3xF7u88YP1l0CkTcYQTn0yDaZx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniil Dulov <d.dulov@aladdin.ru>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 241/511] media: dib7000p: Fix potential division by zero
Date: Sun, 17 Sep 2023 21:11:08 +0200
Message-ID: <20230917191119.635189941@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniil Dulov <d.dulov@aladdin.ru>

[ Upstream commit a1db7b2c5533fc67e2681eb5efc921a67bc7d5b8 ]

Variable loopdiv can be assigned 0, then it is used as a denominator,
without checking it for 0.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 713d54a8bd81 ("[media] DiB7090: add support for the dib7090 based")
Signed-off-by: Daniil Dulov <d.dulov@aladdin.ru>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
[hverkuil: (bw != NULL) -> bw]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-frontends/dib7000p.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/dib7000p.c b/drivers/media/dvb-frontends/dib7000p.c
index 55bee50aa8716..1f0b0690198ef 100644
--- a/drivers/media/dvb-frontends/dib7000p.c
+++ b/drivers/media/dvb-frontends/dib7000p.c
@@ -497,7 +497,7 @@ static int dib7000p_update_pll(struct dvb_frontend *fe, struct dibx000_bandwidth
 	prediv = reg_1856 & 0x3f;
 	loopdiv = (reg_1856 >> 6) & 0x3f;
 
-	if ((bw != NULL) && (bw->pll_prediv != prediv || bw->pll_ratio != loopdiv)) {
+	if (loopdiv && bw && (bw->pll_prediv != prediv || bw->pll_ratio != loopdiv)) {
 		dprintk("Updating pll (prediv: old =  %d new = %d ; loopdiv : old = %d new = %d)\n", prediv, bw->pll_prediv, loopdiv, bw->pll_ratio);
 		reg_1856 &= 0xf000;
 		reg_1857 = dib7000p_read_word(state, 1857);
-- 
2.40.1



