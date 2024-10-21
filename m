Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 591581E0087;
	Mon, 21 Oct 2024 10:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507216; cv=none; b=fCv+xHyR9NWr0d6IDaZk2FVzdBWbqt38I0LD8i4BxYCz5leF379OuOALjFN8MuXSEkPyZJYsdfG89NcLYGF59udOp2Aaet82poOffX4XwmpenODTnv9z5cIgFws779c8jxqcZYoEJJso01Cy34cJ3B9p2LDPQC1DRPOyvOkBiBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507216; c=relaxed/simple;
	bh=Efrk8ivpdQgvHFnCPkW+LkAkjUjlFSUJPhbEefwOg6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bs1dlQSs0YWvqF+vhzITR93txw9I+8hwlqiom7TnAiz+9/xbiegQ/itex5gC8YJIJtVBeDjFkp5LrwjVQ5fpSFpRFmsBhpF/pcdXET9BuLQDdKGflubbz857haFhx6jxXnjdo+C8mDlilK09Fs8pY/t+pqe4kXM+/hPqXjCHKSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DrFjEae3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DrFjEae3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF1B4C4CEC3;
	Mon, 21 Oct 2024 10:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507216;
	bh=Efrk8ivpdQgvHFnCPkW+LkAkjUjlFSUJPhbEefwOg6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DrFjEae3uw7lVDp5aKrdV0vm14LNgjS2LpJRWUCaecYhj0I8+xWRawc6MMeRCoZLa
	 /26JQ+c/LgyM86VnaYY1Liaclnu8d+36mlwa5MH9wT5OrNZLRqqL2Y47w9wRLxCRDE
	 Dol50iRSIqyni21xpqirrLHwukeAOn1v8AVTiTc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Thompson <dev@aaront.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 087/124] Bluetooth: Call iso_exit() on module unload
Date: Mon, 21 Oct 2024 12:24:51 +0200
Message-ID: <20241021102300.094930548@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Thompson <dev@aaront.org>

commit d458cd1221e9e56da3b2cc5518ad3225caa91f20 upstream.

If iso_init() has been called, iso_exit() must be called on module
unload. Without that, the struct proto that iso_init() registered with
proto_register() becomes invalid, which could cause unpredictable
problems later. In my case, with CONFIG_LIST_HARDENED and
CONFIG_BUG_ON_DATA_CORRUPTION enabled, loading the module again usually
triggers this BUG():

  list_add corruption. next->prev should be prev (ffffffffb5355fd0),
    but was 0000000000000068. (next=ffffffffc0a010d0).
  ------------[ cut here ]------------
  kernel BUG at lib/list_debug.c:29!
  Oops: invalid opcode: 0000 [#1] PREEMPT SMP PTI
  CPU: 1 PID: 4159 Comm: modprobe Not tainted 6.10.11-4+bt2-ao-desktop #1
  RIP: 0010:__list_add_valid_or_report+0x61/0xa0
  ...
    __list_add_valid_or_report+0x61/0xa0
    proto_register+0x299/0x320
    hci_sock_init+0x16/0xc0 [bluetooth]
    bt_init+0x68/0xd0 [bluetooth]
    __pfx_bt_init+0x10/0x10 [bluetooth]
    do_one_initcall+0x80/0x2f0
    do_init_module+0x8b/0x230
    __do_sys_init_module+0x15f/0x190
    do_syscall_64+0x68/0x110
  ...

Cc: stable@vger.kernel.org
Fixes: ccf74f2390d6 ("Bluetooth: Add BTPROTO_ISO socket type")
Signed-off-by: Aaron Thompson <dev@aaront.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/af_bluetooth.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/bluetooth/af_bluetooth.c
+++ b/net/bluetooth/af_bluetooth.c
@@ -830,6 +830,8 @@ cleanup_led:
 
 static void __exit bt_exit(void)
 {
+	iso_exit();
+
 	mgmt_exit();
 
 	sco_exit();


