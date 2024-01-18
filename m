Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2F723760;
	Thu, 18 Jan 2024 10:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575013; cv=none; b=R9ObB6owm1stsudQXS/gMLZR8+esgPGKAXOFwZxAGmo5sNxedau4H7sQCvIV+t4oeLGHwoI9HzCwgQIJIQMGmkIylQOUA9YpBWKIScRMCu4K/SIXcfYt6keJt/LiLjB4UAsfDtEa/hNlVeHLvrVB2fhkUFWs1LYsUDQrcuBKhC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575013; c=relaxed/simple;
	bh=tD0z/bAHXoiF1Plhr6mjT4xGN/dpkGVqsKFcmXCSe7Y=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=j/K6r/BZ9ZmeMcen/XgfLnadcY8gbaAQhKDK982K3ZQxp9RTA4IJxm17RFhhD6b/JP1CX8+BTHlK3jkxm2pSX1U9LoV9V6POxSYUdk6cAsWbaw5mSd0pTfcTS0sy2kRT8JgCZHUpqKgMhdghBSdIqrKZrxNYib1hKINUewsfdik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MdTtGTl0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MdTtGTl0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E56DC433F1;
	Thu, 18 Jan 2024 10:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575012;
	bh=tD0z/bAHXoiF1Plhr6mjT4xGN/dpkGVqsKFcmXCSe7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MdTtGTl0V0kRhlb6ZMZqlmjpbrimPmO5ArTT2NIqv5iZ3kTHdXulWk+fYqBxCf3vR
	 BgdKU3vyVSzmKZmWWUYIHx7YdTsWfZKw/FOZUf49UFmi7cd7RinpzD+3hf52OlE0y4
	 e9S6zJH0oGiPH2CoiHzGTkzCgEIzOm37MyEh03EU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.7 01/28] f2fs: explicitly null-terminate the xattr list
Date: Thu, 18 Jan 2024 11:48:51 +0100
Message-ID: <20240118104301.297099258@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104301.249503558@linuxfoundation.org>
References: <20240118104301.249503558@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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


