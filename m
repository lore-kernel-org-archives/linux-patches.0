Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060552;
	b=mvY/2ARkJERn0/iXTl+jcZDKGfys9fADZJKtY4RN1CgNafeHV98a0825K4sMBsj7C9ku
	 a6XoJkDisHykBsCGpxvMOH52DgS6LcQX2YKboRnYsNd0NY6+RxktrbB0PTG5R2Ns6FM80
	 2RwOx8IMZP3U4lBQM6fAUuhliaOB7KRB0ntHjn3RT0XF4xZT/iRL4sA6J2iSLAG29yXM+
	 88X6OeI0CHNua684/uwPCt4GvXKR1KdH7ychC4Hy5Cvy2KF7DptH2vINq08Wn5vwgL8nt
	 HOO1Wb2VfLUjspB3LGv2qLTMd93mU7Ao4LxIhKyeYtpGIUa6hiJtWoJU2qDf3NM400w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060552;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZrD0I1ZTcNPzgNw8TmZAAzQtrYX/tTcoUUW+5LAgaWQ=;
	b=MFr3pBqycwV7XC6X09KFmypVEV4n3PCNAbjQ5nPvKPT7J/vujSoy/NHndKzxGAZJPld4
	 EnoEENuqx6aa4IYiIaqUUKnRaKcd00RKq508o5QijYj7Yz1W7I8I4Qr0pUz4lsvEIta5J
	 d0ELy/yNd++ik+8l2E4WLdtgwN0PIB4wFVhD+V5PQ/D7F21YISKTAJON3laCIMyusmseC
	 hQYb9hTZypNecYjkWEby2PAxhcNYwbIqESPvjwjMq5gCAz29xDKPFojVtpZqke+J07pX/
	 o5K/ds/qAW5WbU6QTmUoMgF7LEY8dryiGWsGFZLTUazszqKXBJ/DhUu8OnXxBbqUMng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=03ok7PCn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80875606A326;
	Sat,  7 Nov 2026 14:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=03ok7PCn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8601F0089F;
	Sat,  7 Nov 2026 14:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060552;
	bh=ZrD0I1ZTcNPzgNw8TmZAAzQtrYX/tTcoUUW+5LAgaWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=03ok7PCnOgyulNx3T8pblqaDGYbfhCVakblyLDBP9p511QaQQL5mvoiztdv+F+LHj
	 CKc2k20WofBTSE0oMAoMw7/a9kYb4kGjaGejRlcHi50KeRmDcthwvO3nrRGjVZryR7
	 39/ZtM20z9lk29Zss46l8HK9q01ZOmncXFblz1cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0018/1536] fork: move the coredump and exec checks into create_io_thread()
Date: Sat,  7 Nov 2026 08:33:54 -0500
Message-ID: <20261107134958.192470907@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit e760200370e4de054b6b5f568a7faa911e2956bb ]

Only a PF_USER_WORKER thread returns from get_signal() after a fatal
signal and can go on to create a thread. get_signal() sets PF_SIGNALED
before it dumps core and before it lets a PF_USER_WORKER thread return.
That flags sticks.

The exec'ing thread itself is never signaled. But it doesn't need the check
anyway as we moved cancellation of io_uring requests before de_thread().
create_io_thread() is the only way a signaled thread creates another
one. vhost_task_create() is reached from ioctls alone.

io_should_retry_thread() doesn't retry -EINTR, so io-wq callers give up
the same way they did when copy_process() refused.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Link: https://lore.kernel.org/r/aq0VLTyxNatFmLOK@redhat.com
Link: https://patch.msgid.link/20260921-work-coredump-fixes-v3-13-8e4adb1619e6@kernel.org
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Stable-dep-of: 1f978881ce6c ("fork: don't create io threads once PF_POSTCOREDUMP is set")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/fork.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/fork.c b/kernel/fork.c
index f22b79d9954a8..c82956f8fc9d5 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2774,6 +2774,10 @@ struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node)
 		.user_worker	= 1,
 	};
 
+	/* A creator past its fatal signal gets no thread. */
+	if (current->flags & PF_SIGNALED)
+		return ERR_PTR(-EINTR);
+
 	return copy_process(NULL, 0, node, &args);
 }
 
-- 
2.53.0



