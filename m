Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8398F4E4C32;
	Thu, 17 Sep 2026 15:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660728; cv=none; b=OtA2l92RM/ihbQ/mLvbo6R01qCzyxFk2APfUrhhGK9um1ir+VpXhMHZullfMbq3/ZvGEnSQ3FQnp1B+UxI+C5PUwpMIFIyciMGRlO0EVqLWzqAFgvLKCrGkDpH+4LY1dSkbWHtrKhlQLeoyv55tdSzOD9pnT9SsHhfcOqYX4GHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660728; c=relaxed/simple;
	bh=n8NIn+HUGwNO9Sfnan3pJikmAGqwfxjmK8NQ17g3fYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KTse9QaoqKq9Zu4V/i3genusmBtsmBz/2UQmagXG4G91LWdBT6l5909R4E8ZvCK8XO4YkkUc5HGVcrtvOuqrAKJ44HnxXrU81ZiimV+xS+QsSB14WpawzN65LLTxW05zNWGRSWbNkNFRMj/N8jNDg8bFWNhjQV2cRy0fLDGHdqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=egjG4XPw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="egjG4XPw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6BA81F00898;
	Thu, 17 Sep 2026 15:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660727;
	bh=pJ+QX2Ru2iXcw7R4+vbPPJ2XBcbNJFmwkG1wnnrBMOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=egjG4XPwfgEhzshiKBOO8XjdzaZ1Rpzp0B9vI2+9QEJMhm/Vme9y/azdurBKaDnxE
	 GkXCBDHlfYybdZrfwSQCWRMeDxBeaCrx1UZyDiqnirS95r9km68m+8r6YVXXMVhR8r
	 +TiiqQtBH1kqN8vNbBp1V63bVbbxdVIl3ReIwG8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 688/733] xfs: actually check internal-rtdev fields in the superblock
Date: Thu, 17 Sep 2026 16:16:36 +0100
Message-ID: <20260917151409.943570095@linuxfoundation.org>
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

commit 1ee2ce797c360785a3813fef62c90f427f3aed34 upstream.

LOLLM points out that the superblock scrubber doesn't check the new
fields that were added for internal realtime volumes when we added zoned
device support.

Cc: stable@vger.kernel.org # v6.15
Fixes: 2167eaabe2fadd ("xfs: define the zoned on-disk format")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/agheader.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -418,6 +418,13 @@ xchk_superblock(
 			xchk_block_set_corrupt(sc, bp);
 	}
 
+	if (xfs_has_zoned(mp)) {
+		if (sb->sb_rtstart != cpu_to_be64(mp->m_sb.sb_rtstart))
+			xchk_block_set_corrupt(sc, bp);
+		if (sb->sb_rtreserved != cpu_to_be64(mp->m_sb.sb_rtreserved))
+			xchk_block_set_corrupt(sc, bp);
+	}
+
 	/* Everything else must be zero. */
 	sblen = xchk_superblock_ondisk_size(mp);
 	if (memchr_inv((char *)sb + sblen, 0, BBTOB(bp->b_length) - sblen))


