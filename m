Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F95D4A35;
	Tue, 13 Oct 2026 12:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895207; cv=none; b=pxd3A28v6Y/slG/RYdqSQdKMqdnCB1x3t67QgF8F72Lx5qgXQ6v+C50ZIMbAf2IN+gTYDgdJ/1RIlPwxUvhzoT5ZuslWcmIkUgR0osHHVUxp+yEs2PsoJRG8NZ7IZAmaHdDoX587ai+EcpqXJB6oB9kPX9rKUSLDHkosgd3eqLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895207; c=relaxed/simple;
	bh=JXJ3Ksru6JJzJcli2cGESAvDDSnplGV2Lrok9ytXUvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SbDJIfz01rJ+VRhGv1S3Fxxe/FV8zXTHvbVXhnNNxFA1QVVIs7TFRNDPACHkxh5Y1mYyMCLoIfG1ENe87e1UqDy9AZpyja3z2XUVpGaLlBfy739OMfahftQhITM+T6R8MVxSwZlFnsmosrQpQwwosZvNILe+E5RROUnO+l+iRxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tKxpIEuw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tKxpIEuw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F30591F000FF;
	Tue, 13 Oct 2026 12:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895206;
	bh=GLaymcEPud+d46yXwkdVVMsl1hlbS+FaZ8NK+DmyOsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tKxpIEuwjM+kWR6gCAWqfVmqfpS/i8mKn3nv4RTbKOZ8bVVDqsZV2wqnZyImQhMhA
	 2Ff6Id5eY0O0zr5K2GW2sgUjWP7dlCE0YrjFWn1SzqM1bkOinXIfQmDE6Mo5ni7uEm
	 g3u65ZEosjVCgs0G8W8xUC058/FjJ65o7SrO6PPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 180/497] Bluetooth: RFCOMM: Fix initial port reference race
Date: Tue, 13 Oct 2026 13:35:47 +0200
Message-ID: <20261013112912.161771280@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
@@ -465,7 +465,7 @@ static int __rfcomm_release_dev(void __u
 	/* Shut down TTY synchronously before freeing rfcomm_dev */
 	tty_port_tty_vhangup(&dev->port);
 
-	if (!test_bit(RFCOMM_TTY_OWNED, &dev->status))
+	if (!test_and_set_bit(RFCOMM_TTY_OWNED, &dev->status))
 		tty_port_put(&dev->port);
 
 	tty_port_put(&dev->port);
@@ -727,10 +727,9 @@ static int rfcomm_tty_install(struct tty
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


