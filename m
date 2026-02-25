Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0352F2798EA;
	Wed, 25 Feb 2026 01:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983760; cv=none; b=Ts+ScI3TDwFEakIro4wxdceRLMiv8+yVXKRa4j+ZKndC3UyIm6CLXUv9U3EvZSYpWBmBlXi158wKuWfoN4WKUCtjoMI6tqxFzyUDTvM9YZ49fgr6gJTKhQOCU4RxmLFm1cisM1KCHkMMnIvTEQjA0lLAJ6Tu5iWRq8fm2eUd8vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983760; c=relaxed/simple;
	bh=8kUU9UQYeM34anwNzMRE0GMh/MfdfeYeJeYyhrFFvao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+3+Wwz4iLwuuZX7waiubSMrsCso6nnDfhiCfZTfIRat8vw/rLwf71I+UmmwLEu07X5DbkVmDosxcOkVhc2/StAgWOKNl/FdxZSVeoYkMywdBPBIh0OE5EUteyTZfd4Ph/umitxqG1GwNP4w2CDEdI2f/RBpnNuqfwUF5A2qjvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vy0ZwLb1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vy0ZwLb1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8BD2C116D0;
	Wed, 25 Feb 2026 01:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983759;
	bh=8kUU9UQYeM34anwNzMRE0GMh/MfdfeYeJeYyhrFFvao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vy0ZwLb1gAJRiDe4LufOcMaTdqU8eN8k55DggBI6BiXNJ4WPBvm4XhHXfR/QeBBnE
	 MYig2HkhXIACMJhJDA1II4jx927bNXsvJjsXlWxxzeZ/oJyqXkNnvBho3KpQPQ3hVM
	 AdI8NurEzAs5aTTuG+K5FEHw55KPjOr5yafHq5lI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Govindarajulu Varadarajan <govind.varadar@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 052/641] ublk: Validate SQE128 flag before accessing the cmd
Date: Tue, 24 Feb 2026 17:16:18 -0800
Message-ID: <20260225012350.298181082@linuxfoundation.org>
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

From: Govindarajulu Varadarajan <govind.varadar@gmail.com>

[ Upstream commit da7e4b75e50c087d2031a92f6646eb90f7045a67 ]

ublk_ctrl_cmd_dump() accesses (header *)sqe->cmd before
IO_URING_F_SQE128 flag check. This could cause out of boundary memory
access.

Move the SQE128 flag check earlier in ublk_ctrl_uring_cmd() to return
-EINVAL immediately if the flag is not set.

Fixes: 71f28f3136af ("ublk_drv: add io_uring based userspace block driver")
Signed-off-by: Govindarajulu Varadarajan <govind.varadar@gmail.com>
Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 56058090d223e..965460d4fc76e 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -3841,10 +3841,10 @@ static int ublk_ctrl_uring_cmd(struct io_uring_cmd *cmd,
 	if (issue_flags & IO_URING_F_NONBLOCK)
 		return -EAGAIN;
 
-	ublk_ctrl_cmd_dump(cmd);
-
 	if (!(issue_flags & IO_URING_F_SQE128))
-		goto out;
+		return -EINVAL;
+
+	ublk_ctrl_cmd_dump(cmd);
 
 	ret = ublk_check_cmd_op(cmd_op);
 	if (ret)
-- 
2.51.0



