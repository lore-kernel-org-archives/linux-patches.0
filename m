Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9F23A3E78;
	Tue, 16 Jun 2026 17:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630909; cv=none; b=ueDVdZMUZANpZd4oecs+31gMFbnvbcapkCamVJfSnHFvlgx32FCsoT0z1/jJoaYlwK3fB4biP+qqQIi+Wdj2KRTDjfAS8V3hQziM1zJqSLG75eN+DakIzXliW+ywQzfyXG4QCphQPJN5MF+KeCOprc84hcjA74Vqbo4U65lVuFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630909; c=relaxed/simple;
	bh=HXONo6ZmwbJpvpYDvaIDW40P0bQBXeWNVr13wK3dbn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=faU/2sNlRlhRBy1rMXR8EfDUywIgmcJ52JfuVbDuSpOeI3V5sjaWFsBUq6QQMKL08I906/P3+eZZWM8F7LeLquPyge5VnXlvoyFc0SnyPjw8XajagWL5wcAiwLmf/B66OBSiKRsDMWQteeia7uczSHLVISw/NUpzwMl8mYrrTN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JscCwdQ7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JscCwdQ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F581F000E9;
	Tue, 16 Jun 2026 17:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630906;
	bh=A+IlkMsini4iPvBLiYjOMZLw+1tU33rvFE7YHulY9k0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JscCwdQ7Pk5QPZAOnmYADcN4iVhs2AFYG6VJ4ygx+pdcF3Zq8ProSSLJO2i2qlF64
	 uupNrFt6pLP5l5x03CZx9lvE+QGn0eRexgFCqQAGKa7D57JjSpVD0TjcA3bGSav9Cm
	 2YXigmA7uS9jzF4ODLCgZGWkpMqsaNmUL2Uvz4iI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Yuqi Xu <xuyq21@lenovo.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 119/522] bpf: sockmap: fix tail fragment offset in bpf_msg_push_data
Date: Tue, 16 Jun 2026 20:24:26 +0530
Message-ID: <20260616145131.538857925@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

From: Yuqi Xu <xuyq21@lenovo.com>

commit f72eed9b84fb771019a955908132410a9ba9ea3f upstream.

When bpf_msg_push_data() inserts data in the middle of a scatterlist
entry, it splits the original entry into a left fragment and a right
fragment.

The right fragment offset is page-local, but the code advances it with
`start`, which is the message-global insertion point. For inserts into a
non-first SG entry, this over-advances the offset and leaves the split
layout inconsistent.

Advance the right fragment offset by the fragment-local delta,
`start - offset`, which matches the length removed from the front of the
original entry.

Fixes: 6fff607e2f14 ("bpf: sk_msg program helper bpf_msg_push_data")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Yuqi Xu <xuyq21@lenovo.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Link: https://patch.msgid.link/8b129d10566aa3eb43f61a8f9757bcf51707d324.1779636774.git.xuyq21@lenovo.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/filter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2841,7 +2841,7 @@ BPF_CALL_4(bpf_msg_push_data, struct sk_
 
 		psge->length = start - offset;
 		rsge.length -= psge->length;
-		rsge.offset += start;
+		rsge.offset += start - offset;
 
 		sk_msg_iter_var_next(i);
 		sg_unmark_end(psge);


