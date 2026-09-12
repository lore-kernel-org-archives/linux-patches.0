Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB9A2DBF75;
	Sat, 12 Sep 2026 14:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221944; cv=none; b=ton/7J7xUXFSyng/deGRlDlzXK+JnCtIWIoMTR65o3dktpwO98pKkUcfFf2MJ/Azh83AVGgXn4GefgHB/lvhvfs62ZaE7kJwVQxPTghanjUizCjO485LZsDkfLtJiSYeXZsWtCWBpSX4jRIwNqpW784jN79na8y4KyjD2wdUnkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221944; c=relaxed/simple;
	bh=Ysf9idulYNhKCqxVu8JG42kShwHI5/5KJ+/M9TSdKbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M5K0scM8K9df7wMV+vI95c06ic+D2Jk/SzACXYXI5Hpz1CQqgdc9aIqQLWKy5gykSHeBoCPO76P+jrLVaUHS2ejJjgOP44BuWeI3kKh/ZBk9dtckfzsUOP9Z7zUUHGOWx+bLhjLtlkSNOKqt2+4hGGsEjgl5Kw4WbWsbd9oEWQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C4Y/yyhq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C4Y/yyhq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 123EE1F000FF;
	Sat, 12 Sep 2026 14:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221943;
	bh=Wle8U1CMoEJyLfNv4Fw2bmpriF5ZAlaaL5GEnBU9r4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C4Y/yyhqHOjGONd0cufyifRYg4/tkfpCShDmrIatjKkc2nVWtn1FZtht8afmKl6Eu
	 2234N+cIkz0eWr1ZAy4WT308FWEORU0fsr2r/tALrc4vUUyaJepcssI+iZSIgJcnaa
	 T1jec6xMGDLaoRsZF+beKoTGlmYajo3RHkp78LZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 0442/1424] media: cec: core: Fix kmemleak due to missed rc_free_device() call
Date: Sat, 12 Sep 2026 08:47:54 +0200
Message-ID: <20260912065617.183581334@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Karlman <jonas@kwiboo.se>

commit a24ba0653f7154e671dc8d2bf64682ab2d042792 upstream.

The commit dccc0c3ddf8f ("media: rc: fix race between unregister and
urb/irq callbacks") removed the implicit call to rc_free_device() from
rc_unregister_device(). However, the commit missed to remove the NULL
assignment of adap->rc that is now causing rc_free_device() to never be
called on an allocated rc device.

kmemleak reports following after e.g. dw-hdmi unbind:

unreferenced object 0xffff00010ac10000 (size 4096):
  comm "kworker/u16:1", pid 39, jiffies 4294897739
  hex dump (first 32 bytes):
    20 23 4b 0a 01 00 ff ff 08 00 c1 0a 01 00 ff ff   #K.............
    08 00 c1 0a 01 00 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace (crc e11baccc):
    kmemleak_alloc+0x38/0x44
    __kmalloc_cache_noprof+0x4a8/0x5e0
    rc_allocate_device+0x48/0x2a0
    cec_allocate_adapter+0x3ac/0x800
    dw_hdmi_cec_probe+0x264/0x634
    platform_probe+0xc0/0x188
    really_probe+0x4a4/0x8e0
    __driver_probe_device+0x2f8/0x440
    driver_probe_device+0x60/0x160
    __device_attach_driver+0x1a0/0x2a0
    bus_for_each_drv+0x100/0x1a0
    __device_attach+0x174/0x350
    device_initial_probe+0x90/0xb0
    bus_probe_device+0x4c/0x120
    device_add+0xdec/0x116c
    platform_device_add+0x354/0x598

Remove the assignment of adap->rc to NULL to let cec_delete_adapter()
free the allocated rc device after last user of the cec device exits to
fix the kmemleak.

Fixes: dccc0c3ddf8f ("media: rc: fix race between unregister and urb/irq callbacks")
Cc: stable@vger.kernel.org
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/cec/core/cec-core.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/media/cec/core/cec-core.c
+++ b/drivers/media/cec/core/cec-core.c
@@ -399,9 +399,7 @@ void cec_unregister_adapter(struct cec_a
 		return;
 
 #ifdef CONFIG_MEDIA_CEC_RC
-	/* Note: rc_unregister also calls rc_free */
 	rc_unregister_device(adap->rc);
-	adap->rc = NULL;
 #endif
 	debugfs_remove_recursive(adap->cec_dir);
 #ifdef CONFIG_CEC_NOTIFIER


