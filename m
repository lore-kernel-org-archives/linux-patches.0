Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D75E4848B5;
	Thu, 17 Sep 2026 15:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660657; cv=none; b=Ui8tbNPZp4LnuCSTbxh9cx1/7Jfc+2Jd9NjGzgo0oCk9RcriYEucOfSBM/TzyACMTbFVoSp+S/jgVcEDVjlA30H+4bKxpmUtozgM9PO5tYewEki0X4qSJ4JLAXeOL2xDSb0154MONhVTtalwOpRAHqa3e6NXWu3VHhPOTLIZyyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660657; c=relaxed/simple;
	bh=j+W16nc4Xgj/STxbQEPfT2xwbgO10jZUoV2ZHmFFJFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bPfEwA45thLBWcCeKcl2GvUbuKw+juG/HiWUff2GIvIa+FYSX/6DvZC3EEi82IWJ/pWgNK6F16nimCYOiuu8yirHbqk2W5OxWavLQeV6cnubEiFENY7Bke0AfQeN6ta/7C8mqVsXN78QAJxXsNWMVqp/PzRSwQguehb2/hNo2lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WsVu8FS4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WsVu8FS4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C392F1F000FF;
	Thu, 17 Sep 2026 15:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660656;
	bh=U6H6U2T5Qc2jH8K3Ne78Zc9Y47oCUy14GVo+ECS8VLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WsVu8FS4eZ+bQTsGmkObukcjim/jBLB6/Sv3aD0udocLnlYjmuGL8RLrvEgC6PGfR
	 2baZ4RkQVO0+AHv5YOvTJ9W8VX4cXvswAyH3gXgLPIZxf89fnwNJINJmm7uOSM8D82
	 3Nqfm9GmvxY7ih+6b6k+WGjMHQhRMNYFP3mNjeVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 658/733] xfs: fix unit conversions in per_binval computation
Date: Thu, 17 Sep 2026 16:16:06 +0100
Message-ID: <20260917151409.059914752@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 05cff7c2b79f76c7cfe90613a60e16aaaa051ef7 upstream.

LOLLM noticed that we're doing the unit conversion in the per_binval
computation backwards -- xfs_buf_inval_log_space's second parameter is
supposed to be in bytes, but max_binval is in units of fsblocks.  Hence
the conversion should be FSB -> B, not the other way around.

Cc: stable@vger.kernel.org # v6.18
Fixes: b2311ec6778fcd ("xfs: compute per-AG extent reap limits dynamically")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/reap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -601,7 +601,7 @@ xreap_configure_agextent_limits(
 
 	/* Maximum overhead of invalidating one buffer. */
 	const unsigned int	per_binval =
-		xfs_buf_inval_log_space(1, XFS_B_TO_FSBT(mp, max_binval));
+		xfs_buf_inval_log_space(1, XFS_FSB_TO_B(mp, max_binval));
 
 	/*
 	 * For each transaction in a reap chain, we can delete some number of
@@ -680,7 +680,7 @@ xreap_configure_agcow_limits(
 
 	/* Overhead of invalidating one buffer */
 	const unsigned int	per_binval =
-		xfs_buf_inval_log_space(1, XFS_B_TO_FSBT(mp, max_binval));
+		xfs_buf_inval_log_space(1, XFS_FSB_TO_B(mp, max_binval));
 
 	/*
 	 * For each transaction in a reap chain, we can delete some number of


