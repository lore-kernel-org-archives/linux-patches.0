Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4605E1E8320;
	Tue, 16 Jun 2026 15:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623361; cv=none; b=NXFZsGoS6xRjIZETemmX4k4WyT01EKoPO+Q4EV4sLkk7I6aTqW60wc2/2wSWJB+Vw/ok+zxhEsA6/AVytHjUXkOawYsdz699HJqVATQQ36O5qImpBz8PmzhbsqS9X7ZVaqVT6UMMuCwbi6V7kb6aF+ZKxy0Y/evO5OTMh0hBirs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623361; c=relaxed/simple;
	bh=SSrXw9dy/UfwtG45z2zDEkMDeGYGOL+jtF1kLFPTTkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AcAXgzh6gzPGWRswY++hX7nobxMRz83fDT7wX7zQQPB2B87DlwUAIjpS/B5RloYGeGeziLG2HjBrVUczu4urBVGin1uW55qKk6dTMAt2gKk/njEQmq4HuRUukrTQl1m1FiRPh4EK524cVl8emYSdNXOJE1PQqqPqiEeotiEsTBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fbdx2v4+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fbdx2v4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42BCB1F000E9;
	Tue, 16 Jun 2026 15:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623360;
	bh=d/yICRG9Cb40rdoS9tirgvaR6uI1tByUQFRPPsyyIDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fbdx2v4+YJWdMlm5CVroeekVoTW2L0IOs7ojvMSREop/aMn9yG0ebqYEaJCpoc40F
	 wpqGNc6onhuQ2VCbvRo+DqHKYS8LY5TewgDQlwPvQsGYBId82yxlYd4+bsjcHKXlxs
	 ieEW5dMT8rFrn/80dVJ1H+3+FPxD6FxDlKrQPanQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 133/378] sctp: validate embedded INIT chunk and address list lengths in cookie
Date: Tue, 16 Jun 2026 20:26:04 +0530
Message-ID: <20260616145117.307552970@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 6f4c80a2a7e6d06753b89a578b710a2499a5e62b ]

sctp_unpack_cookie() only checked that the embedded INIT chunk length
did not exceed the remaining cookie payload, but did not ensure that the
INIT chunk is large enough to contain a complete INIT header.

A malformed COOKIE_ECHO can therefore carry a truncated INIT chunk whose
length field is smaller than sizeof(struct sctp_init_chunk).  Later,
sctp_process_init() accesses INIT parameters unconditionally, which may
lead to out-of-bounds reads.

In addition, raw_addr_list_len is not fully validated against the
remaining cookie payload. When cookie authentication is disabled, an
attacker can supply an oversized raw_addr_list_len and cause
sctp_raw_to_bind_addrs() to read beyond the end of the cookie. The
address parser also lacks sufficient bounds checks for parameter headers
and lengths, allowing malformed address parameters to trigger
out-of-bounds reads.

Fix this by:

- requiring the embedded INIT chunk length to be at least sizeof(struct
  sctp_init_chunk);
- validating that the INIT chunk and raw address list together fit
  within the cookie payload;
- verifying sufficient data exists for each address parameter header and
  payload before parsing it.

Note that sctp_verify_init() must be called after sctp_unpack_cookie()
and before sctp_process_init() when cookie authentication is disabled.
This will be addressed in a separate patch.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/75af23a89adf881a0895d511775e4770da367cbf.1780873427.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/bind_addr.c     | 11 ++++++++++-
 net/sctp/sm_make_chunk.c |  9 +++++++--
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/net/sctp/bind_addr.c b/net/sctp/bind_addr.c
index 75e3e61d494e0f..31737f144c7f03 100644
--- a/net/sctp/bind_addr.c
+++ b/net/sctp/bind_addr.c
@@ -275,6 +275,16 @@ int sctp_raw_to_bind_addrs(struct sctp_bind_addr *bp, __u8 *raw_addr_list,
 		param = (struct sctp_paramhdr *)raw_addr_list;
 		rawaddr = (union sctp_addr_param *)raw_addr_list;
 
+		if (addrs_len < sizeof(*param)) {
+			retval = -EINVAL;
+			goto out_err;
+		}
+		len = ntohs(param->length);
+		if (addrs_len < len) {
+			retval = -EINVAL;
+			goto out_err;
+		}
+
 		af = sctp_get_af_specific(param_type2af(param->type));
 		if (unlikely(!af) ||
 		    !af->from_addr_param(&addr, rawaddr, htons(port), 0)) {
@@ -291,7 +301,6 @@ int sctp_raw_to_bind_addrs(struct sctp_bind_addr *bp, __u8 *raw_addr_list,
 			goto out_err;
 
 next:
-		len = ntohs(param->length);
 		addrs_len -= len;
 		raw_addr_list += len;
 	}
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 9014b095f52ddb..51affa4fd396b7 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -1731,8 +1731,8 @@ struct sctp_association *sctp_unpack_cookie(
 	struct sk_buff *skb = chunk->skb;
 	struct sctp_cookie *bear_cookie;
 	struct sctp_chunkhdr *ch;
+	unsigned int len, chlen;
 	enum sctp_scope scope;
-	unsigned int len;
 	ktime_t kt;
 
 	/* Header size is static data prior to the actual cookie, including
@@ -1761,7 +1761,12 @@ struct sctp_association *sctp_unpack_cookie(
 	bear_cookie = &cookie->c;
 
 	ch = (struct sctp_chunkhdr *)(bear_cookie + 1);
-	if (ntohs(ch->length) > len - fixed_size)
+	chlen = ntohs(ch->length);
+	if (chlen < sizeof(struct sctp_init_chunk))
+		goto malformed;
+	if (chlen > len - fixed_size)
+		goto malformed;
+	if (bear_cookie->raw_addr_list_len > len - fixed_size - chlen)
 		goto malformed;
 
 	/* Verify the cookie's MAC, if cookie authentication is enabled. */
-- 
2.53.0



