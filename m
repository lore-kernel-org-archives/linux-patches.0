Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A01A331203;
	Sat, 12 Sep 2026 15:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226885; cv=none; b=YJHD4doH0dAu7X/OZpS4CcxPXL4SAaq7zGpjMG5W3JWuAJCMjisfnium/QUljXil1JPAyMMukgtB+VFPJuk48+wI6zVN+ls0PnhFwURNPszSw24gdXCpk1j5L8SO1krrXMX/oGRJrcvFecvMxs5Z+IxMQy0t+6T6gXgA+pnlt3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226885; c=relaxed/simple;
	bh=tK7P1qCDa0nCAWvQi6sphNZPdZNkk9VmJLKymEqVr9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GkYLYu0IDI+ANwzig0TcU9TKqYb/SEloZRPOxKB8xxgO/NDIbtqtJdq6jYPWtJQTNqy3N2TfkRHPHRtkagFjLR6bdc7tL//c4i91Q3dBXLwg2SFOqGGegj7rpkusOdV2TKOQ0Dx4zaP9vsMVCDTbJiN4H4EGiVDIqsUGxHK26eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AQ7rdbD1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AQ7rdbD1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A42C1F000FF;
	Sat, 12 Sep 2026 15:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226883;
	bh=bmftPP2GfW/a7bQmTTOme/1YuFQhuZENJONy+U5Q2rQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AQ7rdbD1vuhftr0oyj8CfmU0dCsM7I3g4scoDwfvtbyLH27I7LkwHORwYSM+bEWQ+
	 LQME4xkvqNyRZn8hhmxNZfT7+nWvKD0+uhxmo4KaIMdnfOVFA2PzJvK/YYK3mtNOeT
	 j3JbHNP0xX073zgdLeOR3sPux34Enr4lVVhs7+WE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fredric Cover <fredric.cover.lkernel@gmail.com>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.1 0069/1191] smb: client: harden DFS cache against invalid target hints
Date: Sat, 12 Sep 2026 08:46:37 +0200
Message-ID: <20260912065549.710347301@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fredric Cover <fredric.cover.lkernel@gmail.com>

commit bf86c08123c6ab8c61cc0be1dad7540db93738ff upstream.

Currently, get_tgt_name() returns ERR_PTR(-ENOENT) when ce->tgthint is
NULL, and dfs_cache_noreq_update_tgthint() assumes ce->tgthint is always
valid.

In preparation for clearing ce->tgthint in free_tgts(), harden callers
of get_tgt_name() against ERR_PTR results and harden
dfs_cache_noreq_update_tgthint() against NULL pointer dereferences.

Cc: stable@vger.kernel.org
Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/dfs_cache.c |   31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

--- a/fs/smb/client/dfs_cache.c
+++ b/fs/smb/client/dfs_cache.c
@@ -972,13 +972,22 @@ int dfs_cache_find(const unsigned int xi
 		goto out_free_path;
 	}
 
-	if (ref)
-		rc = setup_referral(path, ce, ref, get_tgt_name(ce));
-	else
+	if (ref) {
+		char *target = get_tgt_name(ce);
+
+		if (IS_ERR(target)) {
+			rc = PTR_ERR(target);
+			goto out_unlock;
+		}
+		rc = setup_referral(path, ce, ref, target);
+	} else {
 		rc = 0;
+	}
+
 	if (!rc && tgt_list)
 		rc = get_targets(ce, tgt_list);
 
+out_unlock:
 	up_read(&htable_rw_lock);
 
 out_free_path:
@@ -1018,10 +1027,17 @@ int dfs_cache_noreq_find(const char *pat
 		goto out_unlock;
 	}
 
-	if (ref)
-		rc = setup_referral(path, ce, ref, get_tgt_name(ce));
-	else
+	if (ref) {
+		char *target = get_tgt_name(ce);
+
+		if (IS_ERR(target)) {
+			rc = PTR_ERR(target);
+			goto out_unlock;
+		}
+		rc = setup_referral(path, ce, ref, target);
+	} else {
 		rc = 0;
+	}
 	if (!rc && tgt_list)
 		rc = get_targets(ce, tgt_list);
 
@@ -1132,7 +1148,8 @@ int dfs_cache_noreq_update_tgthint(const
 	rc = 0;
 	t = ce->tgthint;
 
-	if (unlikely(!strcasecmp(it->it_name, t->name)))
+	/* Check 't' in case ce->tgthint was cleared by free_tgts() */
+	if (t && unlikely(!strcasecmp(it->it_name, t->name)))
 		goto out_unlock;
 
 	list_for_each_entry(t, &ce->tlist, list) {


