Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2748A26980C;
	Tue,  8 Apr 2025 12:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113826; cv=none; b=SP773ULueU9pTc24Fb488jqE8JOZpNaMyK7/6AYsbsvv2nrjBVbFQR714zp1TtedOf3TF3aZNjkq1go1ToAmckfjFv7rwUEhPt5CDjwlonqUmJybQgYka04HLY8g2qV3Ow6Rv1ajbCP7NB4BTGYBN8fV20DO+shcBPo0b7NOoVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113826; c=relaxed/simple;
	bh=rjO1pQgvUUH571dK4IX1N+n/cDBv7ReHM7lJyTwQU6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jbd6BZ7gOzmzCoURvXhaZiQ/ol8kGPbXjiLFph/b7OySgGY4dksQ9GLbUAJUJoO/fjT21s82pYxtX4MR9HZVL4sNoTqvwt+QUY9sLAWrUFvYsmbsXas0qamhHJiJNyBSvwSSVx2bDc0Y8y1bD0UHp6ln+W5KJOvGHg2ELozLV7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MZpm749l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MZpm749l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8207EC4CEE7;
	Tue,  8 Apr 2025 12:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113826;
	bh=rjO1pQgvUUH571dK4IX1N+n/cDBv7ReHM7lJyTwQU6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MZpm749lZShbH+G9V1mrIwHlPLLAq7vwtuJ8m6fmb5FAmYPlrbCzj3SR+ZtSNR0bW
	 7j8+JN71fkTbTadtKmyt2G5kvKXEm6LXBZFYO45LEoZaibP0iUTp/EZXLfm8ufZQIf
	 jx0vM3m4714rNXaYjfRfuZNZ4/RbFiNHZD5kBSxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Lixu <lixu.zhang@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 027/154] HID: intel-ish-hid: fix the length of MNG_SYNC_FW_CLOCK in doorbell
Date: Tue,  8 Apr 2025 12:49:28 +0200
Message-ID: <20250408104816.134402363@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Lixu <lixu.zhang@intel.com>

[ Upstream commit 4b54ae69197b9f416baa0fceadff7e89075f8454 ]

The timestamps in the Firmware log and HID sensor samples are incorrect.
They show 1970-01-01 because the current IPC driver only uses the first
8 bytes of bootup time when synchronizing time with the firmware. The
firmware converts the bootup time to UTC time, which results in the
display of 1970-01-01.

In write_ipc_from_queue(), when sending the MNG_SYNC_FW_CLOCK message,
the clock is updated according to the definition of ipc_time_update_msg.
However, in _ish_sync_fw_clock(), the message length is specified as the
size of uint64_t when building the doorbell. As a result, the firmware
only receives the first 8 bytes of struct ipc_time_update_msg.
This patch corrects the length in the doorbell to ensure the entire
ipc_time_update_msg is sent, fixing the timestamp issue.

Signed-off-by: Zhang Lixu <lixu.zhang@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-ish-hid/ipc/ipc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/intel-ish-hid/ipc/ipc.c b/drivers/hid/intel-ish-hid/ipc/ipc.c
index 8f8dfdf64833e..871f043eeba1e 100644
--- a/drivers/hid/intel-ish-hid/ipc/ipc.c
+++ b/drivers/hid/intel-ish-hid/ipc/ipc.c
@@ -549,14 +549,14 @@ static void fw_reset_work_fn(struct work_struct *unused)
 static void _ish_sync_fw_clock(struct ishtp_device *dev)
 {
 	static unsigned long	prev_sync;
-	uint64_t	usec;
+	struct ipc_time_update_msg time = {};
 
 	if (prev_sync && jiffies - prev_sync < 20 * HZ)
 		return;
 
 	prev_sync = jiffies;
-	usec = ktime_to_us(ktime_get_boottime());
-	ipc_send_mng_msg(dev, MNG_SYNC_FW_CLOCK, &usec, sizeof(uint64_t));
+	/* The fields of time would be updated while sending message */
+	ipc_send_mng_msg(dev, MNG_SYNC_FW_CLOCK, &time, sizeof(time));
 }
 
 /**
-- 
2.39.5



