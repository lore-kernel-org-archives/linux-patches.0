Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8ABC611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:36:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56BE9C4339B;
	Sun, 28 May 2023 19:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302567;
	bh=KHIy/DjASbBH8ipHKTTc0diXLpYwEkyqj69dj12HUyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XAseX8zjTxqJGbhwvyMik2H7AYotg6pMy03K4WrgtbKq+IhadRLGcxNzlEZbZch4G
	 DonnumiZ+T8gARwAUl0whr/Jqu+atnfMZ/CbRGKKWuxZ1XdZhC2DA+b39YaPy7YV6M
	 q7LjDdX2CFEPBXACYXmc0C6MZESZs2erChvrMZyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+fe0c72f0ccbb93786380@syzkaller.appspotmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.1 056/119] debugobjects: Dont wake up kswapd from fill_pool()
Date: Sun, 28 May 2023 20:10:56 +0100
Message-Id: <20230528190837.302298871@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190835.386670951@linuxfoundation.org>
References: <20230528190835.386670951@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit eb799279fb1f9c63c520fe8c1c41cb9154252db6 upstream.

syzbot is reporting a lockdep warning in fill_pool() because the allocation
from debugobjects is using GFP_ATOMIC, which is (__GFP_HIGH | __GFP_KSWAPD_RECLAIM)
and therefore tries to wake up kswapd, which acquires kswapd_wait::lock.

Since fill_pool() might be called with arbitrary locks held, fill_pool()
should not assume that acquiring kswapd_wait::lock is safe.

Use __GFP_HIGH instead and remove __GFP_NORETRY as it is pointless for
!__GFP_DIRECT_RECLAIM allocation.

Fixes: 3ac7fe5a4aab ("infrastructure to debug (dynamic) objects")
Reported-by: syzbot <syzbot+fe0c72f0ccbb93786380@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/6577e1fa-b6ee-f2be-2414-a2b51b1c5e30@I-love.SAKURA.ne.jp
Closes: https://syzkaller.appspot.com/bug?extid=fe0c72f0ccbb93786380
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/debugobjects.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -126,7 +126,7 @@ static const char *obj_states[ODEBUG_STA
 
 static void fill_pool(void)
 {
-	gfp_t gfp = GFP_ATOMIC | __GFP_NORETRY | __GFP_NOWARN;
+	gfp_t gfp = __GFP_HIGH | __GFP_NOWARN;
 	struct debug_obj *obj;
 	unsigned long flags;
 


