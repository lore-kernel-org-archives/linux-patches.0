Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2956C221FC9;
	Mon,  2 Jun 2025 14:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875153; cv=none; b=GlMRyX8tEJnCbA+Hb4EwK7lKfqQVAfR2uYR2R+fHadxbbO8uEICNPRu1c9NNvXlBXTB8pQkYN6mtvLXDqP4ABuxuLWLCYFHl5L+C6dzgBnYhgHIXQMrscN0Vf++Hiyizfg0pjfgG3Pe1NIkCs9Ixw+pLg+RUtIPvIqa7qUb1IYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875153; c=relaxed/simple;
	bh=Yp/9DDrWH49T12j9ONRxkMVVrIS2mHqQ65BxxSfO/uI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NefvPLkXccPvmVtctzK2G2iGgZugiyMi1nszIyTd54rkKnTpdv3TcXUiL5Iq3zQCfDwTAoBak/vovw/uqXkA2cK1LnTDOrJd04aywOIC6B5ZuM83vBaxet/0eJRmdMprhfIuaNr9hz9B0T2/14pCZ6glXeAu9/FzB5pe7tZsrVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e5xN+/18; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e5xN+/18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D9CC4CEEB;
	Mon,  2 Jun 2025 14:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875152;
	bh=Yp/9DDrWH49T12j9ONRxkMVVrIS2mHqQ65BxxSfO/uI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e5xN+/18/GeEehPTc/JvoHd/4Qc2A+IrTLsipMPy/duwgPQ+Ze0HhJzn3F15y7Mav
	 CHkr2SKJEoDnuJTtSAMciL/EjIsAtdxqrkyen3xfokqQXBCWReehT3sN/epujvp9+k
	 8kg0ap9xfpvr8D6bdDbHmjhuCVkQwVTIUbW0kkxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 045/270] rcu/kvfree: Add kvfree_rcu_mightsleep() and kfree_rcu_mightsleep()
Date: Mon,  2 Jun 2025 15:45:30 +0200
Message-ID: <20250602134309.034536495@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9db6710e6ee7b..9b3e01db654e2 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -987,6 +987,9 @@ do {									\
 #define kvfree_rcu(...) KVFREE_GET_MACRO(__VA_ARGS__,		\
 	kvfree_rcu_arg_2, kvfree_rcu_arg_1)(__VA_ARGS__)
 
+#define kvfree_rcu_mightsleep(ptr) kvfree_rcu_arg_1(ptr)
+#define kfree_rcu_mightsleep(ptr) kvfree_rcu_mightsleep(ptr)
+
 #define KVFREE_GET_MACRO(_1, _2, NAME, ...) NAME
 #define kvfree_rcu_arg_2(ptr, rhf) kfree_rcu(ptr, rhf)
 #define kvfree_rcu_arg_1(ptr)					\
-- 
2.39.5



