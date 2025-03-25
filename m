Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F1C266B63;
	Tue, 25 Mar 2025 12:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905677; cv=none; b=jKXoeMJb9dc3z8xprRNI68qOhDFlFexkPEtgJ/Tt2n8Z560N9XoPqr/9xmSI0OBPDhIptQ4UjjgT6EPHRjMBg0A7OcIU58dDRjQmWk9RBx5f5e9jMhEfA2bQAsmopJRz4SAT7jvMz4ut8zU/V9qA9DR84RaQUYiLy+Uc3mdH2M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905677; c=relaxed/simple;
	bh=O0IA928cLXMNfQkfsU6Z+qgeyEqqZZ0QSS+nP3FGtQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RqFnGx08uuR9bKaNPWhOupkSX0KaAgXKBeDKLEALU1PJwkGJf2EsKuG1tR3wMiKHDVtUmzA8hWuoE1CDvnal9L9FEc55MKIrUL3MMOr0fOlzYGuAf9kpFl98zoIw+b2onYtFygR7H60zaQKRpaTTjbd/f4A8Dw0WbC/8dJOqz64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yT8LmCrX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yT8LmCrX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B095FC4CEE4;
	Tue, 25 Mar 2025 12:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905676;
	bh=O0IA928cLXMNfQkfsU6Z+qgeyEqqZZ0QSS+nP3FGtQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yT8LmCrXbHIW5R7vtE2Yil4yPVxCbbHw88VKSJrzJLbX9OS0eN09YScxhpGuilAx3
	 Kv1AOdTeyWBjkS1m5GM02uhAc4vtovBvCyzPin7mChPmR6BIn4ycaO3cJExG5fNrMr
	 xl7+q6AqNmsYrmWX/cVIgNCyOOhUMWuVdKYq+iFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Albershteyn <aalbersh@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 6.1 102/198] xfs: reset XFS_ATTR_INCOMPLETE filter on node removal
Date: Tue, 25 Mar 2025 08:21:04 -0400
Message-ID: <20250325122159.328590930@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

From: Andrey Albershteyn <aalbersh@redhat.com>

[ Upstream commit 82ef1a5356572219f41f9123ca047259a77bd67b ]

In XFS_DAS_NODE_REMOVE_ATTR case, xfs_attr_mode_remove_attr() sets
filter to XFS_ATTR_INCOMPLETE. The filter is then reset in
xfs_attr_complete_op() if XFS_DA_OP_REPLACE operation is performed.

The filter is not reset though if XFS just removes the attribute
(args->value == NULL) with xfs_attr_defer_remove(). attr code goes
to XFS_DAS_DONE state.

Fix this by always resetting XFS_ATTR_INCOMPLETE filter. The replace
operation already resets this filter in anyway and others are
completed at this step hence don't need it.

Fixes: fdaf1bb3cafc ("xfs: ATTR_REPLACE algorithm with LARP enabled needs rework")
Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_attr.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -421,10 +421,10 @@ xfs_attr_complete_op(
 	bool			do_replace = args->op_flags & XFS_DA_OP_REPLACE;
 
 	args->op_flags &= ~XFS_DA_OP_REPLACE;
-	if (do_replace) {
-		args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
+	args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
+	if (do_replace)
 		return replace_state;
-	}
+
 	return XFS_DAS_DONE;
 }
 


