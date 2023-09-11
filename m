Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138FE11706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:46:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4FEC433C8;
	Mon, 11 Sep 2023 14:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443573;
	bh=g22OAn+ql8mxmnpiIOGO5Ob8QCgJ0sBLD87gxH8vq48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TVsCFT82tm06I6FK6wUSqFt5qO9VupeEt+p3iJanaaaITmKLL1MIPbXOCRqPgpsag
	 XIbgJHBe8O2DvD/KonVu3ETNnUVG2Gy4o2105t5//aGpAWmfAnoB5xEg0fklZvUuF1
	 Xo81x9RU5kBgrMf2baG5B7yudN9dGVMmTgV1uvLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Karpovich <vkarpovi@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 396/737] firmware: cs_dsp: Fix new control name check
Date: Mon, 11 Sep 2023 15:44:15 +0200
Message-ID: <20230911134701.660045953@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Karpovich <vkarpovi@opensource.cirrus.com>

[ Upstream commit 7ac1102b227b36550452b663fd39ab1c09378a95 ]

Before adding a new FW control, its name is checked against
existing controls list. But the string length in strncmp used
to compare controls names is taken from the list, so if beginnings
of the controls are matching,  then the new control is not created.
For example, if CAL_R control already exists, CAL_R_SELECTED
is not created.
The fix is to compare string lengths as well.

Fixes: 6477960755fb ("ASoC: wm_adsp: Move check for control existence")
Signed-off-by: Vlad Karpovich <vkarpovi@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20230815172908.3454056-1-vkarpovi@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/cirrus/cs_dsp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/cirrus/cs_dsp.c b/drivers/firmware/cirrus/cs_dsp.c
index ec056f6f40ce8..cc3a28f386a77 100644
--- a/drivers/firmware/cirrus/cs_dsp.c
+++ b/drivers/firmware/cirrus/cs_dsp.c
@@ -978,7 +978,8 @@ static int cs_dsp_create_control(struct cs_dsp *dsp,
 		    ctl->alg_region.alg == alg_region->alg &&
 		    ctl->alg_region.type == alg_region->type) {
 			if ((!subname && !ctl->subname) ||
-			    (subname && !strncmp(ctl->subname, subname, ctl->subname_len))) {
+			    (subname && (ctl->subname_len == subname_len) &&
+			     !strncmp(ctl->subname, subname, ctl->subname_len))) {
 				if (!ctl->enabled)
 					ctl->enabled = 1;
 				return 0;
-- 
2.40.1



