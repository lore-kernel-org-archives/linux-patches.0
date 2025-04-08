Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F2B268684;
	Tue,  8 Apr 2025 12:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115432; cv=none; b=TyGTelq1o+P/YLIblASUT63qSNfVQeLzuP13pL6dIs34sITQeWt0G8Vc12hQsFVhjNv577H4Gbwivtbxv/3vPCNQjjcnBkkVK85O8FNxFaJmfNZq7bcSSZ1YdVjhhxFbS3y4R9G86dr41SEIob1fo8gJ8rkGQx1MOJSzVCVYFZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115432; c=relaxed/simple;
	bh=JCUKbqJItoEuTcvwIFqsemBIpEyqUbCyBnEwqLkhwRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mym/3lOvlRyTEOy2yoo696tQpIIB9mluexSUDmUUCDyKRQYtUrR5Higmpo3NXAne+1nY+Icm58kbxvNj7Si+GaMQnt1TBa5F7ki3JRSajYBhbbO2um0BP1rCH8zyBEY6C8Km92eToMwxqq4fvnECZr4NT8SZxlIso0JFPKwdEf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SFC9N1OM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SFC9N1OM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91309C4CEE5;
	Tue,  8 Apr 2025 12:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115431;
	bh=JCUKbqJItoEuTcvwIFqsemBIpEyqUbCyBnEwqLkhwRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SFC9N1OMjdRRWNmnuDbOvTt9v/pmkwP2hwBTdggYUKpgyjIqMClb1uzvmC8McMvfh
	 SsjUVmfrvGRO/g9zVIoQ71nG/Vv7I4AZ24lJ3cm/b+J5Azirs06UV98LNVeQ+We8Dy
	 nsc4sU7HT8CUvTg/aga4VMxxAvrqVo+u3jbpI63c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yeongjin Gil <youngjin.gil@samsung.com>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.13 473/499] exfat: fix random stack corruption after get_block
Date: Tue,  8 Apr 2025 12:51:25 +0200
Message-ID: <20250408104903.151847292@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sungjong Seo <sj1557.seo@samsung.com>

commit 1bb7ff4204b6d4927e982cd256286c09ed4fd8ca upstream.

When get_block is called with a buffer_head allocated on the stack, such
as do_mpage_readpage, stack corruption due to buffer_head UAF may occur in
the following race condition situation.

     <CPU 0>                      <CPU 1>
mpage_read_folio
  <<bh on stack>>
  do_mpage_readpage
    exfat_get_block
      bh_read
        __bh_read
	  get_bh(bh)
          submit_bh
          wait_on_buffer
                              ...
                              end_buffer_read_sync
                                __end_buffer_read_notouch
                                   unlock_buffer
          <<keep going>>
        ...
      ...
    ...
  ...
<<bh is not valid out of mpage_read_folio>>
   .
   .
another_function
  <<variable A on stack>>
                                   put_bh(bh)
                                     atomic_dec(bh->b_count)
  * stack corruption here *

This patch returns -EAGAIN if a folio does not have buffers when bh_read
needs to be called. By doing this, the caller can fallback to functions
like block_read_full_folio(), create a buffer_head in the folio, and then
call get_block again.

Let's do not call bh_read() with on-stack buffer_head.

Fixes: 11a347fb6cef ("exfat: change to get file size from DataLength")
Cc: stable@vger.kernel.org
Tested-by: Yeongjin Gil <youngjin.gil@samsung.com>
Signed-off-by: Sungjong Seo <sj1557.seo@samsung.com>
Reviewed-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/inode.c |   39 +++++++++++++++++++++++++++++++++------
 1 file changed, 33 insertions(+), 6 deletions(-)

--- a/fs/exfat/inode.c
+++ b/fs/exfat/inode.c
@@ -344,7 +344,8 @@ static int exfat_get_block(struct inode
 			 * The block has been partially written,
 			 * zero the unwritten part and map the block.
 			 */
-			loff_t size, off, pos;
+			loff_t size, pos;
+			void *addr;
 
 			max_blocks = 1;
 
@@ -355,17 +356,41 @@ static int exfat_get_block(struct inode
 			if (!bh_result->b_folio)
 				goto done;
 
+			/*
+			 * No buffer_head is allocated.
+			 * (1) bmap: It's enough to fill bh_result without I/O.
+			 * (2) read: The unwritten part should be filled with 0
+			 *           If a folio does not have any buffers,
+			 *           let's returns -EAGAIN to fallback to
+			 *           per-bh IO like block_read_full_folio().
+			 */
+			if (!folio_buffers(bh_result->b_folio)) {
+				err = -EAGAIN;
+				goto done;
+			}
+
 			pos = EXFAT_BLK_TO_B(iblock, sb);
 			size = ei->valid_size - pos;
-			off = pos & (PAGE_SIZE - 1);
+			addr = folio_address(bh_result->b_folio) +
+			       offset_in_folio(bh_result->b_folio, pos);
 
-			folio_set_bh(bh_result, bh_result->b_folio, off);
+			/* Check if bh->b_data points to proper addr in folio */
+			if (bh_result->b_data != addr) {
+				exfat_fs_error_ratelimit(sb,
+					"b_data(%p) != folio_addr(%p)",
+					bh_result->b_data, addr);
+				err = -EINVAL;
+				goto done;
+			}
+
+			/* Read a block */
 			err = bh_read(bh_result, 0);
 			if (err < 0)
-				goto unlock_ret;
+				goto done;
 
-			folio_zero_segment(bh_result->b_folio, off + size,
-					off + sb->s_blocksize);
+			/* Zero unwritten part of a block */
+			memset(bh_result->b_data + size, 0,
+			       bh_result->b_size - size);
 		} else {
 			/*
 			 * The range has not been written, clear the mapped flag
@@ -376,6 +401,8 @@ static int exfat_get_block(struct inode
 	}
 done:
 	bh_result->b_size = EXFAT_BLK_TO_B(max_blocks, sb);
+	if (err < 0)
+		clear_buffer_mapped(bh_result);
 unlock_ret:
 	mutex_unlock(&sbi->s_lock);
 	return err;


