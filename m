Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59459471265;
	Tue, 21 Jul 2026 20:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664340; cv=none; b=UQwYGfbgkXm+VzJDw1Hl7YuGRqEKioVtctfIkVRdTEtGoU4e+wcweAr4GkrLwcO58U66DWWnPv6ULH3i2R/Z3ejF3PONvfWii2AE3Trl4HM1dwJIN2bCsN5OAIQ+LD0tzBy1haMThqRA+mxt6O28cgGPyDt1aej8Xf2XRkWKwWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664340; c=relaxed/simple;
	bh=Cd8PrwsfzFOZK66K8TqIREC18ogOAhT9RpEZJV0lMfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BIYRMrsv9ENVS4NeQLKQvmCF54zupG4VsEsRweRaVlEoMYwSY4cpRPVmvUcEz4WbpNziJEXMFArH3UVsSrnyN8wz2VzeJVoXrn7uw7rFWNsNm9AxnlPq1vBEfZ0c5pp7tHBrvL36i+yJKfYDnkyipweb2fv/T6kWdqDhntNKlUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qOUexIod; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qOUexIod"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF7341F000E9;
	Tue, 21 Jul 2026 20:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664339;
	bh=G5mN7HGepLMgSE0rWXwyHguY433iCPejN0D8wxj5VPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qOUexIodFJCVwykJAKLPOJmVc/xsvMH1upOkNiIVWjagu3NIwhIMTQgoEkCWQ6lQ3
	 PUrczqYlU5ipCaK0uLx+Uobq6mec+jKETL9Rt+8L6f3cKcXiQsAz5Vt5maYBIouuQP
	 RcqeKPQ05rRKND4dEiMXlYwpBrWOZ8tv7biNAlmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1164/1276] io_uring/rw: ensure reissue path is correctly handled for IOPOLL
Date: Tue, 21 Jul 2026 17:26:47 +0200
Message-ID: <20260721152512.067572741@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

[ Upstream commit bcb0fda3c2da9fe4721d3e73d80e778c038e7d27 ]

The IOPOLL path posts CQEs when the io_kiocb is marked as completed,
so it cannot rely on the usual retry that non-IOPOLL requests do for
read/write requests.

If -EAGAIN is received and the request should be retried, go through
the normal completion path and let the normal flush logic catch it and
reissue it, like what is done for !IOPOLL reads or writes.

Fixes: d803d123948f ("io_uring/rw: handle -EAGAIN retry at IO completion time")
Reported-by: John Garry <john.g.garry@oracle.com>
Link: https://lore.kernel.org/io-uring/2b43ccfa-644d-4a09-8f8f-39ad71810f41@oracle.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: c554246ff4c6 ("io_uring/rw: preserve partial result for iopoll")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rw.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -550,11 +550,10 @@ static void io_complete_rw_iopoll(struct
 	if (kiocb->ki_flags & IOCB_WRITE)
 		io_req_end_write(req);
 	if (unlikely(res != req->cqe.res)) {
-		if (res == -EAGAIN && io_rw_should_reissue(req)) {
+		if (res == -EAGAIN && io_rw_should_reissue(req))
 			req->flags |= REQ_F_REISSUE | REQ_F_BL_NO_RECYCLE;
-			return;
-		}
-		req->cqe.res = res;
+		else
+			req->cqe.res = res;
 	}
 
 	/* order with io_iopoll_complete() checking ->iopoll_completed */


