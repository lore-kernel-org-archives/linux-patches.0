Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8693A340A59
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301128; cv=none; b=JvVekRwMmaNBQE5GXK0ui0tWsCpiMX6hvuq1ip9Z8cdLN2W21sEKXVV+fv+0WgYYNTvrzXEQX8XNNeWDtHX0T7n5jnZMAs+iQIy7ID2Ccxyv07nm7uqzVuEw7OQsYWe06UZiD0nSltavFwu0MdFgIJGN1rgdGGXIKSV4db/ddQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301128; c=relaxed/simple;
	bh=cpgrSgAkJnKPCIz0KN2av2PGQbA/IqX1Sa5PRbhWHEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JaU8dn3bELoLlDxQ2/PXUmiJ9L/+9L4Dco2mOZQ+uNA+0g6/LioZeX0vuHfyNfc2xw/fibquQva6NoUwDqk0MOJvPcYVzH5j8b6QKcFkuBh20qtjhlnUDfZ8o+/EqImOu1XKi5ptbPCkfo70iWZqktIczokMP2f4MjAZSutHQY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h3hSmP+V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h3hSmP+V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A830BC116D0;
	Sat, 28 Feb 2026 17:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301128;
	bh=cpgrSgAkJnKPCIz0KN2av2PGQbA/IqX1Sa5PRbhWHEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h3hSmP+VKr9Bd1fw8rD09Niv4oXHSBymS9HXxxDZKHXf4c0Y33c0F8cXbztYt/kJV
	 sOqyQjKXr5AqXg2L9OqotCjoyXdTvsc+52JmcfWx5QQV4PZ1L02SLyvoqehHAmzDSG
	 sXo2V+u1NZEdhFvimKy9nQSQlBUyx9in4gDUfoGHYD5C/HgVWvjtQr/DqNKPQWsuhu
	 gTbn3PMtyKolU6naEbpWrnGyqcDQwjqwsHX0DbF6mkO9lnRT5KfiXtl6rQUqHVEuh8
	 T1OVxi4rM+aXdVa82eoEpDjd4ZHvsoHdtvviha5X1bOPOWroKBkAhq45QzPd3vjyNf
	 lKJDKS8pxsq5g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Arnd Bergmann <arnd@arndb.de>,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Bryan Tan <bryan-bt.tan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 287/752] vmw_vsock: bypass false-positive Wnonnull warning with gcc-16
Date: Sat, 28 Feb 2026 12:39:58 -0500
Message-ID: <20260228174750.1542406-287-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit e25dbf561e03c0c5e36228e3b8b784392819ce85 ]

The gcc-16.0.1 snapshot produces a false-positive warning that turns
into a build failure with CONFIG_WERROR:

In file included from arch/x86/include/asm/string.h:6,
                 from net/vmw_vsock/vmci_transport.c:10:
In function 'vmci_transport_packet_init',
    inlined from '__vmci_transport_send_control_pkt.constprop' at net/vmw_vsock/vmci_transport.c:198:2:
arch/x86/include/asm/string_32.h:150:25: error: argument 2 null where non-null expected because argument 3 is nonzero [-Werror=nonnull]
  150 | #define memcpy(t, f, n) __builtin_memcpy(t, f, n)
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
net/vmw_vsock/vmci_transport.c:164:17: note: in expansion of macro 'memcpy'
  164 |                 memcpy(&pkt->u.wait, wait, sizeof(pkt->u.wait));
      |                 ^~~~~~
arch/x86/include/asm/string_32.h:150:25: note: in a call to built-in function '__builtin_memcpy'
net/vmw_vsock/vmci_transport.c:164:17: note: in expansion of macro 'memcpy'
  164 |                 memcpy(&pkt->u.wait, wait, sizeof(pkt->u.wait));
      |                 ^~~~~~

This seems relatively harmless, and it so far the only instance of this
warning I have found. The __vmci_transport_send_control_pkt function
is called either with wait=NULL or with one of the type values that
pass 'wait' into memcpy() here, but not from the same caller.

Replacing the memcpy with a struct assignment is otherwise the same
but avoids the warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Bobby Eshleman <bobbyeshleman@meta.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Bryan Tan <bryan-bt.tan@broadcom.com>
Link: https://patch.msgid.link/20260203163406.2636463-1-arnd@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/vmci_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index 7eccd6708d664..aca3132689cf1 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -161,7 +161,7 @@ vmci_transport_packet_init(struct vmci_transport_packet *pkt,
 
 	case VMCI_TRANSPORT_PACKET_TYPE_WAITING_READ:
 	case VMCI_TRANSPORT_PACKET_TYPE_WAITING_WRITE:
-		memcpy(&pkt->u.wait, wait, sizeof(pkt->u.wait));
+		pkt->u.wait = *wait;
 		break;
 
 	case VMCI_TRANSPORT_PACKET_TYPE_REQUEST2:
-- 
2.51.0

