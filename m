Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630BF1BF7F9;
	Wed, 20 Nov 2024 13:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107708; cv=none; b=tfj2Ik338cA145764DLJy7eBL+3dCIzPKABeTxecJ7PWLu3uenNkyBsG95sROxwcsisfL7rCKU1cFTyi87y8mtb+Kf0TW6nO2eBljwNUElZnJ1YKerxPNTZSUJov0GeDERFtD99GdG7Niafou0WcoW0xH/zJ2W4LcKMAu8aQSag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107708; c=relaxed/simple;
	bh=d/7lFGi7W4xfKNtZULzFis78nYthm5R0phen0gcxiEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d6u1cGa5dU/Lj3p3vZHEL/pXQFkQamH/fYqbo3LyOC9xvFHMbdr1DC0u5IuCWvzxCvgSqDFRgFkbG4mbzEwv6okT6sWBh9wxoSYWh42dioxiQ6tlyaCwX9ddAWByPNyUzKK5BWHodsMIUDOAdfAXXaX1k4c0gQHvf0rZRvWeuOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LaGta837; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LaGta837"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E05C4CED1;
	Wed, 20 Nov 2024 13:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107708;
	bh=d/7lFGi7W4xfKNtZULzFis78nYthm5R0phen0gcxiEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LaGta837zUx63IK099/Ve8LaDa+hGU05+tlBDce/uiOnTYgnRmPue6KwaxkIQ/dOS
	 VVysjQNWq/xtqbYCoY8W3S1XAlC8yyCVWKaD8YU/aIBCremDrAqur0ijrTh3RrzVKT
	 +25sLWSImxcA7nf5pAMrF/fli18OzafyRBP3eupw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Luczaj <mhal@rbox.co>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 73/73] net: Make copy_safe_from_sockptr() match documentation
Date: Wed, 20 Nov 2024 13:58:59 +0100
Message-ID: <20241120125811.352681403@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
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

From: Michal Luczaj <mhal@rbox.co>

commit eb94b7bb10109a14a5431a67e5d8e31cfa06b395 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sockptr.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/include/linux/sockptr.h
+++ b/include/linux/sockptr.h
@@ -77,7 +77,9 @@ static inline int copy_safe_from_sockptr
 {
 	if (optlen < ksize)
 		return -EINVAL;
-	return copy_from_sockptr(dst, optval, ksize);
+	if (copy_from_sockptr(dst, optval, ksize))
+		return -EFAULT;
+	return 0;
 }
 
 static inline int copy_to_sockptr_offset(sockptr_t dst, size_t offset,


