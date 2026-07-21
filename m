Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A1D4028CE;
	Tue, 21 Jul 2026 17:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653910; cv=none; b=GNnp4MyU27K1Z56b+0wN5CZizXShs5eyzBoiPO7jzAGfRegTIHEaPtOWhWn56KepVOCvc1i5Bz0GkfAomS0vR2PT+L2GscGryceP3wpMcEpjcWq8bcK/z8gakwPwDQHTSH3SoVU3DHD/ddWCcBBQWmMixiSVNR3Nm6Ls3+aKhuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653910; c=relaxed/simple;
	bh=DXw8cHA8906bYwWjkenSysnMR3S+whtagoUyowx+dag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CPO4mjFrhlfKM6cZ2MuNaHVWtbLg3+g0i4lJHF9dRt7mjoZxC9fz+V0ZUl5dtgkeAYE5ZqhFkbRfYuhNLlHIXSDr3Y39tqrKoIt61cRafl7lEpALWCBkYdLfAzw2mtW4SQZqCoGjBPcE1N8xQ29pATEUP8jrVyioyO7kMhJRgIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mcv0UYxI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mcv0UYxI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC8D01F000E9;
	Tue, 21 Jul 2026 17:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653909;
	bh=NI0kwPhHPWtI/l4AjJIx1vKeRrQQm6G9TMI6GQIeNnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mcv0UYxI8wFL8oU7CmlUlyk8M3z3Tsf5leIJhPv0egz/DzYxvkWT80h0v0h51aBtk
	 im8eMMXyGBLeJwB9ZFpNorwA8mUfUF+asPwHCCkvAtsqqnwmIK4Cm3bkKpMLxEAsno
	 ZfvSLZZ59UG3BfuK85QoS0T2sksuOnX72cDCT6do=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yan <wangyan01@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1504/2077] selftests/net: fix EVP_MD_CTX leak in tcp_mmap
Date: Tue, 21 Jul 2026 17:19:37 +0200
Message-ID: <20260721152628.258369782@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Yan <wangyan01@kylinos.cn>

[ Upstream commit f4ef35efbb49527293309f668ea73ec5de9b8e7a ]

In tcp_mmap.c, both child_thread() and main() allocate an EVP_MD_CTX
via EVP_MD_CTX_new() when integrity checking is enabled, but neither
function releases the context.  child_thread() misses the free in its
common cleanup block, and main() returns without freeing the context.

This results in a SHA256 context leak on every run that uses the
‑i (integrity) option.  Add the missing EVP_MD_CTX_free() calls to
the appropriate cleanup paths to fix the leak.

Fixes: 5c5945dc695c ("selftests/net: Add SHA256 computation over data sent in tcp_mmap")
Signed-off-by: Wang Yan <wangyan01@kylinos.cn>
Link: https://patch.msgid.link/20260702025949.442523-1-wangyan01@kylinos.cn
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/tcp_mmap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/net/tcp_mmap.c b/tools/testing/selftests/net/tcp_mmap.c
index 4fcce5150850dd..2544ae35d07a83 100644
--- a/tools/testing/selftests/net/tcp_mmap.c
+++ b/tools/testing/selftests/net/tcp_mmap.c
@@ -313,6 +313,8 @@ void *child_thread(void *arg)
 				tcp_info_get_rcv_mss(fd));
 	}
 error:
+	if (ctx)
+		EVP_MD_CTX_free(ctx);
 	munmap(buffer, buffer_sz);
 	close(fd);
 	if (zflg)
@@ -606,6 +608,8 @@ int main(int argc, char *argv[])
 		EVP_DigestFinal_ex(ctx, digest, &digest_len);
 		send(fd, digest, (size_t)SHA256_DIGEST_LENGTH, 0);
 	}
+	if (ctx)
+		EVP_MD_CTX_free(ctx);
 	close(fd);
 	munmap(buffer, buffer_sz);
 	return 0;
-- 
2.53.0



