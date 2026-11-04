Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826786;
	b=o+2byh1ak0C91WX6v0udjgdAegF5M5qsQRh/yvLkLPv2OZeDpQd6kg4y/PncFLRgOyN9
	 3wFeua+lQkx/XRVJ798lKLWb7WO6z5UwCq7gP+5AXNkwH02xWaGk7g6JnUGPG4ChNgGx/
	 ZSWuBFxoAdNYBrslOf9ptD+i4wgNJA7xfnGOFm9+8j5zkgWMyc9kk3GQH1rM0DSi6hMxL
	 uqOS8mkiHas7vNsRWYq3b7ryuH+AM6tc823cGkwlPVxFSrHxC//5ehnztwgTcVk0Cozgd
	 f8jIscEoPSZdJ4m6tSkoYVhmTU8xNwRO1xC/CDxt3ZrbydksnHRFIgC4C0Oc4uhQE6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826786;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=houNDDaEzwObt2uld173tIJh3mVgvI58c5fj7YT0vdA=;
	b=1kAmh6S4CkiMI3graMIo1+tzrg42NwT9DhSxm6jG1eQTHUbSoL8oXLcgNIbPlUd5UtEV
	 x8NwiXrSAolOE1BQqJ6S0S70zIQYM9nvKP15LCg2ML+I+hcJmU8BBtTplZR6C4sON8O71
	 bLTLa/jQWNPVaBHToTJtvG4XsM6SqLAF/sA1sEm+TOaktn1Cy4SyC4qKHkWAtS6DpOUnr
	 SLeBNImPCxaYmZVTC47l/lvIccqUYDRSu4t48kvle7KuLQrtldFiF+73hxM1HhbAy77bX
	 3ypoazzXCell72Gird5Jz6LhbPjRDTIRnxIMrL/De61WPf3b4V1ygyWmNhsaQoJmsVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yARJAaTL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27906071A07;
	Wed,  4 Nov 2026 21:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yARJAaTL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 030C71F000C1;
	Wed,  4 Nov 2026 21:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826786;
	bh=houNDDaEzwObt2uld173tIJh3mVgvI58c5fj7YT0vdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yARJAaTLk8x3NKBqtKJl05alW8azvBGt2zhdmYuE/ZjzNLKwjuSKAlRntAH4qP5jS
	 PzRo/pP42y1nf4SVWKgaQMG759T/6CkByMuMN81HxBWc1DlD1AmVO4aUNaAR+Cla7H
	 BpWOJQEecUKs7X+AdeLiECbJYEyICTIvOl1SBsf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0009/1005] fork: move the coredump and exec checks into create_io_thread()
Date: Wed,  4 Nov 2026 15:55:42 -0500
Message-ID: <20261104211043.796385107@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 6734b94600333..bf0bbd8a569e5 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2559,6 +2559,10 @@ struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node)
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



