Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015AD1ED41
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:53:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76BFAC433C7;
	Fri, 21 Jul 2023 18:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965598;
	bh=3AA/1cigcxuxGnogkkh20HhXC+2aOhyPyaILFNDNk0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kihsX0GBjerfEhCO06dH2k8lKqx4ylVS3ZXKXGofMDLkH8hDtbFoN57HTQ8Ei+f2p
	 H9xwG85NnFLyTDigaKmEffs7ggne8L8lV8pASN7tG/Y4t6UoiQk4RFb/c7JK/UWhN/
	 rSQeMdGHo3/N53NCegUJIEREGElh3dmumpMgPJBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 048/532] regulator: core: Fix more error checking for debugfs_create_dir()
Date: Fri, 21 Jul 2023 17:59:12 +0200
Message-ID: <20230721160617.250506434@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 2715bb11cfff964aa33946847f9527cfbd4874f5 ]

In case of failure, debugfs_create_dir() does not return NULL, but an
error pointer.  Most incorrect error checks were fixed, but the one in
create_regulator() was forgotten.

Fix the remaining error check.

Fixes: 2bf1c45be3b8f3a3 ("regulator: Fix error checking for debugfs_create_dir")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/ee980a108b5854dd8ce3630f8f673e784e057d17.1685013051.git.geert+renesas@glider.be
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 211ab227b000c..77573569bc78a 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1874,7 +1874,7 @@ static struct regulator *create_regulator(struct regulator_dev *rdev,
 
 	if (err != -EEXIST)
 		regulator->debugfs = debugfs_create_dir(supply_name, rdev->debugfs);
-	if (!regulator->debugfs) {
+	if (IS_ERR(regulator->debugfs)) {
 		rdev_dbg(rdev, "Failed to create debugfs directory\n");
 	} else {
 		debugfs_create_u32("uA_load", 0444, regulator->debugfs,
-- 
2.39.2



