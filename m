Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82ED12DA76C;
	Tue, 21 Jul 2026 20:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665128; cv=none; b=UUl+Mux7bX9SFXVmJzcWJEzHJ8NryN+jXDxTOHGg3L9u8jmr1fTqhkxfRect5Aaozy0ZwSPqmtcEVsAO53EAPdrOMb4aiTv5E0BA6uLhDNw2fGHRG2GGPSxEKJcM2kgC6mkXMiJ8UTqLX8yTLJfHbeseoRbiR8S7BzbN2Vd9Oto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665128; c=relaxed/simple;
	bh=+j0IVcSMMu/TMRfdXl9166CPtXwambhIxji4nRYvuAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WCjl0wSsuj7Yc6jzJVFywAsOPC9pX3JpmlM+dXDnh27vKqXKeXe3Me2yJ3+TWO8btwWZWttL9t0/XJyX3DwIvY1hgAZXxkwPN0M8CucEFYtjex+3SpnUiKyS2yHFKOevLizMONvM419mfd5e/y3U1y56i7ceJq5dws2sKYlhToA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H/L1XE9Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H/L1XE9Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E77621F00A3D;
	Tue, 21 Jul 2026 20:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665127;
	bh=FRZnI6brvHObs5WrnTjvTvfgOM3MEw8PqZlXHi7bRDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H/L1XE9YhAEhEbh3wtPt0DA30VOJyjKX1L3rYEjLxgdLIny9lhEpv6n7+Swys00U7
	 ACrvyfUYZK+O/3TszPPJDH2KM4VztknDD7ZDjSQxIO07MwtzcBLEgkGsxZ69qa2a31
	 5Fp1SBMykJWWEZm42UdZIOA4toAllWrO8Zmb1oZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Dan Carpenter <error27@gmail.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 0180/1266] smb/client: Fix error code in smb2_aead_req_alloc()
Date: Tue, 21 Jul 2026 17:10:17 +0200
Message-ID: <20260721152445.834159991@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Dan Carpenter <error27@gmail.com>

commit 61f28012e5650c619223decdb7970e0d3162e949 upstream.

The "*num_sgs" variable is a u32 so "ERR_PTR(*num_sgs)" doesn't work.
We would have to do something similar to the previous line where it's
cast to int and then long.  However, it's simpler to store the return in
an int ret variable.

This bug would eventually result in a crash when dereference the invalid
error pointer.

Fixes: d08089f649a0 ("cifs: Change the I/O paths to use an iterator rather than a page list")
Cc: stable@kernel.org
Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2ops.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4182,11 +4182,13 @@ static void *smb2_aead_req_alloc(struct
 	unsigned int req_size = sizeof(**req) + crypto_aead_reqsize(tfm);
 	unsigned int iv_size = crypto_aead_ivsize(tfm);
 	unsigned int len;
+	int ret;
 	u8 *p;
 
-	*num_sgs = cifs_get_num_sgs(rqst, num_rqst, sig);
-	if (IS_ERR_VALUE((long)(int)*num_sgs))
-		return ERR_PTR(*num_sgs);
+	ret = cifs_get_num_sgs(rqst, num_rqst, sig);
+	if (ret < 0)
+		return ERR_PTR(ret);
+	*num_sgs = ret;
 
 	len = iv_size;
 	len += crypto_aead_alignmask(tfm) & ~(crypto_tfm_ctx_alignment() - 1);


