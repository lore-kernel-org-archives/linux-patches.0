Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A7A2F3651;
	Tue, 17 Jun 2025 16:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176869; cv=none; b=eooBbFjv3lAswwIjiJtLnAkYEJcyrvdMPbIsCEvsYESaPqW/QGNj11+MLFWrQP8jLa1iGTinK57HeeSPJKdBqmOlhu6PJ01s7OXJg8WwC5/vk4hbp3w2qBx7S/GiOl8YTnGDhBoNXbgeJpEd8VZRplTFMff0m4odEiOTYJATNOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176869; c=relaxed/simple;
	bh=I81o2IR5SsCnXzKvMKailHxObOY3q+qDJHS7UgucGE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RCUu5BJDPmbmcoDBL9X3Cn9f2f8vGytitSJ9h3rdEMoqWzIDRoEKG+pjpqwDKx+gjZwq0NmD7oIqaFsA5SnrK2EatsCWvhR3PErzvucSupqqLnIoT4ZcShMgZChA/XKw6MjkQaWYmbTU5u6UrSlY5Uo4utyExesdkGw5rl83wGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UoNRPlul; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UoNRPlul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64AA2C4CEE3;
	Tue, 17 Jun 2025 16:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176868;
	bh=I81o2IR5SsCnXzKvMKailHxObOY3q+qDJHS7UgucGE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UoNRPlulSb07H/3zz9Z2ZMpgITwfC4WpG3DfCxrttSsn6uSVnCGdSAuFXLjQGHe3V
	 9YJ/bK/RzboMGVZ9NQbEsURr9mMBPCtaQwUFA3WvhlgHEO0jHCjqxlSnlHXn/vmXqc
	 cdlWsMVUfvi9kgcpc2yLiT0sKxARdtfnSunu2uXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 274/512] dm: free table mempools if not used in __bind
Date: Tue, 17 Jun 2025 17:24:00 +0200
Message-ID: <20250617152430.699083314@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 12d5f414a6788..92e5a233f5160 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2450,10 +2450,10 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
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
@@ -2462,8 +2462,8 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
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



