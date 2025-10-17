Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B3A2745E;
	Fri, 17 Oct 2025 15:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714591; cv=none; b=kuVqr014HzDB8iBl3ZVG+JUpoR87Ai2CZqPFBPOrf96FlOwyNj1Nu4a6WGLrXvA59qJLXMYpxeDs/p2xl5jES7grbSgAMnc+dKvaVJQUwfk6++E/aawj/lYURW5I+gOzG2Yk5NEgcR1z7LYjA7fQ/OltEBLCKQmpYDOF7HjPDa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714591; c=relaxed/simple;
	bh=afC/sd76cIlCYaHCU11yRAKxNpmaPnjNIRHKsAmgCmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aqhTnIElOdXmzds0P/6hHcSc7O7M6I/VugYFXR+2YuUsJF/uPodaw2sh0MDuyjDBLnfNwViTgzLHbS2Tu2AVh4uZlBB/ieSixfIB6MtbO54sePweD4WDitGLfweSl36r66bApXBvGFWdbFF7Ai5iipJsC9ExED65A+I1B4dk5gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J5PnzOrE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J5PnzOrE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB17C4CEFE;
	Fri, 17 Oct 2025 15:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714591;
	bh=afC/sd76cIlCYaHCU11yRAKxNpmaPnjNIRHKsAmgCmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J5PnzOrEuxzoKdl6g7BAscUN7RyE0qwH8o4W7gffY2WvpmawLpDCI8oZRQy0CkouH
	 G2FQ3ATKKdCKQVK7nZPHWBqSvmqxeYCD4B9Eq8p5bKzeq6VxUCGYxn9QNOjEYLPbRx
	 eQGYGfZma+YdjZM+3wVV/7ORmmrEr93F2CulXluQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Haberland <sth@linux.ibm.com>,
	Jaehoon Kim <jhkim@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 198/277] s390/dasd: Return BLK_STS_INVAL for EINVAL from do_dasd_request
Date: Fri, 17 Oct 2025 16:53:25 +0200
Message-ID: <20251017145154.350309956@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaehoon Kim <jhkim@linux.ibm.com>

commit 8f4ed0ce4857ceb444174503fc9058720d4faaa1 upstream.

Currently, if CCW request creation fails with -EINVAL, the DASD driver
returns BLK_STS_IOERR to the block layer.

This can happen, for example, when a user-space application such as QEMU
passes a misaligned buffer, but the original cause of the error is
masked as a generic I/O error.

This patch changes the behavior so that -EINVAL is returned as
BLK_STS_INVAL, allowing user space to properly detect alignment issues
instead of interpreting them as I/O errors.

Reviewed-by: Stefan Haberland <sth@linux.ibm.com>
Cc: stable@vger.kernel.org #6.11+
Signed-off-by: Jaehoon Kim <jhkim@linux.ibm.com>
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/block/dasd.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -3117,12 +3117,14 @@ static blk_status_t do_dasd_request(stru
 		    PTR_ERR(cqr) == -ENOMEM ||
 		    PTR_ERR(cqr) == -EAGAIN) {
 			rc = BLK_STS_RESOURCE;
-			goto out;
+		} else if (PTR_ERR(cqr) == -EINVAL) {
+			rc = BLK_STS_INVAL;
+		} else {
+			DBF_DEV_EVENT(DBF_ERR, basedev,
+				      "CCW creation failed (rc=%ld) on request %p",
+				      PTR_ERR(cqr), req);
+			rc = BLK_STS_IOERR;
 		}
-		DBF_DEV_EVENT(DBF_ERR, basedev,
-			      "CCW creation failed (rc=%ld) on request %p",
-			      PTR_ERR(cqr), req);
-		rc = BLK_STS_IOERR;
 		goto out;
 	}
 	/*


