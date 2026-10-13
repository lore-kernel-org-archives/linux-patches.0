Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36244FC8ED;
	Tue, 13 Oct 2026 12:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895260; cv=none; b=SjT0M6+tfDBL/fXrC9OiM4vUThgUL+L8SOvYbGemP+3OBlivaElQjKY1BZyQGjbcRQmkxEF4OXJAShh5b1Ko9tFqC0iygdV+6B3erpQeb26Ku3anyainI+EB9oEQAFCGM4+8BOvbGJZc3pz4ssKtPCAdKDDDV5AH0UvtH7A4zNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895260; c=relaxed/simple;
	bh=0N6QSHpMdlm1U+O6sTuxkveVUYRUP+evJf+Ui8V7b8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fI2tUpHt6l+jwS7geNqfE5qF79xK/XPgeUSbrRoBSCxk6BOl7yePG4sgpnm0O7ZjhxQbLScsW1VHMf1Zj4LKx9lzVlT78oU9JPbXhOPcXGJmT2bgDzVLc87EkD+iO4oYsHVpjg7qD54BNob12prJSfa2o2oqMOZppsAbHZ7oTxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WVFS30Kc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WVFS30Kc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B301F000FF;
	Tue, 13 Oct 2026 12:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895258;
	bh=IwQPWYXsWRsH9ybiU5jPcLEaBWXuOVOoF802lskoIKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WVFS30KcaTPXOR2PLlhyeq+pvnmsDERh5O/0BwBs9ZCmrKQXBTzVl9+rCTH/XItwm
	 e7eSFSblYBd6fOkbMuU/6i6sdviJnkP9Aa7YSXa3X++wedBGlmr+ST/Odgx/J8n1p8
	 eNDAhKTWfZvpmuXnUh3WBaZoKswObJ8bLnVLzRAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Yuqi Xu <xuyuqiabc@gmail.com>,
	Ren Wei <weir@nebusec.ai>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 213/497] wifi: mac80211: handle empty FILS association request payload
Date: Tue, 13 Oct 2026 13:36:20 +0200
Message-ID: <20261013112912.948173304@linuxfoundation.org>
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

From: Yuqi Xu <xuyuqiabc@gmail.com>

commit 5bfd4b0b40b79781d900cb2f7da0685070f53c67 upstream.

fils_encrypt_assoc_req() accepts a (Re)Association Request frame whose
last element is the FILS Session element.  crypt_len is then zero and
aes_siv_encrypt() is called with an empty plaintext.

kmemdup() returns ZERO_SIZE_PTR for a zero-length allocation, so the
unconditional sg_init_one() puts an invalid page into the scatterlist.
With CONFIG_DEBUG_SG this triggers a kernel BUG in sg_set_buf();
without the debug check the bogus page is handed to the crypto backend.

AES-SIV is defined for empty plaintext and the S2V result is then the
complete output, so handle this case before the CTR step, which has
nothing to encrypt.

Fixes: 39404feee691 ("mac80211: FILS AEAD protection for station mode association frames")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Signed-off-by: Yuqi Xu <xuyuqiabc@gmail.com>
Reviewed-by: Ren Wei <weir@nebusec.ai>
Link: https://patch.msgid.link/325c048982d637a3af80d74ac5b36e9369b93f1e.1789751126.git.xuyuqiabc@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/fils_aead.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/mac80211/fils_aead.c
+++ b/net/mac80211/fils_aead.c
@@ -95,6 +95,14 @@ static int aes_siv_encrypt(const u8 *key
 	if (res)
 		return res;
 
+	/* With an empty plaintext there is no ciphertext to produce and
+	 * the S2V result is the complete output.
+	 */
+	if (!plain_len) {
+		memcpy(out, v, AES_BLOCK_SIZE);
+		return 0;
+	}
+
 	/* Use a temporary buffer of the plaintext to handle need for
 	 * overwriting this during AES-CTR.
 	 */


