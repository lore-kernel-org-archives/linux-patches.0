Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EAC51D5141;
	Wed, 25 Feb 2026 01:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983507; cv=none; b=RUyCaweUa6hlDxWC4xzA51M2516Taml9SaxjlHoWNxgjfOw20zieq4lZaTR345juWJLRsUMqbP3TPXAJg63nh58vIopUxBusca83yzBq88mUTznhjGH0SCKIA1AkwFQ6e8F7G+dmPnfODfHfN5ijrHRr6dNpKrxL8fcITDtjW7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983507; c=relaxed/simple;
	bh=o1VcI1le1ybsQ/NGXiZTHbSQw5IB64Pd0H8Zne/hw/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lgACikXxJGHt58RiMHu/DDWZOhREGfzWfPHXDQ1Zz1ytkb9l3rjOw8b39ACP0LQg8kr04hB8KJsJHPk6VZnRU13caAz8w0AXPHiocqDm8AH+aDhCWku6KsBV7XJqEnjwoyF2wW/JhZ/iGmgflgdz3bto/VgABszVqlyjxCE1SXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m+HT38rx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m+HT38rx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C67C116D0;
	Wed, 25 Feb 2026 01:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983507;
	bh=o1VcI1le1ybsQ/NGXiZTHbSQw5IB64Pd0H8Zne/hw/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m+HT38rxUgeSSEbgt9AOJe9OmE89S23j+EiCd/n9/dqF8az+RqSA4eMyBDJgNk4gZ
	 B/xI2A3GD9nhKzw91ix7nunNoUEbvioHsDfwdZVcYx02f4tuW4QYkVVdZTbiN82HVr
	 hhl2r/+RwxWxbAqFshuVobts0jRfr477ijMiK+SQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 614/781] io_uring/cancel: de-unionize file and user_data in struct io_cancel_data
Date: Tue, 24 Feb 2026 17:22:03 -0800
Message-ID: <20260225012414.859244314@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 22dbb0987bd1e0ec3b1e4ad20756a98f99aa4a08 ]

By having them share the same space in struct io_cancel_data, it ends up
disallowing IORING_ASYNC_CANCEL_FD|IORING_ASYNC_CANCEL_USERDATA from
working. Eg you cannot match on both a file and user_data for
cancelation purposes. This obviously isn't a common use case as nobody
has reported this, but it does result in -ENOENT potentially being
returned when trying to match on both, rather than actually doing what
the API says it would.

Fixes: 4bf94615b888 ("io_uring: allow IORING_OP_ASYNC_CANCEL with 'fd' key")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/cancel.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/io_uring/cancel.h b/io_uring/cancel.h
index 6783961ede1bf..1b201a0943030 100644
--- a/io_uring/cancel.h
+++ b/io_uring/cancel.h
@@ -6,10 +6,8 @@
 
 struct io_cancel_data {
 	struct io_ring_ctx *ctx;
-	union {
-		u64 data;
-		struct file *file;
-	};
+	u64 data;
+	struct file *file;
 	u8 opcode;
 	u32 flags;
 	int seq;
-- 
2.51.0



