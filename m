Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827028;
	b=Vq6Ip3Dd2TBNIR7xnI1Hyz9J8fmTHyGywo0XgpfzmZe3cghMQ2G8/DSE/JKU2kcd1Dh6
	 b/Qw3f/fnzfqlvlTjETWUsp9cD01HlCXEeGKJTrseZ9TVF0zFDx5EWaWxvbiQ3dc3BYxI
	 C8P62vKsPU0a/8ylgLOUcSCqHIppW7oTIpV5HU9B/RiimSSx/qZQMNh998nzga2vhLLIG
	 EOTspnGNjXJlcE2Ac+co3hcfJH9Wm0OzagSwv3jlYSIcfta9NEL81Q7TN/TtokC0zajIz
	 R92EMOCATmSGMeoJfhZ5MtQehsLsFOTxU6g5n/V+zuZhOVqDGJj7DnovFsEeCXn7lEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827028;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=nFk1M9tWfeqNxtg5DgFauyFe+Nyeg9JkgjL8WeHeeZY=;
	b=2zbhXaB6fuBPu0Nj9OTjy7VeS19cyhNMcJJkurYHZF85E3WKLByJOFn6Nt4MYrhyKt2g
	 7QcswkfubnxePVdJqxgmUaRxBB3UoHBGFbbs2ZmHzKg29gK77xRpGFssbVWJVRORgF9y8
	 LGulYDvK7LcFFZYaASurrneZBCgOIuVZ1EMlWBC09BqLJ4LFBWNE895aJ3sSYXvlcFP69
	 IylhfNydaLgOfrmt/rhldrfFyelLnYOYq8BG66R1McLmA912JT82hxOm80y6fmfLtqc7W
	 7ZmuEjmna041MpI6qMeHb69k8Oud6bsPxvTWmogaJE1Y4mX1PJT9SVRX20IgJzdFNbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rErcOEPh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2EF460C0147;
	Wed,  4 Nov 2026 21:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rErcOEPh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F3F61F000C1;
	Wed,  4 Nov 2026 21:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827027;
	bh=nFk1M9tWfeqNxtg5DgFauyFe+Nyeg9JkgjL8WeHeeZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rErcOEPh2G8efyW/6i+To3XNZ08VnvdFPCI2yEyojSbePZ26PhwdZ3fd+mo0bamZy
	 FwFP7JkuD+nf12Vi05t+w4KE91WovmHpmz548w+GGKflY1aqtU0Z+WzIl9wXXVDwdF
	 1pv4L5cX//N8Z5fbjI7X1QjMznkRd+Dxv3qMAkhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 7.3 152/547] platform/x86/amd: hfi: Fix a use-after-free when unloading the driver
Date: Wed,  4 Nov 2026 16:05:36 -0500
Message-ID: <20261104211042.480666805@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 55d8406dfa2fa8ad8ac2f053c2a53a97d8b0ce48 upstream.

amd_hfi_probe() registers CPU hotplug callbacks with
cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, ...) and schedules the static
sched_amd_hfi_itmt_work work item, but amd_hfi_remove() tears down
neither.  The dynamically assigned hotplug state returned by
cpuhp_setup_state() is discarded, so cpuhp_remove_state() can never be
called, and the pending work is never cancelled.

After the module is unloaded and its memory is freed, any subsequent CPU
hotplug event or execution of the scheduled work dereferences the stale
callback and work function pointers, resulting in a use-after-free and
kernel panic.

Store the hotplug state returned by cpuhp_setup_state() and, on removal,
call cpuhp_remove_state() to unregister the callbacks and
cancel_work_sync() to flush the scheduled work before the module memory
goes away.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: bb20421c05fc ("platform/x86: hfi: Add online and offline callback support")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260921170411.1149960-2-mario.limonciello@amd.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/amd/hfi/hfi.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/platform/x86/amd/hfi/hfi.c
+++ b/drivers/platform/x86/amd/hfi/hfi.c
@@ -76,6 +76,8 @@ struct amd_hfi_data {
 	struct amd_shmem_info	*shmem;
 
 	struct dentry *dbgfs_dir;
+
+	int cpuhp_state;
 };
 
 /**
@@ -244,6 +246,8 @@ static void amd_hfi_remove(struct platfo
 {
 	struct amd_hfi_data *dev = platform_get_drvdata(pdev);
 
+	cpuhp_remove_state(dev->cpuhp_state);
+	cancel_work_sync(&sched_amd_hfi_itmt_work);
 	debugfs_remove_recursive(dev->dbgfs_dir);
 }
 
@@ -494,6 +498,7 @@ static int amd_hfi_probe(struct platform
 				amd_hfi_online, amd_hfi_offline);
 	if (ret < 0)
 		return ret;
+	amd_hfi_data->cpuhp_state = ret;
 
 	schedule_work(&sched_amd_hfi_itmt_work);
 


