Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC0F4DDB32;
	Thu, 17 Sep 2026 15:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660708; cv=none; b=SxN6M+eB41jzGU5mWiMw1MabzF+pZ8NsMGwcXfKV3RB4fLJ56LKbg2UNjVw2dBgUZ7oLBpjUsmngN8SwUPlcWUcoPbboZBplgB2np0cfrlpi3zd0vH2WxCe+k3TQzvbcjjJlLXpmsG+h8RYftj/x+Tv0rxurI7woTDs5tu55QA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660708; c=relaxed/simple;
	bh=RUoDWrptU7th9KMGHd1TobMeLHxOFBopqSL/ZLcp0c8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JxQlPRXdq4YDCaddZkoIhVZIcwzhhamvUV280kQIcYcBLJ4REDqRxZVwp72ovGyqROuT9pQaXDacGl5u+aZrGurZWlRkVVP9BJNrxLonKpTbypRACkSwwZnrlb9KN2CaHpmwieoRz0o+X71Ge5UzM7SFG3J4EThaxJK1xanfRg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A6x+wsDf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A6x+wsDf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 163731F000FF;
	Thu, 17 Sep 2026 15:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660706;
	bh=30phOTL2AxNVY5mBkmstvCyHv3greXwfsPLrDSwrt1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A6x+wsDfcFE2ayd+mcMK2CgRPLcE7N1d+PaPnxJ+YqNmQi0ijd8p1D3M/EDPd0tal
	 Xz8pZNON+xRzNP5JT5fKYWx0OJ8lo5yNvcnsul4fEa1SoHaiOPI1rH/1d8eqJa9GXg
	 KvXDqcfdtMLXW6QSEqL1tGGzCIAL2DPtLYO30FAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 682/733] xfs: check healthmon outbuffer space correctly
Date: Thu, 17 Sep 2026 16:16:30 +0100
Message-ID: <20260917151409.767196404@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 74eeb68a628dbc4a8f976351ad2f1ef5463513ee upstream.

LOLLM notices that the outbuf space check in xfs_healthmon_format_pop
isn't quite correct -- it checks that there's enough space to write a
xfs_healthmon_event object, but the outbuffer is supposed to contain
xfs_health_monitor_event objects.  Fix this by adding a helper, and
refactoring all three outbuf size checks to use it.

Cc: stable@vger.kernel.org # v7.0
Fixes: b3a289a2a9397b ("xfs: create event queuing, formatting, and discovery infrastructure")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_healthmon.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/fs/xfs/xfs_healthmon.c
+++ b/fs/xfs/xfs_healthmon.c
@@ -744,6 +744,13 @@ static const unsigned int type_map[] = {
 	[XFS_HEALTHMON_DATALOST]	= XFS_HEALTH_MONITOR_TYPE_DATALOST,
 };
 
+static inline bool
+xfs_healthmon_check_outbuffer_space(const struct xfs_healthmon *hm)
+{
+	return hm->bufhead + sizeof(struct xfs_health_monitor_event) <=
+		hm->bufsize;
+}
+
 /* Render event as a V0 structure */
 STATIC int
 xfs_healthmon_format_v0(
@@ -810,10 +817,10 @@ xfs_healthmon_format_v0(
 		break;
 	}
 
-	ASSERT(hm->bufhead + sizeof(hme) <= hm->bufsize);
+	ASSERT(xfs_healthmon_check_outbuffer_space(hm));
 
 	/* copy formatted object to the outbuf */
-	if (hm->bufhead + sizeof(hme) <= hm->bufsize) {
+	if (xfs_healthmon_check_outbuffer_space(hm)) {
 		memcpy(hm->buffer + hm->bufhead, &hme, sizeof(hme));
 		hm->bufhead += sizeof(hme);
 	}
@@ -896,7 +903,11 @@ xfs_healthmon_format_pop(
 {
 	struct xfs_healthmon_event *event;
 
-	if (hm->bufhead + sizeof(*event) > hm->bufsize)
+	/*
+	 * Don't bother if there's not enough space to format even one event in
+	 * the outbuffer.
+	 */
+	if (!xfs_healthmon_check_outbuffer_space(hm))
 		return NULL;
 
 	mutex_lock(&hm->lock);


