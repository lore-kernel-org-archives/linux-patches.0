Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7C134A793;
	Tue,  6 Jan 2026 17:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720424; cv=none; b=po5+ATRKGGT0oWz6NLx377HsGHkcv+D/3L7igYSbaDTaBsMXmOiGOzh/6vsEnhAg3T640hG3ydMwDL6oWaiXQyFPRnOJsCl8imCMSBxpOMbtI681HjXDvForJDzpeHgrHwUacvKOFU4RnXFSzu2rNzInQC8tXb7ekyvRgFzqU8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720424; c=relaxed/simple;
	bh=sP3Ue+h1ZeH2SpphQp6JPH+JrlpmbHSlbIvZPeiW8cQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IR/y/HJACN1Npuz4Sz5dWyIvIftR5BsY+PRf51dUUW6NBctWyiUglHRGmdWzaghBMh9fUeMqXY/vnOyDhNjzkb//bYq9peNnPdqVA6Z4ZSCoeTK1SHKb5D5SpuqilCAPszlNgKYBwGOksXdJPi5Sy2SoJX/aj6y7gFESKRX/Yk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qrfHpons; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qrfHpons"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F515C116C6;
	Tue,  6 Jan 2026 17:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720423;
	bh=sP3Ue+h1ZeH2SpphQp6JPH+JrlpmbHSlbIvZPeiW8cQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qrfHponsaR3GT3xLQdYQ7FEtnQRxdVnW5X1vveMpDotqpYzOZEjHlfp8r8FuMw/tZ
	 IAw+qg7JNzVcpchnt+3G+96SYsrNYdNOxPeGq7/3grvja7YrKjEtE5c02hI5LzGR95
	 0zlAeuoKznbdTEJljNv48T4znQbeZRyAvmKvRTDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 232/567] xfs: fix a UAF problem in xattr repair
Date: Tue,  6 Jan 2026 18:00:14 +0100
Message-ID: <20260106170459.895096287@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

commit 5990fd756943836978ad184aac980e2b36ab7e01 upstream.

The xchk_setup_xattr_buf function can allocate a new value buffer, which
means that any reference to ab->value before the call could become a
dangling pointer.  Fix this by moving an assignment to after the buffer
setup.

Cc: stable@vger.kernel.org # v6.10
Fixes: e47dcf113ae348 ("xfs: repair extended attributes")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/attr_repair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index c7eb94069caf..09d63aa10314 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -333,7 +333,6 @@ xrep_xattr_salvage_remote_attr(
 		.attr_filter		= ent->flags & XFS_ATTR_NSP_ONDISK_MASK,
 		.namelen		= rentry->namelen,
 		.name			= rentry->name,
-		.value			= ab->value,
 		.valuelen		= be32_to_cpu(rentry->valuelen),
 	};
 	unsigned int			namesize;
@@ -363,6 +362,7 @@ xrep_xattr_salvage_remote_attr(
 		error = -EDEADLOCK;
 	if (error)
 		return error;
+	args.value = ab->value;
 
 	/* Look up the remote value and stash it for reconstruction. */
 	error = xfs_attr3_leaf_getvalue(leaf_bp, &args);
-- 
2.52.0



