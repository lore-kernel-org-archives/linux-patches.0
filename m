Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F73D79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:51:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A2BC433C1;
	Wed, 30 Nov 2022 18:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834302;
	bh=n2v2hJ/A7l9r8nBHwMK3QlJ3qBXpNglH5/XWvNrDO7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MmiUKaAZJxr8R/zzYS/QGyVXO4YQYUwwLkrxVrgg6ufKW1EqJFo3JcyLSviraeuPC
	 SoVBR6RrYzuB9TjmjZCyxBgt6iiooIhVhgnQ2WG1dEX1F2m0d3pjS6qI1SHIaBnosG
	 562aWA+/+iJMoWfDYkU//AcIE1HUUFkmFkzvN/Qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.0 176/289] mm/damon/sysfs-schemes: skip stats update if the scheme directory is removed
Date: Wed, 30 Nov 2022 19:22:41 +0100
Message-Id: <20221130180548.118577629@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: SeongJae Park <sj@kernel.org>

commit 8468b486612c808c9e337708d66a435498f1735c upstream.

A DAMON sysfs interface user can start DAMON with a scheme, remove the
sysfs directory for the scheme, and then ask update of the scheme's stats.
Because the schemes stats update logic isn't aware of the situation, it
results in an invalid memory access.  Fix the bug by checking if the
scheme sysfs directory exists.

Link: https://lkml.kernel.org/r/20221114175552.1951-1-sj@kernel.org
Fixes: 0ac32b8affb5 ("mm/damon/sysfs: support DAMOS stats")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[v5.18]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2342,6 +2342,10 @@ static int damon_sysfs_upd_schemes_stats
 	damon_for_each_scheme(scheme, ctx) {
 		struct damon_sysfs_stats *sysfs_stats;
 
+		/* user could have removed the scheme sysfs dir */
+		if (schemes_idx >= sysfs_schemes->nr)
+			break;
+
 		sysfs_stats = sysfs_schemes->schemes_arr[schemes_idx++]->stats;
 		sysfs_stats->nr_tried = scheme->stat.nr_tried;
 		sysfs_stats->sz_tried = scheme->stat.sz_tried;


