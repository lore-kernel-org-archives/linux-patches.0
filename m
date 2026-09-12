Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFE7356A0D;
	Sat, 12 Sep 2026 08:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203474; cv=none; b=nRspUqNiDdANoo38vU2olxUwtTm9E9pBnb8OQofbCBY0uoWChehZSVH8/jGwJTwoqCMLqxZq28ypZMuARw3HLDaPyQheXbrV81WDzhTTcfI/LcU/CR6v7Og2vRW52XpYsIiUgAKNHoZ6IdKTlU0NMuJ6q1/HvAcv/imN8/ftebY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203474; c=relaxed/simple;
	bh=tquA/3bXff8A44i1Sz/es4Uw5HY0zDj90Q79Zndqons=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S44hxWVukGXw/ym+a5Qwpzno9wC/Hq8Vzv0ww94EVel48PvE1ae5XRVZNkZeEyLWfJXIaSUOW3p+tw6Kp76tdHURxWzPMcoV22YB0Zykt54Iwafqxjfwtkr8iV0nU/3kZDxJZ60Qm8idgYwsE31LqeBv5FOdYZxbV9uMQEctoTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sJcRxQ/C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sJcRxQ/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D330D1F000FF;
	Sat, 12 Sep 2026 08:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203472;
	bh=NVMLZ8rYX4NliVl7ScCJyfRpJiJxRgelIKy9fjSHR+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sJcRxQ/C16ds5uBzf+sjzczgDMbsP3ojKIdovN61L1tVuvcyItcYejeEt/mIfQ6Cd
	 nZCJlzYtPXBJuTID8N++NxhSnz25VlkeDiAd8I4c0G1bHtKoHT3y5Jb6kPgDLA9xxI
	 FLim/EZcAzZFjVSNRbteFyc0Y7vAe69AQtrr8l6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1413/1815] objtool/klp: Fix vmlinux .klp.symid link error for .exitcall.exit symbols
Date: Sat, 12 Sep 2026 08:52:43 +0200
Message-ID: <20260912065722.193095664@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Puranjay Mohan <puranjay@kernel.org>

[ Upstream commit 6656cf1e975aa152c082012b820efffaebd49979 ]

Building a kernel via klp-build fails to link:

  `__exitcall_aes_mod_exit' referenced in section `.klp.symid' of vmlinux.o: defined in discarded section `.exitcall.exit' of vmlinux.o
  `__exitcall_dax_exit' referenced in section `.klp.symid' of vmlinux.o: defined in discarded section `.exitcall.exit' of vmlinux.o
  `__exitcall_hid_exit' referenced in section `.klp.symid' of vmlinux.o: defined in discarded section `.exitcall.exit' of vmlinux.o
  `__exitcall_usb_serial_module_exit' referenced in section `.klp.symid' of vmlinux.o: defined in discarded section `.exitcall.exit' of vmlinux.o

module_exit() on a built-in emits a static __exitcall_$fn pointer into
.exitcall.exit, which vmlinux.lds.h discards unconditionally via
EXIT_CALL.  When two built-in translation units define a module_exit()
function of the same name, the resulting local symbols collide,
symid_needed() sees a duplicate and emits a .klp.symid entry for each,
referencing symbols the linker then throws away.

Same-named module_exit() functions are not rare:

  dax_exit                drivers/dax/device.c, drivers/dax/fsdev.c
  hid_exit                drivers/hid/hid-core.c, drivers/hid/usbhid/hid-core.c
  aes_mod_exit            arch/arm64/crypto/aes-ce-ccm-glue.c, lib/crypto/aes.c
  usb_serial_module_exit  module_usb_serial_driver() expands to this fixed
                          name in each of its ~49 users

The last one makes the collision structural rather than accidental: any
kernel with two built-in USB serial drivers has it.  This is not arch
specific either; it only requires the objects to be built in rather than
modular, which is why a monolithic config trips it while a typical
distro config does not.

Add .exitcall.exit to the discarded section list so its symbols don't get
symids.

This is the same failure mode as "objtool/klp: Fix vmlinux .klp.symid
link error for .no_trim_symbol symbols", for another unconditionally
discarded allocated section.

Fixes: 029223d30162 ("objtool/klp: Add .klp.symid for sympos disambiguation")
Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
Link: https://patch.msgid.link/m24igzlbxf.fsf@kernel.org
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/klp-symid.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/objtool/klp-symid.c b/tools/objtool/klp-symid.c
index 21d8708013aba..b19f76dff13e9 100644
--- a/tools/objtool/klp-symid.c
+++ b/tools/objtool/klp-symid.c
@@ -30,6 +30,7 @@
 
 static const char * const discarded_secs[] = {
 	".discard",
+	".exitcall.exit",
 	".modinfo",
 	".no_trim_symbol",
 	"__tracepoint_check",
-- 
2.53.0



