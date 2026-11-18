Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042860;
	b=4mYNaLLINdEWP8M5mf+XnqPUpvMDEfOzT173XlWMdkmML/ZKE1+HSm3zSrIN7fy+Q1Cw
	 u8rlrfyyaOBvml+8GqBmHL/TgFtQEByC72U3ONKwuttyFwnNuaCn689AG6IvZ95ZUQ4Oq
	 saUN8BzxUJCrgHmzSKkv2E7JpRIrlyz60DPtddmLTbETwlZAWgwIfBtLqI0yYekjnF8AH
	 Enb2MW3H5RRhoEbzYa2eAZJM1SRrStNRlKNW/3Gkzni82zukFp2ZwneleeQeMY1xMGbMX
	 Qe4TuWJfFRfphKg50F5gi+YIStPJljF8QTVDXtbhL/I5BKtqWnt/WCz2sg2xrrDfs1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042860;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2bqtYr0kQEPJSdVFXKAtfKW2zVhfewslvQtgSxjqicM=;
	b=OzeYqMYiyg1efCmCRc7xCy8AV3PSlr8nxz00JOgs5fMrKJ4DJuorHfKoxwjBOKiHYVnH
	 7Nl4Vfv2t+pson1i11jhPfN3jrfx64UGHraxn/YbGOY3GlDtHg9euksmlCots1/3S2AdS
	 3I1zk+BGt9wmhHMuow5m7DaNjqpdGXpdL4ITZ8uiAf5tI+h+SnG61hm06+KH6ZhxSjMJA
	 jQdAMnA9IvDJaEoJie+rjEeKaGT4dBeiHO3B24eg7sfIAozCM8EQaOSih3dKN8bbNjABe
	 zbjCf7l2ICkU9d7uXl8tm/FiqMzyhrnp1rUT8nO0bU9sEzLczX1IUMfVLSdT1WIStkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D7NUkqR8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D3E606A31C;
	Wed, 18 Nov 2026 23:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D7NUkqR8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D4C1F000C5;
	Wed, 18 Nov 2026 23:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042860;
	bh=2bqtYr0kQEPJSdVFXKAtfKW2zVhfewslvQtgSxjqicM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D7NUkqR8Y+11D+O/M0kWYrui7PiiaHBHdF7PCp0IAb+pNd4roFI06NO9deymwrIDz
	 TAVH/kqKa6h/5yhh4tz5g8aNHhmiyXKC+dfE4WIpquLTanNk+xCtxUf2e4b01Z09rh
	 2XpXE+rtDOCG8zErdsTU8grTKZQm2zOBCu6mS+9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	Bradley Morgan <brads@mainlining.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3290/3318] ucount: read the parent ucounts before dropping the rlimit count
Date: Wed, 18 Nov 2026 16:05:12 +0100
Message-ID: <20261118150458.296827626@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nickolai Zeldovich <nickolai@csail.mit.edu>

[ Upstream commit 38bf603d1ea5d5a65a9cb277df75327ffec01ff1 ]

do_dec_rlimit_put_ucounts() drops its share of iter->rlimit[type] and
only then loads iter->ns->ucounts. If the decrement leaves the count
non-zero, a concurrent caller can take it to zero and put the last
reference, which frees the ucounts and possibly its user namespace with
kfree_rcu(). An exiting task frees its pending signals without siglock
or any RCU read-side section, so when it is preempted between the
decrement and the load for a grace period it reads freed memory and
then decrements a counter through the pointer it found there.

A pending signal holds no reference on its ucounts: the reference is
taken by whoever moves the count from 0 to 1 and dropped by whoever
moves it back to 0, so the caller's share of the count is all that
keeps iter alive, and only until it is dropped.

Load the parent first; it stays pinned by the caller's share of its
own count.

Fixes: 15bc01effefe ("ucounts: Fix signal ucount refcounting")
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Link: https://patch.msgid.link/20261024015513.830312-1-nickolai@csail.mit.edu
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/ucount.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/ucount.c b/kernel/ucount.c
index c73d5a38ef7ee..6d76ce60fc31b 100644
--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -295,9 +295,12 @@ static void do_dec_rlimit_put_ucounts(struct ucounts *ucounts,
 {
 	struct ucounts *iter, *next;
 	for (iter = ucounts; iter != last; iter = next) {
-		long dec = atomic_long_sub_return(1, &iter->rlimit[type]);
-		WARN_ON_ONCE(dec < 0);
+		long dec;
+
+		/* Our count pins @iter; once it is dropped @iter may be freed. */
 		next = iter->ns->ucounts;
+		dec = atomic_long_sub_return(1, &iter->rlimit[type]);
+		WARN_ON_ONCE(dec < 0);
 		if (dec == 0)
 			put_ucounts(iter);
 	}
-- 
2.53.0



