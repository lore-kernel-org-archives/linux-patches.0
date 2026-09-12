Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A358E28B4FA;
	Sat, 12 Sep 2026 08:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203158; cv=none; b=Oi1WMqH+crKEHgLAWH4nTDhRTSWXxSEvihjOt7UL7OVQ+X9ehJQLcxrANgm4H6A6ewSubM3m3W3Rz1qX8wYEdscK1j1zQmiXBsDnNy0Ve9BRVeV+h182GrFkDt7cOTIVCgZCPtC/DJYymNJLTENRGpZHcaFJ1N86Ur4sybDn3Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203158; c=relaxed/simple;
	bh=xu9rUFgOaGzQr05ZOtPjLo3NtJb5EnHnwOSzRHbyUfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BNpNiNt6VQrFA13buSpP9e7u8FVkwKHeArvb9Ze7Yr6yZXixY3FZBm94fhW4MGQHufBQCHC+vmoijNsr5xs6cYecWrNPCqJp1oeY779xK2rbBTxRhlKW0eD22ke1xkJCYZdZxlDr0DCYrIUPBGU98GhjlEkl70CKwM9JkTT2PXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jHsIh82S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jHsIh82S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD7E1F000FF;
	Sat, 12 Sep 2026 08:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203157;
	bh=B+MeJ9MmFSUFLt9IHU7XXFjpBlQS8wDu8W26wojkc+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jHsIh82S/yuwznVZFVIaggxQVLeyaWBzdIfof27qQH63a6xx/T3YHflKyMw2crQN0
	 LIenoFcUTCfhitOlNTrAujKUAyNTOrK5/Xhbvd+KancfoRxm9zySeImk51XrbcskBu
	 +T3Zl5DFAHjqS9vLVWv3JZVu7nTFpDgCnBn8WA7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang Hao <haohlliang@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1351/1815] hrtimer: Account nr_retries on recovered interrupt retries
Date: Sat, 12 Sep 2026 08:51:41 +0200
Message-ID: <20260912065720.741215072@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liang Hao <haohlliang@gmail.com>

[ Upstream commit 32a05ba399fc52661f59f38efd2e606f45eb2c8f ]

Re-arranging hrtimer_interrupt() switched the retry path to a local
counter and dropped the update of cpu_base->nr_retries, leaving the
field exported via /proc/timer_list stuck at zero.

Increment nr_retries only when another pass through the expiry loop
is started; the third attempt that falls through to hang handling is
still accounted by nr_hangs alone.

Fixes: 288924384856 ("hrtimer: Re-arrange hrtimer_interrupt()")
Signed-off-by: Liang Hao <haohlliang@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260731150408.19554-1-haohlliang@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/hrtimer.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 313dcea127fe4..96eef3026fbae 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -2228,8 +2228,10 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 	expires_next = hrtimer_update_next_event(cpu_base);
 	cpu_base->hang_detected = false;
 	if (expires_next < now) {
-		if (++retries < 3)
+		if (++retries < 3) {
+			cpu_base->nr_retries++;
 			goto retry;
+		}
 
 		delta = ktime_sub(now, entry_time);
 		cpu_base->max_hang_time = max_t(unsigned int, cpu_base->max_hang_time, delta);
-- 
2.53.0



