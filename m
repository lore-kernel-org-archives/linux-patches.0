Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217294;
	b=ry1xrMWubrZgvOKuBxXxdVjFGTaPiMAuvd2z/3EUJgTuKgZzjp5Pp0uCrkMNPi1c+z0P
	 tpFoP0+Rp156gYp0WqXehLfgNqUzTvBkc3pVwxciHBz9roMpCsqb7XLimJX7eZYLE9sjn
	 n2ErM0eh3HY/ixd+PKRdsYtltQvBcAqe9xA6YX34FAbdSSqm1VcbzWRcJrnrz4EfFJfCp
	 0aNDw2mFHMTj8Meb7sHw/+mDlB1xg3z0ikpPCiC6f+ZCOotpvhxWJiT+1nUlkQ4tgu4uu
	 ySRlqlNHi6JLJ3qCZ58OeTMWjrnx/70mQR723Jt9CY4shNQVgIKPn/6seLA/hvhcjtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217294;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cV7zuCXanhO4QbWaX5wDlomYwH8VYX9fWMysn1CwfQY=;
	b=cHNkDd2kXlciK8MTIFwKI7ukc8faqR9Wrq48bt1ucdiCf6gJ3qHB96Kzu+qlkSGvT8+k
	 dNZQ//cFb0aHeZ67xoo3d+r7U4nFXMb7pT5d9Wo1wMeg2HNf8ynNlJTR2jm0XmdY5+6ar
	 FFcRIvnzovXq8QwUHJeL9u3fw5rpg+WnEK4N2kxJcYrFFrTkgovrpUotqVrcUDfaopGpi
	 cJCbaHXLCb6O31sSo67d0yN3AZoT7gYwbsJ1fD+mzn8FdLVzgLYMA4tNNRUX5yLhw9LPq
	 2TU2+IPUuzUClqcYeOYF6nYNHzgb22WMcyGZIZ4xQv4ipp7GsNEq7e1FLu253xQHwrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I770NgGX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F09606A31A;
	Wed, 28 Oct 2026 19:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I770NgGX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8809E1F031E0;
	Wed, 28 Oct 2026 19:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217294;
	bh=cV7zuCXanhO4QbWaX5wDlomYwH8VYX9fWMysn1CwfQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I770NgGXkm7xiYk0rDawKvPsdXE0ZNRXH1fiVi09JfMpxqPmQAJr0N1i4qvWPJ6c6
	 zLsn5QClE6enjlwLQR7DyjZ00OzZGOt3FmjEzGKy/6IVM1mgHYTs2GDff+r5tybYXl
	 CNI3wjR3DtXDSFU6YYcOv316fnZUDqhvgp/u3OvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Ira Weiny <ira.weiny@intel.com>,
	Jiaqi Yan <jiaqiyan@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Peter Collingbourne <pcc@google.com>,
	Tom Rix <trix@redhat.com>,
	Tony Luck <tony.luck@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1854/1887] highmem: fix a memory copy problem in memcpy_from_folio
Date: Wed, 28 Oct 2026 18:05:50 +0100
Message-ID: <20261028170541.640458281@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

[ Upstream commit 73424d00dc63ba681856e06cfb0a5abbdb62e2b5 ]

Clang static checker complains that value stored to 'from' is never read.
And memcpy_from_folio() only copy the last chunk memory from folio to
destination.  Use 'to += chunk' to replace 'from += chunk' to fix this
typo problem.

Link: https://lkml.kernel.org/r/20231130034017.1210429-1-suhui@nfschina.com
Fixes: b23d03ef7af5 ("highmem: add memcpy_to_folio() and memcpy_from_folio()")
Signed-off-by: Su Hui <suhui@nfschina.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Tom Rix <trix@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/highmem.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index c4d6ae968dfc3..1761b6d0c2c76 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -430,7 +430,7 @@ static inline void memcpy_from_folio(char *to, struct folio *folio,
 		memcpy(to, from, chunk);
 		kunmap_local(from);
 
-		from += chunk;
+		to += chunk;
 		offset += chunk;
 		len -= chunk;
 	} while (len > 0);
-- 
2.53.0



