Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F38352938;
	Wed, 21 Jan 2026 18:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020553; cv=none; b=KSYa4ENpEntB54WLWob9u/0MFdquqRDKk80QOGlOSAFZnx3s8f/52sR+PqmwJJmrTFkkjD134MQbBSS+WKutVy0WOuaoT7IdERzUSH69+GuDIqw0OXrPHxi7eD2bZuOuUVDzDoHzmUfbQFxlCICKtnUVpR4IsI9zlg/8JnAV7sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020553; c=relaxed/simple;
	bh=UozP8Opcw8T3bYiLG/CpF1W0JusqNcRil7gEhzz3s1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=teNL0lBWl+KpIaO8JaMT4LTj3N88UW/Z2HJwjZqF6BIDiX7k/9vNs4sgH05EQogLQ7AnPSRVwkencg8Hx+Tednwvh4OtVRc+LCrWmOAzZsTYdem4o6YG4JAzh/V7vGpdsAUl6d+Ng0Ni7kIEqrQwHF5c5xyc1jiL501qJqgTf5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UW9rGuyz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UW9rGuyz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93D9C19424;
	Wed, 21 Jan 2026 18:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020553;
	bh=UozP8Opcw8T3bYiLG/CpF1W0JusqNcRil7gEhzz3s1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UW9rGuyz3FQH2QOCLywyy9DiWiXONm7G/kFALeShn7W1PbmHx10tswnx264I5qh8Y
	 eQiUIBj0Y1kjZEb5bjZn0dyxK9LOWiZ8Ezeqn9m8WcPhhyEmqNUMK2Dl1bu+SOdpsb
	 LORviUkaxDNe58azjbRUWrQ7NuxDlf4p5ClY1OnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Zhang Lixu <lixu.zhang@intel.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.18 192/198] HID: intel-ish-hid: Fix -Wcast-function-type-strict in devm_ishtp_alloc_workqueue()
Date: Wed, 21 Jan 2026 19:17:00 +0100
Message-ID: <20260121181425.467210844@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

commit 3644f4411713f52bf231574aa8759e3d8e20b341 upstream.

Clang warns (or errors with CONFIG_WERROR=y / W=e):

  drivers/hid/intel-ish-hid/ipc/ipc.c:935:36: error: cast from 'void (*)(struct workqueue_struct *)' to 'void (*)(void *)' converts to incompatible function type [-Werror,-Wcast-function-type-strict]
    935 |         if (devm_add_action_or_reset(dev, (void (*)(void *))destroy_workqueue,
        |                                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  include/linux/device/devres.h:168:34: note: expanded from macro 'devm_add_action_or_reset'
    168 |         __devm_add_action_or_ireset(dev, action, data, #action)
        |                                         ^~~~~~

This warning is pointing out a kernel control flow integrity (kCFI /
CONFIG_CFI=y) violation will occur due to this function cast when the
destroy_workqueue() is indirectly called via devm_action_release()
because the prototype of destroy_workqueue() does not match the
prototype of (*action)().

Use a local function with the correct prototype to wrap
destroy_workqueue() to resolve the warning and CFI violation.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202510190103.qTZvfdjj-lkp@intel.com/
Closes: https://github.com/ClangBuiltLinux/linux/issues/2139
Fixes: 0d30dae38fe0 ("HID: intel-ish-hid: Use dedicated unbound workqueues to prevent resume blocking")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Reviewed-by: Zhang Lixu <lixu.zhang@intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/intel-ish-hid/ipc/ipc.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/hid/intel-ish-hid/ipc/ipc.c
+++ b/drivers/hid/intel-ish-hid/ipc/ipc.c
@@ -933,6 +933,11 @@ static const struct ishtp_hw_ops ish_hw_
 	.dma_no_cache_snooping = _dma_no_cache_snooping
 };
 
+static void ishtp_free_workqueue(void *wq)
+{
+	destroy_workqueue(wq);
+}
+
 static struct workqueue_struct *devm_ishtp_alloc_workqueue(struct device *dev)
 {
 	struct workqueue_struct *wq;
@@ -941,8 +946,7 @@ static struct workqueue_struct *devm_ish
 	if (!wq)
 		return NULL;
 
-	if (devm_add_action_or_reset(dev, (void (*)(void *))destroy_workqueue,
-				     wq))
+	if (devm_add_action_or_reset(dev, ishtp_free_workqueue, wq))
 		return NULL;
 
 	return wq;


