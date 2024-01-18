Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67AAD1774B;
	Thu, 18 Jan 2024 10:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575513; cv=none; b=Nv7GKMLDscWAPYre6hUkmKJajeqn/WcVYRcTqcz8X86wJgpIXnebn0icChqaFWACrkcQkpsgWxv3KDfNHq2lHebNtrkL48S7iMaGQ4VD18JM/ndAhw0YWqbsZM/juvbnTa5jKrbFXjE3Furc31Zai5w+NMlVThMZ4EYO564IIoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575513; c=relaxed/simple;
	bh=HFwTnyBupkbglaXiM5iTYFT2qEMffFLtx1oSC0iaKV4=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=sa99AYcMCv5W4vGyLaNSjKxvhS2Pscv7jTOS5l4OlH30Yqh3QFOgegpBV/xfo2Hq6EMtZrU0Gk0+AMLeqcp20e1Mpar6M8mWcSWRss9G+E4qME/xzKYpmbkAE4JsXozevtvhzAAM0aBSG4P30hPtQsohvK5zKi2dumY/Xfy+dNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qRhLT3At; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qRhLT3At"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF081C433C7;
	Thu, 18 Jan 2024 10:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575513;
	bh=HFwTnyBupkbglaXiM5iTYFT2qEMffFLtx1oSC0iaKV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qRhLT3AtwUx3S6heCxvvV3q/c+mND+Y8tKrA5sDaQxm0q73c9YBpps0y0duOi+FWN
	 c2Pd4swr6JDlRM/HFVNMhqWA87aYaoZP3HBh20KABtmG2We6EMm28uoyWWggXg0+/N
	 D81BapHXSY8vla2Mjzc0ws0glw+G7xU8YUd8bQKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.1 001/100] f2fs: explicitly null-terminate the xattr list
Date: Thu, 18 Jan 2024 11:48:09 +0100
Message-ID: <20240118104310.952914636@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -754,6 +754,12 @@ retry:
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


