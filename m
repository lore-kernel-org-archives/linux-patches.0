Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B742AE68;
	Mon, 30 Dec 2024 15:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574009; cv=none; b=LeYL1etPymN2J4cuTAlReDWuSxNXtXvBF5ntjIJd8yeQvzPX+DfhNiU15LT6r4e8783n7lkKIemhLj+7QTJQaqtTjgttnhvLYfk3YH4lZ7GQLymdU4aofIaHtmFPORzgudA7StfIGt6PzOXAOIRA93zQdWdOi0VBTJsh5gi6JJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574009; c=relaxed/simple;
	bh=/MzB2fTWO0U52EqiR1p2KFwP5sYPyVhHbf68J1PaPcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XBaLKmMfs6I003Tu/MVEs9Z5Zyc7At114tGN047JGgFUzeWbQn1ONTR13eyM5Pf3Jk+x9YfjtVuKwcuvnmDrEqLdxsvtjMaKS55Llaezm3cBAczl8CaU6GbtptZN4x+qiC+bWR7YJIlRJsH6cPMPNun4V4tJStuqVU1T9gVltnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aJ1RwIg1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aJ1RwIg1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6047C4CED0;
	Mon, 30 Dec 2024 15:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574009;
	bh=/MzB2fTWO0U52EqiR1p2KFwP5sYPyVhHbf68J1PaPcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aJ1RwIg1ewxI2SWNn993yAryqv/fsA5bQ54KFuVvji3IkYLjvNyMJRPb1QdTYpbml
	 cB4M/QCDB/L/Uz7k/Nx8onkLmElG7uzNasEIN6pmFSQhrJELEKQGIVDtV23n9CUVjf
	 aOZEHtUjEfdrhuLIraPnb0EfBdx3X/YslrMsEx4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Erkun <yangerkun@huawei.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 013/114] nfsd: Revert "nfsd: release svc_expkey/svc_export with rcu_work"
Date: Mon, 30 Dec 2024 16:42:10 +0100
Message-ID: <20241230154218.569240006@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

From: Yang Erkun <yangerkun@huawei.com>

[ Upstream commit 69d803c40edeaf94089fbc8751c9b746cdc35044 ]

This reverts commit f8c989a0c89a75d30f899a7cabdc14d72522bb8d.

Before this commit, svc_export_put or expkey_put will call path_put with
sync mode. After this commit, path_put will be called with async mode.
And this can lead the unexpected results show as follow.

mkfs.xfs -f /dev/sda
echo "/ *(rw,no_root_squash,fsid=0)" > /etc/exports
echo "/mnt *(rw,no_root_squash,fsid=1)" >> /etc/exports
exportfs -ra
service nfs-server start
mount -t nfs -o vers=4.0 127.0.0.1:/mnt /mnt1
mount /dev/sda /mnt/sda
touch /mnt1/sda/file
exportfs -r
umount /mnt/sda # failed unexcepted

The touch will finally call nfsd_cross_mnt, add refcount to mount, and
then add cache_head. Before this commit, exportfs -r will call
cache_flush to cleanup all cache_head, and path_put in
svc_export_put/expkey_put will be finished with sync mode. So, the
latter umount will always success. However, after this commit, path_put
will be called with async mode, the latter umount may failed, and if
we add some delay, umount will success too. Personally I think this bug
and should be fixed. We first revert before bugfix patch, and then fix
the original bug with a different way.

Fixes: f8c989a0c89a ("nfsd: release svc_expkey/svc_export with rcu_work")
Signed-off-by: Yang Erkun <yangerkun@huawei.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/export.c | 31 ++++++-------------------------
 fs/nfsd/export.h |  4 ++--
 2 files changed, 8 insertions(+), 27 deletions(-)

diff --git a/fs/nfsd/export.c b/fs/nfsd/export.c
index 6d0455973d64..49aede376d86 100644
--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -40,24 +40,15 @@
 #define	EXPKEY_HASHMAX		(1 << EXPKEY_HASHBITS)
 #define	EXPKEY_HASHMASK		(EXPKEY_HASHMAX -1)
 
-static void expkey_put_work(struct work_struct *work)
+static void expkey_put(struct kref *ref)
 {
-	struct svc_expkey *key =
-		container_of(to_rcu_work(work), struct svc_expkey, ek_rcu_work);
+	struct svc_expkey *key = container_of(ref, struct svc_expkey, h.ref);
 
 	if (test_bit(CACHE_VALID, &key->h.flags) &&
 	    !test_bit(CACHE_NEGATIVE, &key->h.flags))
 		path_put(&key->ek_path);
 	auth_domain_put(key->ek_client);
-	kfree(key);
-}
-
-static void expkey_put(struct kref *ref)
-{
-	struct svc_expkey *key = container_of(ref, struct svc_expkey, h.ref);
-
-	INIT_RCU_WORK(&key->ek_rcu_work, expkey_put_work);
-	queue_rcu_work(system_wq, &key->ek_rcu_work);
+	kfree_rcu(key, ek_rcu);
 }
 
 static int expkey_upcall(struct cache_detail *cd, struct cache_head *h)
@@ -364,26 +355,16 @@ static void export_stats_destroy(struct export_stats *stats)
 					    EXP_STATS_COUNTERS_NUM);
 }
 
-static void svc_export_put_work(struct work_struct *work)
+static void svc_export_put(struct kref *ref)
 {
-	struct svc_export *exp =
-		container_of(to_rcu_work(work), struct svc_export, ex_rcu_work);
-
+	struct svc_export *exp = container_of(ref, struct svc_export, h.ref);
 	path_put(&exp->ex_path);
 	auth_domain_put(exp->ex_client);
 	nfsd4_fslocs_free(&exp->ex_fslocs);
 	export_stats_destroy(exp->ex_stats);
 	kfree(exp->ex_stats);
 	kfree(exp->ex_uuid);
-	kfree(exp);
-}
-
-static void svc_export_put(struct kref *ref)
-{
-	struct svc_export *exp = container_of(ref, struct svc_export, h.ref);
-
-	INIT_RCU_WORK(&exp->ex_rcu_work, svc_export_put_work);
-	queue_rcu_work(system_wq, &exp->ex_rcu_work);
+	kfree_rcu(exp, ex_rcu);
 }
 
 static int svc_export_upcall(struct cache_detail *cd, struct cache_head *h)
diff --git a/fs/nfsd/export.h b/fs/nfsd/export.h
index 081afb68681e..3794ae253a70 100644
--- a/fs/nfsd/export.h
+++ b/fs/nfsd/export.h
@@ -75,7 +75,7 @@ struct svc_export {
 	u32			ex_layout_types;
 	struct nfsd4_deviceid_map *ex_devid_map;
 	struct cache_detail	*cd;
-	struct rcu_work		ex_rcu_work;
+	struct rcu_head		ex_rcu;
 	unsigned long		ex_xprtsec_modes;
 	struct export_stats	*ex_stats;
 };
@@ -92,7 +92,7 @@ struct svc_expkey {
 	u32			ek_fsid[6];
 
 	struct path		ek_path;
-	struct rcu_work		ek_rcu_work;
+	struct rcu_head		ek_rcu;
 };
 
 #define EX_ISSYNC(exp)		(!((exp)->ex_flags & NFSEXP_ASYNC))
-- 
2.39.5



