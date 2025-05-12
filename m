Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADC91519B8;
	Mon, 12 May 2025 18:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072870; cv=none; b=i8M1drLSjJyA6XgaZOCGaWw7RZ08zftmUlwkumavBx2qwnC6tqW4YqcarWcAeGfduBKFUnM6hZ2bWKCJmB7CflRkLwKENwwG6T67YvQdXGhBj0qmrkBKYpwekUCf7Ncj/AUVPSrMOmNr/GrtsC8fZd4+P/+tQudAHCznnuKbLGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072870; c=relaxed/simple;
	bh=5+glFYPIAiXX1JK3E1YckSiQwTVIGQ8EO8jwJFL6cwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GbnVU2rCJvKyOVTFTVoefNK7ouhvAeOg5icz9JmXrLO0fBRohkLCRiyHMO4OshOsz9yyq/qJtFuA//8ztahe10ORF1SFHNgX+g3tnVfw3pnOoeMQYWg2T1R1G6aqONKpoUEeoKcQlqdXh+TXhhqxQqct6o8MqECe13ZpoftHGT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hrTCv+fd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hrTCv+fd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42165C4CEE7;
	Mon, 12 May 2025 18:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072870;
	bh=5+glFYPIAiXX1JK3E1YckSiQwTVIGQ8EO8jwJFL6cwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hrTCv+fd617xuod8bINXwYWkKXr7M6Z4cn2TFZ9HN30CtJ/oXs4O+MQdvxyYmxvF2
	 xAyH1UK6ke+zroGZweozVIEOwpd2Cx50eRMzvO+YrT//yZuW2XZinqy1oJCOWPzkQe
	 xHEI6lsCxeBurbKsq5iTjELuCDgQg+3Zy2fglTv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norman Maurer <norman_maurer@apple.com>,
	Christian Mazakas <christian.mazakas@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 081/184] io_uring: ensure deferred completions are flushed for multishot
Date: Mon, 12 May 2025 19:44:42 +0200
Message-ID: <20250512172045.122383373@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit 687b2bae0efff9b25e071737d6af5004e6e35af5 upstream.

Multishot normally uses io_req_post_cqe() to post completions, but when
stopping it, it may finish up with a deferred completion. This is fine,
except if another multishot event triggers before the deferred completions
get flushed. If this occurs, then CQEs may get reordered in the CQ ring,
as new multishot completions get posted before the deferred ones are
flushed. This can cause confusion on the application side, if strict
ordering is required for the use case.

When multishot posting via io_req_post_cqe(), flush any pending deferred
completions first, if any.

Cc: stable@vger.kernel.org # 6.1+
Reported-by: Norman Maurer <norman_maurer@apple.com>
Reported-by: Christian Mazakas <christian.mazakas@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -884,6 +884,14 @@ bool io_req_post_cqe(struct io_kiocb *re
 	struct io_ring_ctx *ctx = req->ctx;
 	bool posted;
 
+	/*
+	 * If multishot has already posted deferred completions, ensure that
+	 * those are flushed first before posting this one. If not, CQEs
+	 * could get reordered.
+	 */
+	if (!wq_list_empty(&ctx->submit_state.compl_reqs))
+		__io_submit_flush_completions(ctx);
+
 	lockdep_assert(!io_wq_current_is_worker());
 	lockdep_assert_held(&ctx->uring_lock);
 


