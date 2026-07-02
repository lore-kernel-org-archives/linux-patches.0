Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563D8246BBA;
	Thu,  2 Jul 2026 16:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010583; cv=none; b=XCgVIYlGk+BnUTTZnU3tPq09pzBaTgsBzlaPZDv86ssnM04uI0gArJZTMd1uFASZcQ6z95aGsItZ+mCN+1fBYcTSsJdxg/RE0mo3dQrfN3kLxbCwrgTBNhwHTdzpjJqufRpmj1slEDbjCTpYHpeGzu3p064twe36HTAIHyXcZMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010583; c=relaxed/simple;
	bh=lnR2EBn1dzruYON8HMA7tSyUm7JuFXEXG/tSP7CCAuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X220hmM6tiHDxHqV0z21H8+siwxXj8rYT5Y6Dp3ieemkAV0R43I91YC2Kbyg1N80pxYA1/RVlhLEDHczLwpvOsy4V7CycCrthVvKS3p4qEmQDinlDWtdAXhcD/xPS18UVDQMeQeHcWglgdCZZA1mJgH1w/CGJi5KBlXbQnfPJ3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1L8obi8B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1L8obi8B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD51B1F000E9;
	Thu,  2 Jul 2026 16:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010582;
	bh=S9P1dbk+XY+hCTWCl+ObOYxtudPkjxeHgUNP1XNInig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1L8obi8BZ+gTsVYwZAC0rrnzHo9GuOTkGVkuEoht/oYX68msiSdOh7jsoBM8x1jux
	 az+nm+izIpvNZkHiBD7988ZP9LNip9b/UFyL0jfv88Lw7sNsG+Q5Id/pnFUTQKui/S
	 DAy8DLVvyk6UmszzVN/Z0/ETbe+SS1LUij6I2tf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.12 165/204] pwrseq: core: fix use-after-free in pwrseq_debugfs_seq_next()
Date: Thu,  2 Jul 2026 18:20:22 +0200
Message-ID: <20260702155122.115108489@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 257595adf9dac15ae1edd9d07753fbc576a7583d upstream.

pwrseq_debugfs_seq_next() declares 'next' with __free(put_device),
which causes put_device() to be called on the returned pointer when
the variable goes out of scope.  This results in a use-after-free
since the seq_file framework receives a pointer whose reference has
already been dropped.

Simply removing __free(put_device) would fix the UAF but would leak
the reference acquired by bus_find_next_device(), as stop() only
calls up_read(&pwrseq_sem) and never releases the device reference.

Fix this by making the reference counting consistent across all
seq_file callbacks, matching the standard pattern used by PCI and
SCSI:

- start(): use get_device() so it returns a referenced pointer.
- next(): explicitly put_device(curr) to release the previous
  device's reference (no NULL check needed - the seq_file framework
  only calls next() while the previous return was non-NULL).
- stop(): put_device(data) to release the last iterated device's
  reference, with a NULL guard since stop() may be called with NULL
  when start() returned NULL or next() reached end-of-sequence.

Cc: stable@vger.kernel.org
Fixes: 249ebf3f65f8 ("power: sequencing: implement the pwrseq core")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260616151049.1705503-1-vulab@iscas.ac.cn
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/sequencing/core.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/drivers/power/sequencing/core.c
+++ b/drivers/power/sequencing/core.c
@@ -990,8 +990,9 @@ static void *pwrseq_debugfs_seq_start(st
 	ctx.index = *pos;
 
 	/*
-	 * We're holding the lock for the entire printout so no need to fiddle
-	 * with device reference count.
+	 * Hold the lock for the entire printout to prevent device removal.
+	 * Reference counts are managed by start()/next()/stop() as required
+	 * by the seq_file contract.
 	 */
 	down_read(&pwrseq_sem);
 
@@ -999,7 +1000,7 @@ static void *pwrseq_debugfs_seq_start(st
 	if (!ctx.index)
 		return NULL;
 
-	return ctx.dev;
+	return get_device(ctx.dev);
 }
 
 static void *pwrseq_debugfs_seq_next(struct seq_file *seq, void *data,
@@ -1009,8 +1010,9 @@ static void *pwrseq_debugfs_seq_next(str
 
 	++*pos;
 
-	struct device *next __free(put_device) =
-			bus_find_next_device(&pwrseq_bus, curr);
+	struct device *next = bus_find_next_device(&pwrseq_bus, curr);
+
+	put_device(curr);
 	return next;
 }
 
@@ -1059,6 +1061,8 @@ static int pwrseq_debugfs_seq_show(struc
 
 static void pwrseq_debugfs_seq_stop(struct seq_file *seq, void *data)
 {
+	if (data)
+		put_device(data);
 	up_read(&pwrseq_sem);
 }
 


