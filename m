Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60DB3EAC6F;
	Tue, 17 Mar 2026 16:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766384; cv=none; b=fx9pJYSEdXtoZ8Vw+hWl3oUGDFvRmWm10h/dhG8xg4GhW6qGGpoWY8zdUFHPruwiLFeKF3FWOgTjCsu5vTD7YFa989IuwgfG1W6IM1pUNl3HcIAT7v2lBPVI21JVOhyUPnj7L91+by863rKfI9eJdN5gK+7I30+84gjtJ+KFGtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766384; c=relaxed/simple;
	bh=+exTHmcF4lX2DWzU5TiAn8RSnQGxF3vMwdNnii/U6Oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oCoAQlZlqXbqojIBLa/RAuYIra6MhPWmzd1YZc2lk4//biUPWKSWb/VLFLFToxk1UexTwBiFPnQKPvx4sTgtEanENSwC5ZdBEVebkvdwGOYk86EyRX8HIwBKIQY/lN3Lk/p90S5KCe2fFU/LRcs9vRJG6TFD13MiS1lSVeLu1Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ybGYXdM7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ybGYXdM7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B8D4C4CEF7;
	Tue, 17 Mar 2026 16:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766383;
	bh=+exTHmcF4lX2DWzU5TiAn8RSnQGxF3vMwdNnii/U6Oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ybGYXdM75Y93kruldy9hVf3arID/PnA3l9zOAMHxlr7XcEo+oz0/uBLJBHCp+76C1
	 VfsVuzt4Fqiqz8l8cH/9swqkTR/CK5/p1WRtNICo3gJGS2ugceK0Zd4p/Z3MNdQBmO
	 XR5HwCqbntXBa0lqvK2Lon8AExoNYiIbi8aj+WXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Liwei Song <liwei.song@windriver.com>,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 6.19 202/378] firmware: stratix10-rsu: Fix NULL pointer dereference when RSU is disabled
Date: Tue, 17 Mar 2026 17:32:39 +0100
Message-ID: <20260317163014.443589025@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liwei Song <liwei.song@windriver.com>

commit c45f7263100cece247dd3fa5fe277bd97fdb5687 upstream.

When the Remote System Update (RSU) isn't enabled in the First Stage
Boot Loader (FSBL), the driver encounters a NULL pointer dereference when
excute svc_normal_to_secure_thread() thread, resulting in a kernel panic:

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000008
Mem abort info:
...
Data abort info:
...
[0000000000000008] user address but active_mm is swapper
Internal error: Oops: 0000000096000004 [#1]  SMP
Modules linked in:
CPU: 0 UID: 0 PID: 79 Comm: svc_smc_hvc_thr Not tainted 6.19.0-rc8-yocto-standard+ #59 PREEMPT
Hardware name: SoCFPGA Stratix 10 SoCDK (DT)
pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : svc_normal_to_secure_thread+0x38c/0x990
lr : svc_normal_to_secure_thread+0x144/0x990
...
Call trace:
 svc_normal_to_secure_thread+0x38c/0x990 (P)
 kthread+0x150/0x210
 ret_from_fork+0x10/0x20
Code: 97cfc113 f9400260 aa1403e1 f9400400 (f9400402)
---[ end trace 0000000000000000 ]---

The issue occurs because rsu_send_async_msg() fails when RSU is not enabled
in firmware, causing the channel to be freed via stratix10_svc_free_channel().
However, the probe function continues execution and registers
svc_normal_to_secure_thread(), which subsequently attempts to access the
already-freed channel, triggering the NULL pointer dereference.

Fix this by properly cleaning up the async client and returning early on
failure, preventing the thread from being used with an invalid channel.

Fixes: 15847537b623 ("firmware: stratix10-rsu: Migrate RSU driver to use stratix10 asynchronous framework.")
Cc: stable@kernel.org
Signed-off-by: Liwei Song <liwei.song@windriver.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/stratix10-rsu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/firmware/stratix10-rsu.c b/drivers/firmware/stratix10-rsu.c
index 41da07c445a6..e1912108a0fe 100644
--- a/drivers/firmware/stratix10-rsu.c
+++ b/drivers/firmware/stratix10-rsu.c
@@ -768,7 +768,9 @@ static int stratix10_rsu_probe(struct platform_device *pdev)
 				 rsu_async_status_callback);
 	if (ret) {
 		dev_err(dev, "Error, getting RSU status %i\n", ret);
+		stratix10_svc_remove_async_client(priv->chan);
 		stratix10_svc_free_channel(priv->chan);
+		return ret;
 	}
 
 	/* get DCMF version from firmware */
-- 
2.53.0



