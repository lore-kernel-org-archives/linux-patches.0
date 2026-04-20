Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370852E36F8;
	Mon, 20 Apr 2026 16:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700939; cv=none; b=FUJ4SbDK2r/8h7hyxfFhUeL4J4VLtPIRmK3o/gNk9KsRM8zQBIwLiLaZPJZAfNgj7CuBM9RofN0Tmv8WcBR+vFc2RDBphCxQnOYSdiFjRSzlozeeXu/qvPiUCKVTuJlj9OtrS7LzgWTegv56tWdcIFUuZ7yRLPDBWw41L/bCzXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700939; c=relaxed/simple;
	bh=uAHAjz1zyYgkosBvHstyMktqA2rKimeGuFKa3Dzw3OQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nvXrZnSA0wcayTRG6y1slCbjw4sksUVnkoR1WxH5WTZ0BtlW4TLOJbAgR+P2EWqIdEU0/2FAOyiIFcUa7gos7O8Z1eabWYkTRJcCGz0cDWsvPDKpEG44E93QmmgVVCo+WCjKsxWWtcxOoxPpsTaoPq3v37GSxWpBW2+lF4SiYe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=esWCPtCo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="esWCPtCo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2510C19425;
	Mon, 20 Apr 2026 16:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700939;
	bh=uAHAjz1zyYgkosBvHstyMktqA2rKimeGuFKa3Dzw3OQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=esWCPtCot4+rvPq1J6a6xb6l5UhrKhFK9scKgHSQQpcOJowP9ixAb52Pxc4HtCySZ
	 p4rIwi7fDQDYHAj6Yh/Ber4il6+2eRXgF6lZRrJp8tcIHROqU3qZN46KXsRca7ttzi
	 Gm+GiR6rUnDLNIjORgGpBLrgMgNTKQhpL46+AzTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d23888375c2737c17ba5@syzkaller.appspotmail.com,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 119/198] crypto: af_alg - Fix page reassignment overflow in af_alg_pull_tsgl
Date: Mon, 20 Apr 2026 17:41:38 +0200
Message-ID: <20260420153939.890702567@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 31d00156e50ecad37f2cb6cbf04aaa9a260505ef ]

When page reassignment was added to af_alg_pull_tsgl the original
loop wasn't updated so it may try to reassign one more page than
necessary.

Add the check to the reassignment so that this does not happen.

Also update the comment which still refers to the obsolete offset
argument.

Reported-by: syzbot+d23888375c2737c17ba5@syzkaller.appspotmail.com
Fixes: e870456d8e7c ("crypto: algif_skcipher - overhaul memory management")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/af_alg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 6867d177f2a2d..b61c3ba126ed1 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -705,8 +705,8 @@ void af_alg_pull_tsgl(struct sock *sk, size_t used, struct scatterlist *dst)
 			 * Assumption: caller created af_alg_count_tsgl(len)
 			 * SG entries in dst.
 			 */
-			if (dst) {
-				/* reassign page to dst after offset */
+			if (dst && plen) {
+				/* reassign page to dst */
 				get_page(page);
 				sg_set_page(dst + j, page, plen, sg[i].offset);
 				j++;
-- 
2.53.0



