Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB07C328610;
	Tue, 16 Jun 2026 17:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629508; cv=none; b=eAh/dCVK5Tp47xH/vdq8xTttqnykhWmf+KmLdxpOCplTm0zr/UJx4VSR7HXvVgDHUHWJQr7BQ8fCvKRRjL5kAqMlTxpFm4ZIGsFGEFVYjrpw9cQAi9nJrWeOtXMaJrV6KCc21Ei69g8kjWi8BS3bq8LNV5qiP/C8pJSHffxQuIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629508; c=relaxed/simple;
	bh=SocGJtAoHKQYDQFKzPsJyXVPQexSVoYk+HMRbBECJwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kgXhLG3laP0hHMBFM1uJGRhTsFVA+nCTVLqA0q1mhqYv7+vnHwfD3pcdIjaWJJq84FXK54BJqsHnpD18OEBa53i7Ey8zN1VMEiHIfk5U83JYRxY5lG/q6+stLGcw6HuIEFCL7EvPATaHtyXRMT3vtEZhnblZsDbdHTIzFRab54I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j7qnaj1p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j7qnaj1p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E79B21F000E9;
	Tue, 16 Jun 2026 17:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629507;
	bh=ijOeorgJCfDCwJ9UH1AEf0V1uNIBgppCXzM2EqZfT9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j7qnaj1pM/d3uTR7c0ujl2Jrs8Mp4bscbe3yV7Mh1Exd9w05hVDa4w7YxE3Wicdr2
	 9YzGU+R0etL/Au7ZRrsy/hnjlz0rK/wErgoEoWlaXXkYaLVSVET8dL+JgNQ/b+mQQf
	 ON+TrAMeOu4DxxcgeLVcmH1LkzHGCM7XL5/Ku2wU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Wyatt Feng <bronzed_45_vested@icloud.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 6.6 299/452] xfrm: espintcp: do not reuse an in-progress partial send
Date: Tue, 16 Jun 2026 20:28:46 +0530
Message-ID: <20260616145133.230058832@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

From: Wyatt Feng <bronzed_45_vested@icloud.com>

commit c381039ade2e161ab08c0eda73c4f8b9a7115928 upstream.

espintcp keeps a single in-flight transmit in ctx->partial.
Before building a new sk_msg, espintcp_sendmsg() first tries to flush
that state through espintcp_push_msgs().

For blocking callers, espintcp_push_msgs() may return success even when
the previous partial send is still pending. espintcp_sendmsg() would
then reinitialize emsg->skmsg and reuse ctx->partial while the old
transfer still owns that state.

Do not rebuild the send message when ctx->partial is still in progress.
If espintcp_push_msgs() returns with emsg->len still set, fail the new
send instead of overwriting the live partial state.

This is a memory-safety fix: reusing the live partial-send state can
leave a stale offset attached to a new sk_msg and lead to an out-of-
bounds read in the send path.

tcp_sendmsg_locked() already handles waiting for send buffer memory, so
the fix here is just to preserve espintcp's one-message-at-a-time
transmit state.

Fixes: e27cca96cd68 ("xfrm: add espintcp (RFC 8229)")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Assisted-by: Codex:GPT-5.4
Signed-off-by: Wyatt Feng <bronzed_45_vested@icloud.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/espintcp.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/xfrm/espintcp.c
+++ b/net/xfrm/espintcp.c
@@ -347,6 +347,10 @@ static int espintcp_sendmsg(struct sock
 			err = -ENOBUFS;
 		goto unlock;
 	}
+	if (emsg->len) {
+		err = -ENOBUFS;
+		goto unlock;
+	}
 
 	sk_msg_init(&emsg->skmsg);
 	while (1) {


