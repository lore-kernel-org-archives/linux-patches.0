Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214167;
	b=WFIN7SWFUiMPY1oy1I+/gyADcYNtrEKCFaWOeiQzhFGBnaSgWdF0oSyh143hF5kiNJJe
	 1OvKmhYVrNsolZpKdwrnAdin8BVpKYWGbj97yKKGKotg2jd8TcbwByhrUJTFU5ynuRXuO
	 XYAkjN3Xga4gYkZubs7JmxC9eKTlOA9ZgQRYdzrXA1PR7eMxFUvcGWyiiqP0Hp02UA/Y7
	 axbq1a1RnX73l1xzKrTFp84k25BoU/xJbkI6vm/6/Xdw7d9sqd0lZf+0LuBSOsgbW/R7p
	 ZvsP9OWM/n+EFIGyTbzE8BGph8Kq9vvkMxCPjpnDV8wDtGvWVW7B1vbu/AGNtjTtLug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214167;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Tk6fjlgFunS3oi2SG3rZq7Sf9NSd0as0ZS/aFRgLEQY=;
	b=19FerMeF9cPOCQVH40fsGi6gSywxTfnyyjffFMW80F/GlM6TZYNQO2BynaEYUmYuDXiW
	 XxFnll2hGxaKiVd2sIGXz7+LuxC5jt24RzMy3pFB+Tx8C6XqacvqSVeTY2uQ7DDZx1Gd5
	 L2rh4g3Hx8OopFamXh249XrE21vbIfq/x4rn2+McfwqrfrWULRpo6sgryKZJahhohjFKJ
	 3kT9qROj64qjvj5t0RY/iJY0YfXtho/EQIOKJmpwcbnK1xDQc5pxjl/P0TX4DiqDZaSkx
	 KzA+WuOiw6PG8PfbC8tGjujsrqvMl8HXW5CIpb+SR6k6JkA2Yvs/DHdEtd9UK1x+zKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="TLaxx9/S";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD06606A323;
	Wed, 28 Oct 2026 19:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TLaxx9/S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11501F01825;
	Wed, 28 Oct 2026 19:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214167;
	bh=Tk6fjlgFunS3oi2SG3rZq7Sf9NSd0as0ZS/aFRgLEQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TLaxx9/Sd8TEVxEDS1NrE1Ln+b8r9ofkGj+Xr/oSSm5sS8fcYrXUku10E6tou21wD
	 uKWYSNdAMJOBQjP8hm4nmAuwlbz3s2JNcrjALg6zEQmYX2ah6qhh7rdAfqd2kDdJgr
	 keTFwt18DtaQp3JCjAVBjp6ITdk+XBWyjb5lS5sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Aurich <paul@darkrain42.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0720/1887] smb: Initialize cfid->tcon before performing network ops
Date: Wed, 28 Oct 2026 17:46:56 +0100
Message-ID: <20261028170515.823626721@linuxfoundation.org>
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

From: Paul Aurich <paul@darkrain42.org>

[ Upstream commit c353ee4fb119a2582d0e011f66a76a38f5cf984d ]

Avoid leaking a tcon ref when a lease break races with opening the
cached directory. Processing the leak break might take a reference to
the tcon in cached_dir_lease_break() and then fail to release the ref in
cached_dir_offload_close, since cfid->tcon is still NULL.

Fixes: ebe98f1447bb ("cifs: enable caching of directories for which a lease is held")
Signed-off-by: Paul Aurich <paul@darkrain42.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cached_dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 194cf24f52df9..baca533953fd1 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -211,6 +211,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		}
 	}
 	cfid->dentry = dentry;
+	cfid->tcon = tcon;
 
 	/*
 	 * We do not hold the lock for the open because in case
@@ -284,7 +285,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		}
 		goto oshr_free;
 	}
-	cfid->tcon = tcon;
 	cfid->is_open = true;
 
 	spin_lock(&cfids->cfid_list_lock);
-- 
2.53.0



