Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CDA1E1C11;
	Mon, 21 Oct 2024 10:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507805; cv=none; b=Zz49MPHuQosw4DHLxLKiYadlVNh1q6uQSpUl1d46o4BWy9GRaL7CQBFOGUYmRs453hENiOB8grbS69sstMISsHq6oZPcOwnT7qyzFYXeZrOafgB2tZ6NR5XJQ1VyvF/703flZ/a4QKgtICu5yUh63gP+9xtgFyl+j14NszQBZCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507805; c=relaxed/simple;
	bh=ZTEO9dhrlmEgVCbs+aDxkKYXJARZyRQv8fquBqA0plo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RjmAFoo6SgL0ECnbhXOEulLwX1jMOuHv8vTOk0/58HvXGPutxQVFOnj63XgOeBxT7sHN/2fxd9ieuGLQVv9OwM2hXHAmW2ehOr3irOLJyrOr7NJJUyIb46rrBIz9WRytu5x2k+DcLK9RyZwn63HpXEoRXjHisagmvRReohm40Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bpORBYJu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bpORBYJu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65144C4CEC3;
	Mon, 21 Oct 2024 10:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507804;
	bh=ZTEO9dhrlmEgVCbs+aDxkKYXJARZyRQv8fquBqA0plo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bpORBYJuUhNT5jIin4UCB8wdjLeSw2nwsQr/BJYZ/Sd9C0tdd5RGRrk/PbqDGPQiv
	 FYH73y3xXfKk5FadcMaUxmleZnbaAEIgEeEKINpXU2bd83dq2zRg1i9aL8eQIXHvOr
	 Od/1blbQyokyHU94T8fnzNuGHJakipYJ6BGXN4tE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Cochran <richardcochran@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 03/52] posix-clock: Fix missing timespec64 check in pc_clock_settime()
Date: Mon, 21 Oct 2024 12:25:24 +0200
Message-ID: <20241021102241.760860698@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102241.624153108@linuxfoundation.org>
References: <20241021102241.624153108@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -299,6 +299,9 @@ static int pc_clock_settime(clockid_t id
 		goto out;
 	}
 
+	if (!timespec64_valid_strict(ts))
+		return -EINVAL;
+
 	if (cd.clk->ops.clock_settime)
 		err = cd.clk->ops.clock_settime(cd.clk, ts);
 	else


