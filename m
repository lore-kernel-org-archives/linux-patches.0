Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065178;
	b=DaL9/nrt6RK34ctPy7ZDBm4vOkp7gNJUEwUFF3KtQrkIzRqGgxUMSXa8qw3MOrlOYPnG
	 A696WPJF43QpdlxTtLgoYAA4MRdRiSggPdSyE+TBWWJIObnzTjuajhIefxW7nEBa344qP
	 cf6FH8g0W3gLc4d00TuvDvU9s3unNI2QJ6qNV6s1fEOjGHRHH7eUiMvVnHnZ8x8oSc+M9
	 Nk35x1EilHQCuuDtBZmgaRiPtJhMvoel+xsu0nawAKprnckpVUCOlW8gybRHS21kT+xJk
	 KwQlAjZRXYW/58ECndxSpErf6Qm8pLoTUt5BEdkmQfU362iXWve5KA0HM/0iGpF5IiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065178;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RYwLgpO5xmzn/7xT3uDE2kBmZ4MQ0zKfPrxHiS4MldA=;
	b=pIRtinKYlM1AKG4XbvSgZsZWLgy5lOqeA4JZicVaCYAWu7S82Nx+kEPoA6rs0Jc8hUyy
	 orJN6T2OIhNb6dHPWOcXkNfBEJArsAF3hpgPYqMUFXv6D8cfKJGQAD12L5sIuiL85gbGf
	 viEWPkEEmE6Hc3pr1bxeyNcZZF9WD6xiwyRuGnFTCgm2ONrW4wBEKwEw7FA1NQyZEDerg
	 JSh90zED0OeGSDDBodN2M7UUsCItuxR8hQh1a7mQRSChrWkbJ4MUw06jbKBfHW0fclZsF
	 bTGk34Nict9gJNQVJkIOg5XaZ90BgB82kuMBl1/ys96Xc4lYmsG7SftT6sTYTZzqaAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KELsTN1t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E127606A32E;
	Sat,  7 Nov 2026 15:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KELsTN1t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C8691F0089F;
	Sat,  7 Nov 2026 15:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065178;
	bh=RYwLgpO5xmzn/7xT3uDE2kBmZ4MQ0zKfPrxHiS4MldA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KELsTN1t6wNtHuBrSksQGKMZl2wc0kC8gv7aPH9CRDNTahj5cLKVoUUq3HANQwUcd
	 pRScEiegIGqa/htGayP9IeY+5y54nzwc+CzH+FaBl0GRmTPOtaffolzhDqjXD3JAi4
	 WDJp9CvmRbxeNCcREh8lJ82+gCQY5aVpHf5TPm1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chi Zhiling <chizhiling@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0984/1257] exfat: hold the invalidate lock while truncating
Date: Sat,  7 Nov 2026 08:54:40 -0500
Message-ID: <20261107135006.540791857@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chi Zhiling <chizhiling@kylinos.cn>

[ Upstream commit 646df471c37483eb31548d76a1b062775db71d60 ]

truncate_setsize() ends in truncate_inode_pages(), which is documented
as being "Called under (and serialised by) inode->i_rwsem and
mapping->invalidate_lock".

Hold invalidate_lock while executing truncate_setsize() to ensure that
truncate and mmap writes are mutually exclusive. This can simplify the
handling in exfat_page_mkwrite().

Fixes: 82a81a7352bc ("exfat: add iomap buffered I/O support")
Cc: stable@vger.kernel.org
Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/file.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index b30aec858da6c..81eeb76ef94bf 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -413,6 +413,7 @@ int exfat_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 		 * about to be freed.
 		 */
 		inode_dio_wait(inode);
+		filemap_invalidate_lock(inode->i_mapping);
 		truncate_setsize(inode, attr->ia_size);
 
 		/*
@@ -420,6 +421,7 @@ int exfat_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 		 * is already written by it, so mark_inode_dirty() is unneeded.
 		 */
 		exfat_truncate(inode);
+		filemap_invalidate_unlock(inode->i_mapping);
 	} else
 		mark_inode_dirty(inode);
 
@@ -784,8 +786,10 @@ static int exfat_extend_valid_size(struct inode *inode, loff_t new_valid_size)
 		ret = exfat_zero_new_range(inode, gap_start, new_valid_size);
 		filemap_invalidate_unlock(inode->i_mapping);
 		if (ret) {
+			filemap_invalidate_lock(inode->i_mapping);
 			truncate_setsize(inode, old_valid_size);
 			exfat_truncate(inode);
+			filemap_invalidate_unlock(inode->i_mapping);
 			return ret;
 		}
 
-- 
2.53.0



