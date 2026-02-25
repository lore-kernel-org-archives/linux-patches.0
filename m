Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2C52652B7;
	Wed, 25 Feb 2026 01:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983746; cv=none; b=i2Gnifatf6j3bn+U/ya/nlAf6gHKzCIxSU/NHOO6Mm/OA5QGp5w985oid0vrl/hss49wQCM0brySbCht16eLPKAqISp2aMrIITAESvFIpKEakH8Z2rkcvbwXI2n18nH9yf5etdbQ88VEHUBL2hRkorMsnOPCMsIZdWqK0uBogAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983746; c=relaxed/simple;
	bh=k7U0AOOy/QPMa31dF7dsLMgn66JWIFiEBO7k3FQgYRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n19WIPscBld1kagFt51+tJVBjgEQVcSxtVdEdC9PuxT8noD/9YTJqQEvPyerbYiMHIHjV7AKZiXJTfjvtq9D9oo+ChIBgZwFD6rbwR8ed+9NyPKdG0w/6s0kJMk8CN3rRO9SJiyZRIhvfVporOXBceqjURlZXrlr8+p13gwX/nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gIKKSAqS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gIKKSAqS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53931C116D0;
	Wed, 25 Feb 2026 01:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983746;
	bh=k7U0AOOy/QPMa31dF7dsLMgn66JWIFiEBO7k3FQgYRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gIKKSAqSX2XUfvZFdoMXf59cChrkJTsKFKrepUbh9Ey3TLUsRw455Pn5sB8LgCzck
	 KXHWZxtv1L6jaQV4Ki89SSdfwK3SilNuKKn8QG/pH175U2fSfC5GPgdZAva4rmLvkI
	 DKGmeSfuL+1UBpzHhb5i2+LsssgUq6ge+dyGor2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 039/641] io_uring/eventfd: remove unused ctx->evfd_last_cq_tail member
Date: Tue, 24 Feb 2026 17:16:05 -0800
Message-ID: <20260225012349.969272135@linuxfoundation.org>
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
index c2ea6280901dc..b4d8aca3e7860 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -439,6 +439,9 @@ struct io_ring_ctx {
 	struct list_head		defer_list;
 	unsigned			nr_drained;
 
+	/* protected by ->completion_lock */
+	unsigned			nr_req_allocated;
+
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	struct list_head	napi_list;	/* track busy poll napi_id */
 	spinlock_t		napi_lock;	/* napi_list lock */
@@ -451,10 +454,6 @@ struct io_ring_ctx {
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



