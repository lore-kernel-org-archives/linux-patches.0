Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CA725DD1D;
	Thu, 17 Apr 2025 18:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915888; cv=none; b=DKsVK/xdsMumIwFWibDd4F4+gD4Fi/TPGyoinnx6kshbRzScWJBWbFxb9Sjkpm4SyKZnR29cABztCHGxjuy3ZfO/dSjQFcuqbinXG9PRLiknmfp4Cg2zf0anT0oiEBGy24Q5yf/Y2wKXcACA5r6m/JvHcFIPLMbc5AWLXxK9COo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915888; c=relaxed/simple;
	bh=40R91eJPNG2rYXEjGxOikQIrtu775ciTPAPztX4VerU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PNazmkmvzv61GGrcKaFt+iqS5x19SUwtL9vVU61DtLnLY7rSbMVbVsRSvXEtGhrb2/SCvzIpIz5Gkw1fHA+7S6a272NppsDZLZwMI3rhU41yFADgxCyjdfdyjZf/0sUuh7DfuyOIjbiIKfhJoseoMk2m3rabmCY+AHO1vLWc3Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hZXueYYY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hZXueYYY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F840C4CEE4;
	Thu, 17 Apr 2025 18:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915887;
	bh=40R91eJPNG2rYXEjGxOikQIrtu775ciTPAPztX4VerU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hZXueYYYGCYTvdV+nQCrMmJ+P6UcNZbww5LYJ4Kb0T4dJXElKV4SeNgJwizKmXScD
	 OsknHdAert4YqtQLVZvpeod4sGmZU2VtU3ri9Kym9sTqW/7WxcBWu1HJpV86P4ROHG
	 owLZClDyEzrHNnaSmF10ESyXUh8OWDnrxwS8FPYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.12 272/393] jbd2: remove wrong sb->s_sequence check
Date: Thu, 17 Apr 2025 19:51:21 +0200
Message-ID: <20250417175118.545353671@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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
@@ -1884,7 +1884,6 @@ int jbd2_journal_update_sb_log_tail(jour
 
 	/* Log is no longer empty */
 	write_lock(&journal->j_state_lock);
-	WARN_ON(!sb->s_sequence);
 	journal->j_flags &= ~JBD2_FLUSHED;
 	write_unlock(&journal->j_state_lock);
 


