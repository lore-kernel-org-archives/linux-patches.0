Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF461A08CA;
	Mon, 12 May 2025 17:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072343; cv=none; b=bwYouB6PiewSys72Mgs8xCmqtBgFxWghTdJWgtMxWKfFjKRzBOdw8PZq259DFsZL8v+DqWICmocVb9CME7z10AOpUtRzNb7hhpD/Ofg6qz4ofI435l5M3XN2JqSyTn7W1ijxnulKlAxn1wRibG/2auK+hWDoWS9RXMHt8xqzWmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072343; c=relaxed/simple;
	bh=Q9Uaw67sflNNMmeA516iGrBXOE1nKUdhDSeEmHlL3O4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m7G8rfxF3F3o38T6OQe1Wl6ARbc/Fl5oPM4+0YMQB8XDXrQXKk1Di5sCFz7E3d2sfSEq93RWUlvf0OG3pL+ug+O++ngBCdfWCs6+tSkzGq51ghRxbxjORAPd9XOZw3r5JuFtD8Yj2ola05aFYzGPsFeqiVl+t3hS3QhKcPG9yA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b7x3unkV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b7x3unkV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24BC5C4CEE7;
	Mon, 12 May 2025 17:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072342;
	bh=Q9Uaw67sflNNMmeA516iGrBXOE1nKUdhDSeEmHlL3O4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b7x3unkVoptQ4Q4nWUjVDUvVDXI8dM5VAjlMfau8cNA0WTX2ZrHJ4Y03akqaStia1
	 YVbjfU2yNICTFpX8mGoUuTrluqCSWcQtpZHB8mA9lcq9qQOTcw6Fth6A9k6J4Unv0w
	 yID7cziE1w+P8xzg+hhCs+eA82VW9i1C/HGy1jwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 11/92] rcu/kvfree: Add kvfree_rcu_mightsleep() and kfree_rcu_mightsleep()
Date: Mon, 12 May 2025 19:44:46 +0200
Message-ID: <20250512172023.588351989@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
References: <20250512172023.126467649@linuxfoundation.org>
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
index d001a69fcb7d4..aef8c7304d45d 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -1031,6 +1031,9 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
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



