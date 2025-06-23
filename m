Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0144819CC11;
	Mon, 23 Jun 2025 21:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714633; cv=none; b=g3Ei4a2+xsR7qxliOJh1adGT+cahPDMBjvhxmMejTd4o7K2OFpJjcFes8fS5K4/W7/okZ7LNhHMqBBw6NbFXr0rVU3a7vy2NH+mWhbaKnCWb+mEqc3pg7rvDZMTDJveYe/1n8SyqsGIa2ZwF/xRiQ9Lkx+/bkz1Bii/b+AoQijc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714633; c=relaxed/simple;
	bh=KnGSc3n7fWUz86uoxbTWhwCYtKv3iv3/Hhluea4MsI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YOCkoJ2qxjk02BUuX2i1saCNnlSLk9zm4rdTcwjyMPBRCcycaEBC5o5oNuKK0Lu7G8YJkdfz32agIvHona3xMT6Uv5n54snoWnRrtgMfhLUf9rik9z8LTe4G+hUnkNFGwy3RLJq+HSCKiov4JvrfaqMZpF/x+PEZVJO+8nrXSu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nee4SgGT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nee4SgGT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FCC0C4CEEA;
	Mon, 23 Jun 2025 21:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714632;
	bh=KnGSc3n7fWUz86uoxbTWhwCYtKv3iv3/Hhluea4MsI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nee4SgGTZCH1i6yOQVnypStTqnxoW1yqJOoohwQ7lhWDcvUTpfN25FtgYePUd3cF7
	 jtk60HK9evQOwFuWPMdojYwIb6Goojn+qurEwArZO2MO0juGXa/bH05il6L9Uvaaao
	 sHxjQHKXB/tW8K3+127ixxOjS4PkYNwKR+rtDZKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 406/592] sock: Correct error checking condition for (assign|release)_proto_idx()
Date: Mon, 23 Jun 2025 15:06:04 +0200
Message-ID: <20250623130710.096066530@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit faeefc173be40512341b102cf1568aa0b6571acd ]

(assign|release)_proto_idx() wrongly check find_first_zero_bit() failure
by condition '(prot->inuse_idx == PROTO_INUSE_NR - 1)' obviously.

Fix by correcting the condition to '(prot->inuse_idx == PROTO_INUSE_NR)'

Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250410-fix_net-v2-1-d69e7c5739a4@quicinc.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 5034d0fbd4a42..3e8c548cb1f87 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -4004,7 +4004,7 @@ static int assign_proto_idx(struct proto *prot)
 {
 	prot->inuse_idx = find_first_zero_bit(proto_inuse_idx, PROTO_INUSE_NR);
 
-	if (unlikely(prot->inuse_idx == PROTO_INUSE_NR - 1)) {
+	if (unlikely(prot->inuse_idx == PROTO_INUSE_NR)) {
 		pr_err("PROTO_INUSE_NR exhausted\n");
 		return -ENOSPC;
 	}
@@ -4015,7 +4015,7 @@ static int assign_proto_idx(struct proto *prot)
 
 static void release_proto_idx(struct proto *prot)
 {
-	if (prot->inuse_idx != PROTO_INUSE_NR - 1)
+	if (prot->inuse_idx != PROTO_INUSE_NR)
 		clear_bit(prot->inuse_idx, proto_inuse_idx);
 }
 #else
-- 
2.39.5



