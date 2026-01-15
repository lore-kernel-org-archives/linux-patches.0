Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133C525228D;
	Thu, 15 Jan 2026 16:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768495975; cv=none; b=tFvmd2WjwLokP/iL8NMUTMPYJThDDgB64EDmI1ZfWwWShk21shTCrViFi2GutL1uhghJqlzYe3SCN7YMZzPlqP3I7Fo6EwWQB1vPz6LX+s+vzxeKk+8nVYdO/ZWeMbLJ+RERjDIF+tplCBIBJo7dY/bReSncjdd5/WPiLvH8UO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768495975; c=relaxed/simple;
	bh=b5YiXFff4V47som3tSk9t3OMrgHRj25mIbfpHsSQro8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=auP0N12N7OucgzpmqlB6sMTe6aHTFDIOmQ/VJBK4Gwq/jH4uJked2/aYp4vlh55E/58W+jV2se18rIwZ+KC2UHatlr7w64XVGKjlL/8OWmEtpppX1yMCaeJZ1wXgg5gyCZtg5iY1+0DGfWskg12PFq40p/1XGEyzKO1UzNbK5O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e0tS470t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e0tS470t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB9CC116D0;
	Thu, 15 Jan 2026 16:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768495974;
	bh=b5YiXFff4V47som3tSk9t3OMrgHRj25mIbfpHsSQro8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e0tS470tPoj/ykcQ72YHB6MQAENcOx2zJD8Y/qxqymaodcDo+bv5MATwNZpvECKge
	 TG88QZpagAggzokfr4KHozUymrBJ/ViobwwQpyipCkVrc9lbn4m9sdXhAKHLmB09Y/
	 FFeRUq5oEwbHHDfp3n0zVD6WhNmWFH/AFHc25H+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lewis Campbell <info@lewiscampbell.tech>,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 032/181] io_uring/io-wq: fix incorrect io_wq_for_each_worker() termination logic
Date: Thu, 15 Jan 2026 17:46:09 +0100
Message-ID: <20260115164203.487598027@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

commit e0392a10c9e80a3991855a81317da3039fcbe32c upstream.

A previous commit added this helper, and had it terminate if false is
returned from the handler. However, that is completely opposite, it
should abort the loop if true is returned.

Fix this up by having io_wq_for_each_worker() keep iterating as long
as false is returned, and only abort if true is returned.

Cc: stable@vger.kernel.org
Fixes: 751eedc4b4b7 ("io_uring/io-wq: move worker lists to struct io_wq_acct")
Reported-by: Lewis Campbell <info@lewiscampbell.tech>
Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io-wq.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -951,11 +951,11 @@ static bool io_wq_for_each_worker(struct
 				  void *data)
 {
 	for (int i = 0; i < IO_WQ_ACCT_NR; i++) {
-		if (!io_acct_for_each_worker(&wq->acct[i], func, data))
-			return false;
+		if (io_acct_for_each_worker(&wq->acct[i], func, data))
+			return true;
 	}
 
-	return true;
+	return false;
 }
 
 static bool io_wq_worker_wake(struct io_worker *worker, void *data)


