Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4F728ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:51:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9E0EC433D2;
	Mon, 12 Dec 2022 13:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670853084;
	bh=OBqqBj7blEIhXnqnGGCNSppkRf0fQbTEDUrvmApP7KA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=onhr9AFM7o2T0qiI3NaYveKzFLnsRsOj4+yi6qVe/+Hn3SPDZ0HUmITFi1/79ot7H
	 tyTqUTmteEI0oX02MyyOgv431BaVVgBjnB9B3aCTZbH3zNw/gwtjZHlhj2CM16+bqb
	 kSXsZX8tL1kRk8P7Ln1Fi1hhKlEOCPb1UOyvFktc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 48/49] net: mvneta: Fix an out of bounds check
Date: Mon, 12 Dec 2022 14:19:26 +0100
Message-Id: <20221212130916.063865878@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130913.666185567@linuxfoundation.org>
References: <20221212130913.666185567@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit cdd97383e19d4afe29adc3376025a15ae3bab3a3 ]

In an earlier commit, I added a bounds check to prevent an out of bounds
read and a WARN().  On further discussion and consideration that check
was probably too aggressive.  Instead of returning -EINVAL, a better fix
would be to just prevent the out of bounds read but continue the process.

Background: The value of "pp->rxq_def" is a number between 0-7 by default,
or even higher depending on the value of "rxq_number", which is a module
parameter. If the value is more than the number of available CPUs then
it will trigger the WARN() in cpu_max_bits_warn().

Fixes: e8b4fc13900b ("net: mvneta: Prevent out of bounds read in mvneta_config_rss()")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/Y5A7d1E5ccwHTYPf@kadam
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 5107382cefb5..fd1311681200 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3620,7 +3620,7 @@ static void mvneta_percpu_elect(struct mvneta_port *pp)
 	/* Use the cpu associated to the rxq when it is online, in all
 	 * the other cases, use the cpu 0 which can't be offline.
 	 */
-	if (cpu_online(pp->rxq_def))
+	if (pp->rxq_def < nr_cpu_ids && cpu_online(pp->rxq_def))
 		elected_cpu = pp->rxq_def;
 
 	max_cpu = num_present_cpus();
@@ -4141,9 +4141,6 @@ static int  mvneta_config_rss(struct mvneta_port *pp)
 		napi_disable(&pp->napi);
 	}
 
-	if (pp->indir[0] >= nr_cpu_ids)
-		return -EINVAL;
-
 	pp->rxq_def = pp->indir[0];
 
 	/* Update unicast mapping */
-- 
2.35.1



