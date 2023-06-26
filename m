Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C60134CE
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:24:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1910C433C8;
	Mon, 26 Jun 2023 18:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803894;
	bh=SXnFj8phiuIcEtJaOFCkfnSCzYd3acM35wTkcbKZ30c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2kfYnr8qwEB/03xOHF4/eIqmdIMWEuLezNz7AY5XOwYQlU62zfH08G/pOmUVXQwg0
	 bIMKuaLL5ayhThZNH5c28BA9uqFxtXS+Pm0Sj/BCOEY/k/Bur67HK6tVa2vF4sHuJi
	 VmO8dQqUU5tSeIBpolVII0vV+xDJGtIeizf74VhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Bart Van Assche <bart.vanassche@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	Johannes Thumshirn <jthumshirn@suse.de>,
	Shane M Seymour <shane.seymour@hpe.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 14/41] rcu: Upgrade rcu_swap_protected() to rcu_replace_pointer()
Date: Mon, 26 Jun 2023 20:11:37 +0200
Message-ID: <20230626180736.834563023@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180736.243379844@linuxfoundation.org>
References: <20230626180736.243379844@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit a63fc6b75cca984c71f095282e0227a390ba88f3 ]

Although the rcu_swap_protected() macro follows the example of
swap(), the interactions with RCU make its update of its argument
somewhat counter-intuitive.  This commit therefore introduces
an rcu_replace_pointer() that returns the old value of the RCU
pointer instead of doing the argument update.  Once all the uses of
rcu_swap_protected() are updated to instead use rcu_replace_pointer(),
rcu_swap_protected() will be removed.

Link: https://lore.kernel.org/lkml/CAHk-=wiAsJLw1egFEE=Z7-GGtM6wcvtyytXZA1+BHqta4gg6Hw@mail.gmail.com/
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
[ paulmck: From rcu_replace() to rcu_replace_pointer() per Ingo Molnar. ]
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Shane M Seymour <shane.seymour@hpe.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: a61675294735 ("ieee802154: hwsim: Fix possible memory leaks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rcupdate.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 68cbe111420bc..cf139d6e5c1d3 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -410,6 +410,24 @@ static inline void rcu_preempt_sleep_check(void) { }
 	_r_a_p__v;							      \
 })
 
+/**
+ * rcu_replace_pointer() - replace an RCU pointer, returning its old value
+ * @rcu_ptr: RCU pointer, whose old value is returned
+ * @ptr: regular pointer
+ * @c: the lockdep conditions under which the dereference will take place
+ *
+ * Perform a replacement, where @rcu_ptr is an RCU-annotated
+ * pointer and @c is the lockdep argument that is passed to the
+ * rcu_dereference_protected() call used to read that pointer.  The old
+ * value of @rcu_ptr is returned, and @rcu_ptr is set to @ptr.
+ */
+#define rcu_replace_pointer(rcu_ptr, ptr, c)				\
+({									\
+	typeof(ptr) __tmp = rcu_dereference_protected((rcu_ptr), (c));	\
+	rcu_assign_pointer((rcu_ptr), (ptr));				\
+	__tmp;								\
+})
+
 /**
  * rcu_swap_protected() - swap an RCU and a regular pointer
  * @rcu_ptr: RCU pointer
-- 
2.39.2



