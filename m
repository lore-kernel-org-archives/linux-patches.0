Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3F01F7577;
	Tue, 17 Dec 2024 17:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455602; cv=none; b=pPnVTmFytjebPkJHnfbGTzRujKWEzjS4F6XSlbN+cxHK60xVJiQqcmdKIdIiNhfZSTMJr+TJkGli5N69urKBUnXM1WwkNqFhX0GELfVKeTI/KJRUbX1HL+GklS7PSeAdYYDAU1u5Y6+Z0SdcFpacTheXipN+0Zu+fWCAlG6BGtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455602; c=relaxed/simple;
	bh=vlo23bj0Bbqvg7lzEqxgyxOnvYhRjOHBG93xLUpY2Jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IeVp0Krzj9YRtmdUha3i4C0K6vpzAjzMwW2PJ7mCuAQ8gjXCZjsolYORlQ/2Lq2244d6UrX1FRe9iUJ1cJh/6DhIY6Y+1p3KSLwFCQboMVsY+RihEAolus/8i7vh9nlcOtjbvVkhBnWbL1rc+j8BHSTjG0HWABSaaJVgvE152aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K9KTgx6Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K9KTgx6Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45275C4CED3;
	Tue, 17 Dec 2024 17:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455601;
	bh=vlo23bj0Bbqvg7lzEqxgyxOnvYhRjOHBG93xLUpY2Jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K9KTgx6QAG/VF4TD1yxh9HLHNw9t51Oh5HlNMOhHC0G0zSBFXytLqVSRvSQPW0MYj
	 Tke05IYu1Oq7+Q5zPobmhq4S9hu7U2nzZPDqBLveSa4sdYrmo5zs+wa52O1uWvSgOQ
	 rEcBN0g+U2xOnffde+xTLnVxvr/VQZ63bSYMpTY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.15 14/51] xfs: fix scrub tracepoints when inode-rooted btrees are involved
Date: Tue, 17 Dec 2024 18:07:07 +0100
Message-ID: <20241217170520.888915508@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170520.301972474@linuxfoundation.org>
References: <20241217170520.301972474@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit ffc3ea4f3c1cc83a86b7497b0c4b0aee7de5480d upstream.

Fix a minor mistakes in the scrub tracepoints that can manifest when
inode-rooted btrees are enabled.  The existing code worked fine for bmap
btrees, but we should tighten the code up to be less sloppy.

Cc: <stable@vger.kernel.org> # v5.7
Fixes: 92219c292af8dd ("xfs: convert btree cursor inode-private member names")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/trace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -464,7 +464,7 @@ TRACE_EVENT(xchk_ifork_btree_error,
 	TP_fast_assign(
 		xfs_fsblock_t fsbno = xchk_btree_cur_fsbno(cur, level);
 		__entry->dev = sc->mp->m_super->s_dev;
-		__entry->ino = sc->ip->i_ino;
+		__entry->ino = cur->bc_ino.ip->i_ino;
 		__entry->whichfork = cur->bc_ino.whichfork;
 		__entry->type = sc->sm->sm_type;
 		__entry->btnum = cur->bc_btnum;


