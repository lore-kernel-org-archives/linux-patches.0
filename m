Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6EF3D25D0;
	Thu, 16 Jul 2026 14:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211633; cv=none; b=RL4n6gmOZGFT3GFtx9DIjLkFergMR8Z0e6PYjFM2BjppS3fT/evdYaPpisj1Bpc75eFrZEbMI4nrItqDs58PulfTKGhjHpn6UW63vExSQ35xlx60u4+x2KI8hYxOAF4IKGuYQFimbbkRNsZn9zxJkQ9atS18oNJl8SEeTmZZXAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211633; c=relaxed/simple;
	bh=GNGjiRAPORuQccw7dnwE65P/VAzRBzKmmDOjdoXytwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JsXTbuoRkY3nqB1wHVPitSMds70Tl1dgX6o2HpQchs7L2AMtRKa4AozvZNQOYT/2Wqg41B8ByRzJiZTzj7ASgg/P2Oj3MKq6uyZe/DT5DD2HYiLmHvAf0MaQCzCgyWwDja9bcixotW0wekx5g/hKQANF6qkgKYzGmajKCPNZ7Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tRJu6sjm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tRJu6sjm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F8321F000E9;
	Thu, 16 Jul 2026 14:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211632;
	bh=E1EC7fPcLzyXshyOtc7Q60W3kFyL0SQHYTuGHInB7ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tRJu6sjm9VoxYhHr0b5vAvdMSZ+q3LO4kSKGNHL3la3A8StfAQ1GwDrD9yt8H0Nhi
	 4P42fYA1cpZpiZ3ruPorxW653oaKrV75J948FSTl8VhxeZYdcZ+rTn3mx2pRcsK4rU
	 7Pha2eRhQ7tPxveEn6linBSO9UGr0GVO4Lbab61Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Curley <jcurley@purestorage.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 022/349] NFSv4/flexfiles: Remove cred local variable dependency
Date: Thu, 16 Jul 2026 15:29:16 +0200
Message-ID: <20260716133033.795286524@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

From: Jonathan Curley <jcurley@purestorage.com>

[ Upstream commit fec80afc41afa3016421115427df8d00dc491ee5 ]

No-op preparation change to remove dependency on cred local
variable. Subsequent striping diff has a cred per stripe so this local
variable can't be trusted to be the same.

Signed-off-by: Jonathan Curley <jcurley@purestorage.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Stable-dep-of: 2c6bb3c40bc2 ("NFSv4/flexfiles: reject zero filehandle version count")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -531,10 +531,10 @@ ff_layout_alloc_lseg(struct pnfs_layout_
 		if (mirror != fls->mirror_array[i]) {
 			/* swap cred ptrs so free_mirror will clean up old */
 			if (lgr->range.iomode == IOMODE_READ) {
-				cred = xchg(&mirror->ro_cred, cred);
+				cred = xchg(&mirror->ro_cred, fls->mirror_array[i]->ro_cred);
 				rcu_assign_pointer(fls->mirror_array[i]->ro_cred, cred);
 			} else {
-				cred = xchg(&mirror->rw_cred, cred);
+				cred = xchg(&mirror->rw_cred, fls->mirror_array[i]->rw_cred);
 				rcu_assign_pointer(fls->mirror_array[i]->rw_cred, cred);
 			}
 			ff_layout_free_mirror(fls->mirror_array[i]);


