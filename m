Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036B71A257D;
	Wed, 23 Apr 2025 15:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421236; cv=none; b=SshBfVkCm+df6TSkSmI+l/8Y+m/eMAZKTWU9RRHEuyUkis4jgSPDDHp/SIm91x9/lnrBu9u2gNIdr4Kt7aLHOFHBRIc3Y7HGZCkyLHM52+6qdwq7WPQzoAf8Pm8byZpCWd95m7WwNkfWnB0S/jnb1yCS/JqG2hr9rkfJ+rMucME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421236; c=relaxed/simple;
	bh=5f2w5gUMekhI/iQ4U8c5UuWW2A/b1gxFbcNmPG+mEcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SnvGfNDRC1sxrcS2iXDa8ouTKT9zW92lLA7KYduv5A/DRhpmP2Mf8zNAJKd1LCZvWmZlATta4SNITXklJ0QOwHdPKec6YS4b/HaVSmtlms9ThDrBy/JQRi4lanF62aMzKfozoHOjHAE4v9C8ACwGAm7nUH8vUvRcjghVOT9SiYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zZ0cPS1h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zZ0cPS1h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF1EC4CEE3;
	Wed, 23 Apr 2025 15:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421235;
	bh=5f2w5gUMekhI/iQ4U8c5UuWW2A/b1gxFbcNmPG+mEcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zZ0cPS1hhFsWaRMdokOcxq/cIsYsfmqINyAyf0ROdY+jgKEA9kwpV6FnHoCskU+xz
	 3sFnnZrYAkYY+cxBUshlXNECKzpGlpd7TakS1VEav5EgjmoJc+lwh37rO5JvXdNReR
	 VYA5Jh0Unn6dhC8SIlFtcJyxcU7Fkb2TFFMMiHv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.1 119/291] jbd2: remove wrong sb->s_sequence check
Date: Wed, 23 Apr 2025 16:41:48 +0200
Message-ID: <20250423142629.263063274@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1711,7 +1711,6 @@ int jbd2_journal_update_sb_log_tail(jour
 
 	/* Log is no longer empty */
 	write_lock(&journal->j_state_lock);
-	WARN_ON(!sb->s_sequence);
 	journal->j_flags &= ~JBD2_FLUSHED;
 	write_unlock(&journal->j_state_lock);
 


