Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58F81A4F1B;
	Wed, 20 Nov 2024 12:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107502; cv=none; b=KarkutDbSDaNbtVMB+lmo+mH565FV/FLv1FW6KGNul3QNtDF+DORT9nJCrelrMUPcmHKwOSh0czM8IWl35bTLOyOAjQFnBHD9IvqvKrxVEDII/Y7fbXEYf9Ljm3o17AjZyolEHGD7YUXdMoTHvNPVgKzYmFUrt++sBQJLSlND28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107502; c=relaxed/simple;
	bh=djhCqsut4w5i8xKO+KoWfZKwwxMUW6W6HC83Tn0uOBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fvSdj9BiqqGWTbSCoPR/cOVRy0ALp72fgeh3TH+KGCmXg9sgU8O6zMrYkMpkYoccyHzT0vC//eJtcuTYU5P0SwgqsR587btY3416bhDCNbkdvpANgcw4KNnApqDGJIynx1QceZksErTQLMMHXI6xMH56sF9aItCjBMEvMUMp0t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KhLcfmZJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KhLcfmZJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7911EC4CECD;
	Wed, 20 Nov 2024 12:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107502;
	bh=djhCqsut4w5i8xKO+KoWfZKwwxMUW6W6HC83Tn0uOBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KhLcfmZJr0FICvbCHh4nRJBlYe9Mx3UruYV8lvFWMBd6nUghWAZ4kTGl1TtvE+8iq
	 sY8+dY3I9yPdlIELVfTS9ewGfvPq3RoBJnZvaMPXhlxyVuCtJqz68pYIgTf5RSb8kk
	 wsrdpCgknKjEC/0kjvueGwzJwQ37e3ZlfiF5DwK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Luczaj <mhal@rbox.co>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 027/107] net: Make copy_safe_from_sockptr() match documentation
Date: Wed, 20 Nov 2024 13:56:02 +0100
Message-ID: <20241120125630.290491352@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Luczaj <mhal@rbox.co>

[ Upstream commit eb94b7bb10109a14a5431a67e5d8e31cfa06b395 ]

copy_safe_from_sockptr()
  return copy_from_sockptr()
    return copy_from_sockptr_offset()
      return copy_from_user()

copy_from_user() does not return an error on fault. Instead, it returns a
number of bytes that were not copied. Have it handled.

Patch has a side effect: it un-breaks garbage input handling of
nfc_llcp_setsockopt() and mISDN's data_sock_setsockopt().

Fixes: 6309863b31dd ("net: add copy_safe_from_sockptr() helper")
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Link: https://patch.msgid.link/20241111-sockptr-copy-ret-fix-v1-1-a520083a93fb@rbox.co
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sockptr.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/sockptr.h b/include/linux/sockptr.h
index fc5a206c40435..195debe2b1dbc 100644
--- a/include/linux/sockptr.h
+++ b/include/linux/sockptr.h
@@ -77,7 +77,9 @@ static inline int copy_safe_from_sockptr(void *dst, size_t ksize,
 {
 	if (optlen < ksize)
 		return -EINVAL;
-	return copy_from_sockptr(dst, optval, ksize);
+	if (copy_from_sockptr(dst, optval, ksize))
+		return -EFAULT;
+	return 0;
 }
 
 static inline int copy_struct_from_sockptr(void *dst, size_t ksize,
-- 
2.43.0



