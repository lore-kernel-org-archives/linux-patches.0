Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAFEB3A7F41;
	Sat, 17 Oct 2026 17:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256689; cv=none; b=E0TmdHY3DEzMEowxDtHBgnXVGZqTc4AE8QclEf+iIf5+lWd59bvrbxDRgYUYhvhrtzgtayvFQEmhOePJjMmlaKdZMcIO5pG1NCDcPfyMRixuLMQOchA0NzXcj/WWq1H8pxyMLvPT9/eRQc0RrZFgzNNg+Mrt3JfQUvWKWp4maKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256689; c=relaxed/simple;
	bh=OmkodR6mXBfZCgGwKjohFSvdx/vMaZW/RCIjNS1aNXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VfrsKIpzWptT+tlh6/SGUCwsWGJXveHPN6skDwSqGEAxzoE8lV1PDA/OPRdqTEg4N2+BSDAYdVAegvsIV6Q4gzPKw0wpEhH+3uDgpo5K8THQaRUP21rCtUp0i80GXK92gxAq37I0YA1oSTH5b8UoLDbFAAPku+bWZPEeUupoZhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AJS6JMC4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AJS6JMC4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 332A21F000C4;
	Sat, 17 Oct 2026 17:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256688;
	bh=5MvctYcW0dI9xVmLEP5NF5IejBja1ajHHftCgJhys4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AJS6JMC4wkb99sIHKgwjviYqW5FzmxJEifa5LgCGMR0uUg7eYFY1Hivflg0a8A1hi
	 9NZDR9ooYZkxetunMfWmWJdak2oh0aSxykZdSJ28CBlSIzCxq6hAU0sinTCI2AZdew
	 HPvHL4uCfMvSOk6bENL8u1xmOUyP3rpH1SH6N+u4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Yuqi Xu <xuyuqiabc@gmail.com>,
	Ren Wei <weir@nebusec.ai>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.6 0319/1674] wifi: mac80211: handle empty FILS association request payload
Date: Sat, 17 Oct 2026 17:43:11 +0200
Message-ID: <20261017160439.306284049@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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


