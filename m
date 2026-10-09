Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 362624E780E;
	Fri,  9 Oct 2026 14:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557013; cv=none; b=hWi9wILEpd5BPajmOQGp4rv6W0WvKgCvR2aIc7mWKcVjpQPVEvak/PZNT+iikIjqAd42Fe5xayn2JsZ3jHBKKAHh0jaJ4XNK+jMubhsk3ybw8p2RqV6dpf5hA+m+Oxdw6FK1jTer6AKXNO7Lci5UfQhYqbC7hAivwc62v3+01rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557013; c=relaxed/simple;
	bh=H1QR8o5SLQG9+T7iUEgJj2sXjC/RZjU+YiEGGY5bdQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bo8KElR9Bmmia/VrpoZzA2pkMcFavbhr1SlES6yY9ooGt/UGZQC47+TvYwVWb5KeeBBiJ0mQg+E/7iLJ53N0/adGnkSSisDfSyRwDFyBRiZT4jtDE7+d1s/kHvjS31YQhf/th/psjLzsLS0tNI/KWMGzYSCwcE6YO8qI9yS0MO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gYzUHKRk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gYzUHKRk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A561F0089D;
	Fri,  9 Oct 2026 14:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557012;
	bh=i2c9fh8ViSFCifbZUIZAaALWA2waC5HGOudHTvY7n10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gYzUHKRk93H/S6IacU3RLM6Mem2rtX1E4eNaGH911fW8TNJwrs6dV67TtSMQW09ur
	 JpJZyruc7dUjfbUzfW7JQG/f/Po8lDObUbIg9QOiHZQU/1pQYXEa6TtmlrBw9wREo/
	 oqyLVSGYpxfXrRle4p9vRbztx1JIs+ca/sqe54DI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.2 282/428] Bluetooth: RFCOMM: Fix initial port reference race
Date: Fri,  9 Oct 2026 16:10:19 +0200
Message-ID: <20261009140952.295002724@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

From: Chengfeng Ye <nicoyip.dev@gmail.com>

commit 2d696c1ed3468dcb62578a3911e687110d463520 upstream.

For RFCOMM_RELEASE_ONHUP devices, rfcomm_tty_install() and
__rfcomm_release_dev() both use RFCOMM_TTY_OWNED to decide who drops the
initial tty_port reference. The release path tests the bit separately
from the install path setting it, so both can drop that reference.

The synchronous hangup does not prevent this race: port->tty is not
assigned until tty_port_open(), after installation. The following
interleaving is possible:

  1. Install and release each obtain a reference with rfcomm_dev_get().
  2. Release observes RFCOMM_TTY_OWNED clear.
  3. Install sets RFCOMM_TTY_OWNED and drops the initial reference.
  4. Release drops the same initial reference again.
  5. TTY cleanup drops its reference and frees the device.
  6. Release performs its final tty_port_put() on the freed port.

KASAN reported:

  BUG: KASAN: slab-use-after-free in tty_port_put+0x22/0x190
  Write of size 4 at addr ffff8881001d3d5c by task poc/92

  Call Trace:
   tty_port_put+0x22/0x190
   rfcomm_dev_ioctl+0x1d4/0x1930
   sock_do_ioctl+0x110/0x260
   sock_ioctl+0x380/0x590
   __x64_sys_ioctl+0x134/0x1c0

  Allocated by task 88:
   rfcomm_dev_ioctl+0x8f6/0x1930
   sock_do_ioctl+0x110/0x260
   sock_ioctl+0x380/0x590
   __x64_sys_ioctl+0x134/0x1c0

  Freed by task 65:
   kfree+0x131/0x3c0
   rfcomm_dev_destruct+0x23b/0x2f0
   release_one_tty+0xc1/0x370
   process_one_work+0x661/0x1090

Use test_and_set_bit() in both paths so that only the caller that changes
RFCOMM_TTY_OWNED from clear to set drops the initial reference. Each path
keeps its own lookup reference until release or TTY cleanup, preserving
the existing callback ordering and error handling.

Fixes: 80ea73378af4 ("Bluetooth: Fix unreleased rfcomm_dev reference")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/rfcomm/tty.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -462,7 +462,7 @@ static int __rfcomm_release_dev(void __u
 	/* Shut down TTY synchronously before freeing rfcomm_dev */
 	tty_port_tty_vhangup(&dev->port);
 
-	if (!test_bit(RFCOMM_TTY_OWNED, &dev->status))
+	if (!test_and_set_bit(RFCOMM_TTY_OWNED, &dev->status))
 		tty_port_put(&dev->port);
 
 	tty_port_put(&dev->port);
@@ -724,10 +724,9 @@ static int rfcomm_tty_install(struct tty
 	 * when the last process closes the tty. The behaviour is expected by
 	 * userspace.
 	 */
-	if (test_bit(RFCOMM_RELEASE_ONHUP, &dev->flags)) {
-		set_bit(RFCOMM_TTY_OWNED, &dev->status);
+	if (test_bit(RFCOMM_RELEASE_ONHUP, &dev->flags) &&
+	    !test_and_set_bit(RFCOMM_TTY_OWNED, &dev->status))
 		tty_port_put(&dev->port);
-	}
 
 	return 0;
 }


