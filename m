Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FAF0151CEC;
	Tue, 20 Feb 2024 21:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463091; cv=none; b=bl2dHFdeSzi8qUOFbefJzsBPNGnktwPfsbW+GqkX/AesNtIHx64JBe9gkzNL46I+T35+39e2rpLCVb9srCHYOFQzv3/0vZwJwXi0+48NFkR3XCv7iTwcnudb7Y48Ra4eGvNXcvC1CVNzNy7++DSIDjkLvyx4n/zfGh499dICSG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463091; c=relaxed/simple;
	bh=fjUSWk8rRjAV2trajawa2A7nyf9FG7qpsEkChGEAJ2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DDwbLXt5JYVV7RL+6SyyVD/H0Eh0X5cf4I29g7FbyJt6eZoPO5ZNBgc6S/vJWCmM13TgcQTkPnhfJpM5aY7Ir8/4cYgkVSAPDEri+O1V9L5Gc9LYKlSasaenTBddapQ8lrKRKor1xN5CvG62ON32jEycdXTLsk7WEdWQhvQrAbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nwxkDHy0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nwxkDHy0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2793C433C7;
	Tue, 20 Feb 2024 21:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463091;
	bh=fjUSWk8rRjAV2trajawa2A7nyf9FG7qpsEkChGEAJ2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nwxkDHy0jvS+3AQfRXAQAVD3n6P7VG1SbHx7wlPyQPkdS8SnlfWazLrSXFhw87qJ0
	 BLYK1UTrgXIHXOZIu1fdqn4aB45NhF1vUEla8Zh+FeXBvHQ8p9WkUkNapDg1D151Tc
	 /zuWLaoeciNF8S/MNu991R0AHTr3I0pIIg0zWMi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 131/197] io_uring/net: fix multishot accept overflow handling
Date: Tue, 20 Feb 2024 21:51:30 +0100
Message-ID: <20240220204844.995847849@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1326,7 +1326,7 @@ retry:
 			 * has already been done
 			 */
 			if (issue_flags & IO_URING_F_MULTISHOT)
-				ret = IOU_ISSUE_SKIP_COMPLETE;
+				return IOU_ISSUE_SKIP_COMPLETE;
 			return ret;
 		}
 		if (ret == -ERESTARTSYS)
@@ -1350,7 +1350,8 @@ retry:
 	if (io_post_aux_cqe(ctx, req->cqe.user_data, ret, IORING_CQE_F_MORE, false))
 		goto retry;
 
-	return -ECANCELED;
+	io_req_set_res(req, ret, 0);
+	return IOU_STOP_MULTISHOT;
 }
 
 int io_socket_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)


