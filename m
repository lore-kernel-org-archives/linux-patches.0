Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909C21EB5A;
	Mon,  4 Mar 2024 21:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588544; cv=none; b=DqdFQ8kX+YrTmrxcaTy4cokX1Q1elNJmXXrPvKfsxgl6GikKmgj3rX9gAvXPAEBE8MOrLmxlI60s+j+GeTgvI51vZkVs86oAXjBi6iOrNlOykqnOwDwm9MQK44w0Mj9ylv1rQkewGQa0epUiuxF4Qu9YmHBbKZFKUEYEh+Ls0UA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588544; c=relaxed/simple;
	bh=KPYmoPK8mjAOoMiaD1RcoG0DkkbIgpptzJCw1HHnnog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vGOVoPnq/SU8SmYssBVd9vKmXI/QYj41Nhcbwni5Cm3i/qHcrZBvfECU6y76X3Yoff120FwD+bDQnkzBwvC3poyUWLfuPT7eg0CNt9cCNufEbhw/ckzpoEWNUuwA7qc2rwuuiMtjyI2V7G+xr13a4iTAhZZpjU8aDukG1xroVyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZybFAmOD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZybFAmOD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22D80C433F1;
	Mon,  4 Mar 2024 21:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588544;
	bh=KPYmoPK8mjAOoMiaD1RcoG0DkkbIgpptzJCw1HHnnog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZybFAmOD5U/DvYDR2Dmn7SlmG5sRs248vOisGJeZCVXxL2mBwQd5W9qxXMFTI+xu/
	 VxFx0b7lI9jPjIPhGKYQ7Mha0Y5TVzN5ZD8XtxX9hRoINnsT6+zu56at2883Tl/fH1
	 fxc3Jr9PDdhBh+G9AibVK4o4JNCoMhKFwoQpkzUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ming Lei <ming.lei@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 132/143] block: define bvec_iter as __packed __aligned(4)
Date: Mon,  4 Mar 2024 21:24:12 +0000
Message-ID: <20240304211554.127282606@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 7838b4656110d950afdd92a081cc0f33e23e0ea8 ]

In commit 19416123ab3e ("block: define 'struct bvec_iter' as packed"),
what we need is to save the 4byte padding, and avoid `bio` to spread on
one extra cache line.

It is enough to define it as '__packed __aligned(4)', as '__packed'
alone means byte aligned, and can cause compiler to generate horrible
code on architectures that don't support unaligned access in case that
bvec_iter is embedded in other structures.

Cc: Mikulas Patocka <mpatocka@redhat.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Fixes: 19416123ab3e ("block: define 'struct bvec_iter' as packed")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bvec.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index 555aae5448ae4..bd1e361b351c5 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -83,7 +83,7 @@ struct bvec_iter {
 
 	unsigned int            bi_bvec_done;	/* number of bytes completed in
 						   current bvec */
-} __packed;
+} __packed __aligned(4);
 
 struct bvec_iter_all {
 	struct bio_vec	bv;
-- 
2.43.0



