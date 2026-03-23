Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ACA1277C88;
	Mon, 23 Mar 2026 15:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278708; cv=none; b=JjM8OCsyvJvdnlJsWECGc01EK7A+orLY4F8vUfr3Q1ly90tIdwWbwQ8Q81CzBXrev4dgCsVqisUmlKbNfjpCMJdLSzRyX/4piAO2kBZ3jbTXaG0F7SehfxZC4FEMjuS6czjGeOtj82PsswPrR45ohCD9kZav2xRqP4bwFvRbWBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278708; c=relaxed/simple;
	bh=NEk/RfKbSybFBvOCuaCj4tlCkg0AoE5pEBOu5u1PWVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uV3NKrngXiJB6m2eIMFXmevLVnOqF5qTnECLXTAKZY0v/e/GkBol27esjoWJm0hmCpanf5RIhB95+Y9WTW7Vz9QJXxZAMGdqSZFkcNonuhtfLdAMO7w663sPs+mljfKcNjEMd3JRwdwh9LVO+6pLlabEDUyQNeB2UUQo2XbzB3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dy13oPq6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dy13oPq6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDADDC4CEF7;
	Mon, 23 Mar 2026 15:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278708;
	bh=NEk/RfKbSybFBvOCuaCj4tlCkg0AoE5pEBOu5u1PWVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dy13oPq62clcMMsjejghsAQ5Q6TIyidoOhQk8k3CCRpUdggt6al/HmvgoKovADUn9
	 N3yrrB7YkiYD4CPob9ywVZt58wfVty5nMlFeVj0WGJ9ytaDTAle3jEeo3H7qeiYOhn
	 vedGC5c+qvcW3UynDb3pxA1qsBScj0L9oS5OHa7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <leo.lilong@huawei.com>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 394/567] xfs: ensure dquot item is deleted from AIL only after log shutdown
Date: Mon, 23 Mar 2026 14:45:14 +0100
Message-ID: <20260323134543.606483905@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Long Li <leo.lilong@huawei.com>

[ Upstream commit 186ac39b8a7d3ec7ce9c5dd45e5c2730177f375c ]

In xfs_qm_dqflush(), when a dquot flush fails due to corruption
(the out_abort error path), the original code removed the dquot log
item from the AIL before calling xfs_force_shutdown(). This ordering
introduces a subtle race condition that can lead to data loss after
a crash.

The AIL tracks the oldest dirty metadata in the journal. The position
of the tail item in the AIL determines the log tail LSN, which is the
oldest LSN that must be preserved for crash recovery. When an item is
removed from the AIL, the log tail can advance past the LSN of that item.

The race window is as follows: if the dquot item happens to be at
the tail of the log, removing it from the AIL allows the log tail
to advance. If a concurrent log write is sampling the tail LSN at
the same time and subsequently writes a complete checkpoint (i.e.,
one containing a commit record) to disk before the shutdown takes
effect, the journal will no longer protect the dquot's last
modification. On the next mount, log recovery will not replay the
dquot changes, even though they were never written back to disk,
resulting in silent data loss.

Fix this by calling xfs_force_shutdown() before xfs_trans_ail_delete()
in the out_abort path. Once the log is shut down, no new log writes
can complete with an updated tail LSN, making it safe to remove the
dquot item from the AIL.

Cc: stable@vger.kernel.org
Fixes: b707fffda6a3 ("xfs: abort consistently on dquot flush failure")
Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ adapted error path to preserve existing out_unlock label between xfs_trans_ail_delete and xfs_dqfunlock ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_dquot.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1297,9 +1297,15 @@ xfs_qm_dqflush(
 	return 0;
 
 out_abort:
+	/*
+	 * Shut down the log before removing the dquot item from the AIL.
+	 * Otherwise, the log tail may advance past this item's LSN while
+	 * log writes are still in progress, making these unflushed changes
+	 * unrecoverable on the next mount.
+	 */
+	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 	dqp->q_flags &= ~XFS_DQFLAG_DIRTY;
 	xfs_trans_ail_delete(lip, 0);
-	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 out_unlock:
 	xfs_dqfunlock(dqp);
 	return error;


