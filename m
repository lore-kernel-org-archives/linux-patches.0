Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7C94988B;
	Mon, 18 Dec 2023 14:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o0AYkXJj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9518C433C8;
	Mon, 18 Dec 2023 14:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908717;
	bh=B8H/II7mwe67BSqBDnIOmXaQbE7rg4X7QnEla4L9ujs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o0AYkXJj0TfJfgZNaaenlInv7jnxQcZSBEai3eyPibh7WIv6l0YapX2yzKOFTgawD
	 m1voMfY4S1ULvz6rZOZOOQ0fzqXjPEcuIs7VwdGwwsrLnzr8q57wLelgItm6E5hrsf
	 LZRndMqcnfTyxzWzCMFKs4o1PjJri8SuGOal+zeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yusong Gao <a869920004@gmail.com>,
	Juerg Haefliger <juerg.haefliger@canonical.com>,
	David Howells <dhowells@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 12/40] sign-file: Fix incorrect return values check
Date: Mon, 18 Dec 2023 14:52:07 +0100
Message-ID: <20231218135043.166653116@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135042.748715259@linuxfoundation.org>
References: <20231218135042.748715259@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yusong Gao <a869920004@gmail.com>

[ Upstream commit 829649443e78d85db0cff0c37cadb28fbb1a5f6f ]

There are some wrong return values check in sign-file when call OpenSSL
API. The ERR() check cond is wrong because of the program only check the
return value is < 0 which ignored the return val is 0. For example:
1. CMS_final() return 1 for success or 0 for failure.
2. i2d_CMS_bio_stream() returns 1 for success or 0 for failure.
3. i2d_TYPEbio() return 1 for success and 0 for failure.
4. BIO_free() return 1 for success and 0 for failure.

Link: https://www.openssl.org/docs/manmaster/man3/
Fixes: e5a2e3c84782 ("scripts/sign-file.c: Add support for signing with a raw signature")
Signed-off-by: Yusong Gao <a869920004@gmail.com>
Reviewed-by: Juerg Haefliger <juerg.haefliger@canonical.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/r/20231213024405.624692-1-a869920004@gmail.com/ # v5
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/sign-file.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/scripts/sign-file.c b/scripts/sign-file.c
index 7434e9ea926e2..12acc70e5a7a5 100644
--- a/scripts/sign-file.c
+++ b/scripts/sign-file.c
@@ -322,7 +322,7 @@ int main(int argc, char **argv)
 				     CMS_NOSMIMECAP | use_keyid |
 				     use_signed_attrs),
 		    "CMS_add1_signer");
-		ERR(CMS_final(cms, bm, NULL, CMS_NOCERTS | CMS_BINARY) < 0,
+		ERR(CMS_final(cms, bm, NULL, CMS_NOCERTS | CMS_BINARY) != 1,
 		    "CMS_final");
 
 #else
@@ -341,10 +341,10 @@ int main(int argc, char **argv)
 			b = BIO_new_file(sig_file_name, "wb");
 			ERR(!b, "%s", sig_file_name);
 #ifndef USE_PKCS7
-			ERR(i2d_CMS_bio_stream(b, cms, NULL, 0) < 0,
+			ERR(i2d_CMS_bio_stream(b, cms, NULL, 0) != 1,
 			    "%s", sig_file_name);
 #else
-			ERR(i2d_PKCS7_bio(b, pkcs7) < 0,
+			ERR(i2d_PKCS7_bio(b, pkcs7) != 1,
 			    "%s", sig_file_name);
 #endif
 			BIO_free(b);
@@ -374,9 +374,9 @@ int main(int argc, char **argv)
 
 	if (!raw_sig) {
 #ifndef USE_PKCS7
-		ERR(i2d_CMS_bio_stream(bd, cms, NULL, 0) < 0, "%s", dest_name);
+		ERR(i2d_CMS_bio_stream(bd, cms, NULL, 0) != 1, "%s", dest_name);
 #else
-		ERR(i2d_PKCS7_bio(bd, pkcs7) < 0, "%s", dest_name);
+		ERR(i2d_PKCS7_bio(bd, pkcs7) != 1, "%s", dest_name);
 #endif
 	} else {
 		BIO *b;
@@ -396,7 +396,7 @@ int main(int argc, char **argv)
 	ERR(BIO_write(bd, &sig_info, sizeof(sig_info)) < 0, "%s", dest_name);
 	ERR(BIO_write(bd, magic_number, sizeof(magic_number) - 1) < 0, "%s", dest_name);
 
-	ERR(BIO_free(bd) < 0, "%s", dest_name);
+	ERR(BIO_free(bd) != 1, "%s", dest_name);
 
 	/* Finally, if we're signing in place, replace the original. */
 	if (replace_orig)
-- 
2.43.0



