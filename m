Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926D33191C8;
	Mon, 29 Dec 2025 16:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025443; cv=none; b=U57+k4/rK//yyuTqTEPEOaV9PQ15QS7DXjUMc1RiSxDwh0H5Lv2Ll+OljkzTEd0SRkbCri5NslKVXfZ8ezsdZJxRMdAIiFoRpudFO7bUXMQ8u1Y8AaOovDY0ECsW1CRM4f96/Vd7uvOsp4AcyoF7iNG34kPp6fLd7sDOjHnNPlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025443; c=relaxed/simple;
	bh=l5fbQOG1M3fOgcedQd0nOXTTK6eFl/FXS60Go4RGfIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sV/c8QL/XXxVKVROAdEPlQ6CVuIaHF0yq6PSojOu9GGWth5ggLTUOYFddqN+MnElF7A4Xe7GO8uQ9Ti3Bi++Pp2kkWgzFdrq0lob2Jx6/RqMLO9gZS/phJRPDAudLIWYtm6GD8DTeazclnOBB55Ch6gJa5LT+jWDhx77+2D0dWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mqp1C2+3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mqp1C2+3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A42FC4CEF7;
	Mon, 29 Dec 2025 16:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025443;
	bh=l5fbQOG1M3fOgcedQd0nOXTTK6eFl/FXS60Go4RGfIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mqp1C2+3CvC0pqA3kFphewi5q2bv4gcFE8NZUHeqq26d4b5Z80UnOMV4w9S0VCEdn
	 ZTlO8cOQ7+489iM0aAbtjPy4K90ucTfl1D/UpnxJ7lSGRhVQY0BIGNRsMqGSOSprJj
	 llzlVwT5pUV7Y3ScSqXKoeKZMlt+S+zy3poilJms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 216/430] ublk: clean up user copy references on ublk server exit
Date: Mon, 29 Dec 2025 17:10:18 +0100
Message-ID: <20251229160732.301399238@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

[ Upstream commit daa24603d9f0808929514ee62ced30052ca7221c ]

If a ublk server process releases a ublk char device file, any requests
dispatched to the ublk server but not yet completed will retain a ref
value of UBLK_REFCOUNT_INIT. Before commit e63d2228ef83 ("ublk: simplify
aborting ublk request"), __ublk_fail_req() would decrement the reference
count before completing the failed request. However, that commit
optimized __ublk_fail_req() to call __ublk_complete_rq() directly
without decrementing the request reference count.
The leaked reference count incorrectly allows user copy and zero copy
operations on the completed ublk request. It also triggers the
WARN_ON_ONCE(refcount_read(&io->ref)) warnings in ublk_queue_reinit()
and ublk_deinit_queue().
Commit c5c5eb24ed61 ("ublk: avoid ublk_io_release() called after ublk
char dev is closed") already fixed the issue for ublk devices using
UBLK_F_SUPPORT_ZERO_COPY or UBLK_F_AUTO_BUF_REG. However, the reference
count leak also affects UBLK_F_USER_COPY, the other reference-counted
data copy mode. Fix the condition in ublk_check_and_reset_active_ref()
to include all reference-counted data copy modes. This ensures that any
ublk requests still owned by the ublk server when it exits have their
reference counts reset to 0.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Fixes: e63d2228ef83 ("ublk: simplify aborting ublk request")
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index fa7b0481ea04..d8079ea8f8ca 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1674,8 +1674,7 @@ static bool ublk_check_and_reset_active_ref(struct ublk_device *ub)
 {
 	int i, j;
 
-	if (!(ub->dev_info.flags & (UBLK_F_SUPPORT_ZERO_COPY |
-					UBLK_F_AUTO_BUF_REG)))
+	if (!ublk_dev_need_req_ref(ub))
 		return false;
 
 	for (i = 0; i < ub->dev_info.nr_hw_queues; i++) {
-- 
2.51.0



