Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3BA4188006;
	Mon, 23 Dec 2024 16:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970096; cv=none; b=PDvM/brziRu72Jzk+TjJiXdkQQ84A0wfrBHvAb/k6+t4m466TnP1lC26d7jZZ4861zE4nm1di6/o5HuYyVnfa2JKCLHME8pxixSQkXsOe6XGqgDi+5AFbSVFq5SajCA/YrSinJ08dvx++0J8//qTiG8EEJ/xwbjMNQCf13q5VFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970096; c=relaxed/simple;
	bh=4Wx6JgiVRniYesgNSOQY567nTN/Ec6FoOGcSxJEwexs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=blo35y9oABkcULMq6B+rZZAr3+yDCMgdxGu5XKs0cwgELoRzA+TMGLnKBCmgIiwik58sIBHxZo1p9Fwqo9pc1Sgyzp2SaWniBVvsYitVwwwPKMM7vXK6qxLTtgcvA3HLJb9cVXbhSpITfYTsv45Y0Ayj2fglGMMo2MnZcUwFuEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eP7k5SvC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eP7k5SvC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78CCBC4CED3;
	Mon, 23 Dec 2024 16:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970095;
	bh=4Wx6JgiVRniYesgNSOQY567nTN/Ec6FoOGcSxJEwexs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eP7k5SvCCVmtqC1xlHD8WUQPbggi/61ZH15ztM7iKWFNCrKoz8BNh4kDK45M8hFiy
	 uK8K7brkkAtc3O7MqlHyycuK0iVdXJ2ggWQaHaSEk1RIaaeuLpSNutT2YHb1hTgKPo
	 OoJvS2YGCApeDiauET/66ehlaiSE33DPOJmNweUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heming Zhao <heming.zhao@suse.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 142/160] ocfs2: fix the space leak in LA when releasing LA
Date: Mon, 23 Dec 2024 16:59:13 +0100
Message-ID: <20241223155414.287616782@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heming Zhao <heming.zhao@suse.com>

commit 7782e3b3b004e8cb94a88621a22cc3c2f33e5b90 upstream.

Commit 30dd3478c3cd ("ocfs2: correctly use ocfs2_find_next_zero_bit()")
introduced an issue, the ocfs2_sync_local_to_main() ignores the last
contiguous free bits, which causes an OCFS2 volume to lose the last free
clusters of LA window during the release routine.

Please note, because commit dfe6c5692fb5 ("ocfs2: fix the la space leak
when unmounting an ocfs2 volume") was reverted, this commit is a
replacement fix for commit dfe6c5692fb5.

Link: https://lkml.kernel.org/r/20241205104835.18223-3-heming.zhao@suse.com
Fixes: 30dd3478c3cd ("ocfs2: correctly use ocfs2_find_next_zero_bit()")
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/localalloc.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -971,9 +971,9 @@ static int ocfs2_sync_local_to_main(stru
 	start = count = 0;
 	left = le32_to_cpu(alloc->id1.bitmap1.i_total);
 
-	while ((bit_off = ocfs2_find_next_zero_bit(bitmap, left, start)) <
-	       left) {
-		if (bit_off == start) {
+	while (1) {
+		bit_off = ocfs2_find_next_zero_bit(bitmap, left, start);
+		if ((bit_off < left) && (bit_off == start)) {
 			count++;
 			start++;
 			continue;
@@ -998,6 +998,8 @@ static int ocfs2_sync_local_to_main(stru
 			}
 		}
 
+		if (bit_off >= left)
+			break;
 		count = 1;
 		start = bit_off + 1;
 	}


