Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964501E51FA;
	Mon, 23 Jun 2025 21:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713930; cv=none; b=VHRFxDE+mtgvAr/UkmgdDh4ogKwtPv5ePYUzq805Z2NkcBSKz9TLCif6PYGJMKYPfEMKOlGTKntfYNyAdbqFeqzvIIbyFPo05wfkDTWgYMJicQIwD91ZBY33sJxaJ1jgtQS+WQsPS4qvhrZ+Z3D+e8ahQcXpjoosM6WMgMop+gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713930; c=relaxed/simple;
	bh=zodM9iz6PHTw/javcP4p5OXU+RI82DZFauqpZjw+yRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=htjpnJRB5g/joVB5Fz8h7S578JeKXEYjqhLalpzFjl8A0gbZvz99mlMQaiNe3IzHTenD+fI+1utdTqZz4z/EIeLGfumEUmp0gh+3uAMaSMoQdE2Vbc5phXGwsVOR6Fh3qR+XfDE6NPo0fuv+LAtq648AmmAIZocwBiL+OpyXeK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FmkkMvoG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FmkkMvoG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A1AC4CEEA;
	Mon, 23 Jun 2025 21:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713930;
	bh=zodM9iz6PHTw/javcP4p5OXU+RI82DZFauqpZjw+yRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FmkkMvoG2PYQtT0AcriOoid5Abh8kx3gnBvUmBrl65si//uMa/yTyqz3y1MVlf0h9
	 19pCJMG6SqOWb9t3uG4rloewx4tR4QHLH7Rws1kYNKKDRU/7bWaVEEl0p+VBb39pze
	 6SAH1uZpHUSh57ZQNBWlb2IzOIw/wJTjQZaW/Hj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 135/508] dm: free table mempools if not used in __bind
Date: Mon, 23 Jun 2025 15:03:00 +0200
Message-ID: <20250623130648.610586887@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Benjamin Marzinski <bmarzins@redhat.com>

[ Upstream commit e8819e7f03470c5b468720630d9e4e1d5b99159e ]

With request-based dm, the mempools don't need reloading when switching
tables, but the unused table mempools are not freed until the active
table is finally freed. Free them immediately if they are not needed.

Fixes: 29dec90a0f1d9 ("dm: fix bio_set allocation")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Tested-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 2b8fe98c515ed..cf7520551b63b 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2205,10 +2205,10 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
 		 * requests in the queue may refer to bio from the old bioset,
 		 * so you must walk through the queue to unprep.
 		 */
-		if (!md->mempools) {
+		if (!md->mempools)
 			md->mempools = t->mempools;
-			t->mempools = NULL;
-		}
+		else
+			dm_free_md_mempools(t->mempools);
 	} else {
 		/*
 		 * The md may already have mempools that need changing.
@@ -2217,8 +2217,8 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
 		 */
 		dm_free_md_mempools(md->mempools);
 		md->mempools = t->mempools;
-		t->mempools = NULL;
 	}
+	t->mempools = NULL;
 
 	old_map = rcu_dereference_protected(md->map, lockdep_is_held(&md->suspend_lock));
 	rcu_assign_pointer(md->map, (void *)t);
-- 
2.39.5



