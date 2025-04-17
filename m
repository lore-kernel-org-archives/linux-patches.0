Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026CE18C034;
	Thu, 17 Apr 2025 18:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913382; cv=none; b=pCizqp+LMeYmMDvMLSN3Mb32gEFrH9NY7EGtT+Q8DNOfQYImSKKPOGOvTRUwKhFlE9xVlgxlyWVLxFzJjQH7fK9repXNHKEzegzrnt3iChuV969OI1D1FpRHIjwXqVFuU/67np6ROQXz1p4VslaVD/LhWrC/LToR9If6CArT7ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913382; c=relaxed/simple;
	bh=2+RWFI0nDeZdSts0VrUaV9sOZkXSB0PbXwlHwyZCFxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F6ynQ+BhAo9yppZ6+64PydwckmdDERPGSZBvdZAL4sjATN6xFzJXLXOFcAKI3Sx57B/0M1fRv0KCkSpGq6T7TZvx8KDbTMNbNdeedTZJSu6Wm1ouDRPgFcHY4vc9lzhraY3tZmuzeQljHA+zgWzEAVREFiJZbHhyhaCCa545NdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YIF3QOiz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YIF3QOiz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DAD7C4CEE4;
	Thu, 17 Apr 2025 18:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913381;
	bh=2+RWFI0nDeZdSts0VrUaV9sOZkXSB0PbXwlHwyZCFxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YIF3QOizH56yrWLcUutMuK/G+zFquG9okt2XDjouyluX6rq5/yQM7eqpfiHHpqQMI
	 2KkdPjhUlN2KSHJGvuXbSk3hjJsQ3Umq+N/Rrlg95Vrt9lHMg2SF+ShJyjpLXoA8nA
	 JP3STT7MXV6DPOKYwiTODM+Hy4xq/c43JeGHJnSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.14 320/449] jbd2: remove wrong sb->s_sequence check
Date: Thu, 17 Apr 2025 19:50:08 +0200
Message-ID: <20250417175131.001707011@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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
@@ -1879,7 +1879,6 @@ int jbd2_journal_update_sb_log_tail(jour
 
 	/* Log is no longer empty */
 	write_lock(&journal->j_state_lock);
-	WARN_ON(!sb->s_sequence);
 	journal->j_flags &= ~JBD2_FLUSHED;
 	write_unlock(&journal->j_state_lock);
 


