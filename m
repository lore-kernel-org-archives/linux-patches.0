Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2B351B196;
	Wed, 30 Sep 2026 18:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792677; cv=none; b=T5V6b2km05zajBzXh3GtXq7Ediw3D1WMUt6IWEe6gZXW5UCPltp/9yst0LwsUcjEVGBWlh+kE0F8/0z8DtVh5BCc4k3VqSG3f9ab0fjvI9FuQqDFM3QTqntEpZ57nZomIc9sGJJL4928uiPFLpHzDLOxYCp46MVyIYWdVnQIoe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792677; c=relaxed/simple;
	bh=9weszvStBGEnalJGVzREHUapYsy5VFe7rLWG3EOLJVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MgycSUE7pS88C1KresDGzcjikwxN42GfoEytRxkhk4JkhosgPyu3OWkdrcRVB7e753q9oN6jgZV+2iqjEZRlsJFNb8HdjmgqUESaJIM5njPbGmPAXyWt3xV2hUGJZT7mkVd2fli7BoDJtDfgfh+mmsTvwCiJCUKIb8kyUl8k2QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tYSr/v/U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tYSr/v/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E8CE1F000FF;
	Wed, 30 Sep 2026 18:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792675;
	bh=8fp1oRzntI6WzQqK+9LrF9LCtkcpGeC5FNj3NpfhsYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tYSr/v/UuIRBh+osgIkZ4Q3wmQDmLqPgzPziqHZleymdHwOU3gmy94h2FRcx6D10J
	 KycTUhLDY+L6mXsBZ5M0vVx2nm7dkQXW9wLXrDNlXaJwoBJ4vxQ1C07sRxWZyLPD6K
	 MSxaffmHLkLk3qPd9asFEUJX+Gk7uSwzZZDPaHIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 738/752] net: tls: fix silent data drop under pipe back-pressure
Date: Wed, 30 Sep 2026 17:30:08 +0200
Message-ID: <20260930152414.187977829@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 7e7be31bfdb066c1c780dcd6b1224078fc54063f ]

tls_sw_splice_read() uses len when advancing rxm->offset / rxm->full_len
after skb_splice_bits(), rather than copied (the actual number of bytes
successfully spliced into the pipe). When the destination pipe cannot
accept all the requested bytes, splice_to_pipe() returns fewer bytes
than len, and 'len - copied' of data is effectively skipped over.

Fixes: e062fe99cccd ("tls: splice_read: fix accessing pre-processed records")
Link: https://patch.msgid.link/20260429222944.2139041-2-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 012ff6a496697..37e92d1386e2f 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2078,10 +2078,10 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 		ctx->recv_pkt = NULL;
 		__strp_unpause(&ctx->strp);
 	}
-	if (chunk < rxm->full_len) {
+	if (copied < rxm->full_len) {
 		__skb_queue_head(&ctx->rx_list, skb);
-		rxm->offset += len;
-		rxm->full_len -= len;
+		rxm->offset += copied;
+		rxm->full_len -= copied;
 	} else {
 		consume_skb(skb);
 	}
-- 
2.53.0



