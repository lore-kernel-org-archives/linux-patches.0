Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71F3125CA
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OPYPrsxp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42DC9C433C9;
	Mon, 23 Oct 2023 11:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698058800;
	bh=g+p0N/mB5vGwS3HoWNKpxuaiAheCuDfLdkpcLsYOyE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OPYPrsxpzS4nxU7IrtNOXPwsIr4Hal5KDBBKL848N41azdYdIpkwYFUr8jCBksrpf
	 jRip608qVbYdnLN+UuIDcpF/rWL5YMUJpA7n3TBGj+2n4q/CqyxSpN+xlOF72y6HhU
	 vjoH5gwp22ynv28iWmDlLSjCZgJgg17TEcKm48Dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <keescook@chromium.org>,
	"Lee, Chun-Yi" <jlee@suse.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4.14 31/66] Bluetooth: avoid memcmp() out of bounds warning
Date: Mon, 23 Oct 2023 12:56:21 +0200
Message-ID: <20231023104811.985680811@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104810.781270702@linuxfoundation.org>
References: <20231023104810.781270702@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit 9d1a3c74746428102d55371fbf74b484733937d9 upstream.

bacmp() is a wrapper around memcpy(), which contain compile-time
checks for buffer overflow. Since the hci_conn_request_evt() also calls
bt_dev_dbg() with an implicit NULL pointer check, the compiler is now
aware of a case where 'hdev' is NULL and treats this as meaning that
zero bytes are available:

In file included from net/bluetooth/hci_event.c:32:
In function 'bacmp',
    inlined from 'hci_conn_request_evt' at net/bluetooth/hci_event.c:3276:7:
include/net/bluetooth/bluetooth.h:364:16: error: 'memcmp' specified bound 6 exceeds source size 0 [-Werror=stringop-overread]
  364 |         return memcmp(ba1, ba2, sizeof(bdaddr_t));
      |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Add another NULL pointer check before the bacmp() to ensure the compiler
understands the code flow enough to not warn about it.  Since the patch
that introduced the warning is marked for stable backports, this one
should also go that way to avoid introducing build regressions.

Fixes: 1ffc6f8cc332 ("Bluetooth: Reject connection with the device which has same BD_ADDR")
Cc: Kees Cook <keescook@chromium.org>
Cc: "Lee, Chun-Yi" <jlee@suse.com>
Cc: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: stable@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_event.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2250,7 +2250,7 @@ static void hci_conn_request_evt(struct
 	/* Reject incoming connection from device with same BD ADDR against
 	 * CVE-2020-26555
 	 */
-	if (!bacmp(&hdev->bdaddr, &ev->bdaddr)) {
+	if (hdev && !bacmp(&hdev->bdaddr, &ev->bdaddr)) {
 		bt_dev_dbg(hdev, "Reject connection with same BD_ADDR %pMR\n",
 			   &ev->bdaddr);
 		hci_reject_conn(hdev, &ev->bdaddr);


