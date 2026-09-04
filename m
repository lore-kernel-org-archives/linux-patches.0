Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3021400DE8;
	Fri,  4 Sep 2026 06:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502891; cv=none; b=FfwmKoLRYA4FhTZFMt1L6RFvkSxE0XqlWpTSWfJvy0bv6WLEsbsAexElrsGQmXIqJkL51P9718MjCedyVKDuFnOzqY40M1ic+6neOu0rCi2mYiA+vvbccUiRMMFM2lkc6Uu1IS0iNgEQvXwO406Nqwjqtah4Ls+Of/2hToxH4g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502891; c=relaxed/simple;
	bh=lDlueuZiFyURY9WlRdYkCy7PGCPlZenuAgoeBQIMYN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EaPfLAijlTuuWuEVSWV9J4V4QYMjWT5lpLWC4x8EWWvzOHe7C9Xs2TZFT6iVmFayZiQ5tu+BYNDPGCcAfenvvweexT4RDNelKECD6IYNunodX75+1r5HxRrZ2IepkKpnc9mZhG0Ma5PaKWzwQWzfLYlR9dMXz5uuvx4N7AV3MWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iGSXkFa9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iGSXkFa9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AEEF1F00A3D;
	Fri,  4 Sep 2026 06:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502890;
	bh=Olj6FB4Js1OL2h2ARxeVdGBfs/OtaLHQtWhhEBTvkwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iGSXkFa9d/IVGLlHk+Mmp/QmmuqDMXzaC0dpuQowmQ6w9mpG/qzO6DFLRnu6likEc
	 1+mNHv/s/HpAVa8v1ZCIWze/mfjjUAcnstAbWmgJYCtdCrVhkSle+9Cwq10ZeYk0I/
	 7Jv22aZ+j2ednZXbnkatVYGv8iqdfkiflQEYOEdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.12 323/403] platform/x86: hp-bioscfg: fix heap OOB read in sk_store() and kek_store()
Date: Fri,  4 Sep 2026 07:02:06 +0200
Message-ID: <20260904045742.177041591@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Bilal <meatuni001@gmail.com>

commit a7508c7959ff8d037327d377ed21a9c0eabe4674 upstream.

sk_store() and kek_store() strip a trailing newline from the sysfs
write before allocating the key buffer:

	length = count;
	if (buf[length - 1] == '\n')
		length--;
	bioscfg_drv.spm_data.signing_key = kmemdup(buf, length, GFP_KERNEL);

but then pass the original "count" (not "length") as the copy size to
hp_wmi_perform_query(), which memcpy()s that many bytes out of the
"length"-sized allocation, reading one byte past it whenever the write
ends in a newline, the normal case for a shell "echo" into sysfs.

KASAN confirms this directly:

  BUG: KASAN: slab-out-of-bounds in hp_wmi_perform_query+0x1e9/0x460 [hp_bioscfg]
  Read of size 28 at addr ffff88813c8e2b80 by task python3/16022
  ...
  sk_store+0xa7/0x240 [hp_bioscfg]
  kernfs_fop_write_iter+0x3e1/0x5d0
  ...
  The buggy address is located 0 bytes inside of
  allocated 27-byte region [ffff88813c8e2b80, ffff88813c8e2b9b)

Reproduced identically for kek_store, and at multiple write sizes
(28, 57, 201 bytes), each time reading exactly one byte past a
kmemdup() allocation one byte smaller than the write.

Fix by passing "length" instead of "count" to hp_wmi_perform_query()
in both functions.

Fixes: b2715aa2e135 ("platform/x86: hp-bioscfg: spmobj-attributes")
Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://patch.msgid.link/20260812111829.172273-3-meatuni001@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/hp/hp-bioscfg/spmobj-attributes.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/platform/x86/hp/hp-bioscfg/spmobj-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/spmobj-attributes.c
@@ -238,7 +238,7 @@ static ssize_t sk_store(struct kobject *
 	ret = hp_wmi_perform_query(HPWMI_SECUREPLATFORM_SET_SK,
 				   HPWMI_SECUREPLATFORM,
 				   (void *)bioscfg_drv.spm_data.signing_key,
-				   count, 0);
+				   length, 0);
 
 	if (!ret) {
 		bioscfg_drv.spm_data.mechanism = SIGNING_KEY;
@@ -274,7 +274,7 @@ static ssize_t kek_store(struct kobject
 	ret = hp_wmi_perform_query(HPWMI_SECUREPLATFORM_SET_KEK,
 				   HPWMI_SECUREPLATFORM,
 				   (void *)bioscfg_drv.spm_data.endorsement_key,
-				   count, 0);
+				   length, 0);
 
 	if (!ret) {
 		bioscfg_drv.spm_data.mechanism = ENDORSEMENT_KEY;


