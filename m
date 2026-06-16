Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D8544A71C;
	Tue, 16 Jun 2026 15:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623538; cv=none; b=pthB94SuxBCpHSLpsgv7poOLtzYxDK24WCS87lhT2AsgAVtESpgudkuLCI5uhjATSB/5DwF/+VVWky+M5ZLh/opKFeBuIxEzRBD6lv5B6ISd6+oqdZwE+wkl4bt/pQIFC+p9XNDNmFc43leKHUktrFs+IeZxlUETrYUaK7x+lcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623538; c=relaxed/simple;
	bh=OnRxLllq0+gAUr1YnzgjYwzACeX6y20C8UIqexUC244=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q/q1wKNd/0z8ysfgA0NURVUih46u8MqzbXVgfC1qOt8VtiSY2P01hUwIDlkMobdX9BLB4z55BUDex66az0sBKVd+ESKu8o9nZLyHQ6662PI9zr0L+axQ8h/UAbEdcFQvs7vGljFHaW7qOwl+5hL7su7i1VZ3nwlZdBe0M1hcv8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mMrMLQh9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mMrMLQh9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A3D1F00A3A;
	Tue, 16 Jun 2026 15:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623537;
	bh=VhJd4H6MAnXiBrM02q07Di5Xc85Rj3vvMDzknZ2aq/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mMrMLQh9h6Fr39UVKk5NDuj4hRG6+36yOnGr1kZGYQ4V22OWwtX6JfxXYTJndPOk+
	 pnFgIRh3E33PomRx3TYuJS8rWVooBQT+0XQIZFHxbCumlBPA9PQ11I6JlzSBccEs+Q
	 2v2+TbfoTIoW8FKs5QPeSy6OwQ6WAjJqks193vzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 167/378] accel/amdxdna: Fix mm_struct reference leak in aie2_populate_range()
Date: Tue, 16 Jun 2026 20:26:38 +0530
Message-ID: <20260616145119.096948480@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit 2f41af638c92bac6f1f9275ea2d1901baef578f3 ]

aie2_populate_range() jumps back to the again label without calling
mmput(mm), leaking a reference to the mm_struct.

Add the missing mmput() before jumping to again.

Fixes: e486147c912f ("accel/amdxdna: Add BO import and export")
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260610151127.2994185-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/aie2_ctx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/accel/amdxdna/aie2_ctx.c b/drivers/accel/amdxdna/aie2_ctx.c
index c0d348884f7494..4c7264c6e6e76f 100644
--- a/drivers/accel/amdxdna/aie2_ctx.c
+++ b/drivers/accel/amdxdna/aie2_ctx.c
@@ -928,6 +928,7 @@ static int aie2_populate_range(struct amdxdna_gem_obj *abo)
 
 		if (ret == -EBUSY) {
 			amdxdna_umap_put(mapp);
+			mmput(mm);
 			goto again;
 		}
 
@@ -938,11 +939,13 @@ static int aie2_populate_range(struct amdxdna_gem_obj *abo)
 	if (mmu_interval_read_retry(&mapp->notifier, mapp->range.notifier_seq)) {
 		up_write(&xdna->notifier_lock);
 		amdxdna_umap_put(mapp);
+		mmput(mm);
 		goto again;
 	}
 	mapp->invalid = false;
 	up_write(&xdna->notifier_lock);
 	amdxdna_umap_put(mapp);
+	mmput(mm);
 	goto again;
 
 put_mm:
-- 
2.53.0



