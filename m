Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBAD37A498;
	Thu, 20 Aug 2026 15:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238814; cv=none; b=iafBXCa56VtPh1tKGMlpk4gao80BaIFdCSetbVv8VLxv/xxSLgX14VNAvVtHLR4AgenLOnpGH2H2zzKl/DcDutStPEsGo59kX4hnJzJfZYfppgzp0GApnOjeIlsVZmoTTa5pg1D5cD50ZReda6bV6ioiuMUAoSHt2uw35uJ/usI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238814; c=relaxed/simple;
	bh=2F5j2UFzbNiwzOXE3KZjn2fHLvhfuSEaJmDtl7epU8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s3U35ZA8HeoCA1TvAYSSB1y5WjnhQ9LX9ArE0NiAlGhXR20BYpy8yR/8FpJHAMeGxU08Lmq501do5+OrfDvmshcbRwaEqYqN5UQzO2OZ/hm1BAIVa/zKial9cFsgutmxRSjxZhV9jo++CC5G8kfXxmvnqhTc4weQbQGedIW6B+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oDPINrNV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oDPINrNV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D82531F000E9;
	Thu, 20 Aug 2026 15:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238813;
	bh=n6oXB8ZjQZppl+gjTOKVNmg3oSg0m8igEe6TFbkaNs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oDPINrNViJmMTQiyHBM4PpDdsJ1Y2qlAHTTlVJUddNDc2a2gMs3DQ/ii9vtbr8XWF
	 GhOXoqKcjssXNqhevuXWcZh8q+dinT6Yv6KDOT6PGouDM1NethNm6C9etpYb2DAzhV
	 9LTL4RCuMMf3PfCUiabU2l2GYBv8G19GTfGbklYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cengiz Can <cengiz.can@canonical.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.18 051/217] gpio: sloppy-logic-analyzer: fix use-after-free via debugfs trigger on unbind
Date: Thu, 20 Aug 2026 16:53:39 +0200
Message-ID: <20260820145239.155451506@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

From: Cengiz Can <cengiz.can@canonical.com>

commit 44f3468a0aef1aabdad551898ab7cfa2a9d20e99 upstream.

The "trigger" debugfs file has a hand-rolled ->write handler
(trigger_write()) that dereferences the per-device gpio_la_poll_priv. The
file is created with debugfs_create_file_unsafe(), and the handler never
takes a debugfs reference. Nothing keeps the object alive while the
handler runs.

priv is allocated with devm_kzalloc(). devres frees it when the platform
device is unbound. debugfs_create_file_unsafe() installs no full_proxy
wrapper, so debugfs_remove_recursive() in gpio_la_poll_remove() does not
wait for an in-flight trigger_write(). The blob_lock taken there does not
help, because trigger_write() never takes it. A write that races an unbind
therefore writes into freed memory:

  trigger_write()                  gpio_la_poll_remove()
    priv = m->private
    buf = memdup_user()  [may sleep]
                                     mutex_lock(&priv->blob_lock)
                                     debugfs_remove_recursive()  [no wait]
                                     mutex_unlock(&priv->blob_lock)
                                   (remove returns; devres frees priv)
    priv->trig_data = buf   <-- use-after-free write
    priv->trig_len  = count

The race is reachable by root via
/sys/bus/platform/drivers/gpio-sloppy-logic-analyzer/unbind.

Create "trigger" with debugfs_create_file() instead. Its full_proxy
wrapper makes debugfs_remove_recursive() drain any in-flight ->write
before it returns.

The use-after-free is confirmed under KASAN with a minimal reproducer of
the same debugfs_create_file_unsafe() plus devm_kzalloc() pattern
(available on request); it produces a slab-use-after-free write in the
handler.

Fixes: 7828b7bbbf20 ("gpio: add sloppy logic analyzer using polling")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Cengiz Can <cengiz.can@canonical.com>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Link: https://patch.msgid.link/20260730220258.358169-2-cengiz.can@canonical.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-sloppy-logic-analyzer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/gpio-sloppy-logic-analyzer.c
+++ b/drivers/gpio/gpio-sloppy-logic-analyzer.c
@@ -301,7 +301,7 @@ static int gpio_la_poll_probe(struct pla
 	debugfs_create_ulong("delay_ns_acquisition", 0400, priv->debug_dir, &priv->acq_delay);
 	debugfs_create_file_unsafe("buf_size", 0600, priv->debug_dir, priv, &fops_buf_size);
 	debugfs_create_file_unsafe("capture", 0200, priv->debug_dir, priv, &fops_capture);
-	debugfs_create_file_unsafe("trigger", 0200, priv->debug_dir, priv, &fops_trigger);
+	debugfs_create_file("trigger", 0200, priv->debug_dir, priv, &fops_trigger);
 
 	return 0;
 }


