Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB743DC857;
	Mon, 17 Aug 2026 14:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975823; cv=none; b=KTYqo1OpK4gpqyboCDI0ku/KPII+FrCtcOCQ+uW7ANbVHdFSE604ziCxENn6fG3zbGD4FvNP02uK00UPWQwpnmrEgbKR0DXsBDiMhafe1uOJFjphNPrhqXGr8G8iOP2rD38p6miDMIbcYsFapoVzWB059Ys3uwqPsERWdW4x+Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975823; c=relaxed/simple;
	bh=YzjTWeCuTAOcLJgQxtBmY8giWJJnePrmgrsJAOvs0B8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gjb4M/c9ZquOH0ttbM0qAAFD5Put1mf/5gcMtsBaSkDW/b6ml4kVqbEJrpbohZ81cqLTxYBM8qmiVvdwCUFav95zValbSYImm4FJ5ET/7HYXMKM2AdqygwaNMOm7HxKYZrzkP/Qtec9JhyOQ06evxhZX5HnxGYndtBDy0Q3aKIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SjMZc9Jd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SjMZc9Jd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E1D1F000E9;
	Mon, 17 Aug 2026 14:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975821;
	bh=05AdiIqkd9ksqQBzh3RhbQ/btE8D4gzJCAPGOUavqPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SjMZc9Jd8ntGwVvew7BDHZ3JFZeC1IeiRccWVOanwKSLEOZS9jVcQlUH/VdxK23hH
	 8etFzDeWVXQh5Yca8Pxy4zAWsUxLVQNWI1ODEeEVPJGB8xYnfOIv1o1SCZL3bc9cL+
	 OVkP6JcMLi8jJ14X41Df5MoeEPmT4leROTp+5NhM=
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
Subject: [PATCH 5.10 161/389] libceph: bound get_version reply decode to front len
Date: Mon, 17 Aug 2026 15:30:00 +0200
Message-ID: <20260817132545.452395861@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -748,7 +748,7 @@ static void handle_get_version_reply(str
 	struct ceph_mon_generic_request *req;
 	u64 tid = le64_to_cpu(msg->hdr.tid);
 	void *p = msg->front.iov_base;
-	void *end = p + msg->front_alloc_len;
+	void *const end = p + msg->front.iov_len;
 	u64 handle;
 
 	dout("%s msg %p tid %llu\n", __func__, msg, tid);


