Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 860FA35A930;
	Fri,  9 Jan 2026 12:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960488; cv=none; b=oxhhN6+5xZR8NYIIRlI0wSpPeXQtbdByUMgax3CFigOJJnOOe2f01fTt7NR4n1yF4tFTedZinMqCL+2JNcdc4mdFrHv86KAEQr0izwVTv/V5qTjx+2GNYKu7IqFlVO4qUIK+AmjqRxZcB9ypOfM14L6Z3u528mMY7+rKlV5dmoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960488; c=relaxed/simple;
	bh=vXX3wvBu27XZeI40LlZv/CaiEvZdLaxxVIS8M8U09Yw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/Mc7yllgzKW0WH47xeP0njU2eA04z+iS348kIor8b+u0zskaLQG/F02q2BBdfvOiFVuPtVz41H/4qSHJk/NNoi9crf6o/fRXOjowWBxYvzOuJMc4mNDwXSYaAPLyzYnetoh180h3+qX2YJB9y13oFBLSZhVj0iFrWk59KVV+98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I6577D8J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I6577D8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07628C16AAE;
	Fri,  9 Jan 2026 12:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960488;
	bh=vXX3wvBu27XZeI40LlZv/CaiEvZdLaxxVIS8M8U09Yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I6577D8JPqJyVr92UPW4Xcj65vnVyFBZGhGxHlbfJdGrR43Z06ytPyTMcnAQvi0Pb
	 GoCKRnCktC5JJDb4YqI5jIeazeO6QpjII6Tf1mUtWDIwvkj608fINc6Jct9hMFS6Qd
	 9GX/8IHedydTDE6A043/aN2B/5O6ALDYoy63gNvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.6 420/737] fs/ntfs3: fix mount failure for sparse runs in run_unpack()
Date: Fri,  9 Jan 2026 12:39:19 +0100
Message-ID: <20260109112149.794636763@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

commit 801f614ba263cb37624982b27b4c82f3c3c597a9 upstream.

Some NTFS volumes failed to mount because sparse data runs were not
handled correctly during runlist unpacking. The code performed arithmetic
on the special SPARSE_LCN64 marker, leading to invalid LCN values and
mount errors.

Add an explicit check for the case described above, marking the run as
sparse without applying arithmetic.

Fixes: 736fc7bf5f68 ("fs: ntfs3: Fix integer overflow in run_unpack()")
Cc: stable@vger.kernel.org
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/run.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/ntfs3/run.c
+++ b/fs/ntfs3/run.c
@@ -984,8 +984,12 @@ int run_unpack(struct runs_tree *run, st
 			if (!dlcn)
 				return -EINVAL;
 
-			if (check_add_overflow(prev_lcn, dlcn, &lcn))
+			/* Check special combination: 0 + SPARSE_LCN64. */
+			if (!prev_lcn && dlcn == SPARSE_LCN64) {
+				lcn = SPARSE_LCN64;
+			} else if (check_add_overflow(prev_lcn, dlcn, &lcn)) {
 				return -EINVAL;
+			}
 			prev_lcn = lcn;
 		} else
 			return -EINVAL;


