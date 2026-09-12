Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878DB4BEE43;
	Sat, 12 Sep 2026 16:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229963; cv=none; b=EeBOvEMxn6i3GqwYDpG7N86rgmIcFY8huEEWjde2mV9sxpgdMv7QqlFnifjGxZ6qle4zOUewvvF/f/j0kFlGaWEffbrJl6SLGAYWTJnY5467bx6omZq2sDXffn5mwNfJElraGIyGs7zqyJlK80wJV01AQZUHK5TPw/QzXJlfpv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229963; c=relaxed/simple;
	bh=WR/wLYxLsUXJxWEvWRitubqKxQK6hgmeNKKWhVzvvJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=quDxOBrvpjMiGCKlIsPehTX41WzRIqWLMoBxm3eMhHU9EZjsNW07yQXeS9L/Zgg8yjwK0l5j4kih3RoAlbbdO9zWhIGGJ1EiNJIkAl9uJJOJxD2FpCutm14lgBSP2eJkTHEFf2X72EQ9osNeKmABJjZk2DGknADUmw3CTcCTCvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DQgd1FNp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DQgd1FNp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D2811F000FF;
	Sat, 12 Sep 2026 16:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229962;
	bh=Ggznd7CHHMyPuXAs5yL1wJ3kg9sx9YcLgW3pXUYjfro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DQgd1FNpwPbxc3uXSa+uXv8DAI5EU/fZz291aAiWstImZX4UEjjfkuY6Ij5k4t17R
	 KsWlWdyKou5LgGkER/txg4ze/Vp5oVvKMki5U4Ud/CZSQXi4d68dqn8cpLEDYFQY/z
	 xLD3u3iW15kjILXtCgfDAioNVVwBnxNdAZXBWnwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0644/1191] ppdev: prevent overflow when setting port timeout
Date: Sat, 12 Sep 2026 08:56:12 +0200
Message-ID: <20260912065602.719396374@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit 3c0cf801ea2fa40daa5e7d1e6d32adca5ff75ad9 ]

PPSETTIME64 supplies the timeval fields as s64 values, but
pp_set_timeout() narrows tv_usec to int and calculates tv_sec * HZ in a
signed long. Large positive values can therefore be truncated or overflow
and install an unintended timeout.

Keep both fields as s64, reject a non-canonical microsecond value, and
use timespec64_to_jiffies() to cap excessively large timeouts at
MAX_JIFFY_OFFSET. This is a behavior change because both PPSETTIME
ioctls could previously accept values with tv_usec >= USEC_PER_SEC.
The validation follows the precedent set by sock_set_timeout().

Fixes: 3b9ab374a1e6 ("ppdev: convert to y2038 safe")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Link: https://patch.msgid.link/20260716013923.19494-1-lilinmao@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ppdev.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/char/ppdev.c b/drivers/char/ppdev.c
index a97edbf7455a6..8ab4617592eab 100644
--- a/drivers/char/ppdev.c
+++ b/drivers/char/ppdev.c
@@ -340,15 +340,17 @@ static enum ieee1284_phase init_phase(int mode)
 	return IEEE1284_PH_FWD_IDLE;
 }
 
-static int pp_set_timeout(struct pardevice *pdev, long tv_sec, int tv_usec)
+static int pp_set_timeout(struct pardevice *pdev, s64 tv_sec, s64 tv_usec)
 {
+	struct timespec64 ts;
 	long to_jiffies;
 
-	if ((tv_sec < 0) || (tv_usec < 0))
+	if (tv_sec < 0 || tv_usec < 0 || tv_usec >= USEC_PER_SEC)
 		return -EINVAL;
 
-	to_jiffies = usecs_to_jiffies(tv_usec);
-	to_jiffies += tv_sec * HZ;
+	ts.tv_sec = tv_sec;
+	ts.tv_nsec = tv_usec * NSEC_PER_USEC;
+	to_jiffies = timespec64_to_jiffies(&ts);
 	if (to_jiffies <= 0)
 		return -EINVAL;
 
-- 
2.53.0



