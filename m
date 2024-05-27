Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707A315EFC3;
	Mon, 27 May 2024 19:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837809; cv=none; b=r1oNFMvuPZYV6kaCVnrvrzznlpH9w55NAuz3QQPR26RT3uhORs944XaVTuDqD9yTh6jCb9UPCe6YrM7gyFVvoAR61pGlqtR2Hu0ob2Zpt7ftTJGyKbI1jYUGpV5yBCXQIoGA343H/V7UYVduyCqPU+ArBSsrpzU/9wdZpmaWwa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837809; c=relaxed/simple;
	bh=v23vynnKZ8Uv0mX1ZSul5wWgrFbWaP0dxmq6ULfL1aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BZir3uxKP1ko6cuMTSanqHBXJgCz18Fw6TkgwiTF62ndrJ/sSjRHUiqVq9kbhlj0Ie+SAsNzHq7Zc3YwtnwjR0qXUrEWEnxZL0wXmcZI4EkC/osxlyrUtdqwLF5LvLMq5Xd7PvrsKwW6FwLCMOkApY8dTseKWp/j0s8z/05H94E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DyGXtpkO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DyGXtpkO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0605EC2BBFC;
	Mon, 27 May 2024 19:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837809;
	bh=v23vynnKZ8Uv0mX1ZSul5wWgrFbWaP0dxmq6ULfL1aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DyGXtpkO2Cm42dio9wZeGrg8ky/VIAEx/ewbmeSaOi5fJJDIEmo3G78TJYAOP3cvF
	 BVynjWtvZL7luxYEHQ9hvFwlaMukXbtjOTBIHXXKZ/8E5w9NySNk+krZzaiv5RnHLy
	 BiWQ0B4TRJQQ9lPiU+k8lUcxccqqAhQCo1qnv2QM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 153/493] io_uring/net: fix sendzc lazy wake polling
Date: Mon, 27 May 2024 20:52:35 +0200
Message-ID: <20240527185635.430700521@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit ef42b85a5609cd822ca0a68dd2bef2b12b5d1ca3 ]

SEND[MSG]_ZC produces multiple CQEs via notifications, LAZY_WAKE doesn't
handle it and so disable LAZY_WAKE for sendzc polling. It should be
fine, sends are not likely to be polled in the first place.

Fixes: 6ce4a93dbb5b ("io_uring/poll: use IOU_F_TWQ_LAZY_WAKE for wakeups")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/5b360fb352d91e3aec751d75c87dfb4753a084ee.1714488419.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/net.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/net.c b/io_uring/net.c
index d193b87d0a03b..099ab92cca0b7 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1022,6 +1022,7 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	struct io_kiocb *notif;
 
 	zc->done_io = 0;
+	req->flags |= REQ_F_POLL_NO_LAZY;
 
 	if (unlikely(READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3)))
 		return -EINVAL;
-- 
2.43.0



