Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038743;
	b=El91/VT53B1BCljo8NJNZpMaVGRyxcgpqyU897mmPPS3EEeO+zCgpcs8PES2I8ysS+fo
	 RVz468UEDLW3MgGvKoJN57EK6QKiVEeDWUw0x8D3aBLPhthtB1A7HV98axoEAmeL4RHuQ
	 tKYbWU9yv+Qc6JeuTjzk4P7UMIzBc/wZovame9+6hPkucJMl+OYgvG+eEP7IwzNC+PLZP
	 kR72d2CWbq0m+exp8g9HQsk6g+rTAILfv3Ubr5+eocreMkVEtOEaub9QjalHPwV5KGmc/
	 SXFMs3Tz60QzVOASB3/PAKTQfOtPoi1q+9xNQgJVfIFbBikUoOljE4+KepNpl7o+Ljw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038743;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/bGdyC4Ni5plIUJi8TPvlSvK3a32T/sNCox0lK2B/yg=;
	b=u65G3mJd+CDSCAQJvdsmD48NBMeqUF2GAXFXXbk9VhQOwjvHZfG6KwPR2kq466r8aiR+
	 G8x1V7JMXa1e3iyS3e5QTBKHKmHF8v0hV6ICSMbn0WoyWpgUAjJeD3/AQwO0+SQvrv3nx
	 0Z0VCwd7AfDAwaWFrxUlsgur8z/GFxynCiD3W4xxQcvFfnA/v55oWNi/btf1oNlWGBZ2Q
	 hi6pv3+HeW2vwJ/dAYVT+OyTOElmeCkIyYo4SK60xBXDUKB50SKCt9XcHLU+kwE6P9ps1
	 mHxHn0QW2TZcvQMTK0IMbxU1sp5kvD5i7G1mk+JiOahBiZAeIMRkgsYAOsT+7YmSbJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ahhlyFjn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A77606A325;
	Wed, 18 Nov 2026 21:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ahhlyFjn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 570361F000C4;
	Wed, 18 Nov 2026 21:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038742;
	bh=/bGdyC4Ni5plIUJi8TPvlSvK3a32T/sNCox0lK2B/yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ahhlyFjnyB983rJO+K+HYBrOMXKbJE76IMmU0SrtrvmJZugV+TvIDzBG1HNHrOm+N
	 rRIxglMzg2aZWVn2hXQBVEully50kFQEczAWDoq9tfooWQdPNbSoylvOeBmJC34Eon
	 uP/2islVwmHQxmWuSh/P68m2vWrW1eMFxB5wjcM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Howells <dhowells@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1851/3318] assoc_array: dont lose objects when a root shortcut is split at level 4
Date: Wed, 18 Nov 2026 15:41:13 +0100
Message-ID: <20261118150417.396831587@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 20b436c1ae8d37032f888c725915729830dc52f2 ]

assoc_array_insert_mid_shortcut() takes level, the level of the node
holding the shortcut as assoc_array_walk() reports it, and adds
ASSOC_ARRAY_LEVEL_STEP to get the level of a node in that shortcut's
place.  If the new key first differs from the shortcut no further in
than that, no shortcut is made in front of the split, and new_n0 takes
the old shortcut's place directly.

A shortcut at the root is held by no node.  assoc_array_walk() reports
level 0 for it, and whatever takes its place is the root, which is read
at level 0.  So when the new key first differs from a root shortcut in
bits 4-7, diff is 4, no shortcut is made in front, and new_n0, whose
slots are indexed by bits 4-7, becomes the root and is indexed by bits
0-3.  Objects already in the array can no longer be found, and the new
one lands in a slot its key does not select.

Eighteen keys are enough: seventeen that agree on bits 0-7 make the root
a shortcut, and one that agrees with them on bits 0-3 only splits it.
Three of the eighteen objects can then not be found, and inserting one
of those keys again adds a second object instead of replacing it.

Only add the step for a shortcut that hangs from a node.  A root
shortcut split at level 4 then gets a shortcut in front of the split
that ends at level 4, as assoc_array_insert_into_terminal_node() already
makes when the leaves of a full root node first differ there.

Found by a userspace test that builds a shortcut ending at every level
and splits it at every level inside it, from the root and from a node:
every split of a root shortcut at level 4 failed, and nothing else did.

Fixes: 3cb989501c26 ("Add a generic associative array implementation.")
Assisted-by: LLM
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Tested-by: David Howells <dhowells@redhat.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/assoc_array.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/assoc_array.c b/lib/assoc_array.c
index 62e35116db19c..e7c9a2f513114 100644
--- a/lib/assoc_array.c
+++ b/lib/assoc_array.c
@@ -843,7 +843,8 @@ static bool assoc_array_insert_mid_shortcut(struct assoc_array_edit *edit,
 	 * zero length - otherwise we just connect the new node directly to the
 	 * parent.
 	 */
-	level += ASSOC_ARRAY_LEVEL_STEP;
+	if (shortcut->back_pointer)
+		level += ASSOC_ARRAY_LEVEL_STEP;
 	if (diff > level) {
 		pr_devel("pre-shortcut %d...%d\n", level, diff);
 		keylen = round_up(diff, ASSOC_ARRAY_KEY_CHUNK_SIZE);
-- 
2.53.0



