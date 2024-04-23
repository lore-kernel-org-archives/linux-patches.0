Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F3F146A64;
	Tue, 23 Apr 2024 21:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908680; cv=none; b=met4KTzW1gL+IQYjEoczd1b/CcL8Y4eQcCmup6kqrux7ZZzsuUojMatZfCdFUkwAmU+kNRdOtcSO238x10q/7rmgv/F/FAfBFo0G3trfbdhX/2cDCTlokC6sJsa0wGLDtOiSnpJW9bH5mSlKWR0UF44nBTiF4J5hdBZ7/OmcY/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908680; c=relaxed/simple;
	bh=qpsG0jYWAbQ57gJcrWWJlvPm3RFmZLNDDficITYSF8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eyenh0ffI0BPjzZZVrN/UUKAP1cHep6EwJqeay3Hl1tgkLOeqCiXRaxLoKQlUvqwTaKMK3l6Mly4YZYVjQWRgTeHWuke5c99w7R6g0E4HjtgizLE28nCOoJH+e2Qnn9rK1OT5GEsMLCX5fTeMjxVIuHVN2FVm4brf6sVh9ULliE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sdbvPuL3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sdbvPuL3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13B5AC32783;
	Tue, 23 Apr 2024 21:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908680;
	bh=qpsG0jYWAbQ57gJcrWWJlvPm3RFmZLNDDficITYSF8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sdbvPuL33EPofnVVyvrFsRLG/O2UyTwefkXXX3cK1GMyad1Xizytvybm/E4YIWrAY
	 yyLzsE0mJA5F595Fx4KWPHtAUB9ezSw02PoT42F6SF3MnRm6g0cO7aRWh5/CxplAEQ
	 t1UHw2SWeOHWBtu+55oim7CasJtBmNCaWCgMR5KQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Izbyshev <izbyshev@ispras.ru>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 005/141] io_uring: Fix io_cqring_wait() not restoring sigmask on get_timespec64() failure
Date: Tue, 23 Apr 2024 14:37:53 -0700
Message-ID: <20240423213853.532291890@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Izbyshev <izbyshev@ispras.ru>

Commit 978e5c19dfefc271e5550efba92fcef0d3f62864 upstream.

This bug was introduced in commit 950e79dd7313 ("io_uring: minor
io_cqring_wait() optimization"), which was made in preparation for
adc8682ec690 ("io_uring: Add support for napi_busy_poll"). The latter
got reverted in cb3182167325 ("Revert "io_uring: Add support for
napi_busy_poll""), so simply undo the former as well.

Cc: stable@vger.kernel.org
Fixes: 950e79dd7313 ("io_uring: minor io_cqring_wait() optimization")
Signed-off-by: Alexey Izbyshev <izbyshev@ispras.ru>
Link: https://lore.kernel.org/r/20240405125551.237142-1-izbyshev@ispras.ru
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2426,6 +2426,14 @@ static int io_cqring_wait(struct io_ring
 			return 0;
 	} while (ret > 0);
 
+	if (uts) {
+		struct timespec64 ts;
+
+		if (get_timespec64(&ts, uts))
+			return -EFAULT;
+		timeout = ktime_add_ns(timespec64_to_ktime(ts), ktime_get_ns());
+	}
+
 	if (sig) {
 #ifdef CONFIG_COMPAT
 		if (in_compat_syscall())
@@ -2439,14 +2447,6 @@ static int io_cqring_wait(struct io_ring
 			return ret;
 	}
 
-	if (uts) {
-		struct timespec64 ts;
-
-		if (get_timespec64(&ts, uts))
-			return -EFAULT;
-		timeout = ktime_add_ns(timespec64_to_ktime(ts), ktime_get_ns());
-	}
-
 	init_waitqueue_func_entry(&iowq.wq, io_wake_function);
 	iowq.wq.private = current;
 	INIT_LIST_HEAD(&iowq.wq.entry);


