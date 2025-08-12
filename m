Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8C1221FAC;
	Tue, 12 Aug 2025 17:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020766; cv=none; b=LbvZeY7KD2noSOZ4k+S3D06be60iJEo/lRcsKYFI2P5EvEQ4OJ1U40bRk8gK/mmcBWKoIcUrJnOl+2SEa1SlYug3cSLU/4l0+G0YgqbXzebKuj5ZyhIdZPgaaiFoNCsLTyp30HmZbQFq5+wZs2Mlj2mrU9qBPiQeMzqRRW0wVmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020766; c=relaxed/simple;
	bh=PJapiJ2ZGadMXmQOkF1O94k8huJoXw8sryTXQ+gTND4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jI9gohLdd2fp88ytq1/nOOtS/Eq1wOp7ZTMO8NgoGCSwEc4MJ9Pd20TyWpB3R8Snd01wRzItOCcw1EUEvtIkfk3x9H/0d7RqvwmDjFdS/MdN25twXIFsGLWXYBDpWvppaBqfcLfdCV1ynC1doGoxs/0Ufp2re3hKjXzaxJ10ihE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iUs8MuW5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iUs8MuW5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 052E2C4CEF7;
	Tue, 12 Aug 2025 17:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020765;
	bh=PJapiJ2ZGadMXmQOkF1O94k8huJoXw8sryTXQ+gTND4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iUs8MuW5gBJNq493Ll6djr957UC7B6m8i1ogCWP2zotwzWPrhEJZtbdRcPOEr6wD7
	 hgvWo3nbIJKgul943hTO2kDZ1NxWfnv83NFZR+dRMy1Xm1qcJindQk3YvmgNBE1xSQ
	 uYxym+YzuzwgvpkqBvzEn8x0MYLaYLvKcTaVXQco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 136/253] ipv6: fix possible infinite loop in fib6_info_uses_dev()
Date: Tue, 12 Aug 2025 19:28:44 +0200
Message-ID: <20250812172954.480822808@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit f8d8ce1b515a0a6af72b30502670a406cfb75073 ]

fib6_info_uses_dev() seems to rely on RCU without an explicit
protection.

Like the prior fix in rt6_nlmsg_size(),
we need to make sure fib6_del_route() or fib6_add_rt2node()
have not removed the anchor from the list, or we risk an infinite loop.

Fixes: d9ccb18f83ea ("ipv6: Fix soft lockups in fib6_select_path under high next hop churn")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250725140725.3626540-4-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 201a0ef51a6d..061a7a524e5e 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5868,16 +5868,21 @@ static bool fib6_info_uses_dev(const struct fib6_info *f6i,
 	if (f6i->fib6_nh->fib_nh_dev == dev)
 		return true;
 
-	if (f6i->fib6_nsiblings) {
-		struct fib6_info *sibling, *next_sibling;
+	if (READ_ONCE(f6i->fib6_nsiblings)) {
+		const struct fib6_info *sibling;
 
-		list_for_each_entry_safe(sibling, next_sibling,
-					 &f6i->fib6_siblings, fib6_siblings) {
-			if (sibling->fib6_nh->fib_nh_dev == dev)
+		rcu_read_lock();
+		list_for_each_entry_rcu(sibling, &f6i->fib6_siblings,
+					fib6_siblings) {
+			if (sibling->fib6_nh->fib_nh_dev == dev) {
+				rcu_read_unlock();
 				return true;
+			}
+			if (!READ_ONCE(f6i->fib6_nsiblings))
+				break;
 		}
+		rcu_read_unlock();
 	}
-
 	return false;
 }
 
-- 
2.39.5



