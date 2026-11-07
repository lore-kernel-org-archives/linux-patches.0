Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063273;
	b=3Lg+s+8Zh164+d8yar8KO5Mq+8CBX9xCInroabGOeZAr1uCZ1BvkM5dEIXHzmWc47FKo
	 vzDBRdZgm8sa31jA5Y4B9/eR61UWigq8eDD0u8E+nWHaupmicxqoHRGpZzv25x5NaI8aE
	 week6I9kXxr7iznImLcAzu+QT1TppZ7ZxKqHO8rE7/EFLS3N60LdA+Fxhhk+DcrsnCNfr
	 GduSQQW0uEytRHXEozpZIuV+u5cNfBuMfUADEu+64+0N8adFZGwBQqQ8aM6XdXFGGI9Yy
	 BOk0BWoEl6RU5+2yXiv87yq2jP7+X0OklzHCe8gZG7n9E6y6bduNeKTLejen6qXmEaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063273;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S8aG3ZYiqzcNq2dXwGo4v1kqYpPSKkuECG8QkhmCO0w=;
	b=wPwAptgpPwMHUQtrtq4mJqFcE/bYUfntpfqg2a49ZIibmT9Vmiq3EEzPTa92N/vgs5j7
	 he605mMMeYc9OTdowWv/nGhpsQjz+OrP64Y69lwIVpnN/WS0EI0HurIL4k238zjgAm6uH
	 FjHFs3UH64MB6nFtSB6HEH9m7zqHkOoHReO0clq6ZViB5jmNcOgzPr1GXeL3eEN9LtQeO
	 u/b8h/QRNcMXmFSoJeK8GcQ8jb1Qwz5QLD45ypKXRFmzF8QHGIvImdDg1Xuz1MmZK8uDy
	 S8y5sipRLftiURxb5EPyuWNnmgeld7NKPwh0HkYygzmgJvAc+qRziw8wD4JxSTnjC6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ECqUebn6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4292606A330;
	Sat,  7 Nov 2026 14:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ECqUebn6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD951F0089F;
	Sat,  7 Nov 2026 14:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063272;
	bh=S8aG3ZYiqzcNq2dXwGo4v1kqYpPSKkuECG8QkhmCO0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ECqUebn6mIljpSP284jGnF82L4a8l4TEQbZu2O9+3JMSY0nHkjNVrsaLuv+tB6h+0
	 7lhcvURk6S5/BYIGFUkczLvUbvJw5QZSWit/VkKejorv945RTo2BRqPikQ/dcTb90f
	 /BiY/EPA4Y4CHwix7bqJtXsTqbHrSPVFSfU8lRUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 469/869] dm-snapshot: fix crash if dm_io_client_create fails
Date: Sat,  7 Nov 2026 08:52:31 -0500
Message-ID: <20261107134909.541354548@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 829c4d21148a205eca864429e06530319e1f92d5 ]

If dm_io_client_create() fails, it stores error into the ps->io_client
variable. The code would try to free it later with
dm_io_client_destroy(ps->io_client), causing an invalid pointer
dereference. Fix this by setting ps->io_client = NULL.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-snap-persistent.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index 0dc429eb26924..989f958c229bc 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -325,8 +325,11 @@ static int read_header(struct pstore *ps, int *new_snapshot)
 	}
 
 	ps->io_client = dm_io_client_create();
-	if (IS_ERR(ps->io_client))
-		return PTR_ERR(ps->io_client);
+	if (IS_ERR(ps->io_client)) {
+		r = PTR_ERR(ps->io_client);
+		ps->io_client = NULL;
+		return r;
+	}
 
 	r = alloc_area(ps);
 	if (r)
-- 
2.53.0



