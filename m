Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D307A15E84;
	Mon, 23 Oct 2023 11:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J9JVhk30"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21C1EC433C7;
	Mon, 23 Oct 2023 11:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060502;
	bh=qRYreFEhas9MVaO43UZDlxbYJQ5YbrazyPjh/RCzrT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J9JVhk30eENY1nB6aDMT6X+Xk/xV8TYNA2COaLm+lUcNAjUltIQ/fmQvVsTuLd2Wq
	 lE6t4n/ML2iDSy1XxKpQGh8tSHyKQQcSxMlg12RJsrnZ3Ks4TVXc02aEqdF9zU4v5K
	 fe5aU03qpurPQfdwTf8Chae5E9N9eb7+oa0fhJck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Edward AD <twuufnxlz@gmail.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	linux-bluetooth@vger.kernel.org,
	netdev@vger.kernel.org,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 6.1 193/196] Bluetooth: hci_sock: Correctly bounds check and pad HCI_MON_NEW_INDEX name
Date: Mon, 23 Oct 2023 12:57:38 +0200
Message-ID: <20231023104833.816029513@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
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

From: Kees Cook <keescook@chromium.org>

commit cb3871b1cd135a6662b732fbc6b3db4afcdb4a64 upstream.

The code pattern of memcpy(dst, src, strlen(src)) is almost always
wrong. In this case it is wrong because it leaves memory uninitialized
if it is less than sizeof(ni->name), and overflows ni->name when longer.

Normally strtomem_pad() could be used here, but since ni->name is a
trailing array in struct hci_mon_new_index, compilers that don't support
-fstrict-flex-arrays=3 can't tell how large this array is via
__builtin_object_size(). Instead, open-code the helper and use sizeof()
since it will work correctly.

Additionally mark ni->name as __nonstring since it appears to not be a
%NUL terminated C string.

Cc: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Cc: Edward AD <twuufnxlz@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Johan Hedberg <johan.hedberg@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: linux-bluetooth@vger.kernel.org
Cc: netdev@vger.kernel.org
Fixes: 18f547f3fc07 ("Bluetooth: hci_sock: fix slab oob read in create_monitor_event")
Link: https://lore.kernel.org/lkml/202310110908.F2639D3276@keescook/
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/bluetooth/hci_mon.h |    2 +-
 net/bluetooth/hci_sock.c        |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/include/net/bluetooth/hci_mon.h
+++ b/include/net/bluetooth/hci_mon.h
@@ -56,7 +56,7 @@ struct hci_mon_new_index {
 	__u8		type;
 	__u8		bus;
 	bdaddr_t	bdaddr;
-	char		name[8];
+	char		name[8] __nonstring;
 } __packed;
 #define HCI_MON_NEW_INDEX_SIZE 16
 
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -439,7 +439,8 @@ static struct sk_buff *create_monitor_ev
 		ni->type = hdev->dev_type;
 		ni->bus = hdev->bus;
 		bacpy(&ni->bdaddr, &hdev->bdaddr);
-		memcpy(ni->name, hdev->name, strlen(hdev->name));
+		memcpy_and_pad(ni->name, sizeof(ni->name), hdev->name,
+			       strnlen(hdev->name, sizeof(ni->name)), '\0');
 
 		opcode = cpu_to_le16(HCI_MON_NEW_INDEX);
 		break;


