Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210363;
	b=yefnn9gwf+auVnX/7Hd7PFTlzcBehW8jshS6oKFeHDDBIgiJzegbEegR3p5B3m6H21m6
	 ptpkm4mGsaiyu7uajp6/eiqMHF3Yis0KwwMo5jrpS+RSOgNo1j+P4NWt3t9fCfKMKoo7D
	 9JlNLy9vlYs872DZmCB9XRNdrovZPbT9zH50dFyNMvkeFZ69vYDm1dsop7sSEOanSrdlb
	 O5qx3u6I94mrHzwDCN73Pd9iJuSi6IwS3Uh+/oU6saEzOy7wBSnz4RGsabCzvo3Cz40Hi
	 YZkEmIJWg8M+X+WFP9Q24NQQFhP57E1Y0WqFDKEzUrlO8YHotsKx6nNuwVYTVQyKdjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210363;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GEeGg4AIqYmuqxoCdqMd0hizBM2P4nwuUQAxXaCzAHE=;
	b=WeijaVcTfcjjoIe1WBgrMTkdN+jFaBnFFrkxzU8WsW+lVEb0cchCfroJ0IQ+YyHNjuFa
	 j0x9+IJYOaQ0uweWacxTaNj/9XkjeIaV1UaW3KGTIhMDuHuhFae1XJt4n4AK70JTy++o1
	 tO8XeB794LOf8pT4mFOWJQ2ovd0uXCK9Ing0ejbxw8SposAh7UlNo14UDJHE6jPXhVCL1
	 zSxjEXBt5/Hh3GvlgyoqODW2wamO82qsRZhPtZQRCmqcZndrBVKFcbOMn5VtfINciEi+y
	 xHjdADa9HpeVP8jfppRKsj7ZTpwInYVQYGzdtborpWK6IyCdOL4bfqStoMx2pzshy4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uLZg36Ns;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99DF2606A31A;
	Wed, 28 Oct 2026 17:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uLZg36Ns
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9AE81F01825;
	Wed, 28 Oct 2026 17:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210363;
	bh=GEeGg4AIqYmuqxoCdqMd0hizBM2P4nwuUQAxXaCzAHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uLZg36Nso+iAYw8vuB6c4Epfs4+yUdlyzfQDpZO1b7aG6sGBsp+CP+ZNDazlmNRKF
	 IrSfTcUA1wVENjnkUPQ5i1yogPo6xVUlGMFbpsN9F7hMuZa1bgWQkCJ0dZtYC2ONVP
	 UOzQA2Dk9kStDZlDfAmVkZGUTsypB4Lss34pE0LI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juanlu Herrero <juanlu@fastmail.com>,
	Anand Natarajan <anand@meta.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 148/168] io_uring/poll: avoid retry wakeup loss when dropping ownership
Date: Wed, 28 Oct 2026 18:01:24 +0100
Message-ID: <20261028165946.588467872@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juanlu Herrero <juanlu@fastmail.com>

Commit 937d38dcacd675dc0572d6c9b6743960df3128ed upstream.

If a wakeup sets IO_POLL_RETRY_FLAG between the owning task consuming
the existing instance of IO_POLL_RETRY_FLAG and the loop check
of io_poll_check_events(), then we stall on processing the request
until an unrelated wakeup comes along.

Using atomic_cmpxchg instead of atomic_sub_return to guarantee both the
count v and poll_refs are 0 and no wake-ups are missed.

Cc: stable@vger.kernel.org
Fixes: a26a35e9019f ("io_uring: make poll refs more robust")
Signed-off-by: Juanlu Herrero <juanlu@fastmail.com>
Assisted-by: LLM
Suggested-by: Anand Natarajan <anand@meta.com>
Link: https://patch.msgid.link/20261013-pu-cmpxchg-v1-1-4ddc10fd8a03@fastmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/poll.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -345,8 +345,8 @@ static int io_poll_check_events(struct i
 		 * Release all references, retry if someone tried to restart
 		 * task_work while we were executing it.
 		 */
-	} while (atomic_sub_return(v & IO_POLL_REF_MASK, &req->poll_refs) &
-					IO_POLL_REF_MASK);
+		v &= IO_POLL_REF_MASK;
+	} while (atomic_cmpxchg(&req->poll_refs, v, 0) != v);
 
 	return IOU_POLL_NO_ACTION;
 }


