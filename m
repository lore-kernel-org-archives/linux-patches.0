Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164D815CAB
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:49:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91FBFC433D6;
	Tue,  8 Nov 2022 13:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915367;
	bh=6N6aeMUQDpdIMBfKrN4ecT38Mmkyk64BTYq1vWwE6fE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gLPUO/DqvqAgJSVkOdKEmUCYGDyk5eTujUmH+uZ3IDyd8PldKKeyfpZUXA59FG3EU
	 /67FRdetmTl4z0VeVqukAFwfPZ6Sh9KGMA2QQTVjZrLjPAeYEFk6xMXG/ShD63LXOT
	 Y9h3p2igxYQrnGb7SeCNeUHWEPivM/UEbYIjvlN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Sandeen <sandeen@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Brian Foster <bfoster@redhat.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 40/74] xfs: group quota should return EDQUOT when prj quota enabled
Date: Tue,  8 Nov 2022 14:39:08 +0100
Message-Id: <20221108133335.375782856@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133333.659601604@linuxfoundation.org>
References: <20221108133333.659601604@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Sandeen <sandeen@redhat.com>

commit c8d329f311c4d3d8f8e6dc5897ec235e37f48ae8 upstream.

Long ago, group & project quota were mutually exclusive, and so
when we turned on XFS_QMOPT_ENOSPC ("return ENOSPC if project quota
is exceeded") when project quota was enabled, we only needed to
disable it again for user quota.

When group & project quota got separated, this got missed, and as a
result if project quota is enabled and group quota is exceeded, the
error code returned is incorrectly returned as ENOSPC not EDQUOT.

Fix this by stripping XFS_QMOPT_ENOSPC out of flags for group
quota when we try to reserve the space.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_trans_dquot.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -756,7 +756,8 @@ xfs_trans_reserve_quota_bydquots(
 	}
 
 	if (gdqp) {
-		error = xfs_trans_dqresv(tp, mp, gdqp, nblks, ninos, flags);
+		error = xfs_trans_dqresv(tp, mp, gdqp, nblks, ninos,
+					(flags & ~XFS_QMOPT_ENOSPC));
 		if (error)
 			goto unwind_usr;
 	}


