Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5802F2D;
	Tue, 27 Feb 2024 13:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041432; cv=none; b=ru418T+zyWqYPCasGaCMcojIzZ7Z6z+f2/pw7S4Xly3eBVrZXqyyW205g2yuGH9UJHJRuoEO1gYm+WggTcsXZS8dYNHKt4zbVmsBz2KKCtEomH1C7loDGlbINMnV/5RaUC5cmUvHmOwU8mH4LksNTGq6k7VHq9TwGjLKHdriQAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041432; c=relaxed/simple;
	bh=ko2O66fO6kQjbYybOd77+x+5TiLAbkUgcYqtgYRa0VQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X3hPIe2+VBvE+QSDOp+ibHXtj05JsWQgy/NE7TTSBMaRGi9U1orVFxQsSMCyZt/OylXwrZr5D/IF/7HkMURVaKYba30WzKB8ws6D/Z8K2KnBOAMxZnJPU+JYZdIJWFddB0Vx/WOhg4rUeaFflAoyXa89DPq+J6ZfRLHJz4PhDLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ErjbL0rr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ErjbL0rr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A19CC43390;
	Tue, 27 Feb 2024 13:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041432;
	bh=ko2O66fO6kQjbYybOd77+x+5TiLAbkUgcYqtgYRa0VQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ErjbL0rrVr1OKseBCCuikzNYc69+ORSA5PxWASII/tGfdtAbrbfX4zR1ecHu4dHzV
	 LErQOsHh5ok/Cg4zK8oxel7+fJEW+Dtygqwa+C/HYj1RmnGyOwoWycOi88u/OCQ5JM
	 NRxE7NJoLvr9/NTHop5pC1zN7iwFmmdWg7vuzm+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 312/334] tools: ynl: make sure we always pass yarg to mnl_cb_run
Date: Tue, 27 Feb 2024 14:22:50 +0100
Message-ID: <20240227131641.131570803@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit e4fe082c38cd74a8fa384bc7542cf3edf1cb7318 ]

There is one common error handler in ynl - ynl_cb_error().
It expects priv to be a pointer to struct ynl_parse_arg AKA yarg.
To avoid potential crashes if we encounter a stray NLMSG_ERROR
always pass yarg as priv (or a struct which has it as the first
member).

ynl_cb_null() has a similar problem directly - it expects yarg
but priv passed by the caller is ys.

Found by code inspection.

Fixes: 86878f14d71a ("tools: ynl: user space helpers")
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Link: https://lore.kernel.org/r/20240220161112.2735195-2-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/net/ynl/lib/ynl.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/net/ynl/lib/ynl.c b/tools/net/ynl/lib/ynl.c
index 830d25097009a..65975a8306738 100644
--- a/tools/net/ynl/lib/ynl.c
+++ b/tools/net/ynl/lib/ynl.c
@@ -462,6 +462,8 @@ ynl_gemsg_start_dump(struct ynl_sock *ys, __u32 id, __u8 cmd, __u8 version)
 
 int ynl_recv_ack(struct ynl_sock *ys, int ret)
 {
+	struct ynl_parse_arg yarg = { .ys = ys, };
+
 	if (!ret) {
 		yerr(ys, YNL_ERROR_EXPECT_ACK,
 		     "Expecting an ACK but nothing received");
@@ -474,7 +476,7 @@ int ynl_recv_ack(struct ynl_sock *ys, int ret)
 		return ret;
 	}
 	return mnl_cb_run(ys->rx_buf, ret, ys->seq, ys->portid,
-			  ynl_cb_null, ys);
+			  ynl_cb_null, &yarg);
 }
 
 int ynl_cb_null(const struct nlmsghdr *nlh, void *data)
@@ -737,11 +739,14 @@ static int ynl_ntf_parse(struct ynl_sock *ys, const struct nlmsghdr *nlh)
 
 static int ynl_ntf_trampoline(const struct nlmsghdr *nlh, void *data)
 {
-	return ynl_ntf_parse((struct ynl_sock *)data, nlh);
+	struct ynl_parse_arg *yarg = data;
+
+	return ynl_ntf_parse(yarg->ys, nlh);
 }
 
 int ynl_ntf_check(struct ynl_sock *ys)
 {
+	struct ynl_parse_arg yarg = { .ys = ys, };
 	ssize_t len;
 	int err;
 
@@ -763,7 +768,7 @@ int ynl_ntf_check(struct ynl_sock *ys)
 			return len;
 
 		err = mnl_cb_run2(ys->rx_buf, len, ys->seq, ys->portid,
-				  ynl_ntf_trampoline, ys,
+				  ynl_ntf_trampoline, &yarg,
 				  ynl_cb_array, NLMSG_MIN_TYPE);
 		if (err < 0)
 			return err;
-- 
2.43.0



