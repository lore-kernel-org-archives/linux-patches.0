Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FCA8332A3A;
	Wed, 17 Sep 2025 12:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113805; cv=none; b=tMM82LYMLjKWwDcwl81ncQpTPNOJvj+RCEGTxwA0AkxX8JJO7+KdK/5ozyP3U2q9vnbr0Ff+CYAg8gv5RjsyAHwG3+CWdmwzvu5DOKQTgvAzcSwhViYS+SzjDFkw1BD/efwxjappV4gByueP/VtanMMo2bKVJBnhQY4RBi8SfjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113805; c=relaxed/simple;
	bh=6F3PON2DzhSXnsJNjGIQnHEcxsGloG+mwaRhz2MseAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OK7gITdNYJ/l6d8CJb03ITm+gBz4dvrmnEgC5hDmVQ5+d68FLV1HJbFTJVbLU/FNZYiSUbBezZaDzfOwE18S8ZeQrcb0f4fySHB3HLF1A+DW/QLBScVbDvvZ8VX3KVGHTV6JpZ3m806g8OJVPkVR49z1jeBSU9XbbypkcUD6ZjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HwIC+dvH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HwIC+dvH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F97C4CEF5;
	Wed, 17 Sep 2025 12:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113805;
	bh=6F3PON2DzhSXnsJNjGIQnHEcxsGloG+mwaRhz2MseAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HwIC+dvHovlMXNCD0djOdqX42XiUl9ZIQUzdtAsd8zytMWn6AngQF97c5cHhy3kQu
	 PJcq/8robTSjR2/UnkljZEbck1SH33ZWhqlt81u7oqDksZR9dQC/Oc4R1FxN2LPNfF
	 OI7N7nzB19vwXOOJTP4jfiD6LC5J24unwKoNoui4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Curley <jcurley@purestorage.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/101] NFSv4/flexfiles: Fix layout merge mirror check.
Date: Wed, 17 Sep 2025 14:34:04 +0200
Message-ID: <20250917123337.371249263@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Curley <jcurley@purestorage.com>

[ Upstream commit dd2fa82473453661d12723c46c9f43d9876a7efd ]

Typo in ff_lseg_match_mirrors makes the diff ineffective. This results
in merge happening all the time. Merge happening all the time is
problematic because it marks lsegs invalid. Marking lsegs invalid
causes all outstanding IO to get restarted with EAGAIN and connections
to get closed.

Closing connections constantly triggers race conditions in the RDMA
implementation...

Fixes: 660d1eb22301c ("pNFS/flexfile: Don't merge layout segments if the mirrors don't match")
Signed-off-by: Jonathan Curley <jcurley@purestorage.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/flexfilelayout/flexfilelayout.c b/fs/nfs/flexfilelayout/flexfilelayout.c
index b05dd4d3ed653..42c73c647a27f 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -276,7 +276,7 @@ ff_lseg_match_mirrors(struct pnfs_layout_segment *l1,
 		struct pnfs_layout_segment *l2)
 {
 	const struct nfs4_ff_layout_segment *fl1 = FF_LAYOUT_LSEG(l1);
-	const struct nfs4_ff_layout_segment *fl2 = FF_LAYOUT_LSEG(l1);
+	const struct nfs4_ff_layout_segment *fl2 = FF_LAYOUT_LSEG(l2);
 	u32 i;
 
 	if (fl1->mirror_array_cnt != fl2->mirror_array_cnt)
-- 
2.51.0



