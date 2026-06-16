Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A95243D4E9;
	Tue, 16 Jun 2026 16:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628585; cv=none; b=Ii0Pxf80O8nVSbw6Dwucwj3glSh7PB/hAG7YCbawpdP8AnSLhIYs/Mc0/kmvyNS6+X1Er8sJJzlVcEMgXiI+ID/G5k1Pl/JlTvkLzeC0akruUwDHSBe6YYLAgjXIne9eVippoTxwCyR9hCMzQn79N+b+bc9SFC6hvcK6TgvsGHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628585; c=relaxed/simple;
	bh=A9FRdXwFTyeo/VfRiSVvsiyNhl5fUI8tkJJ+D8R5RZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D/P2CPC14XvHFKzPtMX6hrXM6mQM2BBWlW99PNDIX9RotHCMvK/g0KaVvfNqAnv+YAFyllYH31ZIBF6S9kaPUSi64iiSfnEV5Ai6tjgOmCg31ATdYX5vXjDO+R6kSoLkAE/yFW7Yl9Rm1i5j0mv+yZ45Pe+u81x2jOYjTYlEdco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M5XmTE9o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M5XmTE9o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FE381F000E9;
	Tue, 16 Jun 2026 16:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628584;
	bh=4nClIdPNpYM0vPybhyAs0xg1DaRSWexl0qzoaVVb47k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M5XmTE9oIoHCXPGYg8GEyQw7QBRxf01rJ8R5Plq+NYRQa+VmP3F/F1Up/8HG0LUrI
	 a1uuHxFJaFw8DsPYJg1klczcnL+NF/DDlOqBjd7g4HM14bkQvEcfjxvpLibmEyK2l1
	 five27xbt2xAHCASe2pTLyouNZ8WiM3UjDFNp0l8=
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
Subject: [PATCH 6.6 124/452] bpf: sockmap: fix tail fragment offset in bpf_msg_push_data
Date: Tue, 16 Jun 2026 20:25:51 +0530
Message-ID: <20260616145124.262760615@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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
@@ -2848,7 +2848,7 @@ BPF_CALL_4(bpf_msg_push_data, struct sk_
 
 		psge->length = start - offset;
 		rsge.length -= psge->length;
-		rsge.offset += start;
+		rsge.offset += start - offset;
 
 		sk_msg_iter_var_next(i);
 		sg_unmark_end(psge);


