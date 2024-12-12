Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279FA205ACF;
	Thu, 12 Dec 2024 15:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017186; cv=none; b=FTouuywujvsF+Qa02w/o4IRk6B0lH7BBVGCdJq8+GdOwrWA/Gl/OnZ80txfynM3/51kLiD1Jf7yOCBb/P3h4iAds05NoUYpsQlAPtdllUxd28Q4M9GUh2N6eO1GCXkuaJFSCPcjsoYIVtx97+Nbf1EFYge1j5SFen4gjhdUIua8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017186; c=relaxed/simple;
	bh=98fLkRc5syxwqOavCuCxV4JRusyxhireMu190o4xs3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tKuWorhpoVTVq/Dn8U6sEFz3kN9dZPCMhG9RxuHc7dC310Bu6YNOkGFG4khwFoMszlaSpyInBIIahnJqn8DVUIE/E/PVQi3Zm879uZY2EVoyHdabfwo+f5oWEhZrovuQHqa/Ocrf6P+bnQsn/Sqjcl1rqKI1yFHffIKnYjNJpW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OcPqmIZN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OcPqmIZN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE78C4CECE;
	Thu, 12 Dec 2024 15:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017186;
	bh=98fLkRc5syxwqOavCuCxV4JRusyxhireMu190o4xs3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OcPqmIZN0kKe1tJVK38fiq5YMA6Wf7WF1FgLUz9Q16s8ks/3RiT6GuuBNftz6lm2a
	 PBYdw2Pz7GTZ5gjDGpg42HbdYqR3vrpaFGmESTVuCC4/JW6eEvh8iTgWlrYl0Q/2Ey
	 y840XjK3ZlwbaLsS+PIl2W3DCKck8KMWmv6XH6Fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7f3761b790fa41d0f3d5@syzkaller.appspotmail.com,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 407/466] fs/ntfs3: Fix case when unmarked clusters intersect with zone
Date: Thu, 12 Dec 2024 15:59:36 +0100
Message-ID: <20241212144322.832684911@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 5fc982fe7eca9d0cf7b25832450ebd4f7c8e1c36 ]

Reported-by: syzbot+7f3761b790fa41d0f3d5@syzkaller.appspotmail.com
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/run.c | 40 ++++++++++++++++++++++++++++++----------
 1 file changed, 30 insertions(+), 10 deletions(-)

diff --git a/fs/ntfs3/run.c b/fs/ntfs3/run.c
index 58e988cd80490..48566dff0dc92 100644
--- a/fs/ntfs3/run.c
+++ b/fs/ntfs3/run.c
@@ -1055,8 +1055,8 @@ int run_unpack_ex(struct runs_tree *run, struct ntfs_sb_info *sbi, CLST ino,
 {
 	int ret, err;
 	CLST next_vcn, lcn, len;
-	size_t index;
-	bool ok;
+	size_t index, done;
+	bool ok, zone;
 	struct wnd_bitmap *wnd;
 
 	ret = run_unpack(run, sbi, ino, svcn, evcn, vcn, run_buf, run_buf_size);
@@ -1087,8 +1087,9 @@ int run_unpack_ex(struct runs_tree *run, struct ntfs_sb_info *sbi, CLST ino,
 			continue;
 
 		down_read_nested(&wnd->rw_lock, BITMAP_MUTEX_CLUSTERS);
+		zone = max(wnd->zone_bit, lcn) < min(wnd->zone_end, lcn + len);
 		/* Check for free blocks. */
-		ok = wnd_is_used(wnd, lcn, len);
+		ok = !zone && wnd_is_used(wnd, lcn, len);
 		up_read(&wnd->rw_lock);
 		if (ok)
 			continue;
@@ -1096,14 +1097,33 @@ int run_unpack_ex(struct runs_tree *run, struct ntfs_sb_info *sbi, CLST ino,
 		/* Looks like volume is corrupted. */
 		ntfs_set_state(sbi, NTFS_DIRTY_ERROR);
 
-		if (down_write_trylock(&wnd->rw_lock)) {
-			/* Mark all zero bits as used in range [lcn, lcn+len). */
-			size_t done;
-			err = wnd_set_used_safe(wnd, lcn, len, &done);
-			up_write(&wnd->rw_lock);
-			if (err)
-				return err;
+		if (!down_write_trylock(&wnd->rw_lock))
+			continue;
+
+		if (zone) {
+			/*
+			 * Range [lcn, lcn + len) intersects with zone.
+			 * To avoid complex with zone just turn it off.
+			 */
+			wnd_zone_set(wnd, 0, 0);
+		}
+
+		/* Mark all zero bits as used in range [lcn, lcn+len). */
+		err = wnd_set_used_safe(wnd, lcn, len, &done);
+		if (zone) {
+			/* Restore zone. Lock mft run. */
+			struct rw_semaphore *lock;
+			lock = is_mounted(sbi) ? &sbi->mft.ni->file.run_lock :
+						 NULL;
+			if (lock)
+				down_read(lock);
+			ntfs_refresh_zone(sbi);
+			if (lock)
+				up_read(lock);
 		}
+		up_write(&wnd->rw_lock);
+		if (err)
+			return err;
 	}
 
 	return ret;
-- 
2.43.0



