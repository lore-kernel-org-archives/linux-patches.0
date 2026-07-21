Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE80D4028D6;
	Tue, 21 Jul 2026 17:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654466; cv=none; b=Pd98SgKtR84uRe5LC8qMkX8OREJ6+5x1HGuEfP/KY0KeP0Ps3+0o2cf7pibghRAMUh52P/OSUJwQcrVsa+zHSwn5UELCeRrmx9UV4FCcS3u6M3QWkvZu4Y08cYnKMVXyZUciz9KawHz8ndeuhhh9HLjtMZeyNwY9bGv5h1i/9fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654466; c=relaxed/simple;
	bh=ziPhOYmPlEMaxQXK0fqsakvNGWPt/+O47j4IRRq57o8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y8wAIMlANB1Ffvwd+zfvESAI4W76fkS7YebaJg6UBY7Swljo4wOTJO5Jzx7ZMJV0DeEKz7ZHdyy9cWYWLf6brjaShHUy3BwSQrG9M9hkivYDxQHl2vMvIQmKq6CID/ckz4sdDeXRr9WwP3EEG8nqFRthnpmLyZFKQHUt+SW2sFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L6ufdtxx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L6ufdtxx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224421F000E9;
	Tue, 21 Jul 2026 17:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654465;
	bh=zlkKY2BbA0LgZW9kJnE/1VttGb0mBH4j4VCUC68MKdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L6ufdtxx71lJCKRbEZG97Kh49Hsv/IpbGLqznybSOiJA2s01gw1WndJCXIlgu2gtH
	 D13wb2fNO7pBncgyYh/+GJmmsgJyR/HpkqPeATZJWSstyQerKxBgmuV4br2l8BEYcQ
	 hDONHC4PRR61Tx+o82aZCbRHHKl3C4P5uCmVRAss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.1 1716/2077] ntfs: make system files immutable to prevent corruption
Date: Tue, 21 Jul 2026 17:23:09 +0200
Message-ID: <20260721152633.230374302@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit f72df3a4c33b64de3418ec74d1ad4f028e09d161 upstream.

When a system file such as $Bitmap is exposed via show_sys_files and
written from userspace, the volume is corrupted and, because the cluster
allocator scans $Bitmap through the same inode's page cache, a write to
$Bitmap also deadlocks writeback against the folio it already holds locked.

These files are maintained by the driver itself and have no valid reason
to be written through the file interface. Mark base metadata files
(mft_no < FILE_first_user) as immutable during inode read so the VFS
rejects write, mmap, truncate and unlink with -EPERM. Directories are
skipped so the root and $Extend remain usable. Internal metadata updates
do not go through the VFS write path and are unaffected.

Fixes: af0db57d4293 ("ntfs: update inode operations")
Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/inode.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -1184,6 +1184,15 @@ no_data_attr_special_case:
 		vi->i_flags |= S_IMMUTABLE;
 
 	/*
+	 * System files such as $Bitmap and $MFT are maintained by the driver
+	 * itself, and writing them from userspace corrupts the volume.
+	 * Always make them immutable regardless of the sys_immutable option.
+	 * Directories are skipped so the root and $Extend stay usable.
+	 */
+	if (ni->mft_no < FILE_first_user && S_ISREG(vi->i_mode))
+		vi->i_flags |= S_IMMUTABLE;
+
+	/*
 	 * The number of 512-byte blocks used on disk (for stat). This is in so
 	 * far inaccurate as it doesn't account for any named streams or other
 	 * special non-resident attributes, but that is how Windows works, too,


