Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6092623BD1B;
	Fri,  4 Sep 2026 05:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498994; cv=none; b=iX+SIHPJbEXau5jGJbNrJgO7SPwvTB9STrC6OvIlinXpCYXO5Wb5bEbVao9BHdIWjeMA3YTF56l6BWw9vZC5UHLcUV3xhAMRSKfS5KPSAqT9wwDkwqn0TI8c9rlXSGIcCelAG8FrFQPOap/q3JtDIuuVXp3OLzMzDpp4eYdyKMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498994; c=relaxed/simple;
	bh=FEnORiXJfPq+O6Ys2QDc6w7DN2vJOCsq4DeaRjvRH8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M3zT4xKHBTGh5orgbA4oj0pv6j7xajEGFPauA8J3AXGYGnT/AGiB25Gmf+fgwbl4mkiRO6D46dAe1kRQiGdnnsotzuXC0FQkv5Wzh2IxpzkPNGh7Q47Qu9e+ZTuvSOmf8Fv0gvJt9Zl7vJWUmuupgZrI1nlzVobyLKd/+++cPek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZB+awICC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZB+awICC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1E51F00A3D;
	Fri,  4 Sep 2026 05:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498993;
	bh=z1kB+3o5yDh5+U5pYfdvZ4eYCmhshtnn0UGxj94VS9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZB+awICCy7pCAIEh60kgUw8lUdGOGS/ai/CoLKFY8HQcKXkA0XzmKH2InC8oFr0Xe
	 xtLlY0fD29pn5adF9EZz1DlQmGJFCvoDEnOSpWfUDNfWVb9738Y/oEX91XHrDK0TSv
	 wJ0cK+bCaBC1VSxczM45m/idolGYG/jbxV330JW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Even Xu <even.xu@intel.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.2 258/713] HID: intel-thc-hid: intel-quicki2c: fix autosuspend cleanup during teardown
Date: Fri,  4 Sep 2026 06:53:46 +0200
Message-ID: <20260904045809.622708859@linuxfoundation.org>
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

commit 42a941e39432ef6766402ef68f1389dcfec4ee37 upstream.

quicki2c_probe() calls pm_runtime_use_autosuspend(), but
quicki2c_remove() does not call the matching
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

Fixes: 5f420e8215c6 ("HID: intel-thc-hid: intel-quicki2c: Add PM implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Even Xu <even.xu@intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/intel-thc-hid/intel-quicki2c/pci-quicki2c.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hid/intel-thc-hid/intel-quicki2c/pci-quicki2c.c
+++ b/drivers/hid/intel-thc-hid/intel-quicki2c/pci-quicki2c.c
@@ -774,6 +774,7 @@ static void quicki2c_remove(struct pci_d
 	quicki2c_hid_remove(qcdev);
 	quicki2c_dma_deinit(qcdev);
 
+	pm_runtime_dont_use_autosuspend(qcdev->dev);
 	pm_runtime_get_noresume(qcdev->dev);
 
 	quicki2c_dev_deinit(qcdev);


