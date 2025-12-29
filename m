Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537A7330B2A;
	Mon, 29 Dec 2025 16:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025268; cv=none; b=WDpOUjeJ30RtOYiI+STuY+XNEwo4UfQTK+qnp50WNg0Rjle+RWR/qZkCqo1pNdCrum8RZnlkiVLpWz0HVrbQho+9/ieY0RnOUNVLCXLuNhuVyn6IQ8BOlq5wl07TVO6+/kBnbB2TZT0hLOpLsgx9lpldYYZQtbYNmlx6WpxGGD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025268; c=relaxed/simple;
	bh=r6k3JHPr+OnDPZ4M5C39uWPIGfYpgm7qQRSdM59dMwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k0flXgJ/4FYf+xtf8fXY2K13e7HrGDN1izhPA36yEfQPfWCAlt5hhIE76oQnenRSRM5vIDufIBG+9+wwhACzl/WGFzVIOgBHe0Y45s+vFJvn+Boiblq6R5pDAesvvnZecoRO6Cdv4I54yU03oniBVWPv4Wnf/9ki08jTfDQuCFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=csFPyO4n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="csFPyO4n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF5D9C4CEF7;
	Mon, 29 Dec 2025 16:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025268;
	bh=r6k3JHPr+OnDPZ4M5C39uWPIGfYpgm7qQRSdM59dMwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=csFPyO4nBc6qeHUIxRjPwZnQ7pn8u5hAq4TeLhziFFOP+8aqlrSE38haG9+2BpAj8
	 1GuWRX4odzOUy4gWDnbqIKNoDxNcYUwNGRWdiZ/kYwTHYnn9LFuXCc5bRvA4f1vYsE
	 cmkpQLnUdROiD1T5aJgdh1FAvJMnIQbeXl20csRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 153/430] xfs: dont leak a locked dquot when xfs_dquot_attach_buf fails
Date: Mon, 29 Dec 2025 17:09:15 +0100
Message-ID: <20251229160729.990155693@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit 204c8f77e8d4a3006f8abe40331f221a597ce608 upstream.

xfs_qm_quotacheck_dqadjust acquired the dquot through xfs_qm_dqget,
which means it owns a reference and holds q_qlock.  Both need to
be dropped on an error exit.

Cc: <stable@vger.kernel.org> # v6.13
Fixes: ca378189fdfa ("xfs: convert quotacheck to attach dquot buffers")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_qm.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1318,7 +1318,7 @@ xfs_qm_quotacheck_dqadjust(
 
 	error = xfs_dquot_attach_buf(NULL, dqp);
 	if (error)
-		return error;
+		goto out_unlock;
 
 	trace_xfs_dqadjust(dqp);
 
@@ -1348,8 +1348,9 @@ xfs_qm_quotacheck_dqadjust(
 	}
 
 	dqp->q_flags |= XFS_DQFLAG_DIRTY;
+out_unlock:
 	xfs_qm_dqput(dqp);
-	return 0;
+	return error;
 }
 
 /*


