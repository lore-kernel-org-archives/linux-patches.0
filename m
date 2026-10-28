Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215425;
	b=P2IX8h4E6VU4bjmb2C3KlH1CqRROX6RrfAruYptLOUoL+CZRXBcOqZD6fCMsdtPW37Uc
	 1YQtnxiZCW8vyEGQBI045qa0GT1lRfUTWi8HTt1C+vbOzWdQLNmmeUEKmfkVgGfutNOWF
	 /wasgfQwc9BtZ4o9lRrhoqRj2SL+TPpBAL4jpVY97UfJ9ab8dviNXNQwi26cf9P9fITKe
	 SLGzkQ1AWpGe94+b00m7oI5wraB+XYfHGOaqcLGmAIP91vo/j4e3i9Nq0zQZRPG1gIj7k
	 YDS7KftxTkj37HGA06smQhVrSOIl2KXcgv6j7LJQRaDJJ+KFEoDxmbjS2HURVHKD0vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215425;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mp+UzGg35QslZoIepi7iwmHd/5ZgtUkKGfoFhcMQ9/Q=;
	b=FGv7KOTkI3SzvtA1RbFZXvn2HfoQGMKiTZQUb55s1QqMW57CPTMo8ZfQN2W32vEYMD+J
	 IRqMIbtsxMVZSGTnhU/GsgUjuhbwwrSahGATaI/vAMeJnS5UKDcMed3GArvQL2O+JSrrz
	 lmOsSDPdf/vViGfpxA9tT/Nf3XbDNLXt7QSEMplokBIr3KapdXqEThNq7SlhfbwZufqlJ
	 IjiNh8YtbRu6qb1tr6zQr8NyASTjLrZVZV0jeGT2AaXqcKxS8wC9aQYHBLwmu1l0lnGbI
	 FU1hgRol9fcPSR/YP6WFJwMR9SVDG8Jn64ukRsoAiBrt7sCmQ0sGXLoEWqm1UsnIOiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jPpSrXEU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B3A606A31D;
	Wed, 28 Oct 2026 19:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jPpSrXEU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596761F01825;
	Wed, 28 Oct 2026 19:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215424;
	bh=Mp+UzGg35QslZoIepi7iwmHd/5ZgtUkKGfoFhcMQ9/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jPpSrXEUW+vEGbcwu55PDS3L4Bb+x9pLuCVntTDrsRJAE+fEvUqSiB5khg9wjivB7
	 pHvddJMqJypBSQsbobqxrJWU/Bz8xFvwtZJBaOGlr9Tnh/02axacj26rMg0uFqi/u5
	 ApKH5KIb92P5j4ToON6B1Guf6FZR031/EFGTw+h4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1206/1887] dm-ioctl: fix a possible overflow in list_version_get_info
Date: Wed, 28 Oct 2026 17:55:02 +0100
Message-ID: <20261028170526.851270912@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 76c6f845dc0c614304a6e6ee619b552f97cf24b3 ]

sizeof(tt->version) is 12 bytes, but the code writes 16 bytes into the
output buffer - info->vers->version[0], info->vers->version[1],
info->vers->version[2] and info->vers->next. This can cause buffer
overflow.

Fix this buffer overflow by replacing "sizeof(tt->version)" with
"sizeof(struct dm_target_versions)".

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4.6
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index de20e26fde291..49b83af62aa57 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -678,7 +678,7 @@ static void list_version_get_info(struct target_type *tt, void *param)
 	struct vers_iter *info = param;
 
 	/* Check space - it might have changed since the first iteration */
-	if ((char *)info->vers + sizeof(tt->version) + strlen(tt->name) + 1 > info->end) {
+	if ((char *)info->vers + sizeof(struct dm_target_versions) + strlen(tt->name) + 1 > info->end) {
 		info->flags = DM_BUFFER_FULL_FLAG;
 		return;
 	}
-- 
2.53.0



