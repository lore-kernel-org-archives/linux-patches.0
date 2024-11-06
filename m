Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3981DF24A;
	Wed,  6 Nov 2024 12:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895588; cv=none; b=F/48Hmm6BEmR2XbyxbCvsLzWhqc8WtvKmzY30fjhpZwpSmLR7sjyv1YtqiIpS26PQ9hv0mxsXFZKXQmGN/4InHNq4k/Qa38Tn3+0cZy0lbVLNrnr3O1vdLdrsn14wB0BjPWToCeJ4ZkPRHzXb1tFso6zhnAK3iXnour1RUcuaBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895588; c=relaxed/simple;
	bh=YmsD9JYBDeGrAL8wXQU/CUoiy5eFzYjdG2y4KBGnay8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=boooR+iEES2CQ8vk3L6IZ1NN5x+UmpjYMbeeiP7hlfxHQGzgIv6WGW6IdDyZ7pvDz9w/O4HKFS2lItPloFbJZBUUh/X12ifaQyt5TQMgYawu/x8Ch4FZd6gvTLvyLfc0TmepInXitwtnDTQpyKjDyN+ZzxzwxarERZNnjFOJyuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qdtqq9mf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qdtqq9mf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E8BC4CECD;
	Wed,  6 Nov 2024 12:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895588;
	bh=YmsD9JYBDeGrAL8wXQU/CUoiy5eFzYjdG2y4KBGnay8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qdtqq9mfkc1U4Qafp5tXNCHw6uhRPUnRZbUVcHFXEkLnnypkgkoifbCpfHPykxp+b
	 YsY3cBmleV7AVnNG+CZMibmPwnycdRUvFCzdnb0ZxofPwG10a638nwCu/Y3F6knEUr
	 RZIOZBMufDiVutK8SeCaiRKFSAW/8QM3clz4g+wA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Cochran <richardcochran@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 268/350] posix-clock: Fix missing timespec64 check in pc_clock_settime()
Date: Wed,  6 Nov 2024 13:03:16 +0100
Message-ID: <20241106120327.513472441@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

commit d8794ac20a299b647ba9958f6d657051fc51a540 upstream.

As Andrew pointed out, it will make sense that the PTP core
checked timespec64 struct's tv_sec and tv_nsec range before calling
ptp->info->settime64().

As the man manual of clock_settime() said, if tp.tv_sec is negative or
tp.tv_nsec is outside the range [0..999,999,999], it should return EINVAL,
which include dynamic clocks which handles PTP clock, and the condition is
consistent with timespec64_valid(). As Thomas suggested, timespec64_valid()
only check the timespec is valid, but not ensure that the time is
in a valid range, so check it ahead using timespec64_valid_strict()
in pc_clock_settime() and return -EINVAL if not valid.

There are some drivers that use tp->tv_sec and tp->tv_nsec directly to
write registers without validity checks and assume that the higher layer
has checked it, which is dangerous and will benefit from this, such as
hclge_ptp_settime(), igb_ptp_settime_i210(), _rcar_gen4_ptp_settime(),
and some drivers can remove the checks of itself.

Cc: stable@vger.kernel.org
Fixes: 0606f422b453 ("posix clocks: Introduce dynamic clocks")
Acked-by: Richard Cochran <richardcochran@gmail.com>
Suggested-by: Andrew Lunn <andrew@lunn.ch>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://patch.msgid.link/20241009072302.1754567-2-ruanjinjie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/posix-clock.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/time/posix-clock.c
+++ b/kernel/time/posix-clock.c
@@ -312,6 +312,9 @@ static int pc_clock_settime(clockid_t id
 		goto out;
 	}
 
+	if (!timespec64_valid_strict(ts))
+		return -EINVAL;
+
 	if (cd.clk->ops.clock_settime)
 		err = cd.clk->ops.clock_settime(cd.clk, ts);
 	else


