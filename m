Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D024FD27C;
	Tue, 13 Oct 2026 12:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893104; cv=none; b=aMXLsql90rd/+9r9Fd9GuT4Tin+IQv9IZJoSgyzosR5wpXxJ9UbYBKgaR85rZOQ3g+xsNgRw84E+pOfqfDFayNj9gj9hH2qrc0pVTNcGgfdZB0BISu4fcyfGl0fpoOfhvMYJBu4a1bW90tOEYH7y8Z93JjshY7kCqROE++AWGkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893104; c=relaxed/simple;
	bh=USsN8ma48Kr+eRwFcD1pbYXCQqNHPb6WWRdhAkT9U/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PuEBLh8wnS2k9HRKV6NE4EvLesTO4DPeyu9gPvZ6kOppV4bZ7kgu/j0ZwzpJL4L2FGXxGTGIlupY68W799rPU/WzZ4Srx933j6IJx+RCvrgCrE6K7rrb34MvWUyqaqM0QMbbA0oFSbbgp7tCqHsYYL/+zvN9jpavjO8jekZpVfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D8E/nuZ3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D8E/nuZ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA5A41F00893;
	Tue, 13 Oct 2026 12:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893103;
	bh=hA/F+n0psDyO2P2n8gB+jT0kafIXXNOYRQemRIMImPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D8E/nuZ34ieKZoNca6hY1oHJkji2R8O1oZ2T8/x0OMCEIsXoTC/2wCigAT6yG94N/
	 VvGKCxk5FRVSK7HkcYXR2nB3m8nWq+oQ/NPQ+ex9tvTrmrQNJONZJNMPzgmb23DOxD
	 hTxWTjgM3bM+16WU6uYib60RoIXG21eeEVJbUEJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Cressey <ben@cressey.dev>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 069/621] dm-crypt: reject the lmk IV mode with AEAD ciphers
Date: Tue, 13 Oct 2026 13:31:04 +0200
Message-ID: <20261013112922.495706119@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2974,8 +2974,13 @@ static int crypt_ctr_cipher_new(struct d
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


