Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBCC23A16AC;
	Fri,  4 Sep 2026 05:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499297; cv=none; b=OEumfbZhEiLtrIvlGlkgTrzn5yh5dGg4VCQyvwWxm8xa3byvBNN2a32wutZEER6U2xk/Lwis7V13bIHOVGggibDQr7qq/woXMzDq2ZmnK0DBfP1kXb9nRrhWvPu8fo77Hnyb/vta1YhGHN8VRojht/TADg6hmq1MrIPrArgKb8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499297; c=relaxed/simple;
	bh=dqbRTBUnAq0X5g3ydBNjlj2rN2xN7qwqbBmShw4fiuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D6geoEAxQW8EPLNEVelljU7/82HVNHE4smw88oTNdeIDGU7AoURdSD910PPFKNF0eCkNvwqldZoODW/Q8AYDXebgM5Dv5s9JKLbbMuHjdjQYBLbTTikp4fH2d1rV56wACKJgiUBqUTsm+Kpupq6hvb44+5bOD8pXybYCLreEV1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=COPb7+TC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="COPb7+TC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B481F00A3D;
	Fri,  4 Sep 2026 05:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499295;
	bh=RjXGyHpAbZAAUILzh2mfBrLelksawOUvuzCHH5CsEks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=COPb7+TCpFeJC/OeSd7cuFllctDu1akTpCkPFInNB57hMq4LMlSD6yiddIsDpOBVQ
	 paXZMC9Pi0vdPdZzGYhiafRCvsM2elzKm9qyYWnapiYrStsvCcOhlI8dP9LggP21OE
	 3hhaXQKjAX5GTak7nDfe4UY+/UXEUmlHEoJrhvqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiacheng Yu <yujiacheng3@huawei.com>,
	Petr Pavlu <petr.pavlu@suse.com>
Subject: [PATCH 7.2 368/713] params: fix charp corruption on allocation failure
Date: Fri,  4 Sep 2026 06:55:36 +0200
Message-ID: <20260904045812.078075928@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Jiacheng Yu <yujiacheng3@huawei.com>

commit 3dfaae04243cde460d82dfc2a7dd0bb6664d20ae upstream.

param_set_charp() stores charp parameters in allocated memory after slab is
available, and releases the previous value when the parameter is updated.

The previous value is released before the replacement allocation succeeds.
If kmalloc_parameter() fails, the setter returns -ENOMEM with the parameter
left as NULL.

Failing zswap's compressor update before zswap is initialized can later
trigger:

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  RIP: 0010:strcmp+0x10/0x30
  Call Trace:
    zswap_setup+0x3b1/0x490
    zswap_enabled_param_set+0x5b/0xa0
    param_attr_store+0x93/0xe0
    module_attr_store+0x1c/0x30
    kernfs_fop_write_iter+0x116/0x1f0

Allocate and copy the replacement first, then replace the parameter value
only after allocation succeeds.

Fixes: e180a6b7759a ("param: fix charp parameters set via sysfs")
Cc: stable@vger.kernel.org
Signed-off-by: Jiacheng Yu <yujiacheng3@huawei.com>
Reviewed-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/params.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/kernel/params.c
+++ b/kernel/params.c
@@ -261,6 +261,7 @@ EXPORT_SYMBOL_GPL(param_set_uint_minmax)
 
 int param_set_charp(const char *val, const struct kernel_param *kp)
 {
+	char *tmp;
 	size_t len, maxlen = 1024;
 
 	len = strnlen(val, maxlen + 1);
@@ -269,19 +270,20 @@ int param_set_charp(const char *val, con
 		return -ENOSPC;
 	}
 
-	maybe_kfree_parameter(*(char **)kp->arg);
-
 	/*
 	 * This is a hack. We can't kmalloc() in early boot, and we
 	 * don't need to; this mangled commandline is preserved.
 	 */
 	if (slab_is_available()) {
-		*(char **)kp->arg = kmalloc_parameter(len + 1);
-		if (!*(char **)kp->arg)
+		tmp = kmalloc_parameter(len + 1);
+		if (!tmp)
 			return -ENOMEM;
-		strcpy(*(char **)kp->arg, val);
+		memcpy(tmp, val, len + 1);
 	} else
-		*(const char **)kp->arg = val;
+		tmp = (char *)val;
+
+	maybe_kfree_parameter(*(char **)kp->arg);
+	*(char **)kp->arg = tmp;
 
 	return 0;
 }


