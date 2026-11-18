Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043961;
	b=PT9mhs50vx4DwwC14+tMcdVaevzCTK3AmyE3ra/Ixi+npEog6rOF98MlUv/hR1jNM/D6
	 KRsSEEuM9jKYGivjvgzEiUH2CFDnK3jLE7SfBlqOxk5PNCi7MmIX6kKR081dg05wFYKyn
	 ODhkbgYKqRM8Drx/0WigmvgR6+VtJhNX91GzyeZIdyVhqwBftHWHyD8ATdfDtGToDyjI8
	 iooTPDcZn7hK04Ucc0hR8ujhk5XahKWxIpkJ3pLdhtrE3+IGzE8tAkLyw7xKUjsSo0P0j
	 Xl35hpMXJjbDsFZOiHw/6ImvSvGrlqYK1OW4tgD70o05Ex0zxMyiZxQeITiRCqouHIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043961;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZPRF4BD83Y3jUGyMI+WrisHQ2rwq6tlakP04YyaPB1c=;
	b=z/Ets5ZKsFDB9QzyR0xDW2ad0dQt8NIw+EiNRgbsGhS6NqxkgZ3ic3UTjWZSgtTEpWSq
	 BPmo4WmeX/+FbO38Ncb2Sl4bWFeiIDFOk9T4B8DcaRWqUiS76ImFy5kzMzVZ2ygZiAbvr
	 U5zEJvCZehewLhsabNRZYQCJER8s2/aYPUKiEPsvHMuntv1CFjNwE5zYroT5pgdiUdWuX
	 ScWjmMzL3WnrNzkZAJNDq5P19QrHLKBZLkxnlWSAvBNJ5o5Ud+ExfIEw+MOd1sXY0sZoF
	 4oLI4Ev5JeKVs2ZZhxwG1F2bZ5qfhqOe4GtX0BR5e56DWkcX/NUimpGvoCLV6fNxS3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zm2jGMew;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4564B606A31C;
	Wed, 18 Nov 2026 23:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zm2jGMew
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 965FD1F000C4;
	Wed, 18 Nov 2026 23:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043961;
	bh=ZPRF4BD83Y3jUGyMI+WrisHQ2rwq6tlakP04YyaPB1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zm2jGMewiezyonYIIDYjHbNrddaIsfm55MEul/ApOGeCieOZ21MXOptqW4JQ2mb4/
	 KJ1ltKucUD9PsKiAVHg1psTLvE+oskWyrjMDhuCW9OihOhFx1RSNfcUahvyQ5p6aoi
	 lr39Ve07pWtCDtkQchbs13xo9E8EW1zo04kQItas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0396/2857] dm-integrity: fix NULL pointer dereference when the R flag is used
Date: Wed, 18 Nov 2026 15:23:50 +0100
Message-ID: <20261118150215.651955918@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-integrity.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 8a7422a54a896..3264d38e21cd5 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3253,6 +3253,10 @@ static void dm_integrity_resume(struct dm_target *ti)
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
@@ -3362,6 +3366,7 @@ static void dm_integrity_resume(struct dm_target *ti)
 		}
 	}
 
+skip_writes:
 	ic->reboot_notifier.notifier_call = dm_integrity_reboot;
 	ic->reboot_notifier.next = NULL;
 	ic->reboot_notifier.priority = INT_MAX - 1;	/* be notified after md and before hardware drivers */
-- 
2.53.0



