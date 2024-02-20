Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DE7446C9;
	Tue, 20 Feb 2024 21:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465098; cv=none; b=E0AUnQhlXalGoi9rtoWFO3UobPe8X4yaKqwXvFSWxaNMkqedZKvSfUxDCpck/B996Guax33dsR0A7XF9gxzuurKyNTb6QWkpNmM+jMETXBpJpS9Iy5gYdTTi2d+RRc5/jgcNqiMTwbj+zJmaHHUxG7jUeKJwpfuOVB14vBVdWQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465098; c=relaxed/simple;
	bh=Hc6ohvvN0cdjlAsf9hSQofUwPQ70Z8Bd/XrEW1hX2bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BL5pU/tgjKArLj/jLrd3pJT1KeeU02B+55YsPjQ0xRw7OVdqKbTu3q9Wa+PL6+NbH7saQ7O8KYr4mGMD4h3gojtuy2pqVVwv1B9QHq3avyxNappygw1PsKst5EKhfdj/apARbh3G0b+/sFHPoByWnX15EPfSPtAUulDNH+Mh0Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wmfmf3A9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wmfmf3A9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B0BC433F1;
	Tue, 20 Feb 2024 21:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465098;
	bh=Hc6ohvvN0cdjlAsf9hSQofUwPQ70Z8Bd/XrEW1hX2bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wmfmf3A93Y2o8xzqjbJ70VX04kWOx0YjQ+7uW0dXU6ojIYOJm2PmwifVe/oz44QJM
	 oPmvg9LCdqZOdmxQG6LKJ8qZn4xWxOAJ0zYsdTpgWiQaAEU1yVzkDS5DwGFlZ73YKc
	 VdrdwNfQTDAgILbonMVrtrO0YbkhVtqQDV4HuPVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.7 236/309] io_uring/net: fix multishot accept overflow handling
Date: Tue, 20 Feb 2024 21:56:35 +0100
Message-ID: <20240220205640.542521874@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit a37ee9e117ef73bbc2f5c0b31911afd52d229861 upstream.

If we hit CQ ring overflow when attempting to post a multishot accept
completion, we don't properly save the result or return code. This
results in losing the accepted fd value.

Instead, we return the result from the poll operation that triggered
the accept retry. This is generally POLLIN|POLLPRI|POLLRDNORM|POLLRDBAND
which is 0xc3, or 195, which looks like a valid file descriptor, but it
really has no connection to that.

Handle this like we do for other multishot completions - assign the
result, and return IOU_STOP_MULTISHOT to cancel any further completions
from this request when overflow is hit. This preserves the result, as we
should, and tells the application that the request needs to be re-armed.

Cc: stable@vger.kernel.org
Fixes: 515e26961295 ("io_uring: revert "io_uring fix multishot accept ordering"")
Link: https://github.com/axboe/liburing/issues/1062
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1372,7 +1372,7 @@ retry:
 			 * has already been done
 			 */
 			if (issue_flags & IO_URING_F_MULTISHOT)
-				ret = IOU_ISSUE_SKIP_COMPLETE;
+				return IOU_ISSUE_SKIP_COMPLETE;
 			return ret;
 		}
 		if (ret == -ERESTARTSYS)
@@ -1397,7 +1397,8 @@ retry:
 				ret, IORING_CQE_F_MORE))
 		goto retry;
 
-	return -ECANCELED;
+	io_req_set_res(req, ret, 0);
+	return IOU_STOP_MULTISHOT;
 }
 
 int io_socket_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)


