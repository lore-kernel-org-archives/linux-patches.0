Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B6724EF62;
	Mon, 24 Feb 2025 14:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407827; cv=none; b=WEibhBWKxBw/zqj1/ouACmr7eNISdf79uaqFo7MxFMqOGVRPvbn90cmfb2tabKddRorBgTVRCnWs4/zpbIZ8Fu3VudHdPd6V3PnnKna9OJwJl4rBdKtf5W30wC8I+AFK5E0KLQmPWWjX8hhLT0Ix9lGafJ9PZvRdgv7uM1NDE4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407827; c=relaxed/simple;
	bh=fr1Wmo/GhMb6rTazd5YrbIEQI4WCHyK+dApBP06m9hE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rTec5zddrrTy/1C1+7eSa7kHEqHEB6kWlvX64GdkBgROtMbZVJqJ8cLLx1qfa/PGlvhw+dnol9/8RZyLWe9482Z4sM99Q72eTWO9rRebjN0ud0GIG8P/e9PSMAulaaJpOzU8UToo/E97JVu5HjRMAHSMlyzfn2cCrxcrbAcRniU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bK5gsL+i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bK5gsL+i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCBA5C4CED6;
	Mon, 24 Feb 2025 14:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407827;
	bh=fr1Wmo/GhMb6rTazd5YrbIEQI4WCHyK+dApBP06m9hE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bK5gsL+iZePUzmEbotQ3Wm+UJ5rm9HRnll97QOX6/eaRnpERIONkPM71R7G3woCo3
	 SPkVhoHgphO72rp2WT4aTdPjwMgO5W1vEk9Gfw91ylU5YtBoRn9C4hj1vJvdFZCVub
	 9A4xsbRoawO6T2sH6bRrPxEAYnhitAFgHp8Qga+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xfs-stable@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Brian Foster <bfoster@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 020/140] xfs: error out when a superblock buffer update reduces the agcount
Date: Mon, 24 Feb 2025 15:33:39 +0100
Message-ID: <20250224142603.799086963@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit b882b0f8138ffa935834e775953f1630f89bbb62 upstream.

XFS currently does not support reducing the agcount, so error out if
a logged sb buffer tries to shrink the agcount.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_buf_item_recover.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -713,6 +713,11 @@ xlog_recover_do_primary_sb_buffer(
 	 */
 	xfs_sb_from_disk(&mp->m_sb, dsb);
 
+	if (mp->m_sb.sb_agcount < orig_agcount) {
+		xfs_alert(mp, "Shrinking AG count in log recovery not supported");
+		return -EFSCORRUPTED;
+	}
+
 	/*
 	 * Initialize the new perags, and also update various block and inode
 	 * allocator setting based off the number of AGs or total blocks.


