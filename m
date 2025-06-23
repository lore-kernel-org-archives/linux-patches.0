Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F7A1E1A05;
	Mon, 23 Jun 2025 21:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714992; cv=none; b=B5EhnGQjeqmHTb2B6adKB/29bCfO8s0FzrW6voIxpt+2ac6d4BHvYcFxpj6aX57TWk3HLZYvzaZcF6dCcnmt0Ua1uLzqfAcNiC38GfCqHg5SbCPVkUhPZpsDy90pG9Vrnu6eHF2gv2vNvjx91k3UiuSFJ4fCg7sFjNcOoM6N5dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714992; c=relaxed/simple;
	bh=K5qo4OHiO7hIVDbZMJCrpsBVPXj2gFBaw+3CT7k/EyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sDQwXynTdgEoolKZSxIj3xNF7FR1BRtZJJMQXZERROm+68/K+TnsHgGGmo/LC0Ph2mJs1nXnHz1D63LtVndsHHG3mpuX8vOsbW8XH3QLdnTDXUxyXxEbxWVnVPtr/qSWe5jFZ0yYh9WQSPtS6Y8J/Ar3aPjfan440nVRi5L9ZL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pUDiGJbZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pUDiGJbZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A5EC4CEED;
	Mon, 23 Jun 2025 21:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714992;
	bh=K5qo4OHiO7hIVDbZMJCrpsBVPXj2gFBaw+3CT7k/EyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pUDiGJbZ+rJ5GNCBl3vwni0aw6g49DwjWgWFgkOYcKIaFwiOnCVnQ0tOwBDRhM9cr
	 ur4VsW9BYpwon6+z99mI/rUs3uu70ZEYos/1Qdm8M+PQDSlUviIkvVikdLvuTfp3aa
	 T7g+s6cOKhEcoABrK5QWrgx/dURCo8U2ENwXpc+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 208/508] xfs: attr forks require attr, not attr2
Date: Mon, 23 Jun 2025 15:04:13 +0200
Message-ID: <20250623130650.385031884@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 73c34b0b85d46bf9c2c0b367aeaffa1e2481b136 ]

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
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/bmap.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index f0b9cb6506fdd..45b135929144e 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -647,7 +647,13 @@ xchk_bmap(
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



