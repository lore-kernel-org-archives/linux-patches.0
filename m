Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209082;
	b=5kLS2NtUc9ZQLwuCpBkXweOV3BXSKeLLw0ElgFpSELjStuJIsr9+I4odyYHAIfJd50YK
	 gjiuFPapj4IRQSOWPLQn1/ks8KwsnmG3qBy2lfE8FA67boZcsfbaFJyUHAgJu8sST10Am
	 JP56i1Nn+3cPcSmJ/Cd2hArWdhAyjqKCC69sYkguXSrdgtbGbjyOm5AU0Xb/0x27S4xPX
	 mG1IcsSZ1mVtTkCDk2I6JpJsAg2IUy5Vej7pIRNWj4VFKO7ACD37mahBasPaAWV+rYPTT
	 nm3ofXYp1q53W+Er6v/UzERGhiW/DTDGxltCdZ1GC13tn2MhPwObPAgTz0FHM8rRVTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209082;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HNIqWM9YPY5XQ8pcGUb9L707B5JANjo2Wc3yfFKfIc4=;
	b=F9yt/L+42w+Krn8ewIDVXRablee6IFOa8sIkZGg1XBWvua2HBPS2Vym924qHYlEXWQuT
	 5FdKW90e1H4CqbCpuGEVAS4fUVqhJ9uw1+Y2IL+QGJWlc7kBrpUHjsqeoiLAJgJ/6Q8r5
	 Wr7/zdf3ZwxO2jNOUfWBQNeZVZ8c5CsxtrvQR0WCMqzrb2+KBxxqnsesCn/KIq7EISgXQ
	 m8L5yX+zelOjMWTzyUMFbYcky2SZmIxqSARM3XHrnh2/O7SuwrwF5/fKOh8YoP+akljVg
	 D3F0i+Yc9TKD/uNuO2EJ9sc+CQnLHI3kzn2vXiOrWmhog2PmPRCJInHc86g1ZpPn0Rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Ey/vizKt";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C591606A339;
	Wed, 28 Oct 2026 17:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ey/vizKt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD7B1F01825;
	Wed, 28 Oct 2026 17:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209082;
	bh=HNIqWM9YPY5XQ8pcGUb9L707B5JANjo2Wc3yfFKfIc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ey/vizKtybRRMwB/p8FzQZKG65PW+Lv3zvi+SJB8P1lTv7KnX5/Wj8PChRBZB16tk
	 Cmm6KefqzJ9+zZ15iQcZIh1cXlszTAA6iYDVQ76H65PCS1bpUXkpl/IbmPX7N2SLJA
	 z5NxNKsyx8MGUeSA/R/o8Y6JhKiFldu/sPsCnSxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Karas <krzysztof.karas@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.10 346/516] drm/i915/gem: Prevent overstepping exec array boundary
Date: Wed, 28 Oct 2026 17:58:18 +0100
Message-ID: <20261028170011.686163670@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Karas <krzysztof.karas@intel.com>

commit ebe162db655881a38de43301151ff7ac940602b5 upstream.

It is possible for eb_relocate_parse_slow() to call kvfree() on
entries outside the original exec array during following
scenario inside eb_relocate_parse_slow():

1) eb_copy_relocations() allocates as many as eb->buffer_count
   copies for exec entries;
2) eb_parse() appends up to two VMAs, right after incrementing
   eb->buffer_count;
3) cleanup under "out" label uses this incremented buffer_count
   to release relocation pointers from exec array via kvfree(),
   not from VMA array.

To amend this problem, ensure that relocation cleanup uses the
original exec object count, excluding the VMAs appended by the
command parser.

Fixes: 8e4ba491b0ba ("drm/i915: Parse command buffer earlier in eb_relocate(slow)")
Signed-off-by: Krzysztof Karas <krzysztof.karas@intel.com>
Assisted-by: GitHub-Copilot:gpt-6-astra
Cc: stable@vger.kernel.org # 5.10+
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patch.msgid.link/20260911061145.3535489-1-krzysztof.karas@intel.com
(cherry picked from commit 2a0158925fb943c7ba8f3216e2734952128defc9)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -1902,6 +1902,7 @@ static int eb_prefault_relocations(const
 static noinline int eb_relocate_parse_slow(struct i915_execbuffer *eb,
 					   struct i915_request *rq)
 {
+	const unsigned int count = eb->buffer_count;
 	bool have_copy = false;
 	struct eb_vma *ev;
 	int err = 0;
@@ -2028,7 +2029,6 @@ err:
 
 out:
 	if (have_copy) {
-		const unsigned int count = eb->buffer_count;
 		unsigned int i;
 
 		for (i = 0; i < count; i++) {


