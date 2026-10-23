Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774995;
	b=3weQsJQkbCJfZb3S4gz2HZ2g+x7KqC1vaKVlkkPFEQktytkYIrCL+fejxWpgAG0tajaE
	 sm7Z5xlYVEq9IRBmvJRlue8FNqg+kP5MG3xsifdMdD9wbUPRWZjWhH2BYSkdtHMlJhMjL
	 HNYJ3oqfTFGdAay1JYVWlskZSbk8wtxFKC+rMGY+Hgsldl8lmIqac7hF8Or2mg+EaFKAG
	 CsXCfkhBB91t1H25P3ON6Ge72Fke7yCXAgVdKkcDhcC2YxOg0/ADZU62q3UoRaJcD9z7J
	 cvquziPxd/01/GkVS14swAQP3bMn5XPEElaHu3jvKZm2GfHocKhPa3RMYzkKIo7T1kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774995;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Pu5zSZdttZJSgXmUMy0vkx+5EJ3fEPN5qXydSYm2lbg=;
	b=Op9g8R9g+ti41J4T2urhwrZCjfdLvxc/KcywhW/i7GKAW6+42qJnniUbt7iak62A8CYS
	 p6krTi4KG+gmppUzLAJw7rVsX8dJtrflTlIrPFaJrsn65r2jGbGiFaSVu9LWEVfHbCyxd
	 ucmRKvUVLSqmL9hDXBssJO6zNc7k3aG4jzPqYfD4Qgj9wnP6dqgrv5lMp+KDmzJUxOAcg
	 lNXab0t7soenouUcgV18WArXvnkpM2MQPz3aeM364F1xBHJ9J9ZwfD+vFA4lbAx2xFWEf
	 Xva0HdJxZWTEw3Wbx4Wzd3iFP0/DDUOatmO6ta1xYl2lFuMJUc0hZBjO+9/Twy+uGpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n8SzfGu7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71862606A31B;
	Fri, 23 Oct 2026 17:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n8SzfGu7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596881F01825;
	Fri, 23 Oct 2026 17:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774995;
	bh=Pu5zSZdttZJSgXmUMy0vkx+5EJ3fEPN5qXydSYm2lbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n8SzfGu7FgXH5C9Jm9Klb4Ly05meHc5jxVdzUknuxAXHeT6HqMYaxK9TrIMkrGFDe
	 O04crcQLpsOu1Ysl8upxTzW1wJiQQ5bsSz3q3BpWi5BBSDjUgiaGdI8O75EasTU4uj
	 6IVi4yguNjSIPoft3onamqhEVhj9PUx42OMIPADg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Baolin Liu <liubaolin@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.2 227/242] ntfs: fix undefined behavior in mft/index record size calculation
Date: Fri, 23 Oct 2026 18:41:09 +0200
Message-ID: <20261023163719.210331003@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongling Zeng <zenghongling@kylinos.cn>

commit a79899ca38af4ce5518a59a22f0eb1f59f7e6089 upstream.

The boot sector validation allows clusters_per_mft_record and
clusters_per_index_record to range from 0xE1 (-31) to 0xF7 (-9) when
interpreted as signed values. When these are used as negative shift
counts in expressions like `1 << -clusters_per_mft_record`, values
like 0xE1 cause `1 << 31`, which shifts into the sign bit of a 32-bit
signed integer, resulting in undefined behavior.

Fix by using unsigned shift (1U << ...) instead of signed shift.
This prevents undefined behavior while preserving the full valid
range of negative values (-31 to -9) that may appear in NTFS boot
sectors.

The encoding scheme uses negative values to represent record sizes
smaller than cluster_size: -log2(record_size). Common values include
-10 (1024 bytes) for mft_record_size and -12 (4096 bytes) for
index_record_size.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Reviewed-by: Baolin Liu <liubaolin@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/super.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -695,7 +695,7 @@ static bool parse_ntfs_boot_sector(struc
 		 * = -log2(mft_record_size) bytes. mft_record_size normaly is
 		 * 1024 bytes, which is encoded as 0xF6 (-10 in decimal).
 		 */
-		vol->mft_record_size = 1 << -clusters_per_mft_record;
+		vol->mft_record_size = 1U << -clusters_per_mft_record;
 	vol->mft_record_size_mask = vol->mft_record_size - 1;
 	vol->mft_record_size_bits = ffs(vol->mft_record_size) - 1;
 	ntfs_debug("vol->mft_record_size = %i (0x%x)", vol->mft_record_size,
@@ -732,7 +732,7 @@ static bool parse_ntfs_boot_sector(struc
 		 * index_record_size normaly equals 4096 bytes, which is
 		 * encoded as 0xF4 (-12 in decimal).
 		 */
-		vol->index_record_size = 1 << -clusters_per_index_record;
+		vol->index_record_size = 1U << -clusters_per_index_record;
 	vol->index_record_size_mask = vol->index_record_size - 1;
 	vol->index_record_size_bits = ffs(vol->index_record_size) - 1;
 	ntfs_debug("vol->index_record_size = %i (0x%x)",


