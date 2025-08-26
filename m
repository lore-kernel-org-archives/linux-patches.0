Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1A331CA74;
	Tue, 26 Aug 2025 11:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207280; cv=none; b=J8rGBvvsH/5kiOgqY1H23Mh8MXH92wvBJKnrUTZtikwTrAXBy6+8qbQ3Wx5lu8+iEgqeSb6DipbZJZt+M7XL+WfoUKteAIXIjEXWZxDmlKWuK13nbC7d3pydzPVcCoZcATPBnM3s5duDP6Z4zIfU5K9Gg3rr4dar5xHaTDehE5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207280; c=relaxed/simple;
	bh=sLrdOECDng2V/QnWmv1SBA5ohoDOOo/9GVT6dWc+MPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XG0gTHD/JKGux61691h0FiGQTNTvWzEMP4w1HKJ9iBja2xnsDqSyG3rZB3KMGRh5ztsbiJA/gHuzzNaGatXt3huXGHnCm2GpfhXGtwKkU66dwXbGgtoz1nLVouvbyqeHH/m+vaX347XNS2Bj5FQ4B7VEoUut6Wu1lzxxh4U3MjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zcxOy7+T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zcxOy7+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C59C4CEF4;
	Tue, 26 Aug 2025 11:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207279;
	bh=sLrdOECDng2V/QnWmv1SBA5ohoDOOo/9GVT6dWc+MPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zcxOy7+TA36W3sZHeiyrlVtQa0W7KncHZyHRNVkfcYWOUwFX/pW0XoOkTdNtNyvu6
	 3iMWLraqsxCeqK9m3KqrhYTrgRrlqCzb544j3L23YqFbLBxDEIF4bhLmEGTTbY0I4/
	 bB0Of248Dzu9sR5L3HB+X8IpMTlq6jA9n2LuRBMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Jan Kara <jack@suse.cz>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.16 113/457] iomap: Fix broken data integrity guarantees for O_SYNC writes
Date: Tue, 26 Aug 2025 13:06:37 +0200
Message-ID: <20250826110940.164042769@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 6b65028e2b51c023a816eabffea88980fdd5564e upstream.

Commit d279c80e0bac ("iomap: inline iomap_dio_bio_opflags()") has broken
the logic in iomap_dio_bio_iter() in a way that when the device does
support FUA (or has no writeback cache) and the direct IO happens to
freshly allocated or unwritten extents, we will *not* issue fsync after
completing direct IO O_SYNC / O_DSYNC write because the
IOMAP_DIO_WRITE_THROUGH flag stays mistakenly set. Fix the problem by
clearing IOMAP_DIO_WRITE_THROUGH whenever we do not perform FUA write as
it was originally intended.

CC: John Garry <john.g.garry@oracle.com>
CC: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Fixes: d279c80e0bac ("iomap: inline iomap_dio_bio_opflags()")
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/20250730102840.20470-2-jack@suse.cz
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/iomap/direct-io.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -368,14 +368,14 @@ static int iomap_dio_bio_iter(struct iom
 		if (iomap->flags & IOMAP_F_SHARED)
 			dio->flags |= IOMAP_DIO_COW;
 
-		if (iomap->flags & IOMAP_F_NEW) {
+		if (iomap->flags & IOMAP_F_NEW)
 			need_zeroout = true;
-		} else if (iomap->type == IOMAP_MAPPED) {
-			if (iomap_dio_can_use_fua(iomap, dio))
-				bio_opf |= REQ_FUA;
-			else
-				dio->flags &= ~IOMAP_DIO_WRITE_THROUGH;
-		}
+		else if (iomap->type == IOMAP_MAPPED &&
+			 iomap_dio_can_use_fua(iomap, dio))
+			bio_opf |= REQ_FUA;
+
+		if (!(bio_opf & REQ_FUA))
+			dio->flags &= ~IOMAP_DIO_WRITE_THROUGH;
 
 		/*
 		 * We can only do deferred completion for pure overwrites that


