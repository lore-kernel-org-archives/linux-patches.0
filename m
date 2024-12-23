Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDF61B395E;
	Mon, 23 Dec 2024 16:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970282; cv=none; b=CmnDfBRjbDmCDzKuNyDOMjjHWOYjyFU2YlaLXgYnyRUd7sOgAClBjMr/kyivQ8vVvFZYsgQO7V/aK8gOXRhjbkB92tsSegnnmoEG1rRJn8aTi+bcAMnObI5zcRmNKVMJ+jCLFfURMXgtKzcA9o9cYgJhOwZl4XcmuovmM6lZZyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970282; c=relaxed/simple;
	bh=/QnW958nyGP3ytafY/0Eoih2shVq+l7D0fjTJNudxhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MdAIufXGPtY+YfdH2k3FiQBAkqJjnbAkuYsfU/ODvkBKFlPS0tJwQ2SxYMRPWOaqDnyxmvQUmgC0t/01AcN07p8oHa5ElTmDBHGaS/u4cVC4LhSm7nAdAWHaIhRpweuPrTzNHIwHNhYciUwFrjp1On4PmJUZ6lBE23JI1yFSRHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MSKV9Itz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MSKV9Itz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0C6C4CED3;
	Mon, 23 Dec 2024 16:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970282;
	bh=/QnW958nyGP3ytafY/0Eoih2shVq+l7D0fjTJNudxhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MSKV9Itze/Fon2iNHKBWP2tc0A/X5sLwcE0By2drsrWekGkktK+DqPJVU44HvoWFP
	 2NQc+GmC4mZBC9EO2XXqlfuxUirVsYqze1UzQjxVly7OgIBI3c2Ya2Irm8Rw6dL/SO
	 KAESsVY+AMrzJfDm3lM6TM+JrGuf0Vdt2DH6Bt+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/116] xfs: attr forks require attr, not attr2
Date: Mon, 23 Dec 2024 16:58:20 +0100
Message-ID: <20241223155400.750601919@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
User-Agent: quilt/0.67
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

commit 73c34b0b85d46bf9c2c0b367aeaffa1e2481b136 upstream.

It turns out that I misunderstood the difference between the attr and
attr2 feature bits.  "attr" means that at some point an attr fork was
created somewhere in the filesystem.  "attr2" means that inodes have
variable-sized forks, but says nothing about whether or not there
actually /are/ attr forks in the system.

If we have an attr fork, we only need to check that attr is set.

Fixes: 99d9d8d05da26 ("xfs: scrub inode block mappings")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/bmap.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 75588915572e..9dfa310df311 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -857,7 +857,13 @@ xchk_bmap(
 		}
 		break;
 	case XFS_ATTR_FORK:
-		if (!xfs_has_attr(mp) && !xfs_has_attr2(mp))
+		/*
+		 * "attr" means that an attr fork was created at some point in
+		 * the life of this filesystem.  "attr2" means that inodes have
+		 * variable-sized data/attr fork areas.  Hence we only check
+		 * attr here.
+		 */
+		if (!xfs_has_attr(mp))
 			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
 		break;
 	default:
-- 
2.39.5



