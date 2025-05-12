Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD16814658D;
	Mon, 12 May 2025 17:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071066; cv=none; b=CVkvKl92uHkGKHSD4wrU3kUM+1rs65kj+JZvzrGEoJTPOIsCkfiRL33vUj5Y3bow1z+8ZUYJmKgj3xjyBHmJfIqwMGsyDGNul7J+tVSGDpPEV0y33NRR6SZb1TRKLxR+dQ0qwxus7f79oTFZjt/U1Xvjn1RtFThNrURvq6vDh+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071066; c=relaxed/simple;
	bh=4Xk1ikB+Y791+qlMnbN4EbY9MhwsuhciyccCj2xM+vE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOaSBz5CHRQz4p+b2OUywVDZtUWtUfFX2KWC86K/yn3smln3Nw4yY9/QLZD6p66rjDM+PF+cMPKerP0rSgTkrXViBZyh0fvVyUXfs8jDPVF1GLT06B0P9mKXkvhdUn9JQpKkpMRQ7QgCw3okbJmp8TSTSCW70C83OS53szW/UYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x5LlF5Dt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x5LlF5Dt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4EBEC4CEE7;
	Mon, 12 May 2025 17:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071066;
	bh=4Xk1ikB+Y791+qlMnbN4EbY9MhwsuhciyccCj2xM+vE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x5LlF5DtTW0OXab6TjCoCzhw1aP9MWLYt0OCZNdj1pHT2dtF0KNy7Wj//8MoAgpkQ
	 p6GEn3Xpy6NjysO+oqimzE6aCxxyMxTYy2LEeLCB0BWYHmkuKM5iLuP/zlBz6WAL2p
	 +kJDdq4yOMdaaLd69gvZbS2itYfRJKpmx+yuvE48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 06/54] rcu/kvfree: Add kvfree_rcu_mightsleep() and kfree_rcu_mightsleep()
Date: Mon, 12 May 2025 19:29:18 +0200
Message-ID: <20250512172015.904517377@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172015.643809034@linuxfoundation.org>
References: <20250512172015.643809034@linuxfoundation.org>
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

From: Uladzislau Rezki (Sony) <urezki@gmail.com>

[ Upstream commit 608723c41cd951fb32ade2f8371e61c270816175 ]

The kvfree_rcu() and kfree_rcu() APIs are hazardous in that if you forget
the second argument, it works, but might sleep.  This sleeping can be a
correctness bug from atomic contexts, and even in non-atomic contexts
it might introduce unacceptable latencies.  This commit therefore adds
kvfree_rcu_mightsleep() and kfree_rcu_mightsleep(), which will replace
the single-argument kvfree_rcu() and kfree_rcu(), respectively.

This commit enables a series of commits that switch from single-argument
kvfree_rcu() and kfree_rcu() to their _mightsleep() counterparts.  Once
all of these commits land, the single-argument versions will be removed.

Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Stable-dep-of: 511e64e13d8c ("can: gw: fix RCU/BH usage in cgw_create_job()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rcupdate.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index d908af5917339..978769e545b5f 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -979,6 +979,9 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
 #define kvfree_rcu(...) KVFREE_GET_MACRO(__VA_ARGS__,		\
 	kvfree_rcu_arg_2, kvfree_rcu_arg_1)(__VA_ARGS__)
 
+#define kvfree_rcu_mightsleep(ptr) kvfree_rcu_arg_1(ptr)
+#define kfree_rcu_mightsleep(ptr) kvfree_rcu_mightsleep(ptr)
+
 #define KVFREE_GET_MACRO(_1, _2, NAME, ...) NAME
 #define kvfree_rcu_arg_2(ptr, rhf)					\
 do {									\
-- 
2.39.5



