Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350D951B16B;
	Wed, 30 Sep 2026 18:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793689; cv=none; b=nwf6ftRo5+Hfgxnum37o0gdrwj3Enij0N+rAeNSUhXzjhr6L/7rs6DcBZEWr/iDuurGgKkbOBm93xIdXEjLgKiPTW2Z2txBbjF80XBhBxn4Yg+oedQdOkaiPdk6rJ++5wSUmhFptfWErgZW4r3TTB26mi84TFq+wayzG7Ihe+dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793689; c=relaxed/simple;
	bh=iusKUSjOkFsRTqVAn7hranNwGwQA2qRREln/mMltPQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=azXj/ktrrYq/r/xM+W07XWDLnxnEI35Zu5aiAf8xVHzhj145sawu3jFfPNbC1fP/TR8THxc+znwqUXWjIeIFKo0iulISPgj+o99PV6g0DX+BnwvA+9QidRXvJskXOL01Jqq1VxN6F8+D03WI1ACwgdHlOWGQc++EKfmTGKUANvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GqV3nddc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GqV3nddc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EEDD1F000FF;
	Wed, 30 Sep 2026 18:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793687;
	bh=tJEV5i/ooahYXebhiTXur7v96gN6zARsXsgKeM1833E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GqV3nddcw2gcI6gQglPmjltPUDLy2Uuas2KVwblOsLMTEeI2sPXA2TUc9dXaQKPsG
	 1JHEJ7AAqk7BWQsLqsdLBSwK+JO4qWNBt9KUHp7il4EZggHrWNSPJr+XnDLbtLzNiq
	 c+ccwAeSaMga+AYqeSZ9rMiHxz3wp8emmu+IKn0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 343/395] xfs: call xfs_dquot_set_prealloc_limits if we installed default rtb limits
Date: Wed, 30 Sep 2026 17:30:05 +0200
Message-ID: <20260930152348.112011398@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 065f3ce5936e68da75f3dc18201d290073d78f3c upstream.

Now that we have quotas for the realtime volume, we also have
precomputed watermark limits for the realtime block counts.  These
precomputations should be done any time we change the rtb limits, which
means that xfs_qm_adjust_dqlimits needs to ensure that if we installed
a default rtb limit.

Cc: stable@vger.kernel.org # v6.13
Fixes: 5dd70852b03901 ("xfs: create quota preallocation watermarks for realtime quota")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_dquot.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -139,10 +139,14 @@ xfs_qm_adjust_dqlimits(
 		dq->q_ino.softlimit = defq->ino.soft;
 	if (!dq->q_ino.hardlimit)
 		dq->q_ino.hardlimit = defq->ino.hard;
-	if (!dq->q_rtb.softlimit)
+	if (!dq->q_rtb.softlimit) {
 		dq->q_rtb.softlimit = defq->rtb.soft;
-	if (!dq->q_rtb.hardlimit)
+		prealloc = 1;
+	}
+	if (!dq->q_rtb.hardlimit) {
 		dq->q_rtb.hardlimit = defq->rtb.hard;
+		prealloc = 1;
+	}
 
 	if (prealloc)
 		xfs_dquot_set_prealloc_limits(dq);


