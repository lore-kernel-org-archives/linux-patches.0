Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061629;
	b=NXPgfN0AUGWcqi/GCZ+VrVo4lC2hr7MigkkRdg4+4BJ1ukfOI+UUGGBXjrTfDHWt5F08
	 EnV8atwbfujGnYRw0xFFcNNYwhH/NScOER8J75O59fY9unXtf1jJ4LerDHEHArbogvs61
	 5sUt7F8rQltHsC4bd9Q7NBDptxxiXQWUFl2bINhyLLKtgqlDjPoQ/mAIT8LKOZX5trg9k
	 HyIDH0jKM0fFS0juQufOfVc17rwD6+HATZvd2REXxg745M8jBhdg7FFFlX5GveUUtS7nM
	 N1CmQNV0lD004nS/WHAIn/3/du4XvmZ0wZjUzhiNiup9nOtNleXC8QHzRS/7UWC983g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061629;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LmachH/xOCRFlDaBcZxp6wI14q0AVWxBCrcSH/FHGxg=;
	b=CUtd7oywlX2djrauMJqJ50cJbbIYkV2Vzgensq4YNnxIvEjfwNnZyB1SnlH1j8fztcRD
	 N/y1wCHS+yRdQIQIKBycpdDSp5cLr6GpXw+g6OxkpPSiJPf2nwtvZDj+wt3AQrZx3ezF3
	 1w3tSvd+aLIi7Y8c8q/kW4mFnWkYxeJsB4lC0+GkyWE/kBZoFsOUJJGZ0sk/ufdSr1aj9
	 fi8pwlP4n5qy2gudQGoYELQASvLKpXSX6h8xJkg2FNoWhtidoJQML8qOMIY3di65iUg5R
	 QYyDUmXzFJt+kvHw+AdoTiKc9b5tyDgOrIhhQyip3g/69fIrqaDnK73EBbCgAJEiP5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="B/d36fXR";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78B7606A330;
	Sat,  7 Nov 2026 14:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B/d36fXR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 747361F00900;
	Sat,  7 Nov 2026 14:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061628;
	bh=LmachH/xOCRFlDaBcZxp6wI14q0AVWxBCrcSH/FHGxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B/d36fXRzmGwLVyACUtcBEMhC9l8dcPhahLJbELxF8Sx+ysTWfYjRVNc8wQ+Ahh53
	 8L5mMBWUXlOBiQVmNc8Pj59SvYFN9f5RR2WN0e+KbtiKQO9/W2HklTYsfFdhmrA86L
	 mPuHJ2YzTEZVUHGM+IAU9Puov6KA/ktYlA6NUk8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0694/1536] xfs: fix unnecessary dapos truncation in xchk_dir_walk
Date: Sat,  7 Nov 2026 08:45:10 -0500
Message-ID: <20261107135016.982727714@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit f60a2ef8d8a7ac6dedf4d0c3325cc3fc2fe0d948 upstream.

LOLLM points out that the all the implementations of xchk_dirent_fn can
handle a signed @dapos parameter, so the truncation here breaks the
information captured in scrub tracepoints if the directory is very
large.  I don't think it ever made sense to do the truncation for the
VFS readdir code for programs that can handle 64-bit offsets, but commit
15440319767942 has been around for 17 years without complaints so I'll
leave that alone.

Stumbled-over: 15440319767942 ("[XFS] truncate readdir offsets to signed 32 bit values")
Cc: stable@vger.kernel.org # v6.4
Fixes: 4c233b5c4f29df ("xfs: streamline the directory iteration code for scrub")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/readdir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/readdir.c
+++ b/fs/xfs/scrub/readdir.c
@@ -238,7 +238,7 @@ xchk_dir_walk_leaf(
 		dep = bp->b_addr + offset;
 		length = xfs_dir2_data_entsize(mp, dep->namelen);
 
-		dapos = xfs_dir2_byte_to_dataptr(curoff) & 0x7fffffff;
+		dapos = xfs_dir2_byte_to_dataptr(curoff);
 		ino = be64_to_cpu(dep->inumber);
 		name.name = dep->name;
 		name.len = dep->namelen;


