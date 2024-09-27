Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0222136352;
	Fri, 27 Sep 2024 12:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440329; cv=none; b=lbRMaaHMCdPC8fkuHff20zVUtqVK267oW7qjCxW7Z3691w76tSiJHx0tZn1RsM9vE9sqC/kpTFCzbFTQ22euJG7kucGFoTuBUPPZUCdxCfc0VPYR+I/k4nVUMWW/RQyssc1wyX5Dtes3bc8MdVyb/2BvMg8yJVN7dsT1actGN0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440329; c=relaxed/simple;
	bh=4geJ6LqHYN6Whkg8FNULT+Ah5Y6CHPtQCUCkS+BpMoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pvcuylEWU1xd3jShWXb0GdB4/5PUcEOwyrPR8ttmK5Gsb0b76D5TrrT4DfECE34409dA3EKFJ4G9N+7lrRA8om1T4X8uZtH+TkW5vxl/I7jcZVspVF1RkXhVLtjPeqRylrrffo8R1zmg9USOY0bjh2xwQnL9ENo7j5FEMBXsZ3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nlMfwmDD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nlMfwmDD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207C7C4CEC4;
	Fri, 27 Sep 2024 12:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440328;
	bh=4geJ6LqHYN6Whkg8FNULT+Ah5Y6CHPtQCUCkS+BpMoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nlMfwmDDICYr9AtgpGxHqe5FmPXLYPrY64PpeMCDkhCugp/iO8ouss7B32sdSeDuD
	 9Un1msjWfzBDEPDhICPXXr7Y24PKPoj5z3ANzNu/YYjTVjbEby4JbG16q4QVGCgsjD
	 A+7+Iir9hzT62q+eG1VfzV1ON2/iw6GXr8L+quzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Dave Chinner <david@fromorbit.com>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 6.1 43/73] xfs: defered work could create precommits
Date: Fri, 27 Sep 2024 14:23:54 +0200
Message-ID: <20240927121721.677724672@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
References: <20240927121719.897851549@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit cb042117488dbf0b3b38b05771639890fada9a52 ]

To fix a AGI-AGF-inode cluster buffer deadlock, we need to move
inode cluster buffer operations to the ->iop_precommit() method.
However, this means that deferred operations can require precommits
to be run on the final transaction that the deferred ops pass back
to xfs_trans_commit() context. This will be exposed by attribute
handling, in that the last changes to the inode in the attr set
state machine "disappear" because the precommit operation is not run.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_trans.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -970,6 +970,11 @@ __xfs_trans_commit(
 		error = xfs_defer_finish_noroll(&tp);
 		if (error)
 			goto out_unreserve;
+
+		/* Run precommits from final tx in defer chain. */
+		error = xfs_trans_run_precommits(tp);
+		if (error)
+			goto out_unreserve;
 	}
 
 	/*


