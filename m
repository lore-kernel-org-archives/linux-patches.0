Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD9F50E5A6;
	Thu, 17 Sep 2026 17:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666361; cv=none; b=TN2IgRK74rDxdQY5E1jRIyaGB6KbejmVQwKr/mPnBETmvNHSaXRfbEUOYnAf6Qv1FI4FmkX1nkmrpSpqh6NWihHCaTH5HOPpZ7I4BlEVAZWdDfrRgnOaGNlo684pJWiPGRKX4tg7nDrCJ1F74HP7OetsWlQO9AEvcD04eNlMtG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666361; c=relaxed/simple;
	bh=gIIyW/gk5Qq/AUgdvWg7Lnrl6AU9uh57eLDu64+GxlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TstqOMqm2rNcJQm9L+QzIjvQWMPfvMtUeUOO7yAk773mTBlYIbL9s8E6sKzw2BPndLwRIFfH7GWCo/p9vIBsFT2sIevbytyI/DFba+iCLxKxo+VEIm9hM6sHSd+8AoceM1KdXOot/TPwcUr30dU9zRG9qrt6rZ0vSzUzYodr304=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rlScuTzo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rlScuTzo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C15B1F000FF;
	Thu, 17 Sep 2026 17:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666360;
	bh=5txZgQaqQ22zMeouCh5vxBUknShzZwW9Xnz61FAY6I0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rlScuTzo3NfORpXP5gBQJeYHRP9MzxrNb0hP2BdAJhh9yOn8pMdrA3TdSAN2hOymz
	 HoDqxdx9WWEMHvbSh6FTyGG8r9hjTwZOdu8CNfZYHep/j9Z7Ydd0ioyRT0DaUUnIwR
	 yG8gaQhfIG4zJQtrDGuB+V71vKh1OPfjWfWR+dDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 1010/1250] io_uring/net: let io_recv_buf_select return the length of the buffer region
Date: Thu, 17 Sep 2026 16:13:25 +0100
Message-ID: <20260917151619.423687692@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Krisman Bertazi <krisman@suse.de>

commit dcbd1c054848848a1937ca0768ce2bdbc31ae621 upstream.

In preparation to using this field as an upper limit to truncation,
return the size of the allocated region.

Fixes: ae98dbf43d75 ("io_uring/kbuf: add support for incremental buffer consumption")
Cc: stable@vger.kernel.org
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
Link: https://patch.msgid.link/20260902230041.1320658-2-krisman@suse.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1107,6 +1107,7 @@ static int io_recv_buf_select(struct io_
 			      struct io_br_sel *sel, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
+	size_t len;
 	int ret;
 
 	/*
@@ -1152,13 +1153,14 @@ static int io_recv_buf_select(struct io_
 		/* special case 1 vec, can be a fast path */
 		if (ret == 1) {
 			sr->buf = arg.iovs[0].iov_base;
-			sr->len = arg.iovs[0].iov_len;
+			len = sr->len = arg.iovs[0].iov_len;
 			goto map_ubuf;
 		}
 		iov_iter_init(&kmsg->msg.msg_iter, ITER_DEST, arg.iovs, ret,
-				arg.out_len);
+			      arg.out_len);
+		len = arg.out_len;
 	} else {
-		size_t len = sel->val;
+		len = sel->val;
 
 		*sel = io_buffer_select(req, &len, sr->buf_group, issue_flags);
 		if (!sel->addr)
@@ -1172,7 +1174,7 @@ map_ubuf:
 			return ret;
 	}
 
-	return 0;
+	return len;
 }
 
 int io_recv(struct io_kiocb *req, unsigned int issue_flags)


