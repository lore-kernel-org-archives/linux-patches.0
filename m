Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4102611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:49:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34A2EC433EF;
	Sun, 28 May 2023 19:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685303396;
	bh=9Y0rT6L80FJuDiXy66NCxzCArPI7PyYaNrSfytyHMyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ISHRjXbikTwAU5OjnsqNl9/C6eIW3dw/nwLEMh9FQ8M2rTtgu98AthWJJ0BgsaMVl
	 UP7gnDgRwGLvn3nc5RxNu1IgwNszTEtcDpdtrybf0AKwLLzL/qhAUK1U2EebT78lWM
	 tEOwZpK97zML+2p6x6hWy2hrJ0LlkyOkvnMN+JWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.15 59/69] platform/mellanox: mlxbf-pmc: fix sscanf() error checking
Date: Sun, 28 May 2023 20:12:19 +0100
Message-Id: <20230528190830.580901288@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190828.358612414@linuxfoundation.org>
References: <20230528190828.358612414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 95e4b25192e9238fd2dbe85d96dd2f8fd1ce9d14 upstream.

The sscanf() function never returns negatives.  It returns the number of
items successfully read.

Fixes: 1a218d312e65 ("platform/mellanox: mlxbf-pmc: Add Mellanox BlueField PMC driver")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/4ccdfd28-099b-40bf-8d77-ad4ea2e76b93@kili.mountain
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/mellanox/mlxbf-pmc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/mellanox/mlxbf-pmc.c b/drivers/platform/mellanox/mlxbf-pmc.c
index c2c9b0d3244c..be967d797c28 100644
--- a/drivers/platform/mellanox/mlxbf-pmc.c
+++ b/drivers/platform/mellanox/mlxbf-pmc.c
@@ -1348,9 +1348,8 @@ static int mlxbf_pmc_map_counters(struct device *dev)
 
 	for (i = 0; i < pmc->total_blocks; ++i) {
 		if (strstr(pmc->block_name[i], "tile")) {
-			ret = sscanf(pmc->block_name[i], "tile%d", &tile_num);
-			if (ret < 0)
-				return ret;
+			if (sscanf(pmc->block_name[i], "tile%d", &tile_num) != 1)
+				return -EINVAL;
 
 			if (tile_num >= pmc->tile_count)
 				continue;
-- 
2.40.1



