Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDBF1953B9;
	Mon, 21 Oct 2024 10:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507409; cv=none; b=DDtS4dNTcLhPm4p+eF0VNqzNJwj37IuZ2h1A8km/iVVO1oZHEqdDlVTEcoF17e34EHCRtKCIIDNZkEmmu9p72XE8igQ/KgkglLJJWimKObBQwNcjKO2TB+wmEc7MObxQkjUpvqyKa8yWXnPdJ9F2CX7X1sHm8+OBnpZo6D29YHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507409; c=relaxed/simple;
	bh=SFIXoqeZ94CkRiR+LUlFUbV2LoOftb1p7tNpfTiVdw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qzvN3TYrmNY4yKVEHWnFJgGXt5WjzGuocKdazSEGVppaBEIQdXPWunEFFXVPmj5ut3Q8QJ9wqFz/8+veQdgwqCbUtTeZa6g5znVe2dxjdGmkiNX9BLhwzpveQgohFp2zIWW6ZKidsMHNduZJQjR57k6heCRbS3yjWn+2TEa8kMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2mmhsBti; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2mmhsBti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B0F1C4CEC3;
	Mon, 21 Oct 2024 10:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507409;
	bh=SFIXoqeZ94CkRiR+LUlFUbV2LoOftb1p7tNpfTiVdw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2mmhsBtidOO2xbl/zDmyEZP+8QHUvU96WcJAG9mckmWeIqeaZGqpbIAX54ESwEd76
	 uH+zhAAFwgMS5aizkgSYhP4lOFzcoJuSXIk2RPDJH8tKkel5jxrdyu96k6W65UXuoV
	 rnKxkIz4qFI1Q+S5FcAJUpeDJ8wEs0tDlcoP3rWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Thompson <dev@aaront.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 68/91] Bluetooth: Call iso_exit() on module unload
Date: Mon, 21 Oct 2024 12:25:22 +0200
Message-ID: <20241021102252.475171553@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
References: <20241021102249.791942892@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -802,6 +802,8 @@ cleanup_led:
 
 static void __exit bt_exit(void)
 {
+	iso_exit();
+
 	mgmt_exit();
 
 	sco_exit();


