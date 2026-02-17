Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379C336F431;
	Tue, 17 Feb 2026 20:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771360985; cv=none; b=YoaAOzJfpUlvKPMpn+GLopg4AgaAtupBmN53ZN4FLkEU6eLv2aLD5rCbECMhzwABjSQymms/jxynetc42kgmj3OnZXRsit7RlsuyyElbVSgUzgt1Qd0JO+KTGd9NgoH2OzBxnC/XjDM7b1cqDHin9pZaHdA44EiiCn7U4pbPK/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771360985; c=relaxed/simple;
	bh=4Jzo/rChetiVHGLyvxTTEg9fs63oT0lNcHEg2XJ1O4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mX0GYIit38BeQ+L/VtHtvca0+ipCr7f9GQi9etpyLwzS6hoz/9K5J2TEKt3wOh91GuIlRK5AnI4d4YqThFhZQfMa0mrnxbnxXpLUhLi41APLh48Uf/LfolvBYBMxum4kolkw6/iY9QLjIDDHr20kJNIasfiyMNqQRwWjFrgj+XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mUHza2yE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mUHza2yE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F77FC4CEF7;
	Tue, 17 Feb 2026 20:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771360984;
	bh=4Jzo/rChetiVHGLyvxTTEg9fs63oT0lNcHEg2XJ1O4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mUHza2yEbAqdgbDxPDd7SVU99uCsnOmNu2m/DP7npac8B4G+qKT6YQhqpCxCUr/jb
	 GlV3q182iswKr0bsbBlq6yhGqkBI8VrvFHW8VmpQe+YX0iaNMECMFPHsq5vwbUc4jw
	 sis7GREx+zPocjtaKLfeB3ZN8LZQ+A4t/lh5X++Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.10 01/24] crypto: octeontx - Fix length check to avoid truncation in ucode_load_store
Date: Tue, 17 Feb 2026 21:31:14 +0100
Message-ID: <20260217200000.768049926@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200000.708219618@linuxfoundation.org>
References: <20260217200000.708219618@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit 5565a72b24fa7935a9f30af386e92c8c9dfb23b9 upstream.

OTX_CPT_UCODE_NAME_LENGTH limits the microcode name to 64 bytes. If a
user writes a string of exactly 64 characters, the original code used
'strlen(buf) > 64' to check the length, but then strscpy() copies only
63 characters before adding a NUL terminator, silently truncating the
copied string.

Fix this off-by-one error by using 'count' directly for the length check
to ensure long names are rejected early and copied without truncation.

Cc: stable@vger.kernel.org
Fixes: d9110b0b01ff ("crypto: marvell - add support for OCTEON TX CPT engine")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
@@ -1337,7 +1337,7 @@ static ssize_t ucode_load_store(struct d
 	int del_grp_idx = -1;
 	int ucode_idx = 0;
 
-	if (strlen(buf) > OTX_CPT_UCODE_NAME_LENGTH)
+	if (count >= OTX_CPT_UCODE_NAME_LENGTH)
 		return -EINVAL;
 
 	eng_grps = container_of(attr, struct otx_cpt_eng_grps, ucode_load_attr);


