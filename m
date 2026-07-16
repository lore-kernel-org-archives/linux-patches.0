Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3318841F5EB;
	Thu, 16 Jul 2026 13:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209712; cv=none; b=urpQ3W3AXoMK+V7jDh3NADtgEZyfTpqaracD2LJSq9qKb4CEgC68qMiMBKBPy0grpDD1E4Aa4Khzu3gU00al11AqZRnuyNzvBxoSLPVjdm9F5v6DRY4f4nXB7PPlv/4m6SZMBypXwY7kvekWyoC2Oi0eYa5UT9+lHc20pUueR0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209712; c=relaxed/simple;
	bh=4FL8iwMy3MZwonUpbM+2ifFOmhnDbdTNZcKIjz0BOKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XNRtBcB59CBC2q4k6DVpCS/kez1yZvaoFSmfgym4r6++pulyu4qYYrmQTUY/MgEtJXimW83mI0WJLXMaOq8ggRhStIVmVSRSno2t8FaU45nWlteud79HZPiQgIRLMdtb0peIq9DEwNS3Iy16kijD6Lsc/ps5Rda7cL1V3fIp9Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QqMoP9PB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QqMoP9PB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D120F1F00A3A;
	Thu, 16 Jul 2026 13:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209702;
	bh=X3M50xwTh99BQwI3lrw/f3a3mxK5+3L/wwp5Zq15N2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QqMoP9PBSIZv3eVoMeFk0rILQ48lWYaGVmdw0Q7NMfGdkpAViPvNSeo6xwvy2Ri5T
	 ebM1TvNS1QqKOq8NSLsIipqX/fKQxrZHIjQougF2fMQw42dzovxt52lWNxY4gSNoLs
	 g5eobAkEo83vYHT4dZxiYQwnZ2sVCthLEOwzPgq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.1 286/518] xfs: initialize iomap->flags earlier in xfs_bmbt_to_iomap
Date: Thu, 16 Jul 2026 15:29:14 +0200
Message-ID: <20260716133054.075130582@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit 327e58826eb72f8bae9419cf1a4e722b57c85694 upstream.

Otherwise we lose the IOMAP_IOEND_BOUNDARY assingment for writes to the
first block in a realtime group, and could cause incorrect merges for
such writes.

Fixes: b91afef72471 ("xfs: don't merge ioends across RTGs")
Cc: <stable@vger.kernel.org> # v6.13
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_iomap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -113,6 +113,7 @@ xfs_bmbt_to_iomap(
 		return xfs_alert_fsblock_zero(ip, imap);
 	}
 
+	iomap->flags = iomap_flags;
 	if (imap->br_startblock == HOLESTARTBLOCK) {
 		iomap->addr = IOMAP_NULL_ADDR;
 		iomap->type = IOMAP_HOLE;
@@ -143,7 +144,6 @@ xfs_bmbt_to_iomap(
 	}
 	iomap->offset = XFS_FSB_TO_B(mp, imap->br_startoff);
 	iomap->length = XFS_FSB_TO_B(mp, imap->br_blockcount);
-	iomap->flags = iomap_flags;
 	if (mapping_flags & IOMAP_DAX) {
 		iomap->dax_dev = target->bt_daxdev;
 	} else {


