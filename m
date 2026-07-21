Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5317F347BC6;
	Tue, 21 Jul 2026 22:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674483; cv=none; b=X9Z2v6ebFYskJyG99zZE/c0as1WuRZRPw/ZVqLmb0joyOIFcvQy3O6lgQrcUT4INgM7qw0v3qkR8sLc9kjiSGuNMiF+mgB/3+TEp8wlFY+1rGmRFQjS9XhNQBEoC/LGdVt2zBxigB4LxPR+uRnU3XD1vIC7Qol+95huVZSi5T54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674483; c=relaxed/simple;
	bh=m4tWHeE+f+zVTqzbfpQGSXnZ8BQfySj/YbqmUaZf1dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TK0NvrpRiJ09kvyJ6+SFOov9dsLoh4kvtw65TAOmuBTZEA9n1GlNBJsBBfGNlqJ6iMqApOvEsWOSMaVnbdu92YxlmYLNUUgy5dD2MUI0f4mAhDOhYLp7M1kSjaoJmsK3JoSBGHzXcMc0iKjt1hcQnE5q4czmcWGfZpjEj9sk/NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J8+CATVq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J8+CATVq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B70D31F000E9;
	Tue, 21 Jul 2026 22:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674482;
	bh=8eGKue6StYBE7zVO0eDKcVlvo2AJt70/6LPC+fedFs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J8+CATVqKvYGoZxMRESd9rxF67v/F6eL1dxh3N0B1c2bSQlXQz4DwIHi23nOkWQB3
	 leV+uFODADyrgxKhE0KhDqLQQR3us9Y9hSVwRodirHnAXbeq8AVMP9Et8FA0JqeUx5
	 Fm0+9c3RzN4oysHPOnmsT1qrDkmilPRV5PjFgKUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 559/699] wifi: rt2x00: avoid full teardown before work setup in probe
Date: Tue, 21 Jul 2026 17:25:18 +0200
Message-ID: <20260721152408.317940159@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit 536fb3d739d75a03cb318c0c6fe799425cfea501 upstream.

rt2x00lib_probe_dev() uses the full rt2x00lib_remove_dev() teardown for
all probe failures. However, drv_data allocation and workqueue allocation
can fail before intf_work, autowakeup_work and sleep_work have been
initialized.

Do not enter the full remove path until the probe has reached the point
where those work items are set up. Return directly for drv_data allocation
failure, and use a small early cleanup path for workqueue allocation
failure.

This issue was found by our static analysis tool and then confirmed by
manual review of rt2x00lib_probe_dev() and rt2x00lib_remove_dev(). The
early probe exits should not call a common teardown path that assumes the
later work setup has already completed.

A QEMU PoC forced alloc_ordered_workqueue() to fail before the work
initializers are reached. The resulting fail path entered
rt2x00lib_remove_dev(), and DEBUG_OBJECTS reported invalid work drains with
rt2x00lib_probe_dev() and rt2x00lib_remove_dev() in the stack.

Fixes: 1ebbc48520a0 ("rt2x00: Introduce concept of driver data in struct rt2x00_dev.")
Fixes: 0439f5367c8d ("rt2x00: Move TX/RX work into dedicated workqueue")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260619073104.1809161-1-runyu.xiao@seu.edu.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
@@ -1368,7 +1368,7 @@ int rt2x00lib_probe_dev(struct rt2x00_de
 			                      GFP_KERNEL);
 		if (!rt2x00dev->drv_data) {
 			retval = -ENOMEM;
-			goto exit;
+			return retval;
 		}
 	}
 
@@ -1402,7 +1402,7 @@ int rt2x00lib_probe_dev(struct rt2x00_de
 	    alloc_ordered_workqueue("%s", 0, wiphy_name(rt2x00dev->hw->wiphy));
 	if (!rt2x00dev->workqueue) {
 		retval = -ENOMEM;
-		goto exit;
+		goto exit_free_drv_data;
 	}
 
 	INIT_WORK(&rt2x00dev->intf_work, rt2x00lib_intf_scheduled);
@@ -1478,6 +1478,14 @@ exit:
 	rt2x00lib_remove_dev(rt2x00dev);
 
 	return retval;
+
+exit_free_drv_data:
+	clear_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
+
+	kfree(rt2x00dev->drv_data);
+	rt2x00dev->drv_data = NULL;
+
+	return retval;
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_probe_dev);
 


