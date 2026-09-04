Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A90F34752B;
	Fri,  4 Sep 2026 05:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500803; cv=none; b=KW0bdT1YjqQIsB2oH78sGWwKiG+0wSDjY//OIo4U7oBzKDpXAeak1GNB9GEaoacOTtopcYuF+hEEkjyQjPKJJ9KHFxvlbDRMQMk8y7zVE/NlFy0OXPi7z3y9zmZ8gchML1vWgrMU+wM7LtjMl5TCJv4JmC2MSxYyYxvLPz0TXI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500803; c=relaxed/simple;
	bh=qpN8+GmUtHbJ+uszAVzJloHT9MPY6QmX7oLIfYn8uuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jaIUHRLTD3zGndmfkyTOmqPLmIVpJ0zYlIVlJRcNhWFqMmvDXFBZkGS5DG+/kLtcEn6poK/CjW8SeIhrZ8KnOr9e+b5OycAiHf3yin3rofy1JPGUgtb9s9eHL6f6G1EY22BRR4yFTFK3oHipD1dejT+iOSZhDSC5GTEZSDifgi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B11fihtf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B11fihtf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85FE11F00A3D;
	Fri,  4 Sep 2026 05:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500802;
	bh=aSgsTgcug5/CySqf6wyUpt/maYKNzWDpJBKq3rLIses=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B11fihtflkHK2fYWK4eD1+hfkOLTReNXmzrbgfC6qfK59DCNA5RTZQW2O2HgVvwmj
	 SsMPcu0CQqKyD0PO2Mh4aoLB8GXH7DOHiA9QLqExI3lciN1oOdAbpJTdmB0vvEuKy9
	 AKxetChsf40Fz7QA364X9Xv697bvUfArKnJf7HNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Even Xu <even.xu@intel.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.18 185/552] HID: intel-thc-hid: intel-quicki2c: fix autosuspend cleanup during teardown
Date: Fri,  4 Sep 2026 06:55:42 +0200
Message-ID: <20260904045753.211690588@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -771,6 +771,7 @@ static void quicki2c_remove(struct pci_d
 	quicki2c_hid_remove(qcdev);
 	quicki2c_dma_deinit(qcdev);
 
+	pm_runtime_dont_use_autosuspend(qcdev->dev);
 	pm_runtime_get_noresume(qcdev->dev);
 
 	quicki2c_dev_deinit(qcdev);


