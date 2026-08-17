Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36BA41D118;
	Mon, 17 Aug 2026 15:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979507; cv=none; b=et+rT5q8OwSZ7oYNDeGZ8uoSPF9GsU0ot4EGIyGEzFUjKrCqOITJ/PR565kIzeT62IhuFvWn2bcco6cSJQXvRZg3tIb/QIQASQlT8euGk3LUb1dM31BOHYA3Jil33Hake1J9G3lVRW7n7mJmnEUDJi5LG3BV+rlTAR+lTfH/7EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979507; c=relaxed/simple;
	bh=EPH06MWyRl66DBNu5fXv0VajWLiI6Dtx7rrbXpOJcRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wzr+Yi1Ikp3VnWqB/QR7s3saISxNeG3zh9t7mdY6jtaSZeW72up06r6D+XNhHaGNI9zB+WGbvrDTpWWFgwME6ZAflRbENGxh3JFZp3SkBHdvCD2nk3AijEg1P5ikodMb8RjxjV+db4CFAebv3GWHYSfyt/1XAevh0HKUl4ShzaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AoRnENOJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AoRnENOJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD321F00A3A;
	Mon, 17 Aug 2026 15:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979505;
	bh=/M/oAGUW/oio2HooJqpLPZAI/A1GtFjwEI+R2xeSX48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AoRnENOJcCP7hQK3Lw0RUJVHMDMgvefyqgYa7eoxXaoJQFnryw7sP38hwh2AK/S1W
	 0KSu8CURbVRxtXh3X/r/OMw5aaSVQZYAfHzEADfZUlMU5GL4xJ6i8pHmZGirE/21tg
	 P91FvTurmCPuBK4qJFtviBO+d6BjFnySbzIvlF2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Douya Le <ldy3087146292@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.1 250/609] libceph: bound get_version reply decode to front len
Date: Mon, 17 Aug 2026 15:29:06 +0200
Message-ID: <20260817132552.454828627@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douya Le <ldy3087146292@gmail.com>

commit d3c32939fa0e3ee9b883b9a0fd1972c5c444e3d0 upstream.

handle_get_version_reply() uses msg->front_alloc_len as the decode
boundary for MON_GET_VERSION_REPLY.  That is the size of the reused
reply buffer, not the number of bytes actually received.

A truncated reply can therefore pass ceph_decode_need() and decode the
second u64 from stale tail bytes left in the buffer by an earlier
message, causing an uninitialized memory read.

Use msg->front.iov_len as the receive-side decode boundary, matching
other libceph reply handlers and limiting decoding to the bytes that
were actually read from the wire.

Cc: stable@vger.kernel.org
Fixes: 513a8243d67f ("libceph: mon_get_version request infrastructure")
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Assisted-by: Codex:GPT-5.4
Signed-off-by: Douya Le <ldy3087146292@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/mon_client.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -821,7 +821,7 @@ static void handle_get_version_reply(str
 	struct ceph_mon_generic_request *req;
 	u64 tid = le64_to_cpu(msg->hdr.tid);
 	void *p = msg->front.iov_base;
-	void *end = p + msg->front_alloc_len;
+	void *const end = p + msg->front.iov_len;
 	u64 handle;
 
 	dout("%s msg %p tid %llu\n", __func__, msg, tid);


