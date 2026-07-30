Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7EB30567C;
	Thu, 30 Jul 2026 15:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424779; cv=none; b=Jh4BG08GqbsiXyz8Fh9BtsLyz5wJ6Yw8rxof6gNro2oeKWK8JowI10R2CmCdg37EEGXJV5NjIH8VFyvKLjbwYogzJG84E/6RgEsqDJ+HZajJxzWw2AwAQrTQeZ6YvronfWRG9m13F351s+2mUq2NM++4ePztPZ9VTacj+3Wg/d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424779; c=relaxed/simple;
	bh=kvB2sfB6tS4wdHzpilccup41Vt/TbeHLmoFhhAUL9LE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rfBq8Kq/r6Mbke3uW6cD2NL2SORx9JgR5azxxUIFNmQyhknft6a/odtdjBz7+znrsGjTRE1trn8QHyt7/OD/aikexoHcjlU6d4tLQTwdjfNQVXZFMVaynSH4jlkOEtA3ecWXyH/BEgUSzNq0GGr7LKgwudamcKt8XYUghCx7NcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tiuya6Z8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tiuya6Z8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B9E41F000E9;
	Thu, 30 Jul 2026 15:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424777;
	bh=Tg4cHPw6E4dtV1GjHhOAK5Mu8oyRoLxfgCrchFX/Awg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tiuya6Z8S+pyFO1jIt5clVSq2pQWwnuBSmnX7qx8ucBgHIoGhWNeKLS3BuYc8gj/s
	 Gc3fak6xl7irAUnBf12ucy9UZ8y4jFWz7nMMvdViqkJqLJAHi7fUpOa53+cO118Od0
	 CPMJmpc0VlsOls8QrM5zIOg0C+rYn6maYhDhk0eg=
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
Subject: [PATCH 6.18 514/675] libceph: bound get_version reply decode to front len
Date: Thu, 30 Jul 2026 16:14:04 +0200
Message-ID: <20260730141456.055370774@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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


