Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E991A26E6F8;
	Wed, 25 Feb 2026 01:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983759; cv=none; b=OswJWdB4C0uq8Nl2MEv6PZc6Vr4v8PKF+QIB3urVW7edfo23/IvIht5B65GE8sC83MIQ5OthjMLbZzqEOKMXeYFxrY4iaPeAB63+bp2pfc7xGrPXgTKrcLHvMO+PrYF9ST0g5bOeKpfO5UHPI6Dm4Y1waDgYYkFsz5KnsE0IzJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983759; c=relaxed/simple;
	bh=XOXYdrZROBZ9xOb/Qfh9EKkeTyWgMghlwgipb3mr/38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MBG5q4qP+AmsUJ3z+6n5q6J26aYRybWeR8+jrHgKjO9pGoY+ZwMvNSGGH5SuI5SqmRAolmUVrpaiYoAKA7ZktuNpQfuYCvrHMIf62wSRSBzBA2PcHOZO2jBeLKRtki1uUjCCzx/9Ncr8TsE917J+IcPNihIowciYG3yIh84+El8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LWkK4VAJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LWkK4VAJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2153C116D0;
	Wed, 25 Feb 2026 01:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983758;
	bh=XOXYdrZROBZ9xOb/Qfh9EKkeTyWgMghlwgipb3mr/38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LWkK4VAJ0lXvgZO5zLao+KP4NjDHV7HVDP+SsYJ8wKOfS/pvFN0ShTSJQcgsNCBeO
	 HKMGi8eEY0I4/c51xfF/WU5A2Hg7/QP1fSv28ItEWE8NVsL3GyzoTvFEAibqkzDSmK
	 SVXwSyfKTr/OThd5Eu0NY4kObrsVsOQ8bde2ay4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 051/641] ublk: restore auto buf unregister refcount optimization
Date: Tue, 24 Feb 2026 17:16:17 -0800
Message-ID: <20260225012350.271869268@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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
index 4b6d7b785d7b3..56058090d223e 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2526,11 +2526,11 @@ static int ublk_ch_uring_cmd_local(struct io_uring_cmd *cmd,
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



