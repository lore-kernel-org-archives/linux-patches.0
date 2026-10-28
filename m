Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211450;
	b=P6wfc20wdNGPs/niaY4OZM/4gP5Qo8sfnG0HeGHzBcyAerRhO4lXsTGiKqU6Vdqbjo7m
	 ewD7L9jgIlmVOIvWtSUMCMnep6tVt6RaZBalWbsZ209R41uPhYHOl4slCQfuwgfgjhXy/
	 T7W8WJX1aL+wXC0IBh5dfz0IFNUns/VGGFrV27BV03R052U4yezI1K2nqCVIeJKpnIlvI
	 +I+lgQHGTeiuS2y2JEh6Y/fJulYK6ISFT30rppfKmn7w8yNIp5W/wa30PzlLOYqXY5GO3
	 DkhqWRPB9f3waSWzOuJt2nCK1QtaCJZenmvBwTtrZb5wzQ2+0eHxZzavOeH2j3KRGLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211450;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NE17UsujZdf5RJAWV6j0za+Wg03TiLRCBRAHEl6HoeU=;
	b=Mw4/IkCOaCFhz/da9TTh+vLJ3bpWV2wRb//ZR8kS8c2zbJDhrjhIOQ2aEJMRPql8XIYq
	 koQCVW5gEJLcjdHlfN1bRbP+HEfeCdgxGH/296YHcn1wJSVCEJ/dMZJMOFPi8EURPiotD
	 WjHCqq/UDZ6qs5vUXVQxvc6BcQkju38nZrUz1af2kFAOTe9WNdRbwPirqKxUTzJCKkgqi
	 aPQhc4EbjxyzzjfOUZo9nm5sZPvt/UewzwqEIVXVpyHMYXpshMY+dKXDM39OD+QVZ+ogW
	 R0HJsQfQThLUtjrIDmCfAGnlnDwdFOue18KRa7vR0ezDuAK3cAS+XBHSO7KqjZK46zA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fT6NGh4S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B78E606A31A;
	Wed, 28 Oct 2026 18:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fT6NGh4S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA34C1F01825;
	Wed, 28 Oct 2026 18:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211450;
	bh=NE17UsujZdf5RJAWV6j0za+Wg03TiLRCBRAHEl6HoeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fT6NGh4SI0AK50LQU3a8OMs8gBWDvS8tN/fpZafT5TQZzTapYXTO+2zuuiOIoWDko
	 C6vMze817X7Ufx+YsA6rFDIQ3J36M0wj4dMcvgnGhZ8dIllFLZugSj8TXm8U7Do4Tq
	 YANaB6pKWjQogZW19JIBTClMoYe1+SRVFr7Qv0iM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Karas <krzysztof.karas@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.15 383/571] drm/i915/gem: Prevent overstepping exec array boundary
Date: Wed, 28 Oct 2026 17:58:50 +0100
Message-ID: <20261028170017.100908840@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1680,6 +1680,7 @@ static int eb_reinit_userptr(struct i915
 static noinline int eb_relocate_parse_slow(struct i915_execbuffer *eb,
 					   struct i915_request *rq)
 {
+	const unsigned int count = eb->buffer_count;
 	bool have_copy = false;
 	struct eb_vma *ev;
 	int err = 0;
@@ -1804,7 +1805,6 @@ err:
 
 out:
 	if (have_copy) {
-		const unsigned int count = eb->buffer_count;
 		unsigned int i;
 
 		for (i = 0; i < count; i++) {


