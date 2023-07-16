Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620E88F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:21:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A34C433C9;
	Sun, 16 Jul 2023 20:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538870;
	bh=Uhk18Bmsbi7YcOKOtaIXMSdyvYyYn1t8ysq/pQrMDmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ohfC4kiKpzxncpvfFWm5ZOVgnBGob1bsFSMAqcnHAi72jaAcSd429xvTblJka3x2U
	 j1gyY9b7D0i4rUMphO4MKrbLgtQ6sFJIKP6CT+tFTYIIS0rRvFwAZv2yQ7sNOev04D
	 RCitnUtQyDRIeTjaClzIO7CgV5xcsLyOgK3vZhE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rikard Falkeborn <rikard.falkeborn@gmail.com>,
	Stanimir Varbanov <stanimir.k.varbanov@gmail.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 606/800] media: venus: helpers: Fix ALIGN() of non power of two
Date: Sun, 16 Jul 2023 21:47:39 +0200
Message-ID: <20230716195003.182400066@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rikard Falkeborn <rikard.falkeborn@gmail.com>

[ Upstream commit 927e78ac8bc58155316cf6f46026e1912bbbbcfc ]

ALIGN() expects its second argument to be a power of 2, otherwise
incorrect results are produced for some inputs. The output can be
both larger or smaller than what is expected.

For example, ALIGN(304, 192) equals 320 instead of 384, and
ALIGN(65, 192) equals 256 instead of 192.

However, nestling two ALIGN() as is done in this case seem to only
produce results equal to or bigger than the expected result if ALIGN()
had handled non powers of two, and that in turn results in framesizes
that are either the correct size or too large.

Fortunately, since 192 * 4 / 3 equals 256, it turns out that one ALIGN()
is sufficient.

Fixes: ab1eda449c6e ("media: venus: vdec: handle 10bit bitstreams")
Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Signed-off-by: Stanimir Varbanov <stanimir.k.varbanov@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/helpers.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
index a2ceab7f9ddbf..a68389b0aae0a 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -1036,8 +1036,8 @@ static u32 get_framesize_raw_yuv420_tp10_ubwc(u32 width, u32 height)
 	u32 extradata = SZ_16K;
 	u32 size;
 
-	y_stride = ALIGN(ALIGN(width, 192) * 4 / 3, 256);
-	uv_stride = ALIGN(ALIGN(width, 192) * 4 / 3, 256);
+	y_stride = ALIGN(width * 4 / 3, 256);
+	uv_stride = ALIGN(width * 4 / 3, 256);
 	y_sclines = ALIGN(height, 16);
 	uv_sclines = ALIGN((height + 1) >> 1, 16);
 
-- 
2.39.2



