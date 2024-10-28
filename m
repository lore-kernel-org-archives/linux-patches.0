Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C6C8837;
	Mon, 28 Oct 2024 06:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098312; cv=none; b=St55TgAot73MZK4coFQ/Udt93Bj81XrDyhmsWVkhQl75Kzvxbsy9KOY5cgWAvUmy+uBMpXxAgYmn41JWvySQA1+ic8kTSSBdYVQHZazcBOP30Uz5g9sp0rH8wgb0QMQaUuh0lXOGQbOoapPJdx87HV+9nIPpoi0ZoxkPznPANds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098312; c=relaxed/simple;
	bh=QroTJCDtdzH8nLRz7QWDndNwUTI1Xd7BLNB+OcJ0L2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ske8J9wwzYk0yE1Ji7jmQcI1Mckk0j5Bv0olyXAl2+c6nD29rR3jGaUUsiWTDoZbw48IA8rRH29FZBmbDN6Ht+9FJmInf7Szph+JAaO5VmNTlMZiwqqwpwrpNUzl0gEAoxR7JNESYM4iAN7QH6ikEqspB1JtFJUq1K7ifOBmpAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0dkQCIBu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0dkQCIBu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA254C4CEC3;
	Mon, 28 Oct 2024 06:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098312;
	bh=QroTJCDtdzH8nLRz7QWDndNwUTI1Xd7BLNB+OcJ0L2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0dkQCIBu5s1222X9D7vHFJSgvtfWpKcl3HBFi8ZXMfvcLW/grjPPk9PMC4wcdmEDc
	 wntVbEDmlql3E+xDjQc8hiJTx33vOmogY0w1K/0N3mawJSSAMwJk9J5zUSmKjA9x3i
	 tTeikbnl1FGVaFkGhd/s6K13/cCREuR/G4AG3VUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Cochran <richardcochran@gmail.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 170/261] posix-clock: posix-clock: Fix unbalanced locking in pc_clock_settime()
Date: Mon, 28 Oct 2024 07:25:12 +0100
Message-ID: <20241028062316.257128470@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 6e62807c7fbb3c758d233018caf94dfea9c65dbd ]

If get_clock_desc() succeeds, it calls fget() for the clockid's fd,
and get the clk->rwsem read lock, so the error path should release
the lock to make the lock balance and fput the clockid's fd to make
the refcount balance and release the fd related resource.

However the below commit left the error path locked behind resulting in
unbalanced locking. Check timespec64_valid_strict() before
get_clock_desc() to fix it, because the "ts" is not changed
after that.

Fixes: d8794ac20a29 ("posix-clock: Fix missing timespec64 check in pc_clock_settime()")
Acked-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Acked-by: Anna-Maria Behnsen <anna-maria@linutronix.de>
[pabeni@redhat.com: fixed commit message typo]
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/posix-clock.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/time/posix-clock.c b/kernel/time/posix-clock.c
index 6b5d5c0021fae..a6487a9d60853 100644
--- a/kernel/time/posix-clock.c
+++ b/kernel/time/posix-clock.c
@@ -310,6 +310,9 @@ static int pc_clock_settime(clockid_t id, const struct timespec64 *ts)
 	struct posix_clock_desc cd;
 	int err;
 
+	if (!timespec64_valid_strict(ts))
+		return -EINVAL;
+
 	err = get_clock_desc(id, &cd);
 	if (err)
 		return err;
@@ -319,9 +322,6 @@ static int pc_clock_settime(clockid_t id, const struct timespec64 *ts)
 		goto out;
 	}
 
-	if (!timespec64_valid_strict(ts))
-		return -EINVAL;
-
 	if (cd.clk->ops.clock_settime)
 		err = cd.clk->ops.clock_settime(cd.clk, ts);
 	else
-- 
2.43.0



