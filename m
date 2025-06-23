Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06D51E5B71;
	Mon, 23 Jun 2025 21:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714130; cv=none; b=lXmx8pXo/b9FlpzrVzH5ppfsXT5VzgiGBLHrr+J9S+xHbobRtTPlf5YEFcYs5a4G8XLDkVOnz4o6+YaP92fpPE3Buk4/brG4eYwm8HyzHeHNEwFOJ3ogqsZ093LsHUVJAaxEo8KtGYzSOsIfP33hd6o6DLink+JndZu5A3cYrx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714130; c=relaxed/simple;
	bh=BlNC21t4px582KbiLtMf3+80Vg1rpf3ADiM+VbgVciA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ldr71/xrQs9IvxJPbp85zp2LgSXVpCW0FtUs3ezhg7LoKquaECodhbbfDdZaVj4PDKgYohmvLOxGtWZb8hr3IGfaODNoQhQHsHUHwZ2FbVTavWHhaHBWH3wDBBGVDR2wb5NaM/cBVwRzqJbchycVk1eFbp/EL1jg8oVGALGORX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZXhtIj1C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZXhtIj1C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5874DC4CEEA;
	Mon, 23 Jun 2025 21:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714130;
	bh=BlNC21t4px582KbiLtMf3+80Vg1rpf3ADiM+VbgVciA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZXhtIj1CpwM0AUM5fKZ1prvkYDIH4xFDB1XocZx7hcA0EmXZgp7emSVyCLILGZYhK
	 NpuOPcasF7WdB6bCZaFDq5ArjC62PyvVsq2Mhb0FYXFUlG+r0TkR649WLK8qTP488b
	 3NLVQ9UgsyGPqAUsyi6D7L1He9WQf4DFza6LDGKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 104/414] net/sched: fix use-after-free in taprio_dev_notifier
Date: Mon, 23 Jun 2025 15:04:01 +0200
Message-ID: <20250623130644.700187024@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunwoo Kim <imv4bel@gmail.com>

commit b160766e26d4e2e2d6fe2294e0b02f92baefcec5 upstream.

Since taprio’s taprio_dev_notifier() isn’t protected by an
RCU read-side critical section, a race with advance_sched()
can lead to a use-after-free.

Adding rcu_read_lock() inside taprio_dev_notifier() prevents this.

Fixes: fed87cc6718a ("net/sched: taprio: automatically calculate queueMaxSDU based on TC gate durations")
Cc: stable@vger.kernel.org
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/aEzIYYxt0is9upYG@v4bel-B760M-AORUS-ELITE-AX
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_taprio.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1328,13 +1328,15 @@ static int taprio_dev_notifier(struct no
 
 		stab = rtnl_dereference(q->root->stab);
 
-		oper = rtnl_dereference(q->oper_sched);
+		rcu_read_lock();
+		oper = rcu_dereference(q->oper_sched);
 		if (oper)
 			taprio_update_queue_max_sdu(q, oper, stab);
 
-		admin = rtnl_dereference(q->admin_sched);
+		admin = rcu_dereference(q->admin_sched);
 		if (admin)
 			taprio_update_queue_max_sdu(q, admin, stab);
+		rcu_read_unlock();
 
 		break;
 	}


