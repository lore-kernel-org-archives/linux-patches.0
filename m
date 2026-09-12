Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3382830DEA3;
	Sat, 12 Sep 2026 19:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242997; cv=none; b=EX8G10cclUiO+tLiTs7ww8qI25hf8qJeBRmcTtRlAe36JtRw+wgHJNOPDP6h+jbfOb+Cu3gssC1JpxS/zRmPmY1c5fcn+LZBMCrcxTV2jWU1wJj4JHuD5JCun3ofVi3ezhSu7oFQo+adelznojt06Dlub3Jsbe45IyK5aQxiPNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242997; c=relaxed/simple;
	bh=xjEeBlq1fmLLp26XmNGYtCiwpxUIvhj9YJE9nipgbHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sno0rQ7mUeR3MYfyRn7Byx7WYzMVvClqaKERdZVGvPoI52BNfAVB6qBc7uFABgWCH8tJKhIXqflBKtEvTnMyPK67QzpZBC9fkdv6EQchcrfbWzB7hL0rIO4OXQQjCwZNtSyFfnXaNRRE+mcooyY5CtubWEM//KaV2pmIaNm6PZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c5wl9XKH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c5wl9XKH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66A911F000FF;
	Sat, 12 Sep 2026 19:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242995;
	bh=Gb2dmQGGzCSVZmiKL8bEp3aLgHSAjOmJveo0QBLbJy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c5wl9XKHJe1T2v0EXoDecpJyHUVGKO4i+E6lswoIJBq6eqeHRYs8Irow4fIx8Xc2K
	 syf0KPhhwGoRRxXuZVKNYNbkpYXyntRNER11B59Rnuml4UWOUbnsWS0r1Kp2yuIJ/l
	 /BrRu/7jVRF6XABnr2bZ17fViCCMINp+TQ1kflck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Calvin Owens <calvin@wbinvd.org>,
	Sashiko <sashiko-bot@kernel.org>,
	Rodolfo Giometti <giometti@enneenne.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 598/798] pps: dont try to wait for negative timeouts in PPS_FETCH
Date: Sat, 12 Sep 2026 09:03:46 +0200
Message-ID: <20260912065530.829857517@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



