Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9A71684BE;
	Fri, 13 Feb 2026 13:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990972; cv=none; b=hbYRH/OXW57DHB+K8hqAC4naNTCMeOi2V/jdvOLoynYyIQUKgQoLFgxdHQSkukdBdS9zTscWoTfVU1R60PdVzN9zhm7vA6PMS35Ve4ivXoNMbFKiQmAhxDfL0kSzG0+90vzy1aMXBCkoBGj2f3zg6uwENMMEU8Ixn0jCrcOnC1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990972; c=relaxed/simple;
	bh=vIzNQ9Ftr8D9x99QpWZ8n+Q+s7aI7tjJiEWuumV2bKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VDUeYMWwQl+FWDcbKWzRqyXpgHe9smjPwPQDEr5ec/WQKiVnlsESwtpjSqSwLHIyh3TlvkP+3WZiUU4KeZQu8nTSi/IgSxm7Z++c6KVJE7ImYlQe7LChrzImknPGRX3KVkfuITTq8jAwvtD8VVVgYI6e6Wx7V7qwFfc9jj9k3m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mmuZ5T6F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mmuZ5T6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09A99C116C6;
	Fri, 13 Feb 2026 13:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990972;
	bh=vIzNQ9Ftr8D9x99QpWZ8n+Q+s7aI7tjJiEWuumV2bKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mmuZ5T6FcMqJdSstlqEVZeO7CTuKb/0daGcckELCJMz+eSXbsWMq7XzwpGl3NHZHf
	 W8eE3fvBkBFPSjFBskMUaJv5AW4c57dmTlHQSeE4p+JTghP+cg8S7DZOnkH/G1JxaW
	 EjKS/5Z676IUjN135uvgEiGrxqWdyWos7pf0igQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 06/24] crypto: iaa - Fix out-of-bounds index in find_empty_iaa_compression_mode
Date: Fri, 13 Feb 2026 14:48:25 +0100
Message-ID: <20260213134704.963899569@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134704.728003077@linuxfoundation.org>
References: <20260213134704.728003077@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -223,15 +223,13 @@ static struct iaa_compression_mode *iaa_
 
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


