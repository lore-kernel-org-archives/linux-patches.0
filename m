Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8783E1419B4;
	Tue, 23 Jan 2024 01:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972065; cv=none; b=pKZtYXAW9ezXoRNRFQixhF9HFlmsZjlmuFhkR8IJuBn1IM6BnWkMoiiU6F84cS4BS0OJtTz4ryyOI426BcgaivBStiEhGa+tQUZu2JGyR26uMZ/GOKLs1NOoZ7RX/TIkPt7t1TxDUpMXoNMnXlKJjwY7+6BHXyjw0PAu7bkzLh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972065; c=relaxed/simple;
	bh=IveJ2pMouNksD4/gJSReYhs5QZWUsqAY9CzlmA299hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cVfKT9zQeDmOJC+TuJ0BwtNcQFELe3qwnzqAsweGPUCEUon4xJun+jgNQMQTxIG63K7L3B7AfvzSb4C9Q4v8rbysdVGBXZtreTksYcspZB0gs0dfeIglfWJPju0Y/7/LY+TGuup4Cth4anCIQEd1BoUsSlwo3z9Fb0iOOUO6f1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aDRXGLd9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aDRXGLd9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4478AC433F1;
	Tue, 23 Jan 2024 01:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972065;
	bh=IveJ2pMouNksD4/gJSReYhs5QZWUsqAY9CzlmA299hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aDRXGLd9RLRCAOmkCmg6xweCjFxJ4pyMViefF0DDoY8P73hbqyFxdSXqVd5uVTYLX
	 bdjuQrz18b/YUL6qd+eQAfM0t71M/WZyhurjRhp+W7kac2Lf2GG7bykxanR4HQu0dW
	 2Tgs4MRJXx3JfUPjKUR8BAB7nZ0HF3Dc+B5Idd/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.15 001/374] f2fs: explicitly null-terminate the xattr list
Date: Mon, 22 Jan 2024 15:54:17 -0800
Message-ID: <20240122235744.658311870@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@google.com>

commit e26b6d39270f5eab0087453d9b544189a38c8564 upstream.

When setting an xattr, explicitly null-terminate the xattr list.  This
eliminates the fragile assumption that the unused xattr space is always
zeroed.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/xattr.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -745,6 +745,12 @@ static int __f2fs_setxattr(struct inode
 		memcpy(pval, value, size);
 		last->e_value_size = cpu_to_le16(size);
 		new_hsize += newsize;
+		/*
+		 * Explicitly add the null terminator.  The unused xattr space
+		 * is supposed to always be zeroed, which would make this
+		 * unnecessary, but don't depend on that.
+		 */
+		*(u32 *)((u8 *)last + newsize) = 0;
 	}
 
 	error = write_all_xattrs(inode, new_hsize, base_addr, ipage);


