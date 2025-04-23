Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D6229B777;
	Wed, 23 Apr 2025 15:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421330; cv=none; b=LDm/LCCKk+VIfOzRUGdyCulW5akliMaggqqVYo0SXtYmA5yjxrh06sBLBkY++G6vthq3Xt1GQT3nJjPZT6URpWfF6G0XuBTjHI3NLKMXth1sXX9YviHfLdFCb4g/fAxIDuVNK6qWgY9A25Sslq6k3c+P37ienGgIwa7pC6F3NxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421330; c=relaxed/simple;
	bh=ZycrAIXJbonIow5Gn7luah27irPyfoz0Ye4edHjE5t0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZhxfM9nU3W5PBKDng2qlClyjJwcaHxcjwksX1Idlb6STBuRCXx3YWU7l+yP7n0rdEqjH9z98KKf7jAze+sHZz2kWWVKXdqtAWYZIqgLf6e+iZy+aaycuT/AH1VMl3uvh9W/35iM9kKvLup/NMmRlc+FmR5BZRcM5L6L6Liat6J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E8ma+bvr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E8ma+bvr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D90BC4CEE8;
	Wed, 23 Apr 2025 15:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421330;
	bh=ZycrAIXJbonIow5Gn7luah27irPyfoz0Ye4edHjE5t0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E8ma+bvruRaWQzKMXA2QS7Ru2N19JUMrLfuz3NclqsotlH1kVP3KJt+kxrUpYf97Y
	 gCZ3q5U8nlmnyt5RY5f6BjjDI84i84vQxXk1Fe1jjZJUDoktGbz3gbPQvTe3LSW9a6
	 QmET66X3IW+0aJaDSJ1/psd9KijzhqER2c4gLZ/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.6 169/393] jbd2: remove wrong sb->s_sequence check
Date: Wed, 23 Apr 2025 16:41:05 +0200
Message-ID: <20250423142650.349224567@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit e6eff39dd0fe4190c6146069cc16d160e71d1148 upstream.

Journal emptiness is not determined by sb->s_sequence == 0 but rather by
sb->s_start == 0 (which is set a few lines above). Furthermore 0 is a
valid transaction ID so the check can spuriously trigger. Remove the
invalid WARN_ON.

CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://patch.msgid.link/20250206094657.20865-3-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jbd2/journal.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1914,7 +1914,6 @@ int jbd2_journal_update_sb_log_tail(jour
 
 	/* Log is no longer empty */
 	write_lock(&journal->j_state_lock);
-	WARN_ON(!sb->s_sequence);
 	journal->j_flags &= ~JBD2_FLUSHED;
 	write_unlock(&journal->j_state_lock);
 


