Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD531194A6C;
	Thu, 30 Jul 2026 16:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427821; cv=none; b=Qj7DDxtsCww7oibgYvYallKAP4/2syeQ2sx3t6s1gapz+yhepf6vaT2C2PQu78IjNJl+vHlvlAPuwWu0CRwelMkJJmMbTD1txbrjLvmKfQ5vIfgj6A0WvirmPLSRwF/N49sE//IPzN9aDNM7qGRWFoAy4nLhYRqlAV1O6BZYQog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427821; c=relaxed/simple;
	bh=o4NXiMxGSyw3D9mc1xbzS6m7WrG8wM610ylnvKZd2jE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FsgkRXVOjoZHS5bmTFFhRpqFqygV03rFZfCye79+d5L30XmUJ2Pq8BowQF+bB+l19ads29v0bc8N3W4oMrbYMTW1JEkS16T7JNhkAnNrJyK+TAA7l5+w9xZHbwftsz0YQ9Y96rI8KbKSI8Or22L5JEquwPijNMEif6YlC7xWeKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T8MFTNLT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T8MFTNLT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9231F000E9;
	Thu, 30 Jul 2026 16:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427820;
	bh=SqFrPLb3XJJazoxgY5/cktii3dD0tNuU+1OPOzY7Tys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T8MFTNLTN4O/mu8L4cg7tuIEsVAXmqMQH6t6tA9P2ZrpeXn6GZrVpcaJ1JR2+unBw
	 usgXGlr90b+P3iAXOfj4XiZVrutfy0EvAaX4rLrqsz9yOKJ12tiIAyxOqHM6Mk2naX
	 +Pn3oz1jhQTpBem+JWJ/RMfP1KOHyPPdVlcDWgrQ=
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
Subject: [PATCH 6.6 304/484] libceph: bound get_version reply decode to front len
Date: Thu, 30 Jul 2026 16:13:21 +0200
Message-ID: <20260730141430.094196265@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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


