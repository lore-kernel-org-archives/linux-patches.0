Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F3133470A;
	Mon, 18 Aug 2025 14:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526312; cv=none; b=NO6BdVPsl+ZgruZXKRJpyxxynqdnVozdt1LzepwN42npiPOJWpd05qcqZDk7o64Zx3hLNxT3BsYa2G14NaGlSFi3HmFAw05vIMM/lBkpNaO7+27xAQVThATk+boKRojxfOylObBY7XShHXgyUecibVPwKAPrivyennRs6caduAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526312; c=relaxed/simple;
	bh=SRu5ZffR7bDenGsci+FD3JQ6M8nxWSD9M08/rd4FIOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ENlNApf+qZ3bVprgtBAGpydu6De+fr/lHjNCAI4tcYw1PXs90gd+V7UcvwFVAlKY0pnvO+WXUNMugZPCnW1JJrH8lfnmILfplK46DIxvbKSjQrJx9OA7znU0usJQ3ca9eocGmxY2xSZKnoJmhYBfO7zcjAe8x4E1NGH7+9tV5rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GBO2yfnW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GBO2yfnW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 127C7C4CEEB;
	Mon, 18 Aug 2025 14:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526312;
	bh=SRu5ZffR7bDenGsci+FD3JQ6M8nxWSD9M08/rd4FIOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GBO2yfnWjSUW7LQyVStnM0f8Yqq3FcY6igYuPz/FA4rX80yrSjG5rE9GOopiRRmUd
	 jB6RsvgXYZbIdhWIrmIS0C6CF9HTQJ0R8yYq55IgixsdAwRJnxbKfVW3FKsxvtOxpy
	 mObUDpf9fsshNj/vqFW3/V0oizgrHkLEYPvBcX5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.16 486/570] futex: Use user_write_access_begin/_end() in futex_put_value()
Date: Mon, 18 Aug 2025 14:47:53 +0200
Message-ID: <20250818124524.603420198@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

commit dfb36e4a8db0cd56f92d4cb445f54e85a9b40897 upstream.

Commit cec199c5e39b ("futex: Implement FUTEX2_NUMA") introduced the
futex_put_value() helper to write a value to the given user
address.

However, it uses user_read_access_begin() before the write. For
architectures that differentiate between read and write accesses, like
PowerPC, futex_put_value() fails with -EFAULT.

Fix that by using the user_write_access_begin/user_write_access_end() pair
instead.

Fixes: cec199c5e39b ("futex: Implement FUTEX2_NUMA")
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20250811141147.322261-1-longman@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex/futex.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/futex/futex.h
+++ b/kernel/futex/futex.h
@@ -321,13 +321,13 @@ static __always_inline int futex_put_val
 {
 	if (can_do_masked_user_access())
 		to = masked_user_access_begin(to);
-	else if (!user_read_access_begin(to, sizeof(*to)))
+	else if (!user_write_access_begin(to, sizeof(*to)))
 		return -EFAULT;
 	unsafe_put_user(val, to, Efault);
-	user_read_access_end();
+	user_write_access_end();
 	return 0;
 Efault:
-	user_read_access_end();
+	user_write_access_end();
 	return -EFAULT;
 }
 


