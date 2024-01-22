Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50ADD4E1AD;
	Tue, 23 Jan 2024 00:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971399; cv=none; b=CxOO9SubUl7eHO7FKrifybCjTcJHDxZZN2aIjTLhzSVYMMFifDVLb7cpiKxarvpZHML9eaO1q4ZGVZQmS/cxon0TZ+73c/brbKnjxg3eXMu1l67pKmHMrxPpHie73VhlkGXOwlpu5NsJyFYSjXNOnfi2KnAo93YqIeRlc3+nsCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971399; c=relaxed/simple;
	bh=MKrwNiNRob3Trknt6JBlzMkHYmLESGk9V2AxpNB8jWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OkUpNONYHM++XI6iTL5C7j8EeU6552YsJL0JvvYc81oghCwAfgfoQdiFyhQ2IImGipbPPjo5fAP7Yd/WW46erjDTU3wz2Cr/9rbtw8gH1NGywJO0lcD3pzEB5ncj88hKMbSIf0y1PDGJTHSxvlug5gxSH4ZUCBQ5uXA/oKn8A7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mYkk34VS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mYkk34VS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBFDBC433C7;
	Tue, 23 Jan 2024 00:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971399;
	bh=MKrwNiNRob3Trknt6JBlzMkHYmLESGk9V2AxpNB8jWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mYkk34VS3TyU23iT5x+ghe+yT5Z9lGhBJqa5mWymPIL735pAU1xRk8WC5hc/jb/Tb
	 esLOzYUHyGN+mxiC/rxv1a2g/fSaXeMCTQewnG5YVr/gxU1hFW0hcW6/9yaZoBLHgf
	 rhuFYsMhhIivqIM0k4czLqNyJ6cPApqXNbol5AXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 146/286] rcu: Create an unrcu_pointer() to remove __rcu from a pointer
Date: Mon, 22 Jan 2024 15:57:32 -0800
Message-ID: <20240122235737.783718691@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit 76c8eaafe4f061f3790112842a2fbb297e4bea88 ]

The xchg() and cmpxchg() functions are sometimes used to carry out RCU
updates.  Unfortunately, this can result in sparse warnings for both
the old-value and new-value arguments, as well as for the return value.
The arguments can be dealt with using RCU_INITIALIZER():

	old_p = xchg(&p, RCU_INITIALIZER(new_p));

But a sparse warning still remains due to assigning the __rcu pointer
returned from xchg to the (most likely) non-__rcu pointer old_p.

This commit therefore provides an unrcu_pointer() macro that strips
the __rcu.  This macro can be used as follows:

	old_p = unrcu_pointer(xchg(&p, RCU_INITIALIZER(new_p)));

Reported-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Stable-dep-of: 5f35a624c1e3 ("drm/nouveau/fence:: fix warning directly dereferencing a rcu pointer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rcupdate.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index ef8d56b18da6..8716a1706351 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -366,6 +366,20 @@ static inline void rcu_preempt_sleep_check(void) { }
 #define rcu_check_sparse(p, space)
 #endif /* #else #ifdef __CHECKER__ */
 
+/**
+ * unrcu_pointer - mark a pointer as not being RCU protected
+ * @p: pointer needing to lose its __rcu property
+ *
+ * Converts @p from an __rcu pointer to a __kernel pointer.
+ * This allows an __rcu pointer to be used with xchg() and friends.
+ */
+#define unrcu_pointer(p)						\
+({									\
+	typeof(*p) *_________p1 = (typeof(*p) *__force)(p);		\
+	rcu_check_sparse(p, __rcu); 					\
+	((typeof(*p) __force __kernel *)(_________p1)); 		\
+})
+
 #define __rcu_access_pointer(p, space) \
 ({ \
 	typeof(*p) *_________p1 = (typeof(*p) *__force)READ_ONCE(p); \
-- 
2.43.0



