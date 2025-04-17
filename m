Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCD218C034;
	Thu, 17 Apr 2025 18:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913301; cv=none; b=eQw4nc+er+eDsUMk2lqtsByR7nsSE0S33QHqENLPkSvdKEfpQkNwE09dR2y9uVuwa9DiFGjsrglssOVeor9V/nYW+k1i3OUeZYyw1gGpTtrgCYePmBp05ea3rqlnppyhc2z2vLuoMzilfAkxPrEAYWeLtvf/Zv7ZrL2zLIn2ydg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913301; c=relaxed/simple;
	bh=5sKGFIES6P5xYXtmahnoPL1jZpGMDfg74nIG4wg/dM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IvAZF9ugCiJdErvpP/LZounrdBF75mla5/ne/kHx7BCDL9ihdUvXNDBq8VgaEcEOdUJ+Y6HTDaSEafSySn6ZfzSjBtU7ZyaJZPhP2iclRFz4hf8LWFIBcfBgI1j5Sn5fNA4jaaD0V60LUYdE+TQnTuD4dyIGW2jS2XxhRd5wc7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mjFm7+Ry; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mjFm7+Ry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67382C4CEE4;
	Thu, 17 Apr 2025 18:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913300;
	bh=5sKGFIES6P5xYXtmahnoPL1jZpGMDfg74nIG4wg/dM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mjFm7+Ry8azQS75d/Kwbc0GpmTj2WdH/WHlViTVXJB/iIDPbOSilQii7z6/U/3Npw
	 IJIDTyHAWL/NrKXxy9aDatNj+cg/9PFNe11QBXOP7BsaDsRFs4CuEmRhPcZAhhUM+Q
	 UMCHRsDn7CuC1PneRa4jnZiAV8wiU75AOorwEOeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+58928048fd1416f1457c@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.14 292/449] io_uring/kbuf: reject zero sized provided buffers
Date: Thu, 17 Apr 2025 19:49:40 +0200
Message-ID: <20250417175129.833022963@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit cf960726eb65e8d0bfecbcce6cf95f47b1ffa6cc upstream.

This isn't fixing a real issue, but there's also zero point in going
through group and buffer setup, when the buffers are going to be
rejected once attempted to get used.

Cc: stable@vger.kernel.org
Reported-by: syzbot+58928048fd1416f1457c@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/kbuf.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -480,6 +480,8 @@ int io_provide_buffers_prep(struct io_ki
 	p->nbufs = tmp;
 	p->addr = READ_ONCE(sqe->addr);
 	p->len = READ_ONCE(sqe->len);
+	if (!p->len)
+		return -EINVAL;
 
 	if (check_mul_overflow((unsigned long)p->len, (unsigned long)p->nbufs,
 				&size))


