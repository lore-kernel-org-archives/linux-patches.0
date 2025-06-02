Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D06228CB8;
	Mon,  2 Jun 2025 14:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875486; cv=none; b=g9P7afM5PbHS3vjHvXj80chVo3Ti+Nu+NHCZ9IuKEMgIB/EaLIbxGHm6MLnBzCooeU1t0GlYOo29pEpx0MFJdYiMz5KGBUnKC1Dr37l9egeg4O69TImMD3OJUG5KZOIuUhCYTWbbV9fa+LQlsBc6lxUXDJIc9L4m//yrXsOJ2kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875486; c=relaxed/simple;
	bh=XXNabtyj3KNm+CScohq32bHx3JCqGVyj2zfYEW6orFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJwBJ/f2+uJsB/ffGrH9IymHKs+bUY+iQHVb8UyWxnWxe+RZdnD2OCy40vCjuul14Rd4e9hBf1VQES1Z+fwcpGOmR53tXfU97lTlDCR9jD5f7eo6Pa36LngL1LTdmF2kePUs3TY4AHZ7m2bb9oPJFphLCSLRaK92q8QKKmsx8Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PhgVLVoM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PhgVLVoM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E164C4CEEB;
	Mon,  2 Jun 2025 14:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875486;
	bh=XXNabtyj3KNm+CScohq32bHx3JCqGVyj2zfYEW6orFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PhgVLVoM96AtxdHD4m8oa6vq8NlcvXuJwYafaSzK1pGkjWsHGyRG0Pos9WyVL9jmz
	 kU+aZSJPaG3bhQqYYgsIH3LTTFhC2Zpdd32j1tIfdPKp6VyuCr+WYESCW/dhk6xKnE
	 7euFrF+xGY2mA1i8L8AUWjENnQlPhUhlSDjupb8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 149/270] posix-timers: Add cond_resched() to posix_timer_add() search loop
Date: Mon,  2 Jun 2025 15:47:14 +0200
Message-ID: <20250602134313.313074797@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 29569b1c3d8c8..3a68c650ff2a3 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -161,6 +161,7 @@ static int posix_timer_add(struct k_itimer *timer)
 			return id;
 		}
 		spin_unlock(&hash_lock);
+		cond_resched();
 	}
 	/* POSIX return code when no timer ID could be allocated */
 	return -EAGAIN;
-- 
2.39.5



