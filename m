Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE7135200C;
	Thu, 20 Aug 2026 15:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238232; cv=none; b=DrwdxqJKci7k8H3nBcnrX6CwwxX9h+4HC7sHIYR45gOsPHfUUWWpe6k7BZnwY30KBp0a3ntWgbSH070gbxGgxyjmoM7lLJCYnob6cqKmY50156jcbnHV6e6tAuZegQOZd4JP9P3ydtlkPZj5X4WV+/Yhmzf+NRJqR4ApNKppRkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238232; c=relaxed/simple;
	bh=++N/vlxe8/sB9DOYF2tOPLvauPwzTOJGx7nfhBQ3iKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rGTvGterhnVYyBKh2WenlzwOVzOGcKlL32tckd+I/tmxp6a8ujybmwXIbMaaI7URgHlAjBCf3EmhadTWE5QsZ1qtixVYHX1hJ5KipPlxCAcCcX2R2yjfLode9XK0C/Byf8IgqcjZca4oJQwmwH8wgaRJlVCPDzFqbpcDLyxlH+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RmACqP76; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RmACqP76"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E131F000E9;
	Thu, 20 Aug 2026 15:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238231;
	bh=NGgzcFd86aFPvvcG6GdB13rj8AfKtOv8tAaH9hXNM9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RmACqP76h4a7d3ZmWJP5CfQBXVqe7SQPRMyNpcx9U8ZTHpaAj1WTqMFTvU58Av+mf
	 huc00hpXVyaPEvGqJ/5x/FxEa0HTrVA0Q/nYJt9bCXuH/LmmRLkCysYFSU5iWH/YcI
	 0uHJBr22sUMj16w2fkr5MyElTVzXAOid/4/VbFAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jordan Rhee <jordanrhee@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 059/228] gve: fix NULL dereference due to missing ptp adjfine
Date: Thu, 20 Aug 2026 16:53:21 +0200
Message-ID: <20260820145246.267499873@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jordan Rhee <jordanrhee@google.com>

commit 3992ced109c70b771efad9e51ae68e5c7a04dea3 upstream.

Fix NULL dereference due to missing implementation of adjfine, which can
be triggered from usermode as follows:

sudo ./testptp -d /dev/ptp0 -f 0
[  551.943697] BUG: kernel NULL pointer dereference, address: 0000000000000000
[...]
[  552.061946] Call Trace:
[  552.064487]  <TASK>
[  552.066681]  ptp_clock_adjtime+0x1c0/0x2c0
[  552.070874]  ? get_clock_desc+0x6b/0xb0
[  552.074825]  pc_clock_adjtime+0x78/0xc0
[  552.078755]  __do_sys_clock_adjtime+0x85/0x110
[  552.083293]  do_syscall_64+0xea/0x610

Cc: stable@vger.kernel.org
Fixes: acd16380523b ("gve: Add initial PTP device support")
Signed-off-by: Jordan Rhee <jordanrhee@google.com>
Signed-off-by: Harshitha Ramamurthy <hramamurthy@google.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20260807224315.234152-3-hramamurthy@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/google/gve/gve_ptp.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/ethernet/google/gve/gve_ptp.c
+++ b/drivers/net/ethernet/google/gve/gve_ptp.c
@@ -26,6 +26,11 @@ int gve_clock_nic_ts_read(struct gve_pri
 	return 0;
 }
 
+static int gve_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
+{
+	return -EOPNOTSUPP;
+}
+
 static int gve_ptp_gettimex64(struct ptp_clock_info *info,
 			      struct timespec64 *ts,
 			      struct ptp_system_timestamp *sts)
@@ -60,6 +65,7 @@ out:
 static const struct ptp_clock_info gve_ptp_caps = {
 	.owner          = THIS_MODULE,
 	.name		= "gve clock",
+	.adjfine	= gve_ptp_adjfine,
 	.gettimex64	= gve_ptp_gettimex64,
 	.settime64	= gve_ptp_settime64,
 	.do_aux_work	= gve_ptp_do_aux_work,


