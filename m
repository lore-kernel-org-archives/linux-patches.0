Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033334;
	b=aCp6SXEJ8TWgxS0sTeOro63BICCV3tgoMF2PXlRWE/qXnUBZV8quMGgfpoLhTAo3mPyt
	 oT1Xpo62NBtmkCgnzw2p85h1uqKMuPxyDfFjDvtUr80dEdSnAwyNfkr4MsUz7G+6yOyJP
	 j+cdnF0ME6/yLjrqpJHzi+iuMs26pYMnoXbob/TjAcTLQewOKqKxJqtfUsKPeEqSpABDG
	 XmUjf3a19zwdYItNTHgfcTSjI/PnzIeoFbVQQpu34XXEWD5APd2+aWsEDxup353ZlQFo5
	 sGztspZKrkDBSbcws4KzM5BnMpYpVATG+EaGafdBgaLEqR5KRXYnNLbtsDjgRRU2aow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033334;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kn0infRIr9zCQgQh7pZtpTxMhkEgVA+K+xW5QZBySzc=;
	b=Hy5HtN3Bn2FdAVkb4VV3LPxtXQLnZNWwEgMo98S5N6lgqHBVWreTs8bbX9WZPPD+yQMn
	 jf8QqxpPX5JdoobIclPZwAq8ZarpP1h0D4eslV9rDl2bn9n30RCGpXKwyuyAI1nFN/M+A
	 dZgQU76HADSflzCWCeDVroVxDa5GV3UikP67jGOcXLEMDXP2bBRlz0EfsDMzQZHsIUeF/
	 HaMNBUU4mJlm8nUTbvwfGHlWzxGPZPSQHXMQZbETIH/jXJ2Fjec4hSlt2JGviHD8jTiq0
	 l+WdaKx2XF97Mr1Dj+GFn4MoxLkNhsrWytL8djfO+52IeRGDeQz00c6Ii0uQD6bbl5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qn+ek5Eo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6E9606A31C;
	Wed, 18 Nov 2026 20:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qn+ek5Eo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319FC1F000C4;
	Wed, 18 Nov 2026 20:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033334;
	bh=kn0infRIr9zCQgQh7pZtpTxMhkEgVA+K+xW5QZBySzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qn+ek5Eo0SAEl7bhqqPV7689CjidcQMR20n/63HjgQFthN1XmjGX1CvTQO5JNoAET
	 GDOBjh76EDt1fP5W4P6EWbKOiXT9364R53vb4RgPZSKvtNl33iP1/cnM2WOc5DV88+
	 09JIe79lfoY5tN+kE++2HEmU6b/oLJ+WASXM8K9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5af33dd272b913b65880@syzkaller.appspotmail.com,
	Szymon Wilczek <swilczek.lx@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.12 1730/1756] fs/ntfs3: fix deadlock in ni_read_folio_cmpr
Date: Wed, 18 Nov 2026 16:04:17 +0100
Message-ID: <20261118150118.454844498@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Szymon Wilczek <swilczek.lx@gmail.com>

commit e37a75bb866c29da954b51d0dd7670406246d9ee upstream.

Syzbot reported a task hung in ni_readpage_cmpr (now ni_read_folio_cmpr).
This is caused by a lock inversion deadlock involving the inode mutex
(ni_lock) and page locks.

Scenario:
1. Task A enters ntfs_read_folio() for page X. It acquires ni_lock.
2. Task A calls ni_read_folio_cmpr(), which attempts to lock all pages in
   the compressed frame (including page Y).
3. Concurrently, Task B (e.g., via readahead) has locked page Y and
   calls ntfs_read_folio().
4. Task B waits for ni_lock (held by A).
5. Task A waits for page Y lock (held by B).
   -> DEADLOCK.

The fix is to restructure locking: do not take ni_lock in ntfs_read_folio().
Instead, acquire ni_lock inside ni_read_folio_cmpr() ONLY AFTER all required
page locks for the frame have been successfully acquired. This restores the
correct lock ordering (Page Lock -> ni_lock) consistent with VFS.

Reported-by: syzbot+5af33dd272b913b65880@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5af33dd272b913b65880
Fixes: f35590ee26f5 ("fs/ntfs3: remove ntfs_bio_pages and use page cache for compressed I/O")
Signed-off-by: Szymon Wilczek <swilczek.lx@gmail.com>
[almaz.alexandrovich@paragon-software.com: ni_readpage_cmpr was renamed to ni_read_folio_cmpr]
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/frecord.c |    2 ++
 fs/ntfs3/inode.c   |    3 +--
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -2176,7 +2176,9 @@ int ni_read_folio_cmpr(struct ntfs_inode
 		pages[i] = pg;
 	}
 
+	ni_lock(ni);
 	err = ni_read_frame(ni, frame_vbo, pages, pages_per_frame, 0);
+	ni_unlock(ni);
 
 out1:
 	for (i = 0; i < pages_per_frame; i++) {
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -756,9 +756,8 @@ static int ntfs_read_folio(struct file *
 	}
 
 	if (is_compressed(ni)) {
-		ni_lock(ni);
+		/* ni_lock is taken inside ni_read_folio_cmpr after page locks */
 		err = ni_read_folio_cmpr(ni, folio);
-		ni_unlock(ni);
 		return err;
 	}
 


