Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84170745E1;
	Tue, 23 Jan 2024 02:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975456; cv=none; b=iZA7KElQU+pHRYF7UjlVgsHu9C7NV+vZj1+cEBQciNVW3S28y4CPGirVQQpbLW457LNJUp39XISGtwUJdIw6FMXW1YmfCC9OmELAqG5PzywBJqU6zjyFJMOA/rJ01TJcaOoGujNF23LevNXVuUiU7kdKntUUqpadJAOvSBLzs2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975456; c=relaxed/simple;
	bh=M4oDbmg97T14C2cjrqb/BirNF3JBnT3AVMlOXdwK7B4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qRl2f1fowmRMZztvLfjvRbaF2T2437MeGSLrdmQUqVu067XaHIrLRx5szBAE2AmvWYqn/m8rUibBntXr+8ztdlFpEJCwhRYYm6SQsqAiiD3LBHkEL1ch82ecM9PQRentEZ0Se2QrHokvDDM6I3AmFDfmHqdx06G2696/2StDEuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w/6tlpds; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w/6tlpds"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D915C433F1;
	Tue, 23 Jan 2024 02:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975456;
	bh=M4oDbmg97T14C2cjrqb/BirNF3JBnT3AVMlOXdwK7B4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w/6tlpdssUdBQJ4pd/Rq06SGOqvBYP6SDhqgiRv7mMTCMMqy93CF5HD/vldXnv2Pt
	 7ELBhi21ajMUWX48pOKoZQkXNy99dS2X9aIb3a+A5rVbHR8sTG+H7tDtzVCqc6bvI3
	 Hst7JreHmxGgTBBSg7j+IUSNb9zBoDAr8NNTUldk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 388/583] io_uring: dont check iopoll if request completes
Date: Mon, 22 Jan 2024 15:57:19 -0800
Message-ID: <20240122235823.863631824@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit 9b43ef3d52532a0175ed6654618f7db61d390d2e upstream.

IOPOLL request should never return IOU_OK, so the following iopoll
queueing check in io_issue_sqe() after getting IOU_OK doesn't make any
sense as would never turn true. Let's optimise on that and return a bit
earlier. It's also much more resilient to potential bugs from
mischieving iopoll implementations.

Cc:  <stable@vger.kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/2f8690e2fa5213a2ff292fac29a7143c036cdd60.1701390926.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1891,7 +1891,11 @@ static int io_issue_sqe(struct io_kiocb
 			io_req_complete_defer(req);
 		else
 			io_req_complete_post(req, issue_flags);
-	} else if (ret != IOU_ISSUE_SKIP_COMPLETE)
+
+		return 0;
+	}
+
+	if (ret != IOU_ISSUE_SKIP_COMPLETE)
 		return ret;
 
 	/* If the op doesn't have a file, we're not polling for it */


