Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335AD74438;
	Mon,  8 Apr 2024 14:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712585180; cv=none; b=oURbS+CzpqUVNoRCevqg0lKqjTCsRxh8VnhiUE8wrPy53xZ8yf48Qa8RjVGdX3mnkAMDCVVpZf8D9WNkf34IM3aq19v/0gnPeR210gDpW49OZpdM4bKrZ/Q45WIyASjmuQKKXfgyGTHL8OgzUUWOMn/JRG9qB0qcKj5OqPwtIaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712585180; c=relaxed/simple;
	bh=/lPDgzCmyRdPVk0nIu1gokLXiuwvGgpMhYJDFNl9WxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ThxkhN4mjttaNj+mfUt41zmdLUlxni+JMEbl2pvLu1lYLNU0QHxAgvEVzdI3KexuZwUJ/Y+pHAUsEWGlmTyC2bIKu/gNtUAALaW1fYi8gfi0semNWz6bPp5keWdk997n5hyY07jKZOaeFP1p5nd8cYyxsLtjAWzOMdXHuw5mr04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nu3rOALm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nu3rOALm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A86F9C433F1;
	Mon,  8 Apr 2024 14:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712585180;
	bh=/lPDgzCmyRdPVk0nIu1gokLXiuwvGgpMhYJDFNl9WxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nu3rOALmSygV88A5gY1V1qZhuEDL0fM0CFwMmP2T/K20yHDICfFcKjgdGdfmbc3br
	 JQuD1SuwJsNNT8Zu8Wy0W+1cOAxcvLBag9CL1ygakQj7W38tlxGG+38UaOBVzdtSDV
	 maD+HQF1nRG7GkrSZnggfdQwuGirNo/tLws6EPyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Saravana Kannan <saravanak@google.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Rob Herring <robh@kernel.org>
Subject: [PATCH 5.15 680/690] of: dynamic: Synchronize of_changeset_destroy() with the devlink removals
Date: Mon,  8 Apr 2024 14:59:06 +0200
Message-ID: <20240408125424.362888304@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herve Codina <herve.codina@bootlin.com>

commit 8917e7385346bd6584890ed362985c219fe6ae84 upstream.

In the following sequence:
  1) of_platform_depopulate()
  2) of_overlay_remove()

During the step 1, devices are destroyed and devlinks are removed.
During the step 2, OF nodes are destroyed but
__of_changeset_entry_destroy() can raise warnings related to missing
of_node_put():
  ERROR: memory leak, expected refcount 1 instead of 2 ...

Indeed, during the devlink removals performed at step 1, the removal
itself releasing the device (and the attached of_node) is done by a job
queued in a workqueue and so, it is done asynchronously with respect to
function calls.
When the warning is present, of_node_put() will be called but wrongly
too late from the workqueue job.

In order to be sure that any ongoing devlink removals are done before
the of_node destruction, synchronize the of_changeset_destroy() with the
devlink removals.

Fixes: 80dd33cf72d1 ("drivers: base: Fix device link removal")
Cc: stable@vger.kernel.org
Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Reviewed-by: Saravana Kannan <saravanak@google.com>
Tested-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Reviewed-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20240325152140.198219-3-herve.codina@bootlin.com
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/dynamic.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/of/dynamic.c
+++ b/drivers/of/dynamic.c
@@ -9,6 +9,7 @@
 
 #define pr_fmt(fmt)	"OF: " fmt
 
+#include <linux/device.h>
 #include <linux/of.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
@@ -678,6 +679,17 @@ void of_changeset_destroy(struct of_chan
 {
 	struct of_changeset_entry *ce, *cen;
 
+	/*
+	 * When a device is deleted, the device links to/from it are also queued
+	 * for deletion. Until these device links are freed, the devices
+	 * themselves aren't freed. If the device being deleted is due to an
+	 * overlay change, this device might be holding a reference to a device
+	 * node that will be freed. So, wait until all already pending device
+	 * links are deleted before freeing a device node. This ensures we don't
+	 * free any device node that has a non-zero reference count.
+	 */
+	device_link_wait_removal();
+
 	list_for_each_entry_safe_reverse(ce, cen, &ocs->entries, node)
 		__of_changeset_entry_destroy(ce);
 }


