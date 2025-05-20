Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B86624503E;
	Tue, 20 May 2025 14:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750789; cv=none; b=u+bqFHmpo2Nlqn7Q9GNOjEdkLqfMh7A3qE2BmNw94654xeXOkp89obFPyRZoyiYt1nEHIf6bqW/3mkJGDFMC9+jAckRr1wxkAodXEnVVr27vsPNQcJ5ybp5HsBhAO3dXoAN/RRDKpZ/akS5m2zouZ3xctdpi7ajPssm0jZG6ktY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750789; c=relaxed/simple;
	bh=7EdhwFgIOwDZ+bo3y3mID6OLMeDvmwl0aoWD0tFfHeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iVquvlYVGhbcZxeB9r0ErbjRocvWswdl+V+5K1uDoR2obOgaCFBcuI9Sga9wxoHdBp2HQEchdpMG2rvkrxCa4IXiwJyTf//wyK9AeVbE/3Pm9qHoHmArQflFFiThTXbqIDQ+TzuHoKvj5Ir3sLpt1CAuJfdVSRmXpjOV5XwuWpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gYES5Gsp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gYES5Gsp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0615DC4CEE9;
	Tue, 20 May 2025 14:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750789;
	bh=7EdhwFgIOwDZ+bo3y3mID6OLMeDvmwl0aoWD0tFfHeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gYES5GspZSCD4BWU+W81wyLn54ijVjuMRwC2SItolX1Wg9Bh2QwWtSgh2yAp05qnb
	 utl/azCZ8aBO7Lnnun9YyrYZOIzn6zKae904PCRuSLEuoT1NvxvYClnvTYwfcZNukb
	 jd/muZtvHLPvxe09lMMNkzzf7qwFTsLfurzTDdgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	hexue <xue01.he@samsung.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.14 122/145] io_uring/uring_cmd: fix hybrid polling initialization issue
Date: Tue, 20 May 2025 15:51:32 +0200
Message-ID: <20250520125815.329168625@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

From: hexue <xue01.he@samsung.com>

commit 63166b815dc163b2e46426cecf707dc5923d6d13 upstream.

Modify the check for whether the timer is initialized during IO transfer
when passthrough is used with hybrid polling, to ensure that it's always
setup correctly.

Cc: stable@vger.kernel.org
Fixes: 01ee194d1aba ("io_uring: add support for hybrid IOPOLL")
Signed-off-by: hexue <xue01.he@samsung.com>
Link: https://lore.kernel.org/r/20250512052025.293031-1-xue01.he@samsung.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/uring_cmd.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -244,6 +244,11 @@ int io_uring_cmd(struct io_kiocb *req, u
 			return -EOPNOTSUPP;
 		issue_flags |= IO_URING_F_IOPOLL;
 		req->iopoll_completed = 0;
+		if (ctx->flags & IORING_SETUP_HYBRID_IOPOLL) {
+			/* make sure every req only blocks once */
+			req->flags &= ~REQ_F_IOPOLL_STATE;
+			req->iopoll_start = ktime_get_ns();
+		}
 	}
 
 	ret = file->f_op->uring_cmd(ioucmd, issue_flags);


