Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7D851CF76;
	Thu, 17 Sep 2026 17:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665075; cv=none; b=g+w1cdvZki4vg9i0Mf+aGH7H9adK1Voip/A11oyP9334B4M0AsEjmuGW2W3wkUs/Q7E8k1fjXZHbU776rBdZYHWB2v4bE7B0lITKZf/9ODWoLUt/xq5w8Kv66KNGAT26hAvmU0nbpujJ4Rl6zcSHixnPs/jGm0JuxHXAK17fRCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665075; c=relaxed/simple;
	bh=rxIokByjw+9nJPp/eGBrW0df+wOHmVwFMrn2aYVTM1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C6suFoJM96K5fyIxSTHMeARBilaZOlA1Fe48V42wWLqOfqYOZoPaDH3efAQBn0sDSXidcWzWwkQYY4iIvtdFUeSyLmNW01AMwmdwz9+GoZcZs5nJkxAtD3ZLNF29UplraixlXSRQ7q4FD/kuTe3IVIxMENWcrItsA9tcjpxTqDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uEMg5Y3z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uEMg5Y3z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B11D1F00893;
	Thu, 17 Sep 2026 17:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665074;
	bh=W7PyNm/kfJxJZNEfU3oK0VUQju4HkK7H6hzD8MyMlW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uEMg5Y3zB9Df2uprlX4mPmFhEyp8Rj8loD4CiYRW/UKoipnCRkaVGVJLEQRq/mV5r
	 VqCxDDl665qs7ZBKeQ+eHNfFYAn/pLRpAoe5YJdXLBq1S+dnjnTg4S5voale0ZGuIj
	 YJzq7WglYNZd/RYqPzMIr04nX2ernTTsR6Bh+2wY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Xin Long <lucien.xin@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0584/1250] sctp: fix err_chunk memory leaks in INIT handling
Date: Thu, 17 Sep 2026 16:06:19 +0100
Message-ID: <20260917151607.715307525@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 9f58a0a4d6c2ed5d341bba64f058f15d1b0c36f2 ]

When sctp_verify_init() encounters unrecognized parameters, it allocates an
err_chunk to report them. However, this chunk is leaked in several code
paths:

1. In sctp_sf_do_5_1B_init(), if security_sctp_assoc_request() fails after
   sctp_verify_init() has populated err_chunk, the function returns
   immediately without freeing it.

2. In sctp_sf_do_unexpected_init(), the same leak occurs on the
   security_sctp_assoc_request() failure path.

3. In sctp_sf_do_unexpected_init(), on the success path after copying
   unrecognized parameters to the INIT-ACK, the function returns without
   freeing err_chunk, unlike sctp_sf_do_5_1B_init() which properly frees
   it.

Fix all three leaks by adding sctp_chunk_free(err_chunk) calls before
returning in the error paths and on the success path in
sctp_sf_do_unexpected_init().

Fixes: c081d53f97a1 ("security: pass asoc to sctp_assoc_request and sctp_sk_clone")
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/0656704f1b0158287c98aec09ba36c83e4a537ab.1781970534.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/sm_statefuns.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 1377493b0844c..3a8e16b29660c 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -416,6 +416,8 @@ enum sctp_disposition sctp_sf_do_5_1B_init(struct net *net,
 	/* Update socket peer label if first association. */
 	if (security_sctp_assoc_request(new_asoc, chunk->skb)) {
 		sctp_association_free(new_asoc);
+		if (err_chunk)
+			sctp_chunk_free(err_chunk);
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 	}
 
@@ -1620,6 +1622,8 @@ static enum sctp_disposition sctp_sf_do_unexpected_init(
 	/* Update socket peer label if first association. */
 	if (security_sctp_assoc_request(new_asoc, chunk->skb)) {
 		sctp_association_free(new_asoc);
+		if (err_chunk)
+			sctp_chunk_free(err_chunk);
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 	}
 
@@ -1685,6 +1689,7 @@ static enum sctp_disposition sctp_sf_do_unexpected_init(
 		 * parameter type.
 		 */
 		sctp_addto_chunk(repl, len, unk_param);
+		sctp_chunk_free(err_chunk);
 	}
 
 	sctp_add_cmd_sf(commands, SCTP_CMD_NEW_ASOC, SCTP_ASOC(new_asoc));
-- 
2.53.0



