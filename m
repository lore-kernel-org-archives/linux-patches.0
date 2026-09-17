Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3034C10F8;
	Thu, 17 Sep 2026 18:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671242; cv=none; b=IrHIYlqcT7hsyjRB8PflAsEU8qCtonbprtCP75bdsMQ+F0pjmm34OP7LGTNFsfBOGtVIkFmgGIreKipjTBxcfUagLxY7sFbKV95TxvVqFqy3/Tx7d7u0Opa13fbM14lju8RJZpdenoHROsOiJCXMKnPsAwb9/W1aglDHeZPNRdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671242; c=relaxed/simple;
	bh=hnP5566ghBGYmvkBZkYhbPqzrwRnXFRfLUoHMr8L1xM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R/5ekea3nlaVNZ+flwb95k7npnQUsTXiG++BNImyfPDZs1OdKi+bvOk5/CDpDSBapoe2Effxwp3v9XbTZqP9VXUKfs4fYOcFXKwr2/3b0E09DBm0UPlOIgOfi3oiHB0Hj/zanNuYdkF5UpvVZLZNRKqV6OrF2IWFO9iYR2p+H40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gmYjSb/g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gmYjSb/g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43141F00893;
	Thu, 17 Sep 2026 18:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671241;
	bh=9UD1ugNURrb0nLxxahKjK4VNcJtTgH70i6epm6u1OxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gmYjSb/gb64WaN1wbuLqejS5AIcoS/E7Azo1VFyvoBdY0eto35eeKkBrIpNoamwal
	 yVPTAg32knv3Xcr0hc/dFSevTf/NbRgXSr97ONyOt/K8vt6dluA2iJy7rHu2tg5gxk
	 ihdzMEtfnxJ7iUxyJxQ9n291lPZULBu3Gg94bTiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0911/1102] xfs: dont spin forever on zero-length dirents when salvaging them
Date: Thu, 17 Sep 2026 16:14:14 +0100
Message-ID: <20260917151603.483484692@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 9f84792b40d0c96833341602144574bf0bd14a6a upstream.

LOLLM noticed that xrep_dir_recover_data can spin forever if it
encounters an unused dirent that claims to have length zero.  Fix that,
and prevent the same thing from happening with a zero-length entry.

Cc: stable@vger.kernel.org # v6.10
Fixes: b1991ee3e7cf85 ("xfs: online repair of directories")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dir_repair.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -478,18 +478,24 @@ xrep_dir_recover_data(
 	while (offset < end) {
 		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
 		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
+		unsigned int			advance;
 
 		if (xchk_should_terminate(rd->sc, &error))
 			return error;
 
 		/* Skip unused entries. */
 		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
+			if (!dup->length)
+				break;
 			offset += be16_to_cpu(dup->length);
 			continue;
 		}
 
 		/* Don't walk off the end of the block. */
-		offset += xfs_dir2_data_entsize(rd->sc->mp, dep->namelen);
+		advance = xfs_dir2_data_entsize(rd->sc->mp, dep->namelen);
+		if (!advance)
+			break;
+		offset += advance;
 		if (offset > end)
 			break;
 


