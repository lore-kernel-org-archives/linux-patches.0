Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099C6331A63;
	Wed,  3 Dec 2025 15:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777157; cv=none; b=UEPw5Ah8BRPk+skziNaYn4hO1oYH3GgM7bSNGQY+XO3dw1gsy8WDXssdQqlgmk8bOH+ePgPTda8ilB7B7g1pkVBQVtB4+CET4+BFkp9j4Fdav17yFMLTTs1syRYjVt8nq/WPEFzk0qJmv5Wj5HYmHzhRRV2LkgdalJ5ol20v+qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777157; c=relaxed/simple;
	bh=LJBRUIvwVWxexZ0tJkQUTRq37fRoZLPfdXdMzNKiLQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OnJMF2Otu2ioGUSGQD0VS31+T7JuitoOFVYsbI6rt5WcbRkup+8RKEfHo8K9o4wyXqninAqcTsaHe0MRZoDJ/MQoNDu18Nq0PpEAlOiRd/ECKEcaSwr8LYZDa440AOlRzzCZwaliBFpjeko+p7pPZlagwtgD9xjh+lkIW/kSH6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=acFJ/D2u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="acFJ/D2u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B63C4CEF5;
	Wed,  3 Dec 2025 15:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777156;
	bh=LJBRUIvwVWxexZ0tJkQUTRq37fRoZLPfdXdMzNKiLQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=acFJ/D2uzt6cHEExdfAaMIjgNPobgy0y1K4RsnH9oiVBPDspvDrA16QuaK1Z7Ie2o
	 lZoLBbC1eiC1WKGtUcwT+2TeUP24TgImnfGaFwspkbtENGu+59NO3HlcX5vv53VJm2
	 qhjZpv4kuYLYhB5JVP9CF4WIDH8Zd227M3n0VRKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Google Big Sleep <big-sleep-vuln-reports+bigsleep-463332873@google.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.17 099/146] io_uring/net: ensure vectored buffer node import is tied to notification
Date: Wed,  3 Dec 2025 16:27:57 +0100
Message-ID: <20251203152350.083573787@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit f6041803a831266a2a5a5b5af66f7de0845bcbf3 upstream.

When support for vectored registered buffers was added, the import
itself is using 'req' rather than the notification io_kiocb, sr->notif.
For non-vectored imports, sr->notif is correctly used. This is important
as the lifetime of the two may be different. Use the correct io_kiocb
for the vectored buffer import.

Cc: stable@vger.kernel.org
Fixes: 23371eac7d9a ("io_uring/net: implement vectored reg bufs for zctx")
Reported-by: Google Big Sleep <big-sleep-vuln-reports+bigsleep-463332873@google.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1542,8 +1542,10 @@ int io_sendmsg_zc(struct io_kiocb *req,
 		unsigned uvec_segs = kmsg->msg.msg_iter.nr_segs;
 		int ret;
 
-		ret = io_import_reg_vec(ITER_SOURCE, &kmsg->msg.msg_iter, req,
-					&kmsg->vec, uvec_segs, issue_flags);
+		sr->notif->buf_index = req->buf_index;
+		ret = io_import_reg_vec(ITER_SOURCE, &kmsg->msg.msg_iter,
+					sr->notif, &kmsg->vec, uvec_segs,
+					issue_flags);
 		if (unlikely(ret))
 			return ret;
 		req->flags &= ~REQ_F_IMPORT_BUFFER;


