Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0977A6FAF;
	Tue,  5 Dec 2023 03:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kvI/tu2B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79796C433C7;
	Tue,  5 Dec 2023 03:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746969;
	bh=+MVP08TKzeTLR91yVtYsRtxdcNyYJBJxbnPfhXEHfgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kvI/tu2BMuzBrE8AYMAoEolxVvXprlY0LPP7/BuQYo5Sj5X3Ku1tcLdrGtXEItdpN
	 HsH3yZgKs3k0yo9ECP3ERjFN7NU44mcfLGQLNaNsd0SsqZU33E/7WEvHj8oiYeLfx7
	 EBrD8JjIDtK28+HmyahPdRZokQzzGR+AsiTcNBK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maria Yu <quic_aiquny@quicinc.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.1 004/107] pinctrl: avoid reload of p state in list iteration
Date: Tue,  5 Dec 2023 12:15:39 +0900
Message-ID: <20231205031531.765822427@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031531.426872356@linuxfoundation.org>
References: <20231205031531.426872356@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maria Yu <quic_aiquny@quicinc.com>

commit 4198a9b571065978632276264e01d71d68000ac5 upstream.

When in the list_for_each_entry iteration, reload of p->state->settings
with a local setting from old_state will turn the list iteration into an
infinite loop.

The typical symptom when the issue happens, will be a printk message like:

  "not freeing pin xx (xxx) as part of deactivating group xxx - it is
already used for some other setting".

This is a compiler-dependent problem, one instance occurred using Clang
version 10.0 on the arm64 architecture with linux version 4.19.

Fixes: 6e5e959dde0d ("pinctrl: API changes to support multiple states per device")
Signed-off-by: Maria Yu <quic_aiquny@quicinc.com>
Cc:  <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20231115102824.23727-1-quic_aiquny@quicinc.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -1239,17 +1239,17 @@ static void pinctrl_link_add(struct pinc
 static int pinctrl_commit_state(struct pinctrl *p, struct pinctrl_state *state)
 {
 	struct pinctrl_setting *setting, *setting2;
-	struct pinctrl_state *old_state = p->state;
+	struct pinctrl_state *old_state = READ_ONCE(p->state);
 	int ret;
 
-	if (p->state) {
+	if (old_state) {
 		/*
 		 * For each pinmux setting in the old state, forget SW's record
 		 * of mux owner for that pingroup. Any pingroups which are
 		 * still owned by the new state will be re-acquired by the call
 		 * to pinmux_enable_setting() in the loop below.
 		 */
-		list_for_each_entry(setting, &p->state->settings, node) {
+		list_for_each_entry(setting, &old_state->settings, node) {
 			if (setting->type != PIN_MAP_TYPE_MUX_GROUP)
 				continue;
 			pinmux_disable_setting(setting);


