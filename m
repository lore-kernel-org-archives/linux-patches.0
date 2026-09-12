Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75023184524;
	Sat, 12 Sep 2026 13:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220763; cv=none; b=AUtPP2JG3CWPCed7oHqgsgI6Ndqht4UvkZexbJ7F+4oN9IwB+B4Pr+6JX4K7PZl+WtbTUcGb3sr7bBPWeTozPHHXhftZx+4lMwSL5nHNQHdXnSY1cA0cCHcFqDPkP/F/Tq/JbPFVTI1NGO/Pusm43rDFu0kmICl6GCu+2mVVJqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220763; c=relaxed/simple;
	bh=/fDPylpUTkKKcphbBA3A0+wmlTY5bOMkb8aMjLFdy9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NIlQ5wIimJBZVM4yyVAXrm6Ht7428ie+nMq/ebknF6h3HVjZK1RTOhwG+JI39mIXGsrjbkQOKeJz1vPzl7FBwHBa7Uo3r5wtznsMBdETbhopyPAln1rAAE3tzAqSgYbGA+fExSHuraBBfPjdLNfBWiGFvrF7uFKqfDRo7GnwdX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p0CqkK12; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p0CqkK12"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A971F000FF;
	Sat, 12 Sep 2026 13:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220762;
	bh=gCmcyZrHIqHDDfoASvh0YW1YXQ6RV37IEEu4XlB86Uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p0CqkK12Ycfcl4ocy+koX2pLpQbP6g/lWE1p2BN6TGZUpVl+fn1wqjTiiflsBdckF
	 1kqQ8BeirSmsSfMpV8pE6fwPgz57Ynr1QLwHXxJSV6kD7kaLh2c455IwL3HG8LP1Ld
	 eZPSwy+WnoxiFctJwIOkk6qwyrzeelzi9fBF5Dsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.6 0243/1424] platform/x86: hp-bioscfg: fix heap OOB read in sk_store() and kek_store()
Date: Sat, 12 Sep 2026 08:44:35 +0200
Message-ID: <20260912065612.724096507@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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


