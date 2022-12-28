Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679781875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:59:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1DCC433EF;
	Wed, 28 Dec 2022 15:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243160;
	bh=D/0aBaHzn5SFB1NyUoKmFvLKw/eY2lz8Z++VcCbMTJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=arLKpLUMe2TWDTlrQvFSLC/drPgFK6gQJzwCx5acoB/v/jVsxWbpms9+BHm7xQZId
	 2VRqQMZMJK415qT6G9gojIsk8UK2GXWmWsOlZAnJrzi8eY63//IkIPepBz/o5kVP3Z
	 6B/Opg3vXbEZi4u0DaC9fkjiWp1wGeMvJrKkSj0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Lei <thunder.leizhen@huawei.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0496/1073] mmc: core: Normalize the error handling branch in sd_read_ext_regs()
Date: Wed, 28 Dec 2022 15:34:44 +0100
Message-Id: <20221228144341.507984799@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit fc02e2b52389c8fde02852b2f959c0b45f042bbd ]

Let's use pr_err() to output the error messages and let's extend a comment
to clarify why returning 0 (success) in one case make sense.

Fixes: c784f92769ae ("mmc: core: Read the SD function extension registers for power management")
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
[Ulf: Clarified the comment and the commit-msg]
Link: https://lore.kernel.org/r/20221130134920.2109-1-thunder.leizhen@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/sd.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index 3662bf5320ce..72b664ed90cf 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -1259,7 +1259,7 @@ static int sd_read_ext_regs(struct mmc_card *card)
 	 */
 	err = sd_read_ext_reg(card, 0, 0, 0, 512, gen_info_buf);
 	if (err) {
-		pr_warn("%s: error %d reading general info of SD ext reg\n",
+		pr_err("%s: error %d reading general info of SD ext reg\n",
 			mmc_hostname(card->host), err);
 		goto out;
 	}
@@ -1273,7 +1273,12 @@ static int sd_read_ext_regs(struct mmc_card *card)
 	/* Number of extensions to be find. */
 	num_ext = gen_info_buf[4];
 
-	/* We support revision 0, but limit it to 512 bytes for simplicity. */
+	/*
+	 * We only support revision 0 and limit it to 512 bytes for simplicity.
+	 * No matter what, let's return zero to allow us to continue using the
+	 * card, even if we can't support the features from the SD function
+	 * extensions registers.
+	 */
 	if (rev != 0 || len > 512) {
 		pr_warn("%s: non-supported SD ext reg layout\n",
 			mmc_hostname(card->host));
@@ -1288,7 +1293,7 @@ static int sd_read_ext_regs(struct mmc_card *card)
 	for (i = 0; i < num_ext; i++) {
 		err = sd_parse_ext_reg(card, gen_info_buf, &next_ext_addr);
 		if (err) {
-			pr_warn("%s: error %d parsing SD ext reg\n",
+			pr_err("%s: error %d parsing SD ext reg\n",
 				mmc_hostname(card->host), err);
 			goto out;
 		}
-- 
2.35.1



