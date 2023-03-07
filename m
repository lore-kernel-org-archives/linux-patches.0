Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E961FBA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:25:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5743DC433EF;
	Tue,  7 Mar 2023 18:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213545;
	bh=JrVWWq4sJZRZXrAVy48HDbLoRW87VOhunRrH9CHQNvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nFi7kyUsw6PKoPZvR2oOW3ZmAM09IZ4c4WiJy+SaxzA0I0lEhmwzSB7z6TVwJaIPK
	 LDMjCyvtFF8NnZa+0zACJi5dg/5nvExKqjXtoj++hvzHh74lSgpjSo6Waa9lEdk9qG
	 6wRcMV0g4dLwDz852diPoKU3MRWSI1M8BTQmoV/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Robert Foss <robert.foss@linaro.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 511/885] media: camss: csiphy-3ph: avoid undefined behavior
Date: Tue,  7 Mar 2023 17:57:25 +0100
Message-Id: <20230307170024.680143579@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 05fb9ace34b8645cb76f7e3a21b5c7b754329cae ]

Marking a case of the switch statement as unreachable means the
compiler treats it as undefined behavior, which is then caught by
an objtool warning:

drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.o: warning: objtool: csiphy_lanes_enable() falls through to next function csiphy_lanes_disable()

Instead of simply continuing execution at a random place of the
driver, print a warning and return from to the caller, which
makes it possible to understand what happens and avoids the
warning.

Fixes: 53655d2a0ff2 ("media: camss: csiphy-3ph: add support for SM8250 CSI DPHY")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c b/drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c
index 451a4c9b3d30d..04baa80494c66 100644
--- a/drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c
+++ b/drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c
@@ -429,7 +429,8 @@ static void csiphy_gen2_config_lanes(struct csiphy_device *csiphy,
 		array_size = ARRAY_SIZE(lane_regs_sm8250[0]);
 		break;
 	default:
-		unreachable();
+		WARN(1, "unknown cspi version\n");
+		return;
 	}
 
 	for (l = 0; l < 5; l++) {
-- 
2.39.2



