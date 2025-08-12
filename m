Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F572FDC53;
	Tue, 12 Aug 2025 18:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024919; cv=none; b=II7vlkykOFzRGba1O2qWXziNwlOl123BbM18b6h9AeKBqzLlaNjcBCWbrF2cVKC3RAIFXCc+EMYh4bAmhNqPvhGEaaRxWDalRC7tS62g4q207wj8qvMUS+E8BTtjwAqq9S4X9E/NgBWiBmUti7y21CRD/x4Vlm0tsmUPnPMOoNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024919; c=relaxed/simple;
	bh=nL6C73CUmffAm2JAeb7wgE/cHhN4Gqiaqrr1tMqXlpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WMdZ5ZR3W3YgvJQs30OIfV/cwqod9vFukNBXjrTUKiImuwAQnwqjU/kFzZVL5Uaj8hVDICOhZLBdjF2cK3I2v4qSgKxfKM3PbwCv/RDUm+0vDmuKneKk9g6+KUAd+lx6P94uzp/hu+odj168FB9+UQOKVfevEiCwJway7D45wFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lLGxDnZs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lLGxDnZs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23693C4CEF1;
	Tue, 12 Aug 2025 18:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024919;
	bh=nL6C73CUmffAm2JAeb7wgE/cHhN4Gqiaqrr1tMqXlpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lLGxDnZs1Vh/g/DHSdDzOi1lUhfKnC8wyNe0pSQWUmRrbgSAutYCspv90ePQCF83A
	 +oTrljFxBG9yuwQ4WRLZNjU4TByqbh4hdisxcP/YjNeRanLf5rPEZgF9WsgxRjP5+a
	 FPpTRVg70UeJgFB7Z6H5twbyfAh270BDSb/3tYTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Luczaj <mhal@rbox.co>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 515/627] kcm: Fix splice support
Date: Tue, 12 Aug 2025 19:33:30 +0200
Message-ID: <20250812173450.033873658@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Luczaj <mhal@rbox.co>

[ Upstream commit 9063de636cee235bd736ab3e4895e2826e606dea ]

Flags passed in for splice() syscall should not end up in
skb_recv_datagram(). As SPLICE_F_NONBLOCK == MSG_PEEK, kernel gets
confused: skb isn't unlinked from a receive queue, while strp_msg::offset
and strp_msg::full_len are updated.

Unbreak the logic a bit more by mapping both O_NONBLOCK and
SPLICE_F_NONBLOCK to MSG_DONTWAIT. This way we align with man splice(2) in
regard to errno EAGAIN:

   SPLICE_F_NONBLOCK was specified in flags or one of the file descriptors
   had been marked as nonblocking (O_NONBLOCK), and the operation would
   block.

Fixes: 5121197ecc5d ("kcm: close race conditions on sk_receive_queue")
Fixes: 91687355b927 ("kcm: Splice support")
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Link: https://patch.msgid.link/20250725-kcm-splice-v1-1-9a725ad2ee71@rbox.co
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/kcm/kcmsock.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 24aec295a51c..c05047dad62d 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -19,6 +19,7 @@
 #include <linux/rculist.h>
 #include <linux/skbuff.h>
 #include <linux/socket.h>
+#include <linux/splice.h>
 #include <linux/uaccess.h>
 #include <linux/workqueue.h>
 #include <linux/syscalls.h>
@@ -1030,6 +1031,11 @@ static ssize_t kcm_splice_read(struct socket *sock, loff_t *ppos,
 	ssize_t copied;
 	struct sk_buff *skb;
 
+	if (sock->file->f_flags & O_NONBLOCK || flags & SPLICE_F_NONBLOCK)
+		flags = MSG_DONTWAIT;
+	else
+		flags = 0;
+
 	/* Only support splice for SOCKSEQPACKET */
 
 	skb = skb_recv_datagram(sk, flags, &err);
-- 
2.39.5



