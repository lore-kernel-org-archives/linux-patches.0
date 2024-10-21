Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A126A1E3776;
	Mon, 21 Oct 2024 10:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506713; cv=none; b=F5OSeAYkz7kE4K7w1mDlUwAASC3AXC3eiUesEN6tc/y5MLjggfl/DwmrnuvKpdsOy8R71Z0RCHd4vH4CzZ82Zbqdow74yZ998bK/552pV6lsbWcFKSs8ezWDu9JwIHM7wNCjQoXluJC3yAtQuIUCYOpG+aMs+nYNP9A40eeDcic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506713; c=relaxed/simple;
	bh=0RrMdBQnrnQjR7rR1hJNzcVsX6t/1U9GqvlYCVmoHNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OquWtdiRYi79C1X6dSsMV5k/LcchwwV5nPKpMv2b7eKAwfag3FWaS6Ul/7uYfAn4KStyNVUOHTUXntHBkHlNlvZe0bAx0DqlTAXtsePjI0FLks2eR2SCQrOuhe5kr89YI4kqh2kg/E1wO+yN+Zuu2zzJA+BAFOkbc072UH5MXFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X0rV3ncu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X0rV3ncu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F52CC4CEC3;
	Mon, 21 Oct 2024 10:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506713;
	bh=0RrMdBQnrnQjR7rR1hJNzcVsX6t/1U9GqvlYCVmoHNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X0rV3ncukyAI6zMZeBfEQi92kbfPApXvu9MUX68p7ETu6xOGtvXsVE3nchkeiFmkL
	 mXKOvyA4Nz+bitOZWig8ILi0zxwYgVtt8MJv/RhhOq1xgt8qq5EeKO/4eSi4PYFp6k
	 l00YkvAXKNeYkUi/RBRMAGCtOU8f43U11q2tTptw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Thompson <dev@aaront.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.11 096/135] Bluetooth: ISO: Fix multiple init when debugfs is disabled
Date: Mon, 21 Oct 2024 12:24:12 +0200
Message-ID: <20241021102303.080831136@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Thompson <dev@aaront.org>

commit a9b7b535ba192c6b77e6c15a4c82d853163eab8c upstream.

If bt_debugfs is not created successfully, which happens if either
CONFIG_DEBUG_FS or CONFIG_DEBUG_FS_ALLOW_ALL is unset, then iso_init()
returns early and does not set iso_inited to true. This means that a
subsequent call to iso_init() will result in duplicate calls to
proto_register(), bt_sock_register(), etc.

With CONFIG_LIST_HARDENED and CONFIG_BUG_ON_DATA_CORRUPTION enabled, the
duplicate call to proto_register() triggers this BUG():

  list_add double add: new=ffffffffc0b280d0, prev=ffffffffbab56250,
    next=ffffffffc0b280d0.
  ------------[ cut here ]------------
  kernel BUG at lib/list_debug.c:35!
  Oops: invalid opcode: 0000 [#1] PREEMPT SMP PTI
  CPU: 2 PID: 887 Comm: bluetoothd Not tainted 6.10.11-1-ao-desktop #1
  RIP: 0010:__list_add_valid_or_report+0x9a/0xa0
  ...
    __list_add_valid_or_report+0x9a/0xa0
    proto_register+0x2b5/0x340
    iso_init+0x23/0x150 [bluetooth]
    set_iso_socket_func+0x68/0x1b0 [bluetooth]
    kmem_cache_free+0x308/0x330
    hci_sock_sendmsg+0x990/0x9e0 [bluetooth]
    __sock_sendmsg+0x7b/0x80
    sock_write_iter+0x9a/0x110
    do_iter_readv_writev+0x11d/0x220
    vfs_writev+0x180/0x3e0
    do_writev+0xca/0x100
  ...

This change removes the early return. The check for iso_debugfs being
NULL was unnecessary, it is always NULL when iso_inited is false.

Cc: stable@vger.kernel.org
Fixes: ccf74f2390d6 ("Bluetooth: Add BTPROTO_ISO socket type")
Signed-off-by: Aaron Thompson <dev@aaront.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/iso.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -2301,13 +2301,9 @@ int iso_init(void)
 
 	hci_register_cb(&iso_cb);
 
-	if (IS_ERR_OR_NULL(bt_debugfs))
-		return 0;
-
-	if (!iso_debugfs) {
+	if (!IS_ERR_OR_NULL(bt_debugfs))
 		iso_debugfs = debugfs_create_file("iso", 0444, bt_debugfs,
 						  NULL, &iso_debugfs_fops);
-	}
 
 	iso_inited = true;
 


