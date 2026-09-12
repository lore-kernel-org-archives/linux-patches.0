Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0FF37702C;
	Sat, 12 Sep 2026 08:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201655; cv=none; b=pUUY8R9pSOdZIIxNIpXq0WXI1esdirp1CdAeRuO4v6OVSGA0kI5C5UKGPg3Zu8Prx2GwN7G27p7CdJ1nXWHJFSINYJlQzxpSVn9vlTfNHIFlAGDwZhbrI9CK2ajdoG45Ez/ZtaGDFa9I8EsUMAdaj3IyX5Z9FHIooHbZ9eTD64w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201655; c=relaxed/simple;
	bh=ZeJRhsXWXJ9SeVwCGWjUj/9l5U19yuFWekUZHqbllyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l02yTil6I3CV4iShkjsz6/bCMWRKcgYf50YwITTTTHVv5PWplSqcpGnfID7af87uZNRIHdEYe5MRUCSNcxEvghbZw9146Nm5LtdhH47JvbGRG+PJgH+VIshnv4lmfBsjhIL+TgYd2o7G3T13q1G1yktM8Rxj9r6PWkviQicdEGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bqkPLfDd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bqkPLfDd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A361F000FF;
	Sat, 12 Sep 2026 08:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201653;
	bh=rj5BkhKJ/hMGOGFZXdVDULcSiJDmb41W2IpGazQHStI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bqkPLfDdxuvRKa+qC3kbYNcPfTYL4j0L9ZXg+y6obdZ+KEy5fEe4IriwmjgoCbvdA
	 NtLIoFNpNjOH5y1x2sngRU7nK09luQwItKQKNyZCDJMR913+V5jh8SlIGXDA7N0Gm1
	 HaM0l/8R3hyCEqYtcCVxEbsFOKTPnRxAU60dPfV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Calvin Owens <calvin@wbinvd.org>,
	Sashiko <sashiko-bot@kernel.org>,
	Rodolfo Giometti <giometti@enneenne.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1039/1815] pps: dont try to wait for negative timeouts in PPS_FETCH
Date: Sat, 12 Sep 2026 08:46:29 +0200
Message-ID: <20260912065713.411017611@linuxfoundation.org>
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
index de1122bb69ea6..7ecdd774a44b9 100644
--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -66,13 +66,19 @@ static int pps_cdev_pps_fetch(struct pps_device *pps, struct pps_fdata *fdata)
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



