Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625999;
	b=CBB+i4FVXprCn1AcqFp4q9H07U1TKuLj35v6vRVQhNiwgcZA9pH+UuhWgQufvyV/FYjl
	 GIscD96aF5dRK/+z0c7RHp8onMN2nn+Nt5syTlIsHs2IcYbj5L9onbK5FfkOR6Ypqz9cD
	 LhY+q82vaACkXcrATE/CO5LgDnX9QOG/WqmiTQTdFQK11yBTwBfxMsnEzc3uXH6Wp3xnl
	 PAq2xlmpw6QDrTq7IF+Cjqgl4X+2Ul5ZVQvKFU5NB1dkey71JfmM6MGisf0WhYqjIheE3
	 AhkDxiucgKBUHbYZOOS4vzLDR+IfXF7QdpNTPM4mZP1k4cqcZy9zy4YPUcuoWKyI5Mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625999;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gfq/6Zu0GnwoBwtHPAnWq0F+u5kTM3vez10bf2bZwpU=;
	b=CQjmxb/IhdpLaHgXD4GJT3q/7sUyLbp/6frp98iXB4hWlwsgKTZeFP4g/rA+Vta8by3D
	 wmIWCXkQJEsU2kNBt5GkjBmlFA51ZBWe6HQwFMCvj9idEhydfG/xtrVlAdgzOxfvSWYYo
	 CUFa9HzQmYlUdraGD/XFjvqfcJiPz6T0sV9hmHmLQ8iWoa4EW2S6gz1xod/D+UeGB9Sz8
	 eRoCWWs28SMXcLGZUxYWIzQe0TfskSFRI6az0Ou1CLFomGtGasG0nL1Ml0VJd0HiIbZwE
	 jWWgerw2PJHK7YfyQZBDzb7FSxpk8GrLc4/rwN4lsKS9bDe0XRA/dhal89Epbb0gJig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dt20ojvI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721AF606A31E;
	Wed, 25 Nov 2026 16:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dt20ojvI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B7811F000CA;
	Wed, 25 Nov 2026 16:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625998;
	bh=Gfq/6Zu0GnwoBwtHPAnWq0F+u5kTM3vez10bf2bZwpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dt20ojvIxjp9HCKSSnkU6EAoFanvOANzUYcaepzbvgCI4r7RFD1tjxmJd/rf+IhDz
	 itjgbloQgEStmnaIgv2vVit8hIjsjuJpZQKj+HeEMDDQTyxwK1yLDWxBU4aFomx04E
	 dorz9GDUGyt7k9cAW/lA2Ac+uIthxaFWecYrn8ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shao Mingyin <shao.mingyin@zte.com.cn>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 696/816] dm mpath: fix buffer overflow in parse_hw_handler()
Date: Wed, 25 Nov 2026 15:37:24 +0100
Message-ID: <20261125143905.292849399@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: shao.mingyin@zte.com.cn <shao.mingyin@zte.com.cn>

commit 8f611fe94a781c6fb658488cc7eab4e4923e6df6 upstream.

parse_hw_handler() builds the hw_handler parameter string in a buffer
sized with

	len = 4;

plus one byte per argument.  Those four bytes were meant for the decimal
form of the parameter count, three digits plus the terminating NUL.
dm_read_arg_group() accepts up to 1024 arguments and the count written is
'hw_argc - 1', so a count of 1000 or more needs four digits plus the NUL
and sprintf() writes one byte past the allocation.

Size the buffer from the actual string length instead.

Fixes: 2bfd2e1337f0 ("[SCSI] scsi_dh: Use scsi_dh_set_params() in multipath.")
Cc: stable@vger.kernel.org
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-mpath.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1082,8 +1082,9 @@ static int parse_hw_handler(struct dm_ar
 
 	if (hw_argc > 1) {
 		char *p;
-		int i, j, len = 4;
+		int i, j, len;
 
+		len = snprintf(NULL, 0, "%d", hw_argc - 1) + 1;
 		for (i = 0; i <= hw_argc - 2; i++)
 			len += strlen(as->argv[i]) + 1;
 		p = m->hw_handler_params = kzalloc(len, GFP_KERNEL);


