Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBEB0189B89;
	Tue, 30 Jul 2024 17:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360771; cv=none; b=A042D650iM0ZgVYodexKrgm9qfvEYE1RlCrRsQA87kdbp/vjfn2VQJuCAKbHgZzqoviDWACQGv8jRpIW3xoCLeIzvvLhX1THsud2gWlesSRJlmDU4dLMoBuHwCwFlEHBauiPnkhi7E/EdiKZ7df4KZMHOAIeNR+2XORDmFSGs2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360771; c=relaxed/simple;
	bh=EqqSeCrTZljghptj8NC9i4qh+QyByRp97/T0m7nbLIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YJSjSpoDjJg9SNiCvwXr1NXdpswTYNWK2WM9zgIAqsy65R9wgVh7YAwrtLnnjHEVJRyEJVFIpaeyJrYoj5In6uRXHH7JqdBl2cq+dKdOqHcbk3KPGZygcuJ3V/m4siZoPDqQUUegjVDy6D0By2l69P1obMZoozzxryT9a40dfiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wyXnCptr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wyXnCptr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53481C32782;
	Tue, 30 Jul 2024 17:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360771;
	bh=EqqSeCrTZljghptj8NC9i4qh+QyByRp97/T0m7nbLIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wyXnCptrCYyz6mERVBun/hECG4XH7e7SbQ2sgE1sQb24dzmtwM531NF9X+oCHiOvu
	 YmSz28niYMfP3ammI9PffPPZPnrLZYWqXZ8qOtxiGxX/I8qhWkqqi3zsiZcjt6QVBt
	 2TxWA6921IPWkBvZxDhHg+QvjBmb8gKZ31RqZDQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 803/809] ublk: fix UBLK_CMD_DEL_DEV_ASYNC handling
Date: Tue, 30 Jul 2024 17:51:19 +0200
Message-ID: <20240730151756.697483318@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 55fbb9a5d64e0e590cad5eacc16c99f2482a008f ]

In ublk_ctrl_uring_cmd(), ioctl command NR should be used for
matching _IOC_NR(cmd_op).

Fix it by adding one private macro, and this way is clean.

Fixes: 13fe8e6825e4 ("ublk: add UBLK_CMD_DEL_DEV_ASYNC")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20240724143311.2646330-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 4e159948c912c..3b58839321333 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -48,6 +48,9 @@
 
 #define UBLK_MINORS		(1U << MINORBITS)
 
+/* private ioctl command mirror */
+#define UBLK_CMD_DEL_DEV_ASYNC	_IOC_NR(UBLK_U_CMD_DEL_DEV_ASYNC)
+
 /* All UBLK_F_* have to be included into UBLK_F_ALL */
 #define UBLK_F_ALL (UBLK_F_SUPPORT_ZERO_COPY \
 		| UBLK_F_URING_CMD_COMP_IN_TASK \
@@ -2904,7 +2907,7 @@ static int ublk_ctrl_uring_cmd(struct io_uring_cmd *cmd,
 	case UBLK_CMD_DEL_DEV:
 		ret = ublk_ctrl_del_dev(&ub, true);
 		break;
-	case UBLK_U_CMD_DEL_DEV_ASYNC:
+	case UBLK_CMD_DEL_DEV_ASYNC:
 		ret = ublk_ctrl_del_dev(&ub, false);
 		break;
 	case UBLK_CMD_GET_QUEUE_AFFINITY:
-- 
2.43.0



