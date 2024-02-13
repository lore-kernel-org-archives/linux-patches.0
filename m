Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625C2A93C;
	Tue, 13 Feb 2024 17:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845992; cv=none; b=NOYb/agLM+G/XBG4PQq9UozctruD02BL67B9X+/s8hZINZHngd3/A+s+Yu/fvoR0e18tov71i/9zDU/3IAu/zGr2N9Q3btPnAH11GERBJn0KNACPN5rEDUVrsnAPZq6x8s4mSAxcF4iTi/vMwrKWpqE4NPWm1w3VIYi6Z/VGAFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845992; c=relaxed/simple;
	bh=klCTKgQ3Do5bVcicaF1oiMdjWK+pBkr9j+GKoZrErf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmOUSS9QveYhaGqwEnJMEuEZye97Ws9fb1iNKa5MiNhnMhKRt1z0gggJQcaFxy+NIFv0r5MjmwNVQIuq7NDHSspnS+AtDSrETW7WMPTde42ZsDb5gh9bye1upmk5KFmEhyhjTIiihW3Yi5yFm7onqpq5jneL7mEPuRjXfwmBkbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Slen0SQz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Slen0SQz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB301C433F1;
	Tue, 13 Feb 2024 17:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845992;
	bh=klCTKgQ3Do5bVcicaF1oiMdjWK+pBkr9j+GKoZrErf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Slen0SQz417C0O/GDro4cu4gwf6s+BwjuSUReBCd5+RSRDz/ASKxW1XIiEG4uF2ZW
	 sXNX6EoTzgWQNSXaqWjaxQswo06HyWNOwobFZOKBeuYl11ilGZ8DvrBNPyzfhckwFf
	 PD/Sm5QHcuijG5qW5k8ou5rjifeKwYZNuTMg+biE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Hill <daniel@gluo.nz>,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 6.7 113/124] bcachefs: rebalance should wakeup on shutdown if disabled
Date: Tue, 13 Feb 2024 18:22:15 +0100
Message-ID: <20240213171857.031386175@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Hill <daniel@gluo.nz>

commit 0c069781ddfa4e31c169a8eced1ee90b8929d522 upstream.

Signed-off-by: Daniel Hill <daniel@gluo.nz>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/bcachefs/move.c      |    2 +-
 fs/bcachefs/move.h      |    1 +
 fs/bcachefs/rebalance.c |   12 ++++++++++--
 3 files changed, 12 insertions(+), 3 deletions(-)

--- a/fs/bcachefs/move.c
+++ b/fs/bcachefs/move.c
@@ -152,7 +152,7 @@ void bch2_move_ctxt_wait_for_io(struct m
 		atomic_read(&ctxt->write_sectors) != sectors_pending);
 }
 
-static void bch2_moving_ctxt_flush_all(struct moving_context *ctxt)
+void bch2_moving_ctxt_flush_all(struct moving_context *ctxt)
 {
 	move_ctxt_wait_event(ctxt, list_empty(&ctxt->reads));
 	bch2_trans_unlock_long(ctxt->trans);
--- a/fs/bcachefs/move.h
+++ b/fs/bcachefs/move.h
@@ -81,6 +81,7 @@ void bch2_moving_ctxt_init(struct moving
 			   struct write_point_specifier, bool);
 struct moving_io *bch2_moving_ctxt_next_pending_write(struct moving_context *);
 void bch2_moving_ctxt_do_pending_writes(struct moving_context *);
+void bch2_moving_ctxt_flush_all(struct moving_context *);
 void bch2_move_ctxt_wait_for_io(struct moving_context *);
 int bch2_move_ratelimit(struct moving_context *);
 
--- a/fs/bcachefs/rebalance.c
+++ b/fs/bcachefs/rebalance.c
@@ -317,8 +317,16 @@ static int do_rebalance(struct moving_co
 			     BTREE_ID_rebalance_work, POS_MIN,
 			     BTREE_ITER_ALL_SNAPSHOTS);
 
-	while (!bch2_move_ratelimit(ctxt) &&
-	       !kthread_wait_freezable(r->enabled)) {
+	while (!bch2_move_ratelimit(ctxt)) {
+		if (!r->enabled) {
+			bch2_moving_ctxt_flush_all(ctxt);
+			kthread_wait_freezable(r->enabled ||
+					       kthread_should_stop());
+		}
+
+		if (kthread_should_stop())
+			break;
+
 		bch2_trans_begin(trans);
 
 		ret = bkey_err(k = next_rebalance_entry(trans, &rebalance_work_iter));


