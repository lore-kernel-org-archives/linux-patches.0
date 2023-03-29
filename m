Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ADC710FA
	for <patches@lists.linux.dev>; Wed, 29 Mar 2023 05:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=guyHag9qCqT02ycAP5gFYMiS5Z8MMs8Ps7B6B4e3yQk=; b=0s+ZsQtqvZrSA+dzaZX4im6LhE
	WyYiRJxXstb/bqMR3zp8lDLo3bPTmJaJEWSTCh06Aez4lV2UP5frUnAfsl7KhQGMydKgbO1lw7zhb
	5jDrZkRjvFJfeHZVno0lB+v2bfAxpKG/fGbbO0mlzuPuljHB9FQjYJ/jVkpBdrh4YEiBJCnK3TUmn
	hiaTcVuownYisCxprFvcXdMGJps9Idj/5unt/K9XrpcpkHwN+cyMrQDW7fOwdPR91ENj/EqR2BYlX
	ZDIkrXjOcSqgk2+GqwuSjX7aetm38G9LIM3wHa+55pCtzqIALL7J0jkg4T34ZcZ7/7O5zQ66cDSM2
	QzeATbHg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1phOPW-00GgRb-2M;
	Wed, 29 Mar 2023 05:31:50 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: david@redhat.com,
	patches@lists.linux.dev,
	linux-modules@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pmladek@suse.com,
	petr.pavlu@suse.com,
	prarit@redhat.com,
	torvalds@linux-foundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org
Cc: christophe.leroy@csgroup.eu,
	tglx@linutronix.de,
	peterz@infradead.org,
	song@kernel.org,
	rppt@kernel.org,
	willy@infradead.org,
	vbabka@suse.cz,
	mhocko@suse.com,
	dave.hansen@linux.intel.com,
	mcgrof@kernel.org
Subject: [PATCH 4/7] sempahore: add a helper for a concurrency limiter
Date: Tue, 28 Mar 2023 22:31:46 -0700
Message-Id: <20230329053149.3976378-5-mcgrof@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230329053149.3976378-1-mcgrof@kernel.org>
References: <20230329053149.3976378-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

While I looked at re-using the old kernel/kmod.c (now kernel/module/kmod.c)
concurrency delimiter methodology for another place in the kernel Linus
noted that this could be simply replaced with a sempahore [0].

So add that so we we don't re-invent the wheel and make it obvious to use.

[0] https://lore.kernel.org/all/CAHk-=whkj6=wyi201JXkw9iT_eTUTsSx+Yb9d4OgmZFjDJA18g@mail.gmail.com/

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 include/linux/semaphore.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/semaphore.h b/include/linux/semaphore.h
index 6694d0019a68..2ecdffdb9814 100644
--- a/include/linux/semaphore.h
+++ b/include/linux/semaphore.h
@@ -28,6 +28,9 @@ struct semaphore {
 #define DEFINE_SEMAPHORE(name)	\
 	struct semaphore name = __SEMAPHORE_INITIALIZER(name, 1)
 
+#define CONCURRENCY_LIMITER(name, n) \
+	struct semaphore name = __SEMAPHORE_INITIALIZER(name, n)
+
 static inline void sema_init(struct semaphore *sem, int val)
 {
 	static struct lock_class_key __key;
-- 
2.39.2

