Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD6727604E;
	Tue, 12 Aug 2025 19:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025521; cv=none; b=FlTEnfwqSvLvsLwSw/F2tlOhxWHGk1li6K/XhAyyUQeBnN9Mz1Ea47Km/BuCi5QSCGj//Q5Wv0mFPyuoP2HSyQlk8F/Hj46QVsmHuBVMKw0cdRZGFPEQ0V0inijfnwtsQX9Gd7xsUyjYNuirHXtTXXM/bvnJaxR+x/N2sW1Jcas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025521; c=relaxed/simple;
	bh=nY6c8bJvT7VNNC9tL6gfm+bqtSwfgXC25APpGkXvyiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h99+G97PIeC907L3LUmwKlBzUQlsjZEz8EYczphJsHpUAqztkg81M6U+MiVNAPpZLxQyuTzWjPX/xeH5+OdvvY48gOuna4lgDphHpf5Dw8ymHekcq/eG6Xamhkv8GBGFPAPwJ4hw1/n9bZ0lb11TZbkyOcajTtoV41G/8374fUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cU9csj0v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cU9csj0v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53478C4CEF0;
	Tue, 12 Aug 2025 19:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025520;
	bh=nY6c8bJvT7VNNC9tL6gfm+bqtSwfgXC25APpGkXvyiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cU9csj0v4n3RVtrk37Q2ssihVRAm0D6DAP55uVb2ba2Ap1Jr2XK2mbF4nS/ycqtS+
	 1WeB2HMzYtR+8wUZrl8ZNm2VXqCs69vYF0wUrJx5mn3j5xxELyoZCFeZtfVXRbRzBE
	 GX+UEAX9X3+C4QC4O4ONSOQUdd11dpg3FfwgEVQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis OSTERLAND-HEIM <denis.osterland@diehl.com>,
	Rodolfo Giometti <giometti@enneenne.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 065/480] pps: fix poll support
Date: Tue, 12 Aug 2025 19:44:33 +0200
Message-ID: <20250812174400.101063200@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis OSTERLAND-HEIM <denis.osterland@diehl.com>

[ Upstream commit 12c409aa1ec2592280a2ddcc66ff8f3c7f7bb171 ]

Because pps_cdev_poll() returns unconditionally EPOLLIN,
a user space program that calls select/poll get always an immediate data
ready-to-read response. As a result the intended use to wait until next
data becomes ready does not work.

User space snippet:

    struct pollfd pollfd = {
      .fd = open("/dev/pps0", O_RDONLY),
      .events = POLLIN|POLLERR,
      .revents = 0 };
    while(1) {
      poll(&pollfd, 1, 2000/*ms*/); // returns immediate, but should wait
      if(revents & EPOLLIN) { // always true
        struct pps_fdata fdata;
        memset(&fdata, 0, sizeof(memdata));
        ioctl(PPS_FETCH, &fdata); // currently fetches data at max speed
      }
    }

Lets remember the last fetch event counter and compare this value
in pps_cdev_poll() with most recent event counter
and return 0 if they are equal.

Signed-off-by: Denis OSTERLAND-HEIM <denis.osterland@diehl.com>
Co-developed-by: Rodolfo Giometti <giometti@enneenne.com>
Signed-off-by: Rodolfo Giometti <giometti@enneenne.com>
Fixes: eae9d2ba0cfc ("LinuxPPS: core support")
Link: https://lore.kernel.org/all/f6bed779-6d59-4f0f-8a59-b6312bd83b4e@enneenne.com/
Acked-by: Rodolfo Giometti <giometti@enneenne.com>
Link: https://lore.kernel.org/r/c3c50ad1eb19ef553eca8a57c17f4c006413ab70.camel@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pps/pps.c          | 11 +++++++++--
 include/linux/pps_kernel.h |  1 +
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
index 6a02245ea35f..9463232af8d2 100644
--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -41,6 +41,9 @@ static __poll_t pps_cdev_poll(struct file *file, poll_table *wait)
 
 	poll_wait(file, &pps->queue, wait);
 
+	if (pps->last_fetched_ev == pps->last_ev)
+		return 0;
+
 	return EPOLLIN | EPOLLRDNORM;
 }
 
@@ -186,9 +189,11 @@ static long pps_cdev_ioctl(struct file *file,
 		if (err)
 			return err;
 
-		/* Return the fetched timestamp */
+		/* Return the fetched timestamp and save last fetched event  */
 		spin_lock_irq(&pps->lock);
 
+		pps->last_fetched_ev = pps->last_ev;
+
 		fdata.info.assert_sequence = pps->assert_sequence;
 		fdata.info.clear_sequence = pps->clear_sequence;
 		fdata.info.assert_tu = pps->assert_tu;
@@ -272,9 +277,11 @@ static long pps_cdev_compat_ioctl(struct file *file,
 		if (err)
 			return err;
 
-		/* Return the fetched timestamp */
+		/* Return the fetched timestamp and save last fetched event  */
 		spin_lock_irq(&pps->lock);
 
+		pps->last_fetched_ev = pps->last_ev;
+
 		compat.info.assert_sequence = pps->assert_sequence;
 		compat.info.clear_sequence = pps->clear_sequence;
 		compat.info.current_mode = pps->current_mode;
diff --git a/include/linux/pps_kernel.h b/include/linux/pps_kernel.h
index c7abce28ed29..aab0aebb529e 100644
--- a/include/linux/pps_kernel.h
+++ b/include/linux/pps_kernel.h
@@ -52,6 +52,7 @@ struct pps_device {
 	int current_mode;			/* PPS mode at event time */
 
 	unsigned int last_ev;			/* last PPS event id */
+	unsigned int last_fetched_ev;		/* last fetched PPS event id */
 	wait_queue_head_t queue;		/* PPS event queue */
 
 	unsigned int id;			/* PPS source unique ID */
-- 
2.39.5



