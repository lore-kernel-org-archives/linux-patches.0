Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24958229B05;
	Tue, 29 Apr 2025 16:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945373; cv=none; b=oTN/QpAvZjZb5m2stWo+Hu18DK84TFDUxwwFz1KllX+oqWmGJe9pq3uB1/L4EKVyAMQZy1mRuRZqWYRBsUgAbbMiqwbkJxxM9nF9VMZXbTaBLjNJlFzCBSCcSUcnIoeUot6R+W6TenGJkkuUgZcQTluPH9B5vEtMfiThet15N54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945373; c=relaxed/simple;
	bh=z8YdibSUPUHtPHnwnFu+RGHakG7F3QomdQcl+BD7Ck0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0hBT7mfy6YWk6S9zV2R7gAX3uWUFy/d5xj5wDChWPopGeh4LrLPR4anHkH4HqMqpkqu8T5mTfDySSAn4Ml5KRNS8rYWsQKYKu+fYNrVQaaO5/vi1g/d+cSYvaDp4ixRLSjfTc1PXTWK4vwSKOywcR2h0DH+/7fdatzHJQV0g6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Epokhugg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Epokhugg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F50C4CEE9;
	Tue, 29 Apr 2025 16:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945372;
	bh=z8YdibSUPUHtPHnwnFu+RGHakG7F3QomdQcl+BD7Ck0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EpokhuggkRz6UruTz8VurniFN4u+pNCchhHt26oRtF4MncyDACzS32yHlrUBVDMmn
	 DAi/KgQ8IvGmIviYd3T4TXY/4LDxQNPAY1sWZXoXqh7OcmhBRmdP5AcicZJhDaqCiG
	 yk9Kpsma2tpo/hD1xfSZ4LEf9zOxPnRgsUo6FJlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.4 060/179] jbd2: remove wrong sb->s_sequence check
Date: Tue, 29 Apr 2025 18:40:01 +0200
Message-ID: <20250429161051.833485690@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1432,7 +1432,6 @@ int jbd2_journal_update_sb_log_tail(jour
 
 	/* Log is no longer empty */
 	write_lock(&journal->j_state_lock);
-	WARN_ON(!sb->s_sequence);
 	journal->j_flags &= ~JBD2_FLUSHED;
 	write_unlock(&journal->j_state_lock);
 


