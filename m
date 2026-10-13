Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3FD4EDCBB;
	Tue, 13 Oct 2026 11:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892145; cv=none; b=YCuanNEJL3SCcb+J/uaSg7DpnUMZ9xcri4JLLcdL2DykGKHIb9xHxxMXvROpGJNaCTPONTGYz3kklA1srbil5Raevhvh4Q1b9EnyX/msbFOXlvgWYpt73aWcuV1ePgRSENMHzJRWR8/pH8mwPetbVSyP1wn7pajK5LqgdGjQ2Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892145; c=relaxed/simple;
	bh=3uf5dez19OU4YN1XpU/Up8cR/ebHLuva6jLguxbYT54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ja7FfMq89Pos3tyXzvM3AHpdrmvjjJc5ePAX+JZI8Kv2pSLwbV6su+pEEnwO1zGFKcLzR+RxX9MvltbS+CiNJD9OtBRBNofSGqRwH67IzUCHTXTu8djpQRMoQcfvWvylUmdQuklhBmRoIwBdm/yb2BMFJ3VYOe05zb6lxzGk8CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cn2Amfn4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cn2Amfn4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 850651F000FF;
	Tue, 13 Oct 2026 11:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892144;
	bh=iMyii9ZuIMK/ibJUqdRq29Lq6gbfbi5foiSUBKEY+YY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cn2Amfn4Djxk3ZxjHk5H+rgggb+VKB1Wn5z+B1/v4Rb845l3GmrzYyygj9ynhQg1b
	 0PTBis4yLqHSUudhEa4D9dZq9WoiPx2YRZbUDSNNn2JWyAz1+QWcdEc8VnKMBhLBxz
	 T22IsXaG8FDZwTUEV9E4a9FZclUiP+OOUyNn69QM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Cressey <ben@cressey.dev>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.2 073/281] dm-crypt: reject the lmk IV mode with AEAD ciphers
Date: Tue, 13 Oct 2026 13:36:29 +0200
Message-ID: <20261013112856.900606357@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Cressey <ben@cressey.dev>

commit 3195e0daf590683992edb4eed32269e569e04924 upstream.

A "capi:" table line that pairs an AEAD cipher with the lmk IV mode,
for example "capi:gcm(aes)-lmk" with the integrity:28:aead option,
causes an oops when it is loaded. lmk sets tfms_count to 64, but
crypt_alloc_tfms_aead only allocates one transform, so crypt_setkey
reads past the end of the tfms_aead array and calls crypto_aead_setkey
on the values it finds there.

lmk exists for compatibility with Loop-AES, which uses CBC, so refuse
it with an AEAD cipher rather than allocate 64 AEAD transforms. The
check cannot go in crypt_iv_lmk_ctr with the other lmk checks, because
the IV constructor runs after crypt_set_key.

Note that this is not a security bug because the memory corruption can
only be triggered by root.

Fixes: 33d2f09fcb35 ("dm crypt: introduce new format of cipher with "capi:" prefix")
Cc: stable@vger.kernel.org
Signed-off-by: Ben Cressey <ben@cressey.dev>
Assisted-by: LLM
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-crypt.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2895,8 +2895,13 @@ static int crypt_ctr_cipher_new(struct d
 		}
 	}
 
-	if (*ivmode && !strcmp(*ivmode, "lmk"))
+	if (*ivmode && !strcmp(*ivmode, "lmk")) {
+		if (crypt_integrity_aead(cc)) {
+			ti->error = "AEAD transforms not supported for LMK";
+			return -EINVAL;
+		}
 		cc->tfms_count = 64;
+	}
 
 	if (*ivmode && !strcmp(*ivmode, "essiv")) {
 		if (!*ivopts) {


