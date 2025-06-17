Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C382EA487;
	Tue, 17 Jun 2025 15:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174980; cv=none; b=X3BNqhurL4tEdxZGQc4eme+5Y6uQuF1+E0zWV+ltVQjRQkZYs5plrvOVgHZ0TjVVAG5F4wkpzr036O2dxLZHN0eOAjHvcTAFqNGSGnvaMAk+N4JqgsvFPu4qHZ332DP/hePpbFwCa48vZthUUvjzIOE/NKc7Eo0mNQ447w0wOUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174980; c=relaxed/simple;
	bh=cExr6gHhZVQFCYBC2G32BYItAWl6K/CaWgK2l39f+bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dz4Bj3ndMOAzPH7uIFMe+Q1MX4ntHbJQWReeEImWatz/kkbtB3argHTXvlWEf7ArU64gmPynro+2cQnArYXzB81XEz59y0T0GQW8LtJN9K25xFZWodfyDGjko7Vaz0j8aSsDYh53AflnHpOhK+U6vccDcbLxLWOE0CXekusTySs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xUhIzHbW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xUhIzHbW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA523C4CEE3;
	Tue, 17 Jun 2025 15:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174980;
	bh=cExr6gHhZVQFCYBC2G32BYItAWl6K/CaWgK2l39f+bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xUhIzHbWtY4PfJvBbN0EVU+x8bSOFHxJxPr/8B4KGVtU5SkYY7Z6DJbfa/eRKfRQO
	 m7FTsH7Vcowri1mU5MCF3zOLR+61718Ha+gUFrWAod+I3qrx+zX1rDNbBOFZ3apDck
	 EkHLDMxeo+6P/WHelKVB2Z8b+VtilC/grHNI24MM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 133/356] kernfs: Relax constraint in draining guard
Date: Tue, 17 Jun 2025 17:24:08 +0200
Message-ID: <20250617152343.590263981@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Koutný <mkoutny@suse.com>

[ Upstream commit 071d8e4c2a3b0999a9b822e2eb8854784a350f8a ]

The active reference lifecycle provides the break/unbreak mechanism but
the active reference is not truly active after unbreak -- callers don't
use it afterwards but it's important for proper pairing of kn->active
counting. Assuming this mechanism is in place, the WARN check in
kernfs_should_drain_open_files() is too sensitive -- it may transiently
catch those (rightful) callers between
kernfs_unbreak_active_protection() and kernfs_put_active() as found out by Chen
Ridong:

	kernfs_remove_by_name_ns	kernfs_get_active // active=1
	__kernfs_remove					  // active=0x80000002
	kernfs_drain			...
	wait_event
	//waiting (active == 0x80000001)
					kernfs_break_active_protection
					// active = 0x80000001
	// continue
					kernfs_unbreak_active_protection
					// active = 0x80000002
	...
	kernfs_should_drain_open_files
	// warning occurs
					kernfs_put_active

To avoid the false positives (mind panic_on_warn) remove the check altogether.
(This is meant as quick fix, I think active reference break/unbreak may be
simplified with larger rework.)

Fixes: bdb2fd7fc56e1 ("kernfs: Skip kernfs_drain_open_files() more aggressively")
Link: https://lore.kernel.org/r/kmmrseckjctb4gxcx2rdminrjnq2b4ipf7562nvfd432ld5v5m@2byj5eedkb2o/

Cc: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Michal Koutný <mkoutny@suse.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20250505121201.879823-1-mkoutny@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/kernfs/dir.c  | 5 +++--
 fs/kernfs/file.c | 3 ++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index b068ed32d7b32..f6e2a4523f7e6 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -1560,8 +1560,9 @@ void kernfs_break_active_protection(struct kernfs_node *kn)
  * invoked before finishing the kernfs operation.  Note that while this
  * function restores the active reference, it doesn't and can't actually
  * restore the active protection - @kn may already or be in the process of
- * being removed.  Once kernfs_break_active_protection() is invoked, that
- * protection is irreversibly gone for the kernfs operation instance.
+ * being drained and removed.  Once kernfs_break_active_protection() is
+ * invoked, that protection is irreversibly gone for the kernfs operation
+ * instance.
  *
  * While this function may be called at any point after
  * kernfs_break_active_protection() is invoked, its most useful location
diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index 332d08d2fe0d5..6b90fea6cca20 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -820,8 +820,9 @@ bool kernfs_should_drain_open_files(struct kernfs_node *kn)
 	/*
 	 * @kn being deactivated guarantees that @kn->attr.open can't change
 	 * beneath us making the lockless test below safe.
+	 * Callers post kernfs_unbreak_active_protection may be counted in
+	 * kn->active by now, do not WARN_ON because of them.
 	 */
-	WARN_ON_ONCE(atomic_read(&kn->active) != KN_DEACTIVATED_BIAS);
 
 	rcu_read_lock();
 	on = rcu_dereference(kn->attr.open);
-- 
2.39.5



