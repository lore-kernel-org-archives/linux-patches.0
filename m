Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA0A233722;
	Mon, 13 Apr 2026 16:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097847; cv=none; b=WCyyOuvsMTT0zokuI2EC+fTH9qCNc3GGZvAu/1Wc+jvmlB3pb5jUVhtTdbsyvP7RKw18RWkOEoFXF9m+iTtI65CmFgUFJvb4rdDf/WTzNHWIuObl9MD6QcnW4iZWeKY3iXnzlFvOfeCS00Lh1FXBUNVzKk7Zc2WDawKVD+FTJWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097847; c=relaxed/simple;
	bh=jnEAxw+6Fz/I3ytiNuIuwNqXWkNAMAZJrXZwvZaei3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W94d9FR3E+YKQ2BOegtTVryujfaiNB2TFk9E7OADjYfRVEy9jMmS9+MQF53l7gVXKu5coEnEoHxMdZiry4cJpseUOb5Ab6QPmTJcPuVP+eTwTuvhrf7QQEgLEv+v6CZDB6HrfoyEL3HXhXP/oVp4PLeqHSCyuDj7w/nY3qIk3IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MnUfJM2a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MnUfJM2a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9238C2BCAF;
	Mon, 13 Apr 2026 16:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097847;
	bh=jnEAxw+6Fz/I3ytiNuIuwNqXWkNAMAZJrXZwvZaei3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MnUfJM2aF6B3BdTEwG6YsS1Yx1cppZwfsCxD/oRdGPeNA2ivczXu+pIXHnoDQXDBb
	 tQ40iSGZK/Vp+OfJJMg8zA/w4vEO85AeyaFU8f0PL0xXbXD4DiUHV50Gbbi3dQMFmp
	 lEzQQmRViS0znUJKr0R+jd8YAS1JzWwClcCnPsmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.15 294/570] xen/privcmd: add boot control for restricted usage in domU
Date: Mon, 13 Apr 2026 17:57:05 +0200
Message-ID: <20260413155841.515897760@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juergen Gross <jgross@suse.com>

commit 1613462be621ad5103ec338a7b0ca0746ec4e5f1 upstream.

When running in an unprivileged domU under Xen, the privcmd driver
is restricted to allow only hypercalls against a target domain, for
which the current domU is acting as a device model.

Add a boot parameter "unrestricted" to allow all hypercalls (the
hypervisor will still refuse destructive hypercalls affecting other
guests).

Make this new parameter effective only in case the domU wasn't started
using secure boot, as otherwise hypercalls targeting the domU itself
might result in violating the secure boot functionality.

This is achieved by adding another lockdown reason, which can be
tested to not being set when applying the "unrestricted" option.

This is part of XSA-482

Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/privcmd.c    |   13 +++++++++++++
 include/linux/security.h |    1 +
 security/security.c      |    1 +
 3 files changed, 15 insertions(+)

--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -26,6 +26,7 @@
 #include <linux/miscdevice.h>
 #include <linux/moduleparam.h>
 #include <linux/notifier.h>
+#include <linux/security.h>
 #include <linux/wait.h>
 
 #include <asm/xen/hypervisor.h>
@@ -59,6 +60,11 @@ module_param_named(dm_op_buf_max_size, p
 MODULE_PARM_DESC(dm_op_buf_max_size,
 		 "Maximum size of a dm_op hypercall buffer");
 
+static bool unrestricted;
+module_param(unrestricted, bool, 0);
+MODULE_PARM_DESC(unrestricted,
+	"Don't restrict hypercalls to target domain if running in a domU");
+
 struct privcmd_data {
 	domid_t domid;
 };
@@ -1022,6 +1028,13 @@ static struct notifier_block xenstore_no
 
 static void __init restrict_driver(void)
 {
+	if (unrestricted) {
+		if (security_locked_down(LOCKDOWN_XEN_USER_ACTIONS))
+			pr_warn("Kernel is locked down, parameter \"unrestricted\" ignored\n");
+		else
+			return;
+	}
+
 	restrict_wait = true;
 
 	register_xenstore_notifier(&xenstore_notifier);
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -122,6 +122,7 @@ enum lockdown_reason {
 	LOCKDOWN_XMON_WR,
 	LOCKDOWN_BPF_WRITE_USER,
 	LOCKDOWN_DBG_WRITE_KERNEL,
+	LOCKDOWN_XEN_USER_ACTIONS,
 	LOCKDOWN_INTEGRITY_MAX,
 	LOCKDOWN_KCORE,
 	LOCKDOWN_KPROBES,
--- a/security/security.c
+++ b/security/security.c
@@ -60,6 +60,7 @@ const char *const lockdown_reasons[LOCKD
 	[LOCKDOWN_XMON_WR] = "xmon write access",
 	[LOCKDOWN_BPF_WRITE_USER] = "use of bpf to write user RAM",
 	[LOCKDOWN_DBG_WRITE_KERNEL] = "use of kgdb/kdb to write kernel RAM",
+	[LOCKDOWN_XEN_USER_ACTIONS] = "Xen guest user action",
 	[LOCKDOWN_INTEGRITY_MAX] = "integrity",
 	[LOCKDOWN_KCORE] = "/proc/kcore access",
 	[LOCKDOWN_KPROBES] = "use of kprobes",


