Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0F323BD1B;
	Fri,  4 Sep 2026 05:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498997; cv=none; b=BjlSCwDay53ldF+sAZnaAsqptbXzbJnA7d2h8V4u4zRNQmq7oEZkmWpVEIsURrlHrRVWESOjUE9z0Iv/vvJgc1xomTRwKObQltzfJCTzjb8GZbcrCYU+OM1j6xMUmXl7dn3Hry6rruIh3Bfs07T4gEGupBtxQjS0gU8krmI34N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498997; c=relaxed/simple;
	bh=iID+NgTK4HffFNIRSfxQh2ovenhS3uTTGnTe9LpEWPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VWcAMRu5pnGZ3xpcVxeq6jDpHcJCc66xiIS4MWEVXQoR1AAKs9D8TF1mjOdM3sdhNOV4hvPHzndEQqtbcB3AgUa8z7+jQC/tbOv2YsTfeBVMI2FynPAHHoFxRegDOYuWR3dJBGfUGcqvz7PZaFiDQizwLPxUyjqcxsqRg9YU0jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Adp8LbmD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Adp8LbmD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545FF1F00A3D;
	Fri,  4 Sep 2026 05:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498995;
	bh=5G3daLoEFFagd18e0q8Yv5XBIyxOxcsT/TudfcNv2yU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Adp8LbmDJV8f0KQL+YcusQgx2DgRcALZz169/xOGZ1Ho250LCqnsXzJwAivvz2eBI
	 /ij1Al7+m9oow6FZ8HXuDFOSnLeoAmGAy5tgS+MmIAV+RXPjzqhWXJyZRt7NkjQQNW
	 hwnJBe2Vfo0X3JYb9fys6GRqvO43snz3ovQhh50s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Even Xu <even.xu@intel.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.2 259/713] HID: intel-thc-hid: intel-quickspi: fix autosuspend cleanup during teardown
Date: Fri,  4 Sep 2026 06:53:47 +0200
Message-ID: <20260904045809.644661890@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 05dffa55fd6dbed4bf2421fae5accc2b857e668d upstream.

quickspi_probe() calls pm_runtime_use_autosuspend(), but
quickspi_remove() does not call the matching
pm_runtime_dont_use_autosuspend() during teardown.

If the autosuspend delay is set to a negative value while autosuspend
is enabled, the runtime PM core increments usage_count to prevent
runtime suspend. Without calling pm_runtime_dont_use_autosuspend()
during teardown, this reference is not dropped.

The documentation for pm_runtime_use_autosuspend() also notes that it
is important to undo it with pm_runtime_dont_use_autosuspend() at
driver exit time, unless runtime PM was initially enabled with
devm_pm_runtime_enable().

Add the missing pm_runtime_dont_use_autosuspend() call to the driver
remove path.

This issue was found by manual code inspection.

Fixes: 6912aaf3fd24 ("HID: intel-thc-hid: intel-quickspi: Add PM implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Even Xu <even.xu@intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c
+++ b/drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c
@@ -720,6 +720,7 @@ static void quickspi_remove(struct pci_d
 	quickspi_hid_remove(qsdev);
 	quickspi_dma_deinit(qsdev);
 
+	pm_runtime_dont_use_autosuspend(qsdev->dev);
 	pm_runtime_get_noresume(qsdev->dev);
 
 	quickspi_dev_deinit(qsdev);


