Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953161419A9;
	Tue, 27 Feb 2024 14:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042454; cv=none; b=LaLvPoJLibxFY9De4wPPPYSlpoRhI9QAKYz8dA3gBvK3Bvxod5kzaie4s18kbJwygY/+8W0nsBitMrsdo+/wJ7dcx4NbVexg4jWX5vmPbsVsvoamp2oN+oFi4n3qchoKhupX55AIzduCCXFbrSVVf5gztJ6ykDzmDi0tlUNZKdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042454; c=relaxed/simple;
	bh=ZjXtgJoow3GfODO79skYr3w/YHPPtY/OQHYwqSXO0ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XIgV5T9CvO33ltIijGdF2RFaErvAibYKyce3C7QloUpQxR+EfwLeo7l0t6t2qMbD5BVU6jCH1o8Scxek3v3lviQDSabkddqIytJoiuvdcmaRAKh1vKX+ICKoBGxxJpwL0f7h2By3XDgH9jz4+/tECHrZ6bqfwI+cTbIz/h4FF68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CGE/JJ7p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CGE/JJ7p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FF5CC43390;
	Tue, 27 Feb 2024 14:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042454;
	bh=ZjXtgJoow3GfODO79skYr3w/YHPPtY/OQHYwqSXO0ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CGE/JJ7pdj7YkLKYxkUxN8CkfdUD3nlI+H/niIA3lfRoxchniS/euPKtbOdx0gqSo
	 kHcT+i1FN+hhxAz3XgQRzMvBmK9SyjIUkmituSp0IH2WiH8kjSdUScnMsGCdrK6s2j
	 fwxlUQ07xeBW7mCc8gCyGq62G1qmY/pH5Pao4pAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 277/299] tools: ynl: make sure we always pass yarg to mnl_cb_run
Date: Tue, 27 Feb 2024 14:26:28 +0100
Message-ID: <20240227131634.593776416@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 514e0d69e7310..0a7fe6a13f7b9 100644
--- a/tools/net/ynl/lib/ynl.c
+++ b/tools/net/ynl/lib/ynl.c
@@ -450,6 +450,8 @@ ynl_gemsg_start_dump(struct ynl_sock *ys, __u32 id, __u8 cmd, __u8 version)
 
 int ynl_recv_ack(struct ynl_sock *ys, int ret)
 {
+	struct ynl_parse_arg yarg = { .ys = ys, };
+
 	if (!ret) {
 		yerr(ys, YNL_ERROR_EXPECT_ACK,
 		     "Expecting an ACK but nothing received");
@@ -462,7 +464,7 @@ int ynl_recv_ack(struct ynl_sock *ys, int ret)
 		return ret;
 	}
 	return mnl_cb_run(ys->rx_buf, ret, ys->seq, ys->portid,
-			  ynl_cb_null, ys);
+			  ynl_cb_null, &yarg);
 }
 
 int ynl_cb_null(const struct nlmsghdr *nlh, void *data)
@@ -725,11 +727,14 @@ static int ynl_ntf_parse(struct ynl_sock *ys, const struct nlmsghdr *nlh)
 
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
 
@@ -751,7 +756,7 @@ int ynl_ntf_check(struct ynl_sock *ys)
 			return len;
 
 		err = mnl_cb_run2(ys->rx_buf, len, ys->seq, ys->portid,
-				  ynl_ntf_trampoline, ys,
+				  ynl_ntf_trampoline, &yarg,
 				  ynl_cb_array, NLMSG_MIN_TYPE);
 		if (err < 0)
 			return err;
-- 
2.43.0



