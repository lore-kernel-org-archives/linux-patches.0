Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585996;
	b=f0/MDDuf8MVbxbznq6VryjF0tfxe4wqqPcBiHe1oTTr3pBwFrDf9pxyPTBY+XS2LBNBX
	 ZYPHdFUVOo/TiiiSI/dk6p2KEiR13f656IHh25TaFO0XpPZnOw97dFxxoROYEerE0mvWO
	 MQd1fgjI1/0yQmuQE4+75vxmQzcXBjGTvpjP3bt8j+FdMWf84GsXNYG/XR0muOc4h7pqn
	 whcahJcEoNpkrezdwwoxeCSURcdnzNKd1aCRo63RboR6BvJwOFve1mDi1aL17Lpq9giw9
	 cC7RVY3YmCOqnKttwv4C7CjKuiuwF3tz+g+AYmNfbXaxEaLuNwB7mMAfg3UjX7fgi2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585996;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9qCw4EaQJHt4A/Z2dfv0IKlvRt/J7M9es9BZBrJeiH4=;
	b=tMFYC47ca2+juxkW4Cf6W75vLLND+U0ujc1OSQWSuW4kzkwDhBZqjH/9WP7KtMo9dZiE
	 rqptH1hAJtZJXql/sIEdDtQKjjaneYxCnTIm4ndzE1A9cmPtFGNz/d1N4aRaX6tetkZmt
	 NHYy28fTTEPQfjc40GO2sE9woFIYFdVsdN4ZRQDPrsJwGhREHa+N0PzEMDSvMcj6/PkgJ
	 OdRXfPjafQEszO+QYp3M5TV5XDpjjERYRPsVEzEJBzjWx9IxQ1pWOU3iXl1yOQ4iwOibo
	 Exy0YOWB6jCqx+FgVZ/tih0S+s096SxFpt1PVfezKy/Z+pSctHG+oLg4CvyU8BURS6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bl2nHPQJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47974606B2C3;
	Fri, 13 Nov 2026 16:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bl2nHPQJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 965091F000C6;
	Fri, 13 Nov 2026 16:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585995;
	bh=9qCw4EaQJHt4A/Z2dfv0IKlvRt/J7M9es9BZBrJeiH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bl2nHPQJuYaHQjHTcnm1oPJVssfRsL33qCQzUWAVuBuhhJCUieoBfHaPQtj/IgmZU
	 kNGliorywU8736Im6TYVUjSS3in6P518X27iFoRBMSMggJLkVrYJ3TZnH0k93/5lCT
	 qn+4+VOdFr9D02u8hLkHXHjtxrYoDtPA4v1il3Xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Huth <thuth@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 011/686] smb: client: Avoid leaking sensitive data to the heap in connect.c
Date: Fri, 13 Nov 2026 10:42:24 -0500
Message-ID: <20261113153821.306013373@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Thomas Huth <thuth@redhat.com>

[ Upstream commit 111a2b8717efbd9729d36828308d5163fdc977c3 ]

TCP_Server_Info contains a preauth_sha_hash[] and a cryptkey[] array
that might contain sensitive data. Thus free its memory with
kfree_sensitive() to avoid that we are leaking this information to
the heap.

Signed-off-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Stable-dep-of: 482c117c6dbe ("smb: client: hold server info until cifsd exits")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/connect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 2cbbbf0c93b80..fa7c2f70b6ed3 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1147,7 +1147,7 @@ clean_demultiplex_info(struct TCP_Server_Info *server)
 	put_net(cifs_net_ns(server));
 	kfree(server->leaf_fullpath);
 	kfree(server->hostname);
-	kfree(server);
+	kfree_sensitive(server);
 
 	length = atomic_dec_return(&tcpSesAllocCount);
 	if (length > 0)
-- 
2.53.0



