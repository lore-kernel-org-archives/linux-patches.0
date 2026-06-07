Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE051E98EF;
	Sun,  7 Jun 2026 10:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829057; cv=none; b=gs3tEDCECVpfP41LVux+MkOIk5zzIZE2x5tmm9KXH5IXJeKfjcVlf3NX8rTZdIU9K9a5T+xmu3NXEHB4Hh/I0yVSWVE86ArjbuUfDrCa9TL6HX2jilaF5vQ1hJ4pqXRQioxXgZTV6asum39UrBM9rZzSKtxzQBmBu9nh3fOncg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829057; c=relaxed/simple;
	bh=ADP8U5kMtaeylYZ1WIaRF75ez4TBsSh1W031smC8W14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=obLXTy8nY0dP7XQ8cScAZxFv5QOMTsv0VE0bO9TtewSVCo7YqFm+lSy9ni5/fDYOoVlHfZ74nD6syS4bOUWhvvzCODHmwbf83TfPxRFFQnGIYTvztBpb6xIhdqu3RSeG4rM3ZecvqbyIR/hOsNj6ApNGegPq2zmPjfLz0CV8Ow0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dQp4/BMM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dQp4/BMM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C691F00893;
	Sun,  7 Jun 2026 10:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829056;
	bh=0wsacAC8oV2wFZmJwyFapsuvFBHUhHEjzmUkXUJiZ+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dQp4/BMMqNV6Tk7u2mEb/rbM7wa3DBYlXWHmcU+mgOswnCNoEU0onOk1RGJbedMj9
	 8kc02n9K2/QhIqDWsZ4tO2n8mouCSu4RkBW6uMkEQvNP7r+mF6ZJ9i4HMoxAkcwQxd
	 +V+4LbWrWxCemNzoV0m1G1GYlrM2207gKyGkWSEs=
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
Subject: [PATCH 7.0 209/332] bpf: sockmap: fix tail fragment offset in bpf_msg_push_data
Date: Sun,  7 Jun 2026 11:59:38 +0200
Message-ID: <20260607095735.743300653@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2865,7 +2865,7 @@ BPF_CALL_4(bpf_msg_push_data, struct sk_
 
 		psge->length = start - offset;
 		rsge.length -= psge->length;
-		rsge.offset += start;
+		rsge.offset += start - offset;
 
 		sk_msg_iter_var_next(i);
 		sg_unmark_end(psge);


