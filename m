Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0991C5799;
	Sat, 12 Sep 2026 18:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239561; cv=none; b=mg2TEr7jlF8p7CJ+QOLYoWKxZK0Di6F2qCiK03lqxIEDv9EF/imMdZ/t4WbD++jZ5AKNSnvxSeGjKxxpZ9DcMpca7BzjrGENYU0W9CraqkgnwCYP0txKbW5st6rKP7ZPgunl5iapiTrBU96gHUho1U4dEvNysDOuKv/5IQVKi6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239561; c=relaxed/simple;
	bh=sM0YvKDMmCKVxoxo61Z5F8PTX6c8a2zO9kffbO1YZjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bks5NG0bU+r3cgBfGpDapYhJPu4zJnBXMvT0DHSNz+Af8MyIjXP9N/zVtGMVnAp9XKvJaPjbP+n1P7sAjJZy99xyhq1vDDVe4r+hpcvl9jOyxvFLcSZlgaGOGB93dglgrYnvRaOcoKeCpffLBbWAoU88Fih1GjV1Z6Wl1aD/wyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TxAaQwll; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TxAaQwll"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D4911F000FF;
	Sat, 12 Sep 2026 18:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239559;
	bh=s5wXBMP8z8yZVSeXLPMoRf2VqlETjI0yTjmcGMcis+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TxAaQwllsODRp9df5VVV8eiT6MqffWFh3nMmMto8R89eHTy2V67OUR04GoUhIfDon
	 LLH6EqppKNAsBn1wrKnX+sexwNBC+SCR5yiPa7mNy5nRhL9HHZCNpewUuYZqaWO4t/
	 sgp3j/Eqf3nd98ySbAnh9Ub28vciAQ7raBuSGYOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Calvin Owens <calvin@wbinvd.org>,
	Sashiko <sashiko-bot@kernel.org>,
	Rodolfo Giometti <giometti@enneenne.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 690/935] pps: dont try to wait for negative timeouts in PPS_FETCH
Date: Sat, 12 Sep 2026 09:02:00 +0200
Message-ID: <20260912065542.667211529@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Calvin Owens <calvin@wbinvd.org>

[ Upstream commit 45217e98987a87ff2372386dbf82fd5325db28ea ]

If userspace passes a negative timeout to PPS_FETCH, it triggers a kernel
splat from schedule_timeout():

    schedule_timeout: wrong timeout value fffffffffff0bfb4
    CPU: 17 UID: 0 PID: 4720 Comm: a.out Not tainted 7.1.0-rc5-x86-kvm-00150-g331d97e36b37 #1 PREEMPT_RT
    Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-20240910_120124-localhost 04/01/2014
    Call Trace:
     <TASK>
     dump_stack_lvl+0x4b/0x70
     schedule_timeout+0xb7/0xe0
     pps_cdev_pps_fetch.isra.0+0x93/0x150
     pps_cdev_ioctl+0x70/0x310
     __x64_sys_ioctl+0x7b/0xc0
     do_syscall_64+0xb6/0xfc0
     entry_SYSCALL_64_after_hwframe+0x4b/0x53

Here is a trivial reproducer that works with the PPS_CLIENT_KTIMER test
device enabled in the kernel:

    #include <stdlib.h>
    #include <fcntl.h>
    #include <unistd.h>
    #include <sys/ioctl.h>
    #include <linux/pps.h>
    #include <err.h>

    int main() {
        struct pps_fdata fdata;
        int fd;

        fd = open("/dev/pps0", O_RDWR);
        if (fd == -1)
            err(1, "Failed to open /dev/pps0");

        fdata.timeout.sec = -1;
        fdata.timeout.nsec = 0;

        if (ioctl(fd, PPS_FETCH, &fdata))
            err(2, "PPS_FETCH failed");

        close(fd);
        return 0;
    }

Sashiko imagines this to be some sort of security problem, which is
obviously really silly.  But I think it is still worth fixing, so buggy
userspace code can't trigger the splat.

Silence the splat by using timespec64_to_jiffies(), which hard limits the
timeout to LONG_MAX jiffies.  To be safe, explicitly preserve the
-ETIMEDOUT return value userspace sees today if it passes a negative
timeout.

If you really squint, this is still a slight behavior change in that there
are "denormalized" combinations of tv_sec and tv_nsec which used to work
but will now return -ETIMEDOUT.  I can't imagine anybody will care about
that...

Link: https://lore.kernel.org/c5c97c3b3c9d66010382094fd538e59a38f4aacf.1781289959.git.calvin@wbinvd.org
Fixes: eae9d2ba0cfc ("LinuxPPS: core support")
Signed-off-by: Calvin Owens <calvin@wbinvd.org>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/cover.1779733602.git.calvin%40wbinvd.org?part=3
Acked-by: Rodolfo Giometti <giometti@enneenne.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pps/pps.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
index dbeb67ffebf33..6fca934d5d429 100644
--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -63,13 +63,19 @@ static int pps_cdev_pps_fetch(struct pps_device *pps, struct pps_fdata *fdata)
 		err = wait_event_interruptible(pps->queue,
 				ev != pps->last_ev);
 	else {
+		struct timespec64 ts;
 		unsigned long ticks;
 
 		dev_dbg(&pps->dev, "timeout %lld.%09d\n",
 				(long long) fdata->timeout.sec,
 				fdata->timeout.nsec);
-		ticks = fdata->timeout.sec * HZ;
-		ticks += fdata->timeout.nsec / (NSEC_PER_SEC / HZ);
+
+		if (fdata->timeout.sec < 0)
+			return -ETIMEDOUT;
+
+		ts.tv_sec = fdata->timeout.sec;
+		ts.tv_nsec = fdata->timeout.nsec;
+		ticks = timespec64_to_jiffies(&ts);
 
 		if (ticks != 0) {
 			err = wait_event_interruptible_timeout(
-- 
2.53.0



