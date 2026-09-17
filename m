Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2DAD4B44CE;
	Thu, 17 Sep 2026 15:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660711; cv=none; b=Df/gaBDahbGFE8/a8UHlUGw1hny99dxh8EtD9jOd/B1gCsyPJtVE3khxNlzV95ItVV7XrIBnGm6/QRT7LhrYn+d5vDGBaxdg95gOs8jIM7WwgwMZqyPFH6DyisEwxG/PcDgh5yFdAV7lVJNHi8qI6eItUqmnDkffL0k3hapn9GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660711; c=relaxed/simple;
	bh=cwOti5c9k+PwP70IICdHqpVAiLDVFZ9sIA7x8Ky1Z+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nz4JUDiyw9ZgxzbzHC82LKVEOA9g4d9eGn4MSFUH4B0KbT+72SCkfSLD3mcjBB6+dvZgTxMOVYyIX5gS0BoE5ikH0sNNef56AV3p/dZ4lyUANDqJo0b2oxa/tDZWagJlmyoPE7UbXNV5nPtnzR2YAbZVBtfuFe1SGv21Xw53+t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xaXjOXAw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xaXjOXAw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F76C1F000FF;
	Thu, 17 Sep 2026 15:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660709;
	bh=aVyE8xRhymdhp7dwxi5kW0xw94lBwr5iH0rHhEWmwlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xaXjOXAwveN+rb92uC9jRITrcW2j4IMTIrdG17bv7BOCiJTyRxMhnrv6aetU4NzCc
	 QKD2a9MQgcHU81rBsf4En8cLoCTo4aiYbsHG1RyRNfGOgA6z1NbtG2XePizei0MJZA
	 4zB7r5s64q1F/kQBGRwRmX0ANMsYM83ZodWlrU+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 683/733] xfs: bump lost_prev_errors if we lose even the healthmon lost event
Date: Thu, 17 Sep 2026 16:16:31 +0100
Message-ID: <20260917151409.796558379@linuxfoundation.org>
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

commit 295f2cfd3e2c814c2ecd2c1d522bc31c5288e414 upstream.

LOLLM observes that we don't bump xfs_healthmon::lost_prev_event even if
we can't allocate or queue a LOST event, which means that events can
disappear silently when things are going very wrong.  Bump the counter
to avoid this problem.

Cc: stable@vger.kernel.org # v7.0
Fixes: b3a289a2a9397b ("xfs: create event queuing, formatting, and discovery infrastructure")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_healthmon.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_healthmon.c
+++ b/fs/xfs/xfs_healthmon.c
@@ -334,8 +334,10 @@ xfs_healthmon_clear_lost_prev(
 	if (hm->events < XFS_HEALTHMON_MAX_EVENTS)
 		event = kmemdup(&lost_event, sizeof(struct xfs_healthmon_event),
 				GFP_NOFS);
-	if (!event)
+	if (!event) {
+		xfs_healthmon_bump_lost(hm);
 		return -ENOMEM;
+	}
 
 	__xfs_healthmon_push(hm, event);
 cleared:


