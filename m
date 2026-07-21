Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3B735C697;
	Tue, 21 Jul 2026 21:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669030; cv=none; b=gnUy0Yil0SplVU4L6TV+KvH101gDaJpTvD9gB6Ak5Q2AmaNnDJMvmnTwn3UIXZYUZCrtQTMCnNsEsuKAMe6zreviSfNWjOZ36yVOUrVzgzisUYCGZWCwqNb1EE6c1p0Iv4d+obnwE5gTxhz9s9YzmnxBSpGhhVa8mSxznohoul4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669030; c=relaxed/simple;
	bh=zKW1kP1r6SW82/ZFANvQzwF6KM9WVDOs6uK5BnVcZSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pEgb1Ihv8colAWZ2ypgENE1PfaPjcbZ+AYOOiIRvC1EEitDTaB+byESqzJ1i/rAzQ5QKU5jVc2XF93J52EbzDbaFh95Dr8gjXd+9DN4pk+aZVNGAFkEnBn32zGI1dN6gLLDDI3ej3pUcCfvXNi/fdqDdl8OtOS+Q0xMUnlTzIiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Bap7SGh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Bap7SGh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B5D1F000E9;
	Tue, 21 Jul 2026 21:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669029;
	bh=0hZG97I8o7z15pitkL8Bof1gNRiMzIr8GpibMKlDRhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Bap7SGh8fecr/OuUmMVLsibTa4CuQP2ojFaykb5cPLQnK6LxpP4Pi77Wf83yh6kO
	 w98crsLMa9Qk9jIdmTei0sXveSjJMDDiLSQ5bZzXq4DCIqPXRXx/mQf4jLljMQJzN+
	 kQyzO1uGfCCrCMCZJG/gI0K6rQHP+LZonHfMYIWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e70e4c6f6eee43357ba7@syzkaller.appspotmail.com,
	Dmitry Vyukov <dvyukov@google.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0400/1067] firmware_loader: Fix recursive lock in device_cache_fw_images()
Date: Tue, 21 Jul 2026 17:16:41 +0200
Message-ID: <20260721152433.579558221@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Dmitry Vyukov <dvyukov@google.com>

[ Upstream commit d3ec78f8f8d48a04a9fac38d47275c34645e5103 ]

A recursive locking deadlock can occur in the firmware loader's power
management notification handler.

During system suspend or hibernation preparation, fw_pm_notify() calls
device_cache_fw_images(). This function acquires fw_lock to set the
firmware cache state to FW_LOADER_START_CACHE and then iterates over all
devices using dpm_for_each_dev() while still holding the lock.

For each device, dev_cache_fw_image() schedules asynchronous work to cache
the firmware. If memory allocation for the async work entry fails (e.g., in
out-of-memory conditions), async_schedule_node_domain() falls back to
executing the work function synchronously in the current thread.

The synchronous execution path (__async_dev_cache_fw_image() ->
cache_firmware() -> request_firmware() -> assign_fw()) attempts to acquire
fw_lock again. Since the current thread already holds fw_lock, this results
in a recursive locking deadlock.

Fix this by releasing fw_lock immediately after updating the cache state
and before calling dpm_for_each_dev(). The lock is only needed to protect
the state update. Concurrent firmware requests will correctly see the
FW_LOADER_START_CACHE state and use the piggyback mechanism, which is
independently protected by its own fwc->name_lock.

Fixes: ac39b3ea73aa ("firmware loader: let caching firmware piggyback on loading firmware")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Reported-by: syzbot+e70e4c6f6eee43357ba7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e70e4c6f6eee43357ba7
Link: https://syzkaller.appspot.com/ai_job?id=8b4af9fd-24af-423f-8acb-1159fd34c1a5
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Link: https://patch.msgid.link/48b092a5-f49d-48a4-95f4-f65bebfc6bc3@mail.kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/firmware_loader/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/base/firmware_loader/main.c b/drivers/base/firmware_loader/main.c
index cfface4f4c1e61..9c04a734a83e15 100644
--- a/drivers/base/firmware_loader/main.c
+++ b/drivers/base/firmware_loader/main.c
@@ -1452,9 +1452,10 @@ static void device_cache_fw_images(void)
 
 	mutex_lock(&fw_lock);
 	fwc->state = FW_LOADER_START_CACHE;
-	dpm_for_each_dev(NULL, dev_cache_fw_image);
 	mutex_unlock(&fw_lock);
 
+	dpm_for_each_dev(NULL, dev_cache_fw_image);
+
 	/* wait for completion of caching firmware for all devices */
 	async_synchronize_full_domain(&fw_cache_domain);
 
-- 
2.53.0



