Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785133ADB9A;
	Tue, 12 May 2026 17:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608006; cv=none; b=X4r7+oul1ssDpuTAGccVl8RcpCMiWMFlCJJJ5eJN67SBXPEJvfncMooBLJ0Yo5CT6sDw9RBs9d1FDI2TTzsBY+KTA/wBNYs6m9JmNaYh2UhCxNsW/UX7I4vchpWPPlqAl1hMqnSsTleezx+Z5ZunElJtzCKK4AtZXXFBa/4nezg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608006; c=relaxed/simple;
	bh=ssAPdPpHdQUCahK1la6sdGtANO6rOj7bi5Bizfkgnto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hBqvlaUSx3JFiOpHJ4RLGGuFQA+Em1PGEvsgoXB/SWFg1PPw0ukrgCUdAyfb/cU2Ar0hY/zvnulkPniM2xUj0a2/dJaJI0o60dbScYW3jJ8x8UnVXzxe+YJSBUtWOB8H74cgQv6qOgxaXfMYuVFArmUJ1MauQFmdR4ZDuIn+hJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GwLsOseX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GwLsOseX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA2BC2BCB0;
	Tue, 12 May 2026 17:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608006;
	bh=ssAPdPpHdQUCahK1la6sdGtANO6rOj7bi5Bizfkgnto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GwLsOseX0SW6XCR9CeBe5QFqSvVwon4966cmJgYlo8QTAyfVCb2z61DqIkheWnGt0
	 4d96jMf7qNhy1UiTbxoxhNUCiVdMYOX1RfrtibK6nx2/TypbaK0mdPEvmd46a8bUbB
	 irZN/QIr+EoFHHGEZWLGvmnhxOwfCVNDJrP/mcCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6.12 121/206] isofs: validate Rock Ridge CE continuation extent against volume size
Date: Tue, 12 May 2026 19:39:33 +0200
Message-ID: <20260512173935.419335148@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit a36d990f591320e9dd379ab30063ebfe91d47e1f upstream.

rock_continue() reads rs->cont_extent verbatim from the Rock Ridge CE
record and passes it to sb_bread() without checking that the block
number is within the mounted ISO 9660 volume.  commit e595447e177b
("[PATCH] rock.c: handle corrupted directories") added cont_offset
and cont_size rejection for the CE continuation but did not validate
the extent block number itself.  commit f54e18f1b831 ("isofs: Fix
infinite looping over CE entries") later capped the CE chain length
at RR_MAX_CE_ENTRIES = 32 but again left the block number unchecked.

With a crafted ISO mounted via udisks2 (desktop optical auto-mount)
or via CAP_SYS_ADMIN mount, rs->cont_extent can therefore point at
an out-of-range block or at blocks belonging to an adjacent
filesystem on the same block device.  sb_bread() on an out-of-range
block returns NULL cleanly via the block layer EIO path, so there
is no memory-safety violation.  For in-range reads of adjacent-
filesystem data, the CE buffer is parsed as Rock Ridge records and
only the text of SL sub-records reaches userspace through
readlink(), which makes the info-leak channel narrow and difficult
to exploit; still, rejecting the malformed CE outright matches the
rejection shape already present in the same function for
cont_offset and cont_size.

Add an ISOFS_SB(sb)->s_nzones bounds check to rock_continue() next
to the existing offset/size rejection, printing the same
corrupted-directory-entry notice.

Fixes: f54e18f1b831 ("isofs: Fix infinite looping over CE entries")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Link: https://patch.msgid.link/20260419212155.2169382-2-michael.bommarito@gmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/isofs/rock.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/isofs/rock.c
+++ b/fs/isofs/rock.c
@@ -101,6 +101,15 @@ static int rock_continue(struct rock_sta
 		goto out;
 	}
 
+	if ((unsigned)rs->cont_extent >= ISOFS_SB(rs->inode->i_sb)->s_nzones) {
+		printk(KERN_NOTICE "rock: corrupted directory entry. "
+			"extent=%u out of volume (nzones=%lu)\n",
+			(unsigned)rs->cont_extent,
+			ISOFS_SB(rs->inode->i_sb)->s_nzones);
+		ret = -EIO;
+		goto out;
+	}
+
 	if (rs->cont_extent) {
 		struct buffer_head *bh;
 


