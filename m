Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF89265630;
	Tue,  8 Apr 2025 11:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110527; cv=none; b=cdlcKA8G4n0Yc5aBG0lIjUaK+XSkHc6SuEstsVOvvH73h7Gtr+QREpsGnZIjZgVVhBtFjxpmqCmM9imdaJp3pg+Rb24FRODvxAuf4NUZUodww+/u4mlTrf1PCyaRAKzeC9WCSKgJ5+mg02F3XEFJxImiQbavXKiaTzUiwzpAazI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110527; c=relaxed/simple;
	bh=zypb4TLNtSBOwKK3aDnIvqKOj0jUfdLocz3lKlW55xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BH5Ub8hcjvj2usDjA6meqOsJ96fg814G2eoxQFuAdqJvV8F1ObdPNE4AKBQbdIhj9zJi0a0iNV3qqvno/yJLsRDQGB6AkDSznKiTAJAE9r/WyFrbrhe0sYAMx4XSMe90P82RzzuBPtWe1c4aYeiZIYjC3UgW43nh0nGT2AIyaXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tbJ2/o2B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tbJ2/o2B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E6DEC4CEE7;
	Tue,  8 Apr 2025 11:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110527;
	bh=zypb4TLNtSBOwKK3aDnIvqKOj0jUfdLocz3lKlW55xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tbJ2/o2B7fyJeU+hT9RXxPcSIGk5fDKZlQk7A+QdJtbsPho1oDHyGogKLZBEJUWc9
	 sbmxE9n3Dbh+6kZxgO008WrvuGP83rCmtmJgfw9MffELYNeAeVNNCUu3cEGTXZ5onx
	 S4vvv1AjZ0DkFPPRG3jwcYo0y90t8RD0t7ssJyEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Max Kellermann <max.kellermann@ionos.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 098/731] io_uring/io-wq: do not use bogus hash value
Date: Tue,  8 Apr 2025 12:39:55 +0200
Message-ID: <20250408104916.548890143@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Kellermann <max.kellermann@ionos.com>

[ Upstream commit 486ba4d84d62e92716cd395c4b1612b8ce70a257 ]

Previously, the `hash` variable was initialized with `-1` and only
updated by io_get_next_work() if the current work was hashed.  Commit
60cf46ae6054 ("io-wq: hash dependent work") changed this to always
call io_get_work_hash() even if the work was not hashed.  This caused
the `hash != -1U` check to always be true, adding some overhead for
the `hash->wait` code.

This patch fixes the regression by checking the `IO_WQ_WORK_HASHED`
flag.

Perf diff for a flood of `IORING_OP_NOP` with `IOSQE_ASYNC`:

    38.55%     -1.57%  [kernel.kallsyms]  [k] queued_spin_lock_slowpath
     6.86%     -0.72%  [kernel.kallsyms]  [k] io_worker_handle_work
     0.10%     +0.67%  [kernel.kallsyms]  [k] put_prev_entity
     1.96%     +0.59%  [kernel.kallsyms]  [k] io_nop_prep
     3.31%     -0.51%  [kernel.kallsyms]  [k] try_to_wake_up
     7.18%     -0.47%  [kernel.kallsyms]  [k] io_wq_free_work

Fixes: 60cf46ae6054 ("io-wq: hash dependent work")
Cc: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Link: https://lore.kernel.org/r/20250128133927.3989681-6-max.kellermann@ionos.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io-wq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index d1eaa3e39cd5f..24f06fba43096 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -599,7 +599,9 @@ static void io_worker_handle_work(struct io_wq_acct *acct,
 		do {
 			struct io_wq_work *next_hashed, *linked;
 			unsigned int work_flags = atomic_read(&work->flags);
-			unsigned int hash = __io_get_work_hash(work_flags);
+			unsigned int hash = __io_wq_is_hashed(work_flags)
+				? __io_get_work_hash(work_flags)
+				: -1U;
 
 			next_hashed = wq_next_work(work);
 
-- 
2.39.5



