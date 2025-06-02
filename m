Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58122C3247;
	Mon,  2 Jun 2025 14:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873436; cv=none; b=vCpxc2swCRLqGA4d6BfZCoMEHEGqlr/SE7oQxj7jyU9j22mWtAUdUMIcDZr3PQRjydeB2oOxeiq1GiG3e+dDoEm07Cmw5NqiJ6QFKPJNZPjfoiqBmhbn1Q+CxjyIYYvhcONpvxr7ZPAdT17196ofSUjlozwsQrsell/b/jdnr90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873436; c=relaxed/simple;
	bh=dUWuVWuH9kCmNgpX6x1/HzcaPH709x4sRRKTY0nrE4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m2lkrlsySBb3L0fcC2jb3ECh2wObK9JgP6TVVJuLjBrssIrVHRp2Nk8EsHEDqJ095bjy63rvIIYQtpQ4gSiNlR9Dr46g0/o6ilzFeyiGShhTcjX9n6V4dXdgLOJScDvnyjicyJlfjJzYuE4YsGwBaPLME7i+peO9DySAu2RD3O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SUI/7Ofx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SUI/7Ofx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23FE6C4CEEB;
	Mon,  2 Jun 2025 14:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873436;
	bh=dUWuVWuH9kCmNgpX6x1/HzcaPH709x4sRRKTY0nrE4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SUI/7OfxGIx0dgQbxzhNZCW+W7ZFJ9gw9eFaTtBcUx7eN2GkU8Lw/ZRF/ipVRjDF6
	 ilmb+YhpTqkTArPDKmh5qUZO6cECaC6MAMQyfWLKP2I1pzMMeiXpVneeJH9iuxMT4M
	 sOyCfEjB68uuqS4JVzbx7hUEJNhC90RQ2C98iTaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 111/444] posix-timers: Add cond_resched() to posix_timer_add() search loop
Date: Mon,  2 Jun 2025 15:42:55 +0200
Message-ID: <20250602134345.402611116@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 5f2909c6cd13564a07ae692a95457f52295c4f22 ]

With a large number of POSIX timers the search for a valid ID might cause a
soft lockup on PREEMPT_NONE/VOLUNTARY kernels.

Add cond_resched() to the loop to prevent that.

[ tglx: Split out from Eric's series ]

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Link: https://lore.kernel.org/all/20250214135911.2037402-2-edumazet@google.com
Link: https://lore.kernel.org/all/20250308155623.635612865@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/posix-timers.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index b924f0f096fa4..7534069f60333 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -118,6 +118,7 @@ static int posix_timer_add(struct k_itimer *timer)
 			return id;
 		}
 		spin_unlock(&hash_lock);
+		cond_resched();
 	}
 	/* POSIX return code when no timer ID could be allocated */
 	return -EAGAIN;
-- 
2.39.5



