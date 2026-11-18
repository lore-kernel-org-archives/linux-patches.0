Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045702;
	b=EYsDkOuX1xpcZayOBbcxKQyYBNBLkjolKTkv64f5QU6s1N7Ly3G+DnuqXEKPD9+PfNbc
	 sgcVe15ZGrW6ZzFY7ag3ABJ9vHue57MVp5kv4ZqAVKphK4gW0mau1vuOXwY5B92yhr4Y6
	 0L4Fan4XviXiFO/GZi32u3uu4L//us7k+40xxcUg8/8E+z5Je81rCFdBxd8t4fhE5EneC
	 Cy65NSeP/SYHwIWbOE8Rk1nTi7twGM94Pd7fbw898tJi/Dtla22Y0SCLYapRLSclDDQ8w
	 uWV/+dlLbk72vpDuAhPEop1sh8ne4Vi0Z8zS/zpfckesf3ImsR1H3FhyXgk/fhnGSrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045702;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2H6Bf/EIGkpFSDCep6DUkWCReFQYTyrP35LwfrtACxg=;
	b=K/oymawcUp0SLpZbg3lMzwzP8A1BLP1GKQOC5Er8BzHx48aW4pVrTe1w8pj0aS+N3Vid
	 XeJb8ugExat2CE1sOHn4ouLplCWgOXeHDXl3P2kKxHC2ThOsXIhE13DvB0L/iGw156TUn
	 2obw2nM7cOk0C8qOCrlMGaFC1p1yUjwCH6UIYpDHziXurZ55RxK6XtgioMjExMYJ+89LE
	 fMwgFapEdrlEyTelzTSXRu/Rt+6OkWUUWAeq12qKK7gjN58k7hvOm7rJ8xoljliYrr7SS
	 R0r8YkyzgsLaJPwrGYui5INqqFN6HAXKp31Og1DPta8PWU49ZM19HFswhxRH7OlkXpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cYeh5GlM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9896060A2602;
	Wed, 18 Nov 2026 23:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cYeh5GlM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A311F000C5;
	Wed, 18 Nov 2026 23:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045702;
	bh=2H6Bf/EIGkpFSDCep6DUkWCReFQYTyrP35LwfrtACxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cYeh5GlMi3dbj4ynkHCe5y9EfxV68mzhJwIROtfouWtVueesWzILoWsWlGXuUod3I
	 x/MPZTwtyySsQBJ80x4hW8ZJZNuarughGmyLc2unB6kiHAbdktZuLzvXW4PxkPdaJF
	 kp7qxGGmkHxZGRodGE6lQrZEhfskhDja/pKVbhXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Sun <sunjunchao@bytedance.com>,
	Tejun Heo <tj@kernel.org>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1017/2857] writeback: reset dirtied_when when switching wbs
Date: Wed, 18 Nov 2026 15:34:11 +0100
Message-ID: <20261118150238.216553869@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Sun <sunjunchao@bytedance.com>

[ Upstream commit 13b9a606dd0a6cf9bac12894c97b9546d22a7425 ]

When switching a dirty inode to another wb, inode_do_switch_wbs() puts
it at the newest end of the target b_dirty list instead of searching
for its sorted position. This requires updating dirtied_when, which
move_expired_inodes() uses to decide where to stop scanning.

However, the switch updates dirtied_time_when instead. This leaves
b_dirty out of order and can make the scan stop before reaching older
inodes. It also resets the lazytime expiration timestamp, potentially
delaying timestamp writeback.

Update dirtied_when instead, preserving both the constant-time insertion
and the lazytime expiration timestamp. Correct the field name in the
comment and document the distinction between the two inode timestamps.

Fixes: 9a6ebbdbd412 ("writeback: Avoid excessively long inode switching times")
Cc: stable@vger.kernel.org
Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
Link: https://patch.msgid.link/20261016115230.3640770-2-sunjunchao@bytedance.com
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fs-writeback.c  | 6 +++---
 include/linux/fs.h | 4 +++-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 085e0fa0cab37..7066cc78879e7 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -429,12 +429,12 @@ static bool inode_do_switch_wbs(struct inode *inode,
 		if (inode->i_state & I_DIRTY_ALL) {
 			/*
 			 * We need to keep b_dirty list sorted by
-			 * dirtied_time_when. However properly sorting the
+			 * dirtied_when. However properly sorting the
 			 * inode in the list gets too expensive when switching
 			 * many inodes. So just attach inode at the end of the
-			 * dirty list and clobber the dirtied_time_when.
+			 * dirty list and clobber the dirtied_when.
 			 */
-			inode->dirtied_time_when = jiffies;
+			inode->dirtied_when = jiffies;
 			inode_io_list_move_locked(inode, new_wb,
 						  &new_wb->b_dirty);
 		} else {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0692c2e0fcf3f..7e8d570ed839b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -650,7 +650,9 @@ struct inode {
 	unsigned long		i_state;
 	struct rw_semaphore	i_rwsem;
 
-	unsigned long		dirtied_when;	/* jiffies of first dirtying */
+	/* Timestamp for writeback list ordering and age checks (jiffies). */
+	unsigned long		dirtied_when;
+	/* Start time for deciding when lazytime updates need writeback (jiffies). */
 	unsigned long		dirtied_time_when;
 
 	struct hlist_node	i_hash;
-- 
2.53.0



