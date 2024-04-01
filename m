Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C851DFF4;
	Mon,  1 Apr 2024 17:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991122; cv=none; b=hxY5MVRfttZ/3XOArAcReO8CCeOnZ7SX85nw4/fWbfYonb/saBVrMnQfIfXmDozJK3V0cnzO4ZoX0NYyl9irP4gkX096q8cT/hu8a0m2MTicqmjC1TjNb/5q+2bh7eclG8Ww8aQVGVMlFzxAadVMFEaxm1KV7EPJOqHdHMyWemQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991122; c=relaxed/simple;
	bh=BP9KJXDw4u5ptyy2JLxnevmwr7X8xdbTeyFWkDEWcdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e+8FE8gK8FszsK4qyOy+pyJPlzoNhelss/V5rSjL4hReR9boe2UNVcEEK9vMYkgXQLlpwkX6J8vnpFt7/xPPmzYDj0s1B5ykgK/8hSAdjklAVHi6C/AGtE6Du71omYiCk8Oftw8K7LK07eENJe2RfS6NuQUcKrR/r0r3seRDlN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sin0NZiC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sin0NZiC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F01C433C7;
	Mon,  1 Apr 2024 17:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991122;
	bh=BP9KJXDw4u5ptyy2JLxnevmwr7X8xdbTeyFWkDEWcdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sin0NZiC5kw8ehGYzg++2XqR7pF4bO3fyVOmqtYhx6KrCFvXJSvesn7LeWWvTXcxe
	 krqpnHWsL55qhyOfMYk3rqfEs8YwrQ1yNyqCURIzp4InVBfpxMerVw6jvSFPJOESg3
	 3WIRsahQM1Hydh+kpoNiw2VBvlDoq0QcnAdLoJGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Rapeli <mikko.rapeli@linaro.org>,
	Sumit Garg <sumit.garg@linaro.org>,
	Jens Wiklander <jens.wiklander@linaro.org>
Subject: [PATCH 6.1 169/272] tee: optee: Fix kernel panic caused by incorrect error handling
Date: Mon,  1 Apr 2024 17:45:59 +0200
Message-ID: <20240401152536.028715306@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sumit Garg <sumit.garg@linaro.org>

commit 95915ba4b987cf2b222b0f251280228a1ff977ac upstream.

The error path while failing to register devices on the TEE bus has a
bug leading to kernel panic as follows:

[   15.398930] Unable to handle kernel paging request at virtual address ffff07ed00626d7c
[   15.406913] Mem abort info:
[   15.409722]   ESR = 0x0000000096000005
[   15.413490]   EC = 0x25: DABT (current EL), IL = 32 bits
[   15.418814]   SET = 0, FnV = 0
[   15.421878]   EA = 0, S1PTW = 0
[   15.425031]   FSC = 0x05: level 1 translation fault
[   15.429922] Data abort info:
[   15.432813]   ISV = 0, ISS = 0x00000005, ISS2 = 0x00000000
[   15.438310]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
[   15.443372]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[   15.448697] swapper pgtable: 4k pages, 48-bit VAs, pgdp=00000000d9e3e000
[   15.455413] [ffff07ed00626d7c] pgd=1800000bffdf9003, p4d=1800000bffdf9003, pud=0000000000000000
[   15.464146] Internal error: Oops: 0000000096000005 [#1] PREEMPT SMP

Commit 7269cba53d90 ("tee: optee: Fix supplicant based device enumeration")
lead to the introduction of this bug. So fix it appropriately.

Reported-by: Mikko Rapeli <mikko.rapeli@linaro.org>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218542
Fixes: 7269cba53d90 ("tee: optee: Fix supplicant based device enumeration")
Cc: stable@vger.kernel.org
Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tee/optee/device.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/tee/optee/device.c
+++ b/drivers/tee/optee/device.c
@@ -90,13 +90,14 @@ static int optee_register_device(const u
 	if (rc) {
 		pr_err("device registration failed, err: %d\n", rc);
 		put_device(&optee_device->dev);
+		return rc;
 	}
 
 	if (func == PTA_CMD_GET_DEVICES_SUPP)
 		device_create_file(&optee_device->dev,
 				   &dev_attr_need_supplicant);
 
-	return rc;
+	return 0;
 }
 
 static int __optee_enumerate_devices(u32 func)


