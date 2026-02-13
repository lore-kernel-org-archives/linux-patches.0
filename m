Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B4734CFC3;
	Fri, 13 Feb 2026 13:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990711; cv=none; b=PudDhIGgl5ohPOGIkiW/ZvdUUOTHjRBxfAD9rnN32AUNGH+Jl6Onlz/UPxjuI/v21PGqPNhTSCxc1yvc+HqEAtCvb6AZZq6Vn03fvogl6zVhChs3+SoY+cGg5b1PEYaRiyy3LwLRdm8Ni1It9MXoBtU9ro2RJLgzjRlFFapIVS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990711; c=relaxed/simple;
	bh=srjq/1X2KpIFUDQFyqS+5D4rR3mbVoxFOr3vBLhsA/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RTEOUmug1ZzsoB9jUVP67FbWTDTEZkF455EO51/tVdr2ZR3gtS0Vi2rhYAomOhoCC8xvggMFqcRvZcF+TxzKP8LhoX/RFfpOo56rraPViXvU+ZyLwCkNEfePIfzaHAMEwC8eE01N4xDR5xydFcRcKyj0hK75DTXTOMI3QzCk4Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QSEXB/0O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QSEXB/0O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3ABDC116C6;
	Fri, 13 Feb 2026 13:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990711;
	bh=srjq/1X2KpIFUDQFyqS+5D4rR3mbVoxFOr3vBLhsA/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QSEXB/0OyHsttObJPFRqpujNKiubgDSgeUGC08JenNylKwK3qStk9V9/vhfKKjqLz
	 Ii5JedTZTGQD+nyHr7PO+5OwKm5IHsklH1A/3QBzu+Ur10m/wSt8m05jf0ZBkdWtnV
	 MxCK1RxhIO80FY/J/33y34J02AMoeBydf/uQ6Uho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.19 30/49] crypto: iaa - Fix out-of-bounds index in find_empty_iaa_compression_mode
Date: Fri, 13 Feb 2026 14:47:49 +0100
Message-ID: <20260213134709.833361491@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134708.713126210@linuxfoundation.org>
References: <20260213134708.713126210@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit 48329301969f6d21b2ef35f678e40f72b59eac94 upstream.

The local variable 'i' is initialized with -EINVAL, but the for loop
immediately overwrites it and -EINVAL is never returned.

If no empty compression mode can be found, the function would return the
out-of-bounds index IAA_COMP_MODES_MAX, which would cause an invalid
array access in add_iaa_compression_mode().

Fix both issues by returning either a valid index or -EINVAL.

Cc: stable@vger.kernel.org
Fixes: b190447e0fa3 ("crypto: iaa - Add compression mode management along with fixed mode")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Acked-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -221,15 +221,13 @@ static struct iaa_compression_mode *iaa_
 
 static int find_empty_iaa_compression_mode(void)
 {
-	int i = -EINVAL;
+	int i;
 
-	for (i = 0; i < IAA_COMP_MODES_MAX; i++) {
-		if (iaa_compression_modes[i])
-			continue;
-		break;
-	}
+	for (i = 0; i < IAA_COMP_MODES_MAX; i++)
+		if (!iaa_compression_modes[i])
+			return i;
 
-	return i;
+	return -EINVAL;
 }
 
 static struct iaa_compression_mode *find_iaa_compression_mode(const char *name, int *idx)


