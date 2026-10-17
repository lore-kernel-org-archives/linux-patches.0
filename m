Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357E04CF477;
	Sat, 17 Oct 2026 15:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792252496; cv=none; b=MCj0Kg/+5PMyprdj352HnTkLvFPjyLgZDJgGijJeFEkXGy7oxyBJgrO1d1kQ/v7nN9YdlOFvqSmi8SSnkULDINJhMHt5hxIbsp6KbI7rS/AdqwpVgMPwHwFcO2kiRXL+0GVIZbFvxMjqSoOLgfo1DABmKPdXf5SBZwLe2PoAS5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792252496; c=relaxed/simple;
	bh=ZCiB6RmG1g34TqiUr59cLrQPpqipS91OIUEHvheUN0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qYhLuHqHMkX4M8Krnu/T4UL/qHwWFL5lIGDcNu+T27YfG91Xzv6DUUzBPYbk47nLEa4NQBv4WkW+GldZK4I1XGinnly2D35x1r0Wqdpwleeh4trFGDfF9wLHcqNMVBjC7CSsOhCPzZ/AT5ON/eWowJ0VuI1xn0v2zIu6kHywREU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l718hWKJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l718hWKJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CBA91F000C4;
	Sat, 17 Oct 2026 15:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792252495;
	bh=QSYbHVlIKHYfKbawbdXosrjtSo7siuMwkqnEs7PMozU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l718hWKJEvSgEWfbUTtEo5mzVtYwvOVlcfjR/IBoAtb//wpJuyIix03f5hLX9EgxW
	 FNzmWOi52XxqOlvVhP2LSqE60Ex2eiNu/XmJyD1X3KDZsLhdGy3Lfecc/iSJVtjV1i
	 pslFMw35+ANLWpAV8gyqjP0NdLzKIqyYPqP/SgxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 02/10] dm-integrity: fix NULL pointer dereference when the R flag is used
Date: Sat, 17 Oct 2026 17:54:31 +0200
Message-ID: <20261017155059.792072896@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017155059.698368299@linuxfoundation.org>
References: <20261017155059.698368299@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 7d4d4f3b668d708d94f62ecdd33ac330a6fd8a84 ]

If the dm-integrity device has the SB_FLAG_DIRTY_BITMAP flag set and the
user activates the device in the 'R' mode, a crash in dm_integrity_resume
happens because the function attempts to read the journal containing the
bitmap.

This patch makes dm-integrity skip any writes to the device in
dm_integrity_resume if the device is activated in the 'R' mode.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: 468dfca38b1a ("dm integrity: add a bitmap mode")
Cc: stable@vger.kernel.org
Stable-dep-of: fc79aeb86a2c ("dm-integrity: validate the superblock on resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-integrity.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 4bda7b5dba1a6..cded0607b39c0 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3874,6 +3874,10 @@ static void dm_integrity_resume(struct dm_target *ti)
 	r = sync_rw_sb(ic, REQ_OP_READ);
 	if (r)
 		dm_integrity_io_error(ic, "reading superblock", r);
+
+	if (ic->mode == 'R')
+		goto skip_writes;
+
 	if ((ic->sb->flags & flags) != flags) {
 		ic->sb->flags |= flags;
 		r = sync_rw_sb(ic, REQ_OP_WRITE | REQ_FUA);
@@ -3983,6 +3987,7 @@ static void dm_integrity_resume(struct dm_target *ti)
 		}
 	}
 
+skip_writes:
 	ic->reboot_notifier.notifier_call = dm_integrity_reboot;
 	ic->reboot_notifier.next = NULL;
 	ic->reboot_notifier.priority = INT_MAX - 1;	/* be notified after md and before hardware drivers */
-- 
2.53.0



