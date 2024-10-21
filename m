Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002D419753F;
	Mon, 21 Oct 2024 10:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506708; cv=none; b=QKG1CTZKUgaSa/baP/4NQetPjHGETVMM6QbxsGIkwTGlsnZGlSszNazMmSOVYsKwZblwUMfUsCX8PbS4P0Mu8ylr2E8sVCQqVE1cgv4u6WDljm+IoLLvDqOGY9Q228DcZkA1lwf2Sn8Bmg0RSOn56m6a/2ZsbpSocQ0ol8zBoH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506708; c=relaxed/simple;
	bh=zNsNjFIkN0dM4urVZchnRqQvawliePMest48aDYTzj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hd4SIHFd/c8VgCaNKL4RpM61RcS9YzAahIUd639wDrBTzXRiCEFITZewL0dxotZcU4kTJLtGIIcI7PUUJjn5ImRpCdH4VmzuGvL9flsyn/THaUXDK0Kz9eEUlZKAbXhN74M2RabcqYINSxHeTcgfspwXSO3k2K8X0Bbo80F0OyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f6HiXHXg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f6HiXHXg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4A4C4CEC3;
	Mon, 21 Oct 2024 10:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506707;
	bh=zNsNjFIkN0dM4urVZchnRqQvawliePMest48aDYTzj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f6HiXHXgmmde7PCDw1iVDTwR+D4gKAenOGZ5kgYmBcDshE2t+OqsqAvfBhhlKw4+C
	 upZCZErrSSPj9eIHaF+Bg+kdR8mk07xaQ9ldVfO/f9S1p+z6gJ10c020rXCaxfSI+G
	 GbO6EavN2oZOSkpj3fuF3vcj8WF2FSFj6lUmHRXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Thompson <dev@aaront.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.11 094/135] Bluetooth: Call iso_exit() on module unload
Date: Mon, 21 Oct 2024 12:24:10 +0200
Message-ID: <20241021102303.002958435@linuxfoundation.org>
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


