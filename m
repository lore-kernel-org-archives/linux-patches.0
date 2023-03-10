Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F51847E
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:48:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79AB1C433D2;
	Fri, 10 Mar 2023 13:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456138;
	bh=W5ZR2xvhvWDUe4qPkZL+I71kq9SfbFAwJ6Gi/XTyzJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D8TjXCIpl3tTQDBO5I6gQ4dJTa2Tsn4BvA1Ov4flX28vdu6EEA0ndOutVTmqolstk
	 221WCu8VmaK9phJEdXosr02YX9J8blDqGyyIEbs9lIAE9jtkbhKLvu9W0H/KajnsI/
	 qNMwnq95VvyVM+RAJ7wd66IRDIX9fCeUXUqYrXIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	linux-samsung-soc@vger.kernel.org,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 093/193] regulator: s5m8767: Bounds check id indexing into arrays
Date: Fri, 10 Mar 2023 14:37:55 +0100
Message-Id: <20230310133714.304169831@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kees Cook <keescook@chromium.org>

[ Upstream commit e314e15a0b58f9d051c00b25951073bcdae61953 ]

The compiler has no way to know if "id" is within the array bounds of
the regulators array. Add a check for this and a build-time check that
the regulators and reg_voltage_map arrays are sized the same. Seen with
GCC 13:

../drivers/regulator/s5m8767.c: In function 's5m8767_pmic_probe':
../drivers/regulator/s5m8767.c:936:35: warning: array subscript [0, 36] is outside array bounds of 'struct regulator_desc[37]' [-Warray-bounds=]
  936 |                         regulators[id].vsel_reg =
      |                         ~~~~~~~~~~^~~~

Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-samsung-soc@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20230128005358.never.313-kees@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/s5m8767.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index d558f806a4705..80e751759b706 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -918,10 +918,14 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
 
 	for (i = 0; i < pdata->num_regulators; i++) {
 		const struct sec_voltage_desc *desc;
-		int id = pdata->regulators[i].id;
+		unsigned int id = pdata->regulators[i].id;
 		int enable_reg, enable_val;
 		struct regulator_dev *rdev;
 
+		BUILD_BUG_ON(ARRAY_SIZE(regulators) != ARRAY_SIZE(reg_voltage_map));
+		if (WARN_ON_ONCE(id >= ARRAY_SIZE(regulators)))
+			continue;
+
 		desc = reg_voltage_map[id];
 		if (desc) {
 			regulators[id].n_voltages =
-- 
2.39.2



