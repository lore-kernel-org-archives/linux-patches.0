Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2B5383;
	Thu, 30 Jan 2025 14:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246601; cv=none; b=I9d4KOkg0QD8q5zu0SpkIcgJOleQR/2TeOJ/IEAa30GBNGbFFIQ0DtuEF9NkCe2SBbr4hk/9fRNx61bJpk6Kuw/fmGXlEyNNDc0GOo90xFNFKxGW23Hk5EEMpUFavF9IuxnMCzHO1EMPLqXWQIylqnEhJgsXILVqs8l9mjOCjNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246601; c=relaxed/simple;
	bh=U2Ktzn0fKusRqApCLFMp/evE78hrHvfP4GasRhf77tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u3k+9nVkbOUVM5arnDspTrC9+hIyrpVXqJJm64oWf2zvt0YHlo0+Kc63BfnM40sDC8NJ2e645/7SkTLO9NzNRPIUoCfJBpCumwJyAYRcpRzoN/xLrW4sEeN87ySUjMjGM4DQHkcE5fp6Aj9l1tvSRePUKXb3YI3GIGrtei8yV5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YLYG+Xu8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YLYG+Xu8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA30C4CED2;
	Thu, 30 Jan 2025 14:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246601;
	bh=U2Ktzn0fKusRqApCLFMp/evE78hrHvfP4GasRhf77tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YLYG+Xu8YJXMLltUoTXihb4sv43isVJWA+CZJ68MQh7YE1EDLbrC5VhfI04P7u1iL
	 2hOVn34kns6Ej6ihegQKwnZcREpcVKxfKn4Ds5zYl9qJqeVa8+KXRJ+d2RJ3ruvXOH
	 Ob00vKJbU44budpwJq1cQOjeWiI1Gxh3D0mHoSxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Yang Erkun <yangerkun@huawei.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.6 21/43] libfs: Return ENOSPC when the directory offset range is exhausted
Date: Thu, 30 Jan 2025 14:59:28 +0100
Message-ID: <20250130133459.754795073@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133458.903274626@linuxfoundation.org>
References: <20250130133458.903274626@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 903dc9c43a155e0893280c7472d4a9a3a83d75a6 ]

Testing shows that the EBUSY error return from mtree_alloc_cyclic()
leaks into user space. The ERRORS section of "man creat(2)" says:

>	EBUSY	O_EXCL was specified in flags and pathname refers
>		to a block device that is in use by the system
>		(e.g., it is mounted).

ENOSPC is closer to what applications expect in this situation.

Note that the normal range of simple directory offset values is
2..2^63, so hitting this error is going to be rare to impossible.

Fixes: 6faddda69f62 ("libfs: Add directory operations for stable offsets")
Cc: stable@vger.kernel.org # v6.9+
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Yang Erkun <yangerkun@huawei.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Link: https://lore.kernel.org/r/20241228175522.1854234-2-cel@kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
[ cel: adjusted to apply to origin/linux-6.6.y ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/libfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -287,8 +287,8 @@ int simple_offset_add(struct offset_ctx
 
 	ret = xa_alloc_cyclic(&octx->xa, &offset, dentry, limit,
 			      &octx->next_offset, GFP_KERNEL);
-	if (ret < 0)
-		return ret;
+	if (unlikely(ret < 0))
+		return ret == -EBUSY ? -ENOSPC : ret;
 
 	offset_set(dentry, offset);
 	return 0;


