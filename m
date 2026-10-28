Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212982;
	b=FKEOr+1CCvBzEKmU5yQBVqfFYjjHpIWW7DVCTf6yLZMd4z4Oqzt3S8f4wShYN4LMX44o
	 9EuVONVpsYW2J51662gBvUFvZB/6BTSmM2w6HVlBWqNkABXKIP9sCkVFWCoBmIPOkh1vI
	 lbJzLc4cFlMPgzmPovGw0FYbG3EEs22b9b0a6r7yi5G6p+s4lzZLoUIcry5yTnOMdoYCz
	 Caoujpav3D6itV7Oj4q27kv8OvFy9cjJuHkMhHyrkDfjylFVHXtB/Dxv1rBoMXUIMGJgY
	 7C/FCtWF1ERAQlh3WYSowXCcOnhxuKJJuDLjzX1d6EOa6xEjeFPqE+fT28zHwrqdkCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212982;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lb9fruExjXOxaS8F2IZ8ntBs/Brakt2Q2HIYrH9Dixw=;
	b=mwuFx3bh3yhtlNLlD+AjnEphLF5RIYiEqYddYCrfwY/i1+q42RwaiEboeKotYJLzS/dc
	 b0wWDx9s6GpFov1wmFa+N9NYuwPlLRxrgXe27aTjLO+t8nzGKhctZx9ysg9Y0mWKqcJFm
	 SjFePQ6vjI2wRonn6SpF9zCyce9Z2i7UXM4tz8B0MoLhvcyvGPYNJs7D0QxzZE9Ldlf5r
	 BQOFFTOQ/kpQ0VuZLGtX7NYFsuNTjRtCD9V70FlVGrERrQxyOkrjLzkWbswShK/rlZ05a
	 J4Dn5T8DWQvy9kNrYZeOrLMOo6sluuc7SIVejPM0Kl9ARjoGKYZeMXGsLBdYgH8l/kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zeMbsdNz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26EAE606A31C;
	Wed, 28 Oct 2026 18:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zeMbsdNz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 787701F01829;
	Wed, 28 Oct 2026 18:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212982;
	bh=lb9fruExjXOxaS8F2IZ8ntBs/Brakt2Q2HIYrH9Dixw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zeMbsdNzRmwRbcdjEGgrbkIQsOsIa6R2WfLlsAj0afjH7J8xlGRioe1HDf/IfwHix
	 V+CWRdf2LKfzImIBv9EH3AWWiYSJMHnmcI2vsqTiEZgfF/iwTemj4NEGASEMhimWIW
	 7WisbD2Pyyl/E4Sd0qmCjJfGBB0cETAR9VWCTTiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 0301/1887] Bluetooth: RFCOMM: Fix initial port reference race
Date: Wed, 28 Oct 2026 17:39:57 +0100
Message-ID: <20261028170506.078260307@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -730,10 +730,9 @@ static int rfcomm_tty_install(struct tty
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


