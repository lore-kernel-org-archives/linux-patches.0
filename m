Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71C43D8115;
	Wed,  8 Apr 2026 18:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673660; cv=none; b=jIuVOE2xqBruu02n/s0y+UYEDKlrQjm27EqISk2kjUoY7J6EVazBd4DJZFmB4ClMwV0q8DEjk3DygiIWPkfp/xyUHhsKCqEu2STq/1Dqn+OU/NmCJK930pUKg4ljvOqr/+aauU6cbEaY2G4vjxvu5nVPSUtFh1xpVy5Izh0+Ku8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673660; c=relaxed/simple;
	bh=oSixiJ4XGw975jpFgAhZ8kV931KI9jePcsCyqfkniCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gvp0n/GUnSOeq7awXBoZeToDD/RIKqx5+PUzVNHzolNAc9ZX9pZo/SYztXPeuc/qfkXTPWhd/dYovXwDJM2VVpJ8h0WMBJzoNStwOnKrDJjemgeV1YzrDtXiIaoywAQpUx63fCiEtkFAnWowffFtPIGziF9vkIEAb7hGQt59mE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g5DOLX+R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g5DOLX+R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13468C19421;
	Wed,  8 Apr 2026 18:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673660;
	bh=oSixiJ4XGw975jpFgAhZ8kV931KI9jePcsCyqfkniCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g5DOLX+RnHWZeemqAobNm+LVGOtNE/m+g/4o9uwhiDF1V5MZGNU9LH88s5eyjDgiD
	 L9BqhATbw3vSq+TAF1NjWyS+LL1G/lBcj4EI06xY/fmRY/M78Ui2l8+Go4zXEGKqbc
	 H0L6QAhCajr3NlMUWq7RmR5Vm2VD3lMbVfa8rSCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 009/242] io_uring/net: dont use io_net_kbuf_recyle() for non-provided cases
Date: Wed,  8 Apr 2026 20:00:49 +0200
Message-ID: <20260408175927.421297448@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

Commit 15ba5e51e689ceb1c2e921c5180a70c88cfdc8e9 upstream.

A previous commit used io_net_kbuf_recyle() for any network helper that
did IO and needed partial retry. However, that's only needed if the
opcode does buffer selection, which isnt support for sendzc, sendmsg_zc,
or sendmsg. Just remove them - they don't do any harm, but it is a bit
confusing when reading the code.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -578,7 +578,7 @@ int io_sendmsg(struct io_kiocb *req, uns
 			kmsg->msg.msg_controllen = 0;
 			kmsg->msg.msg_control = NULL;
 			sr->done_io += ret;
-			return io_net_kbuf_recyle(req, kmsg, ret);
+			return -EAGAIN;
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
@@ -1448,7 +1448,7 @@ int io_send_zc(struct io_kiocb *req, uns
 			zc->len -= ret;
 			zc->buf += ret;
 			zc->done_io += ret;
-			return io_net_kbuf_recyle(req, kmsg, ret);
+			return -EAGAIN;
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
@@ -1508,7 +1508,7 @@ int io_sendmsg_zc(struct io_kiocb *req,
 
 		if (ret > 0 && io_net_retry(sock, flags)) {
 			sr->done_io += ret;
-			return io_net_kbuf_recyle(req, kmsg, ret);
+			return -EAGAIN;
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;


