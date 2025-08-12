Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59F12CA9;
	Tue, 12 Aug 2025 18:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024551; cv=none; b=QjPAb4jjXHg4mCZZdjxujKwmVhGhBSQMXoqZ/cHChrezmYX0nA+TsehUsa6PaGMsMx+2Xo9/oQbcJKaV8C4lf5HJfA3e7b4V1NHPBWUf0Yv1IOSr3WdqZ2sMJQL4t34EC7xcIH9QI/pxz8XqlJbWuWfw3okirDZXQ5BY93XRRyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024551; c=relaxed/simple;
	bh=miOjKqQbd1Zr7Wl2DaEQjIVTnKEGNK5VKkYEf9EeN8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fs/HSRt/dPYI213PgAp4irWU+eAfn1FFVj8sCJJ7HKHfyjm6ZSI9S+QQxuL3ISNBvSdRmFTWXxQAokSWtyv7XaPUvPFqiQD+sZJ1t+sXvoI8iyOPBBL0DYB1f/Uu2o3/ocbHDqlklLMi6z6FB9L3VXwLj12xQ+EHh39fnGsC9kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xH1Qave+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xH1Qave+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2972C4CEF0;
	Tue, 12 Aug 2025 18:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024550;
	bh=miOjKqQbd1Zr7Wl2DaEQjIVTnKEGNK5VKkYEf9EeN8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xH1Qave+zTVBsj/pW/xTW62Pfs5WQkc4hzI9hJ1pze39wjQmjkyep7U08UyiLGA6N
	 a3a+wqAWjGbNt10qFv4ry0o1b2//3uXnU7OkLVrP1p9npdVdXzfdD0aalvT6vpgtw7
	 LDpe1F7urHbkqD5/qSR/09FvoGakOOnOr+BxhvQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 406/627] crypto: krb5 - Fix memory leak in krb5_test_one_prf()
Date: Tue, 12 Aug 2025 19:31:41 +0200
Message-ID: <20250812173434.733181365@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@kernel.org>

[ Upstream commit b19f1ab8d5bf417e00d5855c62e061fb449b13c5 ]

Fix a leak reported by kmemleak:

    unreferenced object 0xffff8880093bf7a0 (size 32):
      comm "swapper/0", pid 1, jiffies 4294877529
      hex dump (first 32 bytes):
        9d 18 86 16 f6 38 52 fe 86 91 5b b8 40 b4 a8 86  .....8R...[.@...
        ff 3e 6b b0 f8 19 b4 9b 89 33 93 d3 93 85 42 95  .>k......3....B.
      backtrace (crc 8ba12f3b):
        kmemleak_alloc+0x8d/0xa0
        __kmalloc_noprof+0x3cd/0x4d0
        prep_buf+0x36/0x70
        load_buf+0x10d/0x1c0
        krb5_test_one_prf+0x1e1/0x3c0
        krb5_selftest.cold+0x7c/0x54c
        crypto_krb5_init+0xd/0x20
        do_one_initcall+0xa5/0x230
        do_initcalls+0x213/0x250
        kernel_init_freeable+0x220/0x260
        kernel_init+0x1d/0x170
        ret_from_fork+0x301/0x410
        ret_from_fork_asm+0x1a/0x30

Fixes: fc0cf10c04f4 ("crypto/krb5: Implement crypto self-testing")
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/krb5/selftest.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/krb5/selftest.c b/crypto/krb5/selftest.c
index 2a81a6315a0d..4519c572d37e 100644
--- a/crypto/krb5/selftest.c
+++ b/crypto/krb5/selftest.c
@@ -152,6 +152,7 @@ static int krb5_test_one_prf(const struct krb5_prf_test *test)
 
 out:
 	clear_buf(&result);
+	clear_buf(&prf);
 	clear_buf(&octet);
 	clear_buf(&key);
 	return ret;
-- 
2.39.5



