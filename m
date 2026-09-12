Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53179331203;
	Sat, 12 Sep 2026 15:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226473; cv=none; b=qOAMYcFxHOeH7ytaZNh8yqwMraJMmJLIA8xxv6ikjebzDy7iCVO9y024OW6VQVkrwIYTGvWOUnp18UJA7BJ8enA3cwFztPrlASPLU+gK+KXKUd8dWXWxAH0AB4c66ShF6q8xHUYZCPc3+GplJmmKGoWhfUhAFZE4T9XYI2MtHLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226473; c=relaxed/simple;
	bh=Mxt2k1+8o/ysbaKFCR7hhc/54wdPTbAYg4x8D1zmedQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i92CtmsxeP3x3iNLFyhR+5s9KZ6Op4By5P5GpEBkXJsGnGMj3u5+ieef2JszDUypCj9OvU49/eYEepWP0ONMlMDODKKbsAXUlPSGLj5xCIwD+f8n6kbo2IT6TMunt+JGvWnbsHFvKcS7g3rrtoegm7Ypz4avvg4F8PctJA0jWeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QGJrXQPn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QGJrXQPn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 707FA1F000FF;
	Sat, 12 Sep 2026 15:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226472;
	bh=hliBI0UEtNRh/JChdUb4yAFVajSzUbk/zCtSjpw26Qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QGJrXQPnsksEMwm2f9qxW6pN5qjgSYqZDcNtB/y/FnAStXKIWfznyWJ4cDObvHBwJ
	 Rmwnx5324Oqq2V8cw0WKoT4NNVudcEqSMpx0irJdFbMI/Nt9vqH31wSuvoJEbYxL4b
	 BGtsvyEtyAP0wy3thW2cpUNbQHk9sFc80ONEK79A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuriy Havrylyuk <yhavry@gmail.com>,
	Sven Peter <sven@kernel.org>,
	Nick Chan <towinchenmi@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1407/1424] nvme-apple: Reset q->sq_tail during queue init
Date: Sat, 12 Sep 2026 09:03:59 +0200
Message-ID: <20260912065638.768820416@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nick Chan <towinchenmi@gmail.com>

[ Upstream commit a6ab75639e23169a741b0b2e12191fd8acb32c73 ]

Fixes a "duplicate tag error for tag 0" firmware crash during controller
reset while setting up a  queue on Apple A11 / T8015 caused by stale
entries in the submission queue due to an invalid sq_tail offset after
reset.

Fixes: 04d8ecf37b5e ("nvme: apple: Add Apple A11 support")
Cc: stable@vger.kernel.org
Suggested-by: Yuriy Havrylyuk <yhavry@gmail.com>
Reviewed-by: Sven Peter <sven@kernel.org>
Signed-off-by: Nick Chan <towinchenmi@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/apple.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
index 0470941e38988..771c03fd850bc 100644
--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -1023,6 +1023,7 @@ static void apple_nvme_init_queue(struct apple_nvme_queue *q)
 	unsigned int depth = apple_nvme_queue_depth(q);
 	struct apple_nvme *anv = queue_to_apple_nvme(q);
 
+	q->sq_tail = 0;
 	q->cq_head = 0;
 	q->cq_phase = 1;
 	if (anv->hw->has_lsq_nvmmu)
-- 
2.53.0



