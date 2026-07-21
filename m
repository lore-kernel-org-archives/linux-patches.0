Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C49337DE8D;
	Tue, 21 Jul 2026 20:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665184; cv=none; b=LsnWgvf01qTLbAkk3uEOIKUoWgQJNWLC2Kv/6T68w1JwGJuqugiQ07vjCwXVUy/8bxtBnC5I++GFL68fIwv0rZaWomjgU0XM2Z0b+RZ2/Ecu1+1wS9/A3GzoHRFQJgROINUJmInKVTvGM3UaNE+SGUaLDzPh8UIpNLcA38Sunhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665184; c=relaxed/simple;
	bh=SNC3GdHsVhsqc02mWRcOIn752/BX3DmQadzICnaycAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XNeCOzPKkvocJu0aNIJ+POxChIAPyJWMkYgrVgA+uQI+fX/AVnEUmC5Om+KXyn26H5YrRTZpbSnAxPzXRId89y+o+Rm2eYy/FT/0DBikVt87iT2ULzI5BSc4mdoBiAbx/prJvxFF02Ii51870pX+GHWJJyyKtK6XRYwRA3DjsAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VbJPGTAY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VbJPGTAY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D38D1F000E9;
	Tue, 21 Jul 2026 20:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665183;
	bh=5k+uFh7aaKSHDaYEM6ApucvpGYImGZdoj1gwj6iZrp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VbJPGTAYenoxedUSY8Rv1wGlFxwc/j8eTlejt1Eyv1/RtgBPj7w16UsTAXHpWePg1
	 ReLpCgvcID+GO5X6Id4qXwnckzhuKxH5EcJ7hheuFzzp2mnKM0A+/Q7ywYhOudrYvn
	 12fTK9sdHLhmAlRnu8T3oGUhBlkmtd++1416a8CY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	Thomas Gleixner <tglx@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>
Subject: [PATCH 6.6 0208/1266] posix-cpu-timers: Fix pid refcount leak in do_cpu_nanosleep() error path
Date: Tue, 21 Jul 2026 17:10:45 +0200
Message-ID: <20260721152446.468680796@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: WenTao Liang <vulab@iscas.ac.cn>

commit 87bd2ad568e15b90d5f7d4bcd70342d05dad649c upstream.

In do_cpu_nanosleep(), posix_cpu_timer_create() takes a pid reference
via get_pid() and stores it in timer.it.cpu.pid. If the subsequent
posix_cpu_timer_set() call fails, the function returns immediately
without calling posix_cpu_timer_del() to release the pid reference,
causing a leak.

Fix it by calling posix_cpu_timer_del() before the unlock-and-return
on the error path, consistent with the other exit paths in the same
function.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: WenTao Liang <vulab@iscas.ac.cn>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260611161738.97043-1-vulab@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/posix-cpu-timers.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -1535,6 +1535,7 @@ static int do_cpu_nanosleep(const clocki
 		spin_lock_irq(&timer.it_lock);
 		error = posix_cpu_timer_set(&timer, flags, &it, NULL);
 		if (error) {
+			posix_cpu_timer_del(&timer);
 			spin_unlock_irq(&timer.it_lock);
 			return error;
 		}


