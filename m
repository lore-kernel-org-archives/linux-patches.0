Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349651C32EB;
	Tue,  8 Oct 2024 13:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392534; cv=none; b=sCfhXkfM/4vXj+fpd46/sAuwofD645kiPf1VYwq25WDMnMtLTxLjc88t1fYrk4zFXhURnGpzbiPqke+mid+Bi8V+U0F8QGcv4mT1l18pex0Proe7aRPbIO+g2dba0wWeRWn+1m6f7V0pE+XT4qf9tS5jsLlbBrwM8NHarsQA6VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392534; c=relaxed/simple;
	bh=8pVTSQmzLtfV3UsTf+YP/gEaT2j+UkNxX9I8Iro6h3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ffT7rdcXQK6IpGKHHZuCoLf2Q621tnq9HJaVB4IUmmrxqwS1xDDSBuonvi1kmFzF28k/3nkvaLcqY0lfaUaaplAQQT8UFDo+UM9QSUHpU7+WyqkPNN9RaOtyMClGdFTnNmFnMDJcNQel42Gv+82w+9PcewRFafTibb+CJEeT+g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=thrWx/Df; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="thrWx/Df"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F152C4CEC7;
	Tue,  8 Oct 2024 13:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392533;
	bh=8pVTSQmzLtfV3UsTf+YP/gEaT2j+UkNxX9I8Iro6h3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=thrWx/DfOM+P6+RrcJm9+FRLUy3XlvA2FEpqiRghVYxxSiAaqki+QVRdCGBAXvFeT
	 CnWN4/CYCjqTzaGRz8dZAhyI0Yc3X9CBilzI7oAquu8jCrPFZWwvVsjIVHLhhOWMEe
	 YiKIk+dyq+niEie/J3B0I/BNBbwWBjKFFYlyg5SY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heming Zhao <heming.zhao@suse.com>,
	Su Yue <glass.su@suse.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Gang He <ghe@suse.com>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.11 412/558] ocfs2: fix the la space leak when unmounting an ocfs2 volume
Date: Tue,  8 Oct 2024 14:07:22 +0200
Message-ID: <20241008115718.487567321@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heming Zhao <heming.zhao@suse.com>

commit dfe6c5692fb525e5e90cefe306ee0dffae13d35f upstream.

This bug has existed since the initial OCFS2 code.  The code logic in
ocfs2_sync_local_to_main() is wrong, as it ignores the last contiguous
free bits, which causes an OCFS2 volume to lose the last free clusters of
LA window on each umount command.

Link: https://lkml.kernel.org/r/20240719114310.14245-1-heming.zhao@suse.com
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Su Yue <glass.su@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/localalloc.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -1002,6 +1002,25 @@ static int ocfs2_sync_local_to_main(stru
 		start = bit_off + 1;
 	}
 
+	/* clear the contiguous bits until the end boundary */
+	if (count) {
+		blkno = la_start_blk +
+			ocfs2_clusters_to_blocks(osb->sb,
+					start - count);
+
+		trace_ocfs2_sync_local_to_main_free(
+				count, start - count,
+				(unsigned long long)la_start_blk,
+				(unsigned long long)blkno);
+
+		status = ocfs2_release_clusters(handle,
+				main_bm_inode,
+				main_bm_bh, blkno,
+				count);
+		if (status < 0)
+			mlog_errno(status);
+	}
+
 bail:
 	if (status)
 		mlog_errno(status);


