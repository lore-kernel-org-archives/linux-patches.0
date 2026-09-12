Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED761A9F83;
	Sat, 12 Sep 2026 11:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212702; cv=none; b=dL5ycBMRrEyub9h+xmNHIXqL6iFlqZx1kJf+Ub8SbVCR1dp384hkmXeKPgkaLPyQWt7m/NbSWYWYEvVK0jk2J9IXkHakl//rQUcNN6bBTPNx/UHvw0GMq3DSj+c793asP62/0wUXkh+1Mb3JP3xXQfjKtYv2EV1ODS8BiKl/MjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212702; c=relaxed/simple;
	bh=1ZblBJcaq6a4meg5sci6rFUEUkYHsSmj6Mx0aiR+M5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gCIqUZ8SvtXhCsLTFJ3gKHX3rLlam9nWXvobIsZ20yXOHsnPZwMc4ElvmvmWNHTfQzMEd09eXplvUCIKmtIAOa2lv3FX1gVKMWldkriSl+mKgB3Ek4cDfmfgbPzQH4pe2OjpyNOo1loGgxsMagX4+oiUlu/16GTRHJov40FWmvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AbuobX6q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AbuobX6q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF4BA1F000FF;
	Sat, 12 Sep 2026 11:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212701;
	bh=/Lxg7F8Axc9ySblPcHzWagmnWUUzVWPDMcBhGUqbyhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AbuobX6qS6jSUVVXN148busgicbefQhL4gGrpVPYpnIxtfbiTsfoZpBjYUKVnTg1T
	 NsudJ7ntdJLQDRxRtxmCUrmkNDHkldayc9xoE4vKZmAIndgz2GtmDk9Eozp2krF+su
	 anPMnOCxFbHGJl9uY7A8Bn/YT8+CH4f5RCewRwCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1490/1518] pinctrl: airoha: Fix AIROHA_PINCTRL_CONFS_DRIVE_E2 in an7583_pinctrl_match_data
Date: Sat, 12 Sep 2026 09:00:59 +0200
Message-ID: <20260912065657.268335681@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 0341d1b1ebf10bcbb9f35e174e83dbb21068387d ]

Clang warns (or errors with CONFIG_WERROR=y / W=e):

  pinctrl/mediatek/pinctrl-airoha.c:2064:41: error: variable 'an7583_pinctrl_drive_e2_conf' is not needed and will not be emitted [-Werror,-Wunneeded-internal-declaration]
   2064 | static const struct airoha_pinctrl_conf an7583_pinctrl_drive_e2_conf[] = {
        |                                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~

Due to a typo, an7583_pinctrl_drive_e2_conf is only used within
ARRAY_SIZE() (hence no instance of -Wunused-variable), which is
evaluated at compile time, so it will not be needed in the final object
file.

Fix the .confs assignment for AIROHA_PINCTRL_CONFS_DRIVE_E2 in
an7583_pinctrl_match_data to clear up the warning.

Closes: https://github.com/ClangBuiltLinux/linux/issues/2142
Fixes: 3ffeb17a9a27 ("pinctrl: airoha: add support for Airoha AN7583 PINs")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Christian Marangi <ansuelsmth@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-airoha.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-airoha.c b/drivers/pinctrl/mediatek/pinctrl-airoha.c
index 5d8b6e828673b..ba5647f6328eb 100644
--- a/drivers/pinctrl/mediatek/pinctrl-airoha.c
+++ b/drivers/pinctrl/mediatek/pinctrl-airoha.c
@@ -3259,7 +3259,7 @@ static const struct airoha_pinctrl_match_data an7583_pinctrl_match_data = {
 			.num_confs = ARRAY_SIZE(an7583_pinctrl_pulldown_conf),
 		},
 		[AIROHA_PINCTRL_CONFS_DRIVE_E2] = {
-			.confs = en7581_pinctrl_drive_e2_conf,
+			.confs = an7583_pinctrl_drive_e2_conf,
 			.num_confs = ARRAY_SIZE(an7583_pinctrl_drive_e2_conf),
 		},
 		[AIROHA_PINCTRL_CONFS_DRIVE_E4] = {
-- 
2.53.0



