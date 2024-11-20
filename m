Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E663D1AA1E6;
	Wed, 20 Nov 2024 12:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107578; cv=none; b=q1f++3yYa+CL8r2Uonzf+3jY5+S6YkShb403XRasTkr8kOD0lwOglCMohJBJTqLkL2qEtSDf4+gW7Tyf62iK90AGJi+aehcH6AbNb1Uq4IJSx5/bvOpWWg0mtUfLQdLm/HKzjbfZUweyEYqdIm3IxWjdKOi7wNlhQ9eZLU6H1xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107578; c=relaxed/simple;
	bh=Bp3BSFUHw3ETgRtQoODyvYz2rBaYcfvgOAuS/uPdsmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rWvBNJiEhjeP3ewG0paikku+XwTCJpjkvOlG/aU1KsaliTHmG2Ey6Ytk7YaCQ3/vWdU0gy5GpGtoCyjXnPz+oUVhy2N9SBCLtisojyMQ0gPNSIcEU4GvRAQGHx5AHuMe/pBKGKt2C5skbWReRGStLFAZVG8Kalv87H47a+lv9r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VsY0qGXq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VsY0qGXq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF05AC4CECD;
	Wed, 20 Nov 2024 12:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107577;
	bh=Bp3BSFUHw3ETgRtQoODyvYz2rBaYcfvgOAuS/uPdsmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VsY0qGXqHEd5eBhdZcorpKKqgBuB6rbnL7M4W7UPjeOjn0lxAMsWnQeyidOpv8mw2
	 0YqJaRu3lgw2QMHYVY67bL2pQtwJ3zCfrQET8/SUPoBMreh8U2f266994/FOjqrBZF
	 u4xxSnPaXg60NbqjQA7iAImQ+1v8ivaa8DqZknyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Luczaj <mhal@rbox.co>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 19/82] net: Make copy_safe_from_sockptr() match documentation
Date: Wed, 20 Nov 2024 13:56:29 +0100
Message-ID: <20241120125630.045444790@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1c1a5d926b171..0eb3a2b1f81ff 100644
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
 
 static inline int copy_to_sockptr_offset(sockptr_t dst, size_t offset,
-- 
2.43.0



