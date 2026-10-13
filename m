Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E61389104;
	Tue, 13 Oct 2026 12:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895786; cv=none; b=LScqaAjY7nJVbF5+u+JfzJDcvF7zT1HGJ79pyKUURhCSXtL5iVmowZaXGj1io6NfQmNNkyRicR4fTFeACsENKslefP/O/jHBdoBtjG3SjKtpI3OwsYqU6fsZadOeymBFDjzq/TXqJwqIZLolE+/HcTORdH7PjOs6RzKhQAdZegg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895786; c=relaxed/simple;
	bh=dS2Sxpbr6U76DuZqaVnAJCRFeVMi+cmJsK+JPd7N0ZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mwRGqMp5lSMNcT57qbXuGbDE/TPrDmuWDhFQ2PpKfIzne7Fb+QByeYzae7BChellrSr4Cs9aqB0yyZrOvOkGj/+9T7sf5riaKkuAEhn2y6uzfUvUI/2Ng/aCkGr1s98r/tnoZXdkfJSoOk3DsOo9hyaS2CbbbQU6AnIeSnAyVRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dLKasAN1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dLKasAN1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D7A1F000FF;
	Tue, 13 Oct 2026 12:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895785;
	bh=gYKOxB7X/CC2aeJ4cQYOr4yhHvVT56ylNgCkN5/Npk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dLKasAN1LEkWyWpXegqQHlPmAyPKtz5mM5AOv9su8uJH8YU2DpTTvlXJlYQn3/irm
	 hKp0wS0IgWttpdoVY0OOdIC20ROOs/N5SGqdep8XL/7z/D335+wpLgRk2TK26221jH
	 E1CoCv4mdfOiV1+2wWrdowF9XkGwQt9mSKgNpb5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Cressey <ben@cressey.dev>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 392/497] dm-crypt: reject the lmk IV mode with AEAD ciphers
Date: Tue, 13 Oct 2026 13:39:19 +0200
Message-ID: <20261013112917.197637726@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
@@ -2995,8 +2995,13 @@ static int crypt_ctr_cipher_new(struct d
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


