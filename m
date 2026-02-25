Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297B01D5ABA;
	Wed, 25 Feb 2026 01:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982868; cv=none; b=XzFAq/zMYz2inNERk0rrNwgC5JEVJ+Nu9b1jhSXmyhzUZeORyIAAlhHo6loQmdqxANbifedwIoxKtf7py0gNGIFO7gQZnEUoKeUuI+2QO7nO1mN1TR8xVxdXY7kP5d729wz4LXc4h1pyUTUK5GsSqny2b18ZF9EsSO/VgZfub98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982868; c=relaxed/simple;
	bh=P1DeXZLRGuFfZJEh6IXd8JtKPVGthK2u0m2BNm7oGqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KctjQc+r/sfE94445i5+U5M2KWA5b4YngFM6cnAIOxElb2ptz0G5z5mJWQF/2nqQsB7/BKPMYsy2U2PUvy8ROQchPnCtBg3AfT+DKIiQeL1SqecLk0i+WJgE1tBFq5mWX0EmorzPdi9jlwGxSUFrGWgLWY46PN0BiNN71Rlk9aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OKoT3GnV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OKoT3GnV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6787C116D0;
	Wed, 25 Feb 2026 01:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982868;
	bh=P1DeXZLRGuFfZJEh6IXd8JtKPVGthK2u0m2BNm7oGqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OKoT3GnVIkQ4VVflNluQYS9YLU/Si1hq8VXHq+wdwrNIC71eA941zCsLrPFkfKPld
	 vjacXN1yZWGoQUWmw5VAWW7pc2f42pC0soTmA5nzW7XlWMSz/nGXa9xdvSTVZhP7+/
	 dDQHpMXAlEYkrcrtDKpiYNCc9BAG4Ptd0ZOe9eJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 054/781] ublk: restore auto buf unregister refcount optimization
Date: Tue, 24 Feb 2026 17:12:43 -0800
Message-ID: <20260225012401.026830405@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Caleb Sander Mateos <csander@purestorage.com>

[ Upstream commit ad5f2e2908c9b79a86529281a48e94d644d43dc7 ]

Commit 1ceeedb59749 ("ublk: optimize UBLK_IO_UNREGISTER_IO_BUF on daemon
task") optimized ublk request buffer unregistration to use a non-atomic
reference count decrement when performed on the ublk_io's daemon task.
The optimization applied to auto buffer unregistration, which happens as
part of handling UBLK_IO_COMMIT_AND_FETCH_REQ on the daemon task.
However, commit b749965edda8 ("ublk: remove ublk_commit_and_fetch()")
reordered the ublk_sub_req_ref() for the completed request before the
io_buffer_unregister_bvec() call. As a result, task_registered_buffers
is already 0 when io_buffer_unregister_bvec() calls ublk_io_release()
and the non-atomic refcount optimization doesn't apply.
Move the io_buffer_unregister_bvec() call back to before
ublk_need_complete_req() to restore the reference counting optimization.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Fixes: b749965edda8 ("ublk: remove ublk_commit_and_fetch()")
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index cd1e84653002d..6000517645e12 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2462,11 +2462,11 @@ static int ublk_ch_uring_cmd_local(struct io_uring_cmd *cmd,
 		io->res = result;
 		req = ublk_fill_io_cmd(io, cmd);
 		ret = ublk_config_io_buf(ub, io, cmd, addr, &buf_idx);
+		if (buf_idx != UBLK_INVALID_BUF_IDX)
+			io_buffer_unregister_bvec(cmd, buf_idx, issue_flags);
 		compl = ublk_need_complete_req(ub, io);
 
 		/* can't touch 'ublk_io' any more */
-		if (buf_idx != UBLK_INVALID_BUF_IDX)
-			io_buffer_unregister_bvec(cmd, buf_idx, issue_flags);
 		if (req_op(req) == REQ_OP_ZONE_APPEND)
 			req->__sector = addr;
 		if (compl)
-- 
2.51.0



