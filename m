Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C471827055D;
	Wed, 25 Feb 2026 01:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983605; cv=none; b=VLJYlavlHpxXdu0FeXV1Ou+b1X+5yHNCj3fh6pQ4BZw4huLT75Hs5/2ti8pEGrq6tXOiI5L+TqAsqYSnxyvaMHoIGrtghXo1+pFmfWWExqw1CpmR+jzOsTZxA9dQI1UjnhzWuJ/x9ym1fXzdz2OQNKAMGFLelJgphKNF/5xmN/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983605; c=relaxed/simple;
	bh=cSYNhWkCSnLgxbj33th/3+9iCrh0mX6tlG794wK719M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RQIiz93A64F/HtjGmyCUsaILosrW24cszYjeDXpjdorIxk8SstTRd3c4J24d6udUvC8fjKlAFJYA8FsiI47F7rTFKFYxLa0ykGUKeE8Wui6xvvQ3JxnXYbVaEnu8fi123mA6dDbWSnCGUVsOCitNzZ/dHm/ICDDLUjzxx8HQHCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cTtaYgfW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cTtaYgfW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82A95C116D0;
	Wed, 25 Feb 2026 01:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983605;
	bh=cSYNhWkCSnLgxbj33th/3+9iCrh0mX6tlG794wK719M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cTtaYgfW1ngX/MTs83CSU6nOvCVT19VhOwspADR5MR1NkHCrbTDuGD9DVBKgARy9m
	 oqkrSK82asM2R6ayWD80FD/IAoF5I0fj9lZPx56Y4y8b+FkS6A0aJOAYn48A1436iI
	 u7fdiV4b1rOaqv9+diG2fCoaRWHbuANSICIbCB4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Helge Deller <deller@gmx.de>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 693/781] AppArmor: Allow apparmor to handle unaligned dfa tables
Date: Tue, 24 Feb 2026 17:23:22 -0800
Message-ID: <20260225012416.758701732@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@kernel.org>

[ Upstream commit 64802f731214a51dfe3c6c27636b3ddafd003eb0 ]

The dfa tables can originate from kernel or userspace and 8-byte alignment
isn't always guaranteed and as such may trigger unaligned memory accesses
on various architectures. Resulting in the following

[   73.901376] WARNING: CPU: 0 PID: 341 at security/apparmor/match.c:316 aa_dfa_unpack+0x6cc/0x720
[   74.015867] Modules linked in: binfmt_misc evdev flash sg drm drm_panel_orientation_quirks backlight i2c_core configfs nfnetlink autofs4 ext4 crc16 mbcache jbd2 hid_generic usbhid sr_mod hid cdrom
sd_mod ata_generic ohci_pci ehci_pci ehci_hcd ohci_hcd pata_ali libata sym53c8xx scsi_transport_spi tg3 scsi_mod usbcore libphy scsi_common mdio_bus usb_common
[   74.428977] CPU: 0 UID: 0 PID: 341 Comm: apparmor_parser Not tainted 6.18.0-rc6+ #9 NONE
[   74.536543] Call Trace:
[   74.568561] [<0000000000434c24>] dump_stack+0x8/0x18
[   74.633757] [<0000000000476438>] __warn+0xd8/0x100
[   74.696664] [<00000000004296d4>] warn_slowpath_fmt+0x34/0x74
[   74.771006] [<00000000008db28c>] aa_dfa_unpack+0x6cc/0x720
[   74.843062] [<00000000008e643c>] unpack_pdb+0xbc/0x7e0
[   74.910545] [<00000000008e7740>] unpack_profile+0xbe0/0x1300
[   74.984888] [<00000000008e82e0>] aa_unpack+0xe0/0x6a0
[   75.051226] [<00000000008e3ec4>] aa_replace_profiles+0x64/0x1160
[   75.130144] [<00000000008d4d90>] policy_update+0xf0/0x280
[   75.201057] [<00000000008d4fc8>] profile_replace+0xa8/0x100
[   75.274258] [<0000000000766bd0>] vfs_write+0x90/0x420
[   75.340594] [<00000000007670cc>] ksys_write+0x4c/0xe0
[   75.406932] [<0000000000767174>] sys_write+0x14/0x40
[   75.472126] [<0000000000406174>] linux_sparc_syscall+0x34/0x44
[   75.548802] ---[ end trace 0000000000000000 ]---
[   75.609503] dfa blob stream 0xfff0000008926b96 not aligned.
[   75.682695] Kernel unaligned access at TPC[8db2a8] aa_dfa_unpack+0x6e8/0x720

Work around it by using the get_unaligned_xx() helpers.

Fixes: e6e8bf418850d ("apparmor: fix restricted endian type warnings for dfa unpack")
Reported-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Closes: https://github.com/sparclinux/issues/issues/30
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/match.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/security/apparmor/match.c b/security/apparmor/match.c
index c5a91600842a1..26e82ba879d44 100644
--- a/security/apparmor/match.c
+++ b/security/apparmor/match.c
@@ -15,6 +15,7 @@
 #include <linux/vmalloc.h>
 #include <linux/err.h>
 #include <linux/kref.h>
+#include <linux/unaligned.h>
 
 #include "include/lib.h"
 #include "include/match.h"
@@ -42,11 +43,11 @@ static struct table_header *unpack_table(char *blob, size_t bsize)
 	/* loaded td_id's start at 1, subtract 1 now to avoid doing
 	 * it every time we use td_id as an index
 	 */
-	th.td_id = be16_to_cpu(*(__be16 *) (blob)) - 1;
+	th.td_id = get_unaligned_be16(blob) - 1;
 	if (th.td_id > YYTD_ID_MAX)
 		goto out;
-	th.td_flags = be16_to_cpu(*(__be16 *) (blob + 2));
-	th.td_lolen = be32_to_cpu(*(__be32 *) (blob + 8));
+	th.td_flags = get_unaligned_be16(blob + 2);
+	th.td_lolen = get_unaligned_be32(blob + 8);
 	blob += sizeof(struct table_header);
 
 	if (!(th.td_flags == YYTD_DATA16 || th.td_flags == YYTD_DATA32 ||
@@ -313,14 +314,14 @@ struct aa_dfa *aa_dfa_unpack(void *blob, size_t size, int flags)
 	if (size < sizeof(struct table_set_header))
 		goto fail;
 
-	if (ntohl(*(__be32 *) data) != YYTH_MAGIC)
+	if (get_unaligned_be32(data) != YYTH_MAGIC)
 		goto fail;
 
-	hsize = ntohl(*(__be32 *) (data + 4));
+	hsize = get_unaligned_be32(data + 4);
 	if (size < hsize)
 		goto fail;
 
-	dfa->flags = ntohs(*(__be16 *) (data + 12));
+	dfa->flags = get_unaligned_be16(data + 12);
 	if (dfa->flags & ~(YYTH_FLAGS))
 		goto fail;
 
@@ -329,7 +330,7 @@ struct aa_dfa *aa_dfa_unpack(void *blob, size_t size, int flags)
 	 * if (dfa->flags & YYTH_FLAGS_OOB_TRANS) {
 	 *	if (hsize < 16 + 4)
 	 *		goto fail;
-	 *	dfa->max_oob = ntol(*(__be32 *) (data + 16));
+	 *	dfa->max_oob = get_unaligned_be32(data + 16);
 	 *	if (dfa->max <= MAX_OOB_SUPPORTED) {
 	 *		pr_err("AppArmor DFA OOB greater than supported\n");
 	 *		goto fail;
-- 
2.51.0



