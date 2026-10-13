Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9044F3EC2;
	Tue, 13 Oct 2026 11:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892408; cv=none; b=Wm64apq/jr0RBUkiHir9a3b57pvUUTXJqa0F7rGDJrn6RMDfWhF+AGQUXTb/Ytm5ocPcbiqNZKGSrvXRDrwZ/Dm3xF1RKauTQ/mzUig0Y+MU1E3Ht0RZrio2aQTV/71D2jJ3mYPGUtZOe7mGU4hkeoqcYvsbDfpBXz4kubCGjUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892408; c=relaxed/simple;
	bh=+BJIqyGXCkD1zJrNQ7l+vexwhU+xS5vslzKVWZ3F90c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wlh7+4Y3Ljub26W7+qM3FwqBUS37K8EZYlLVw6QCA6Q9jai+mp/dMrHL0mF6aaKFUeZ5JStLldS7qtRxd51q0y6zd4IIi1P1dUYoYsd0PVyGslovNszHSs9m1eEFczTHA9ShSm9JqS6rlkiLxqxmyK7D1HesqezsMOeGjykeBGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PpjQpt5A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PpjQpt5A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5BEA1F000FF;
	Tue, 13 Oct 2026 11:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892407;
	bh=tyrpXM3BsMXPBZgEfvI3gQh3kk2lFfAV6BFlZRd3aw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PpjQpt5A/O/EUsHWkaiFT0Ijpruk4Iro5Ewz8ma/9fiX300qGuvp6nxmgdoBXXKxI
	 MFFi2s1Q6qw1JoujdU5CoLpKzpU5xF1v94ugJoTLIgYLTSurV3M02wQRaY9q3OqkJw
	 o9YmPKJCi9LPP9W+IyiooW3mKn/tybV3ikENo86s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Karas <krzysztof.karas@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 7.2 126/281] drm/i915/gem: Prevent overstepping exec array boundary
Date: Tue, 13 Oct 2026 13:37:22 +0200
Message-ID: <20261013112858.207195590@linuxfoundation.org>
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
@@ -1766,6 +1766,7 @@ static int eb_reinit_userptr(struct i915
 
 static noinline int eb_relocate_parse_slow(struct i915_execbuffer *eb)
 {
+	const unsigned int count = eb->buffer_count;
 	bool have_copy = false;
 	struct eb_vma *ev;
 	int err = 0;
@@ -1868,7 +1869,6 @@ err:
 
 out:
 	if (have_copy) {
-		const unsigned int count = eb->buffer_count;
 		unsigned int i;
 
 		for (i = 0; i < count; i++) {


