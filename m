Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2CC928ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:17:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E576C433D2;
	Mon, 12 Dec 2022 13:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670851076;
	bh=9bZAtuVAQTMZoDVw+2gv2FVUPeOg/zC0QGfbEPMFS2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m20LdLKD6YuJLzHOvCAkSelJMgsLTvUOGXqxGx7hr/kGR1nP1USfZBda393EEasRk
	 VnzefmC9YX5G7pevNgLhSz3J777hXlqcS/wetLnfyT4DoujOMg5DcxPkJ0Kraw9kFx
	 jjoDB97ZyFDr5oBWS7Lw91QIL9PTlfqfUfLQFiF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 104/106] net: mvneta: Fix an out of bounds check
Date: Mon, 12 Dec 2022 14:10:47 +0100
Message-Id: <20221212130929.399421685@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
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
index 6bfa0ac27be3..f5567d485e91 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -4140,7 +4140,7 @@ static void mvneta_percpu_elect(struct mvneta_port *pp)
 	/* Use the cpu associated to the rxq when it is online, in all
 	 * the other cases, use the cpu 0 which can't be offline.
 	 */
-	if (cpu_online(pp->rxq_def))
+	if (pp->rxq_def < nr_cpu_ids && cpu_online(pp->rxq_def))
 		elected_cpu = pp->rxq_def;
 
 	max_cpu = num_present_cpus();
@@ -4767,9 +4767,6 @@ static int  mvneta_config_rss(struct mvneta_port *pp)
 		napi_disable(&pp->napi);
 	}
 
-	if (pp->indir[0] >= nr_cpu_ids)
-		return -EINVAL;
-
 	pp->rxq_def = pp->indir[0];
 
 	/* Update unicast mapping */
-- 
2.35.1



