Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBABC315D5D;
	Mon, 17 Aug 2026 13:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974217; cv=none; b=P6ZdWpGja5hASz0kZnXj25YuKQc4jSCb0nal3QSYky5m6Agu6smI4I26wZC3O/d+6Ug8tcbYEErt/gHjoieOmIqdxlF41FsgAzhu0+LCWma3ZqHfAq4wBLzUq5zn/znfmGY6tiwII1XHGS9LZXTvDQPl3oDOtyEFXJQjoKQFdY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974217; c=relaxed/simple;
	bh=PZx/Io9XlR40SAySHF39pVNopCq6DPzkvkWygEGmcM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b/ZOgVg1jqREvVqrZ0/RAhoz4VYHtNgujvG/GZf9McaCS8WMYWybmnofjHs3+FnPqrTzVcf660Xrz0atN+NU7N3si9+Y/q7gpIC1mXHxE8rWEOWXTEqYM2/eV39QVL7JtlWTU1mcCmpfdtiwtxSbYhTEkLKVtVGbjuq7pUzicFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TOv6H1cY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TOv6H1cY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 307141F00A3A;
	Mon, 17 Aug 2026 13:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974215;
	bh=SPmJ1fUGYsZehm0YPcndSFsQk1zpGtGqnS77e0Xq2H0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TOv6H1cYJ8Zr034KI2BaGRwAocdjTmoabFAT/Qmq+nKz/XyM9Q6i97RJLRzGZbwoU
	 yEEXDkLL5xE+1Z/2sTBdH4cm9sfo7EpfgGMryixO/N1TOC+biEzrlLRclZzEvgcj6R
	 jFpD538KiEmNtBExvpAaMJD20NzFyfGuThKDZjvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Wilken Gottwalt <wilken.gottwalt@posteo.net>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 122/271] hwmon: (corsair-psu) serialize debugfs access against hwmon
Date: Mon, 17 Aug 2026 15:30:47 +0200
Message-ID: <20260817132541.883689187@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ali Ahmet Memis <ali@iusegentoo.com>

[ Upstream commit 2da6050809d437a805e7a3aa22398a15073b0234 ]

corsairpsu_request() sends a rail select command and then the actual
read as two separate transfers, both going through the single shared
cmd_buffer and wait_completion in corsairpsu_usb_cmd(). The hwmon core
serializes its own callers, but the debugfs files call
corsairpsu_get_value() directly and never take that lock, so a debugfs
read can land between another reader's rail select and its value read.

The result is a value from the wrong rail reported as the right one,
because corsairpsu_usb_cmd() only checks the command echo and both
transfers echo the command it expects. It can also make a caller consume
the reply meant for the other one, since raw_event() writes into the
shared buffer and completes whoever happens to be waiting.

Locking was dropped in commit 4207069edbf0 ("hwmon: (corsair-psu) Rely
on subsystem locking") on the grounds that the subsystem serializes for
us, which holds for sysfs but not for these files. Take
the same lock in the debugfs paths that issue commands, using the guard
added in commit d1e720c7328e ("hwmon: Support guard() and scoped_guard
for subsystem locks").

The lock cannot go into corsairpsu_request() itself: the hwmon core
already holds it across ->read, so every sysfs read would deadlock.
vendor_show() and product_show() only print strings cached during probe
and issue no command, and corsairpsu_get_criticals() and
corsairpsu_check_cmd_support() run before either interface is
registered, so none of them need it.

Fixes: 4207069edbf0 ("hwmon: (corsair-psu) Rely on subsystem locking")
Signed-off-by: Ali Ahmet Memis <ali@iusegentoo.com>
Tested-by: Wilken Gottwalt <wilken.gottwalt@posteo.net>
Link: https://lore.kernel.org/r/20260806142139.168611-1-ali@iusegentoo.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/corsair-psu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/hwmon/corsair-psu.c b/drivers/hwmon/corsair-psu.c
index 3c01ae3fc4af2..ebcaddf337d80 100644
--- a/drivers/hwmon/corsair-psu.c
+++ b/drivers/hwmon/corsair-psu.c
@@ -664,6 +664,8 @@ static void print_uptime(struct seq_file *seqf, u8 cmd)
 	long val;
 	int ret;
 
+	guard(hwmon_lock)(priv->hwmon_dev);
+
 	ret = corsairpsu_get_value(priv, cmd, 0, &val);
 	if (ret < 0) {
 		seq_puts(seqf, "N/A\n");
@@ -723,6 +725,8 @@ static int ocpmode_show(struct seq_file *seqf, void *unused)
 	long val;
 	int ret;
 
+	guard(hwmon_lock)(priv->hwmon_dev);
+
 	/*
 	 * The rail mode is switchable on the fly. The RAW interface can be used for this. But it
 	 * will not be included here, because I consider it somewhat dangerous for the health of the
-- 
2.53.0



