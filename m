Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889701D86DC;
	Mon, 23 Jun 2025 22:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716181; cv=none; b=FYRZCye4yDLKp27FFtIPXde3K3RuTio5/F5ktMVuAkaTJ/pknqnyEMkmQttAIlfB3nkMpH4SI5aSKD3pb3Wkx1itBENUTcVA+W4oVsNKxYonnG16mJR0wxZZ9vGNxqxX7jnUcLoHYK+jAmULbBqbvglmlHEocW8IEMZi8zqTftg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716181; c=relaxed/simple;
	bh=lB9mwtL7KOVSoS/R9SjNlo8JEgZ48euPZcmRGoLh5dU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rZFHJaY5cFQjFMHqq9lJaHSyeWkOsEAsf9XWd25kaObjTE6Wve4V+flKlfsAULwxnh0+/nH80eGauFGejYyWv6+4QEyEb9GA06urr2haNVf9TtKfWXIGlIi4dCbhBOGcCr9ZkhRh0eJzX1lAYXIiMBpdLWzC/UwtU0SJGe1F6fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m5wPukeC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m5wPukeC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20BF2C4CEF1;
	Mon, 23 Jun 2025 22:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716181;
	bh=lB9mwtL7KOVSoS/R9SjNlo8JEgZ48euPZcmRGoLh5dU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m5wPukeCbohLBEYvBCLdyalX0jYLSbMwG4CUoDqJBypJTbC3oW0Oubxvfj7WNVGI+
	 zLWeB45nMXLjtkUNQH2NGnaSdii23Tgrp00S8XDLhhP9UWDWdedWDZ58DS6zhtKyzO
	 AoD+w4qauZu0PI+Ww/Tifn7Xv2eKyM7vfW+DbUkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 333/411] sock: Correct error checking condition for (assign|release)_proto_idx()
Date: Mon, 23 Jun 2025 15:07:57 +0200
Message-ID: <20250623130642.033190587@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7f7f02a01f2dd..3634a4f1f76c6 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3571,7 +3571,7 @@ static int assign_proto_idx(struct proto *prot)
 {
 	prot->inuse_idx = find_first_zero_bit(proto_inuse_idx, PROTO_INUSE_NR);
 
-	if (unlikely(prot->inuse_idx == PROTO_INUSE_NR - 1)) {
+	if (unlikely(prot->inuse_idx == PROTO_INUSE_NR)) {
 		pr_err("PROTO_INUSE_NR exhausted\n");
 		return -ENOSPC;
 	}
@@ -3582,7 +3582,7 @@ static int assign_proto_idx(struct proto *prot)
 
 static void release_proto_idx(struct proto *prot)
 {
-	if (prot->inuse_idx != PROTO_INUSE_NR - 1)
+	if (prot->inuse_idx != PROTO_INUSE_NR)
 		clear_bit(prot->inuse_idx, proto_inuse_idx);
 }
 #else
-- 
2.39.5



