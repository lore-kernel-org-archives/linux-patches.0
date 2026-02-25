Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF709242D9B;
	Wed, 25 Feb 2026 01:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982853; cv=none; b=FBnAWcaUh6/RaqSNcaDbjbH19+MXR9hit/Eec+EFqhkUo3eM/lL5lOIKIQwICOj+fFlLpg68NUGUmDAr81LMBS9kjdtphMkE+3a4vIpwCWwqke3qwdfFAjpUqvHYFvCeGt4ru+B11HfGWUUmQQBNnFN3oxvNeymdHzya6ys7m6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982853; c=relaxed/simple;
	bh=zcI9pgalqxlzGEJPLv2Lpo0aeNmkfKDXxuqc7ZxfMQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jqef+uZaGh40cVCzB+1iZMzvPrCDzHk0jEwDhkQqa4pk+pwx0W2k5VtuEP9uhX7ov/0+oveBTrTZNrxhcaSeoGbsyhafi3jl4UKvqPJvcSg4SOzLv+zr2ELK/c1afIEWhCgPMG8s2af3fUN9H2MoEESOO15T5nLOA00WCLrIs5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e7itBou+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e7itBou+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A939DC116D0;
	Wed, 25 Feb 2026 01:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982852;
	bh=zcI9pgalqxlzGEJPLv2Lpo0aeNmkfKDXxuqc7ZxfMQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e7itBou+athJg5Qs95dLHBjj93SvzHLyZrBJucD33eqq8xotPjw6fSss9rB+CJFDa
	 2bYQ8J0aztfzKydKS1bXU9Ujv1DnAYWVnGmyUV/XDmWq0cknse15pkJKtRy60elGoy
	 9rEAVId7dEHU9b63O59SxlDVcXtejAMp3Jpv9YXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 042/781] io_uring/eventfd: remove unused ctx->evfd_last_cq_tail member
Date: Tue, 24 Feb 2026 17:12:31 -0800
Message-ID: <20260225012400.735929390@linuxfoundation.org>
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

[ Upstream commit 07f3c3a1cd56c2048a92dad0c11f15e4ac3888c1 ]

A previous commit got rid of any use of this member, but forgot to
remove it. Kill it.

Fixes: f4bb2f65bb81 ("io_uring/eventfd: move ctx->evfd_last_cq_tail into io_ev_fd")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/io_uring_types.h | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index a3e8ddc9b380f..4c9770536eb5d 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -444,6 +444,9 @@ struct io_ring_ctx {
 	struct list_head		defer_list;
 	unsigned			nr_drained;
 
+	/* protected by ->completion_lock */
+	unsigned			nr_req_allocated;
+
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	struct list_head	napi_list;	/* track busy poll napi_id */
 	spinlock_t		napi_lock;	/* napi_list lock */
@@ -456,10 +459,6 @@ struct io_ring_ctx {
 	DECLARE_HASHTABLE(napi_ht, 4);
 #endif
 
-	/* protected by ->completion_lock */
-	unsigned			evfd_last_cq_tail;
-	unsigned			nr_req_allocated;
-
 	/*
 	 * Protection for resize vs mmap races - both the mmap and resize
 	 * side will need to grab this lock, to prevent either side from
-- 
2.51.0



