Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8003D3B3C18;
	Wed, 30 Sep 2026 19:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795760; cv=none; b=hPMVyd+GHyJadH1qCJ/j0fssIuPDSJ1NSQXbB34bmUYAcw33h+AzkE4TZXsoLD9zQmRf2lyhIZUtYw4oO2qNijv90Cpg6DVLN7o5FgjQmg84j7CGwWV4gYtsxOHf4HiZpvK63v3nkWjSeyvjknyLq7j12wLJrwc0Yo968XrlCRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795760; c=relaxed/simple;
	bh=Fke9N5ug3er4Zhr0Azgr98uCQGF+U7zZ6emv5UdSSnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SGdGYydKegbH5PTDMj6gp35hJbIr8W1AkaW/+tO90xXrTLqo6HHnu+mRMgE004jNztLxWQTKv8g0AgFHGre1UouoYhrCc6MN+SsN1nOHmfCtQLDcZlXWoeyysPwlAiicSMQhoYmFh8CDhgYMFVcjQWxk4/UEOGQrcH+7chjukno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qr1aPSbi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qr1aPSbi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D816F1F000FF;
	Wed, 30 Sep 2026 19:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795759;
	bh=6jU6c6MBHrUzkVnwoKzdgWEUuy0lUdUy/6dy6yVXP2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qr1aPSbiyTNEaVNwGAIw55Kkd0ryw1B37G6hnO6TSwY4HFvxMUVmuYSlj5j8KIlzy
	 i8sjyWdLudOtP0NkVKWpLZrfUttZD/YP72rXByrJz+g+kp45APgp9tmSl62KbcdDUW
	 VtdLRVifVtG3lMe9UIuJRUSxVRP70rBUhIxxjeUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.6 0675/1193] xfs: bail out on bitmap errors in xrep_agfl_fill
Date: Wed, 30 Sep 2026 17:22:39 +0200
Message-ID: <20260930152449.242823941@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit eaf580538eb1be3d162400d04c4b7dc4c627296b upstream.

LOLLM also points out that the xagb_bitmap_set call in xrep_agfl_fill
can fail, but we don't check the result of xagb_bitmap_walk, so we
silently drop the error and proceed with inconsistent incore data.
That shouldn't be allowed.

Cc: stable@vger.kernel.org # v6.6
Fixes: 014ad53732d2ba ("xfs: use per-AG bitmaps to reap unused AG metadata blocks during repair")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/agheader_repair.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -708,7 +708,9 @@ xrep_agfl_init_header(
 	 */
 	xagb_bitmap_init(&af.used_extents);
 	af.agfl_bno = xfs_buf_to_agfl_bno(agfl_bp);
-	xagb_bitmap_walk(agfl_extents, xrep_agfl_fill, &af);
+	error = xagb_bitmap_walk(agfl_extents, xrep_agfl_fill, &af);
+	if (error && error != -ECANCELED)
+		goto err_undo;
 	error = xagb_bitmap_disunion(agfl_extents, &af.used_extents);
 	if (error)
 		goto err_undo;


