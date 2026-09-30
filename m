Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A75517BD9;
	Wed, 30 Sep 2026 17:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788025; cv=none; b=aRXhLZ6zP4TDFIQE5GUpprS87oIqDlzs5qFC2s/mMr/F9oHPgoPIb7aEeU2n8s8NB+6nIEifE+CU5ifyCBuvzIF2zm6/KVlazTdAKX7apcnfEkrnSVAAMxYlz+CYhC7qo56GfrEjJQsYVlpAt/Yoa0RfocEazy6Zrdy4NU4qL5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788025; c=relaxed/simple;
	bh=whGjD4NAhJcxB72EscxjapgenohhhTWDBifWybmh1Bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GTmbf+kJqNSWHGbOEeO3ClwQlDEN8nSftg0FSgC2K90cjLlDQgE6nKRRcnALD8MCrKH4ZSmjHHDblFM+jNW1p5vfzmQUzYOPqEnEw46XXis3mpsyc/V7pYa2Bytqo0Yarj5VY1oN1K2+WReKDEs6/xU0EzmYGpXwh3v+DN8I76g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h60utHNZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h60utHNZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D151F000FF;
	Wed, 30 Sep 2026 17:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788024;
	bh=R/+t8j9tf373SwtFaLy3efpelNdSy1XeJrIaGbglc0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h60utHNZFAWLWKmELrzAfqHj7h28uIUgzFssITbO7GDv3CDoU/VId7aF51ZdCpoFo
	 k0A36PpQ+F+45y56RLmSLJYVfoYmkBON7GpMO4jmJg02fVV16FijUO9IHru7Jcl7ea
	 6UdaCFDTkqIxuMkhoqxBz9i46NJKPA1joPJ3v5h8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 7.2 435/457] landlock: Work around gcc-16 -Wuninitialized warning
Date: Wed, 30 Sep 2026 17:29:00 +0200
Message-ID: <20260930152355.383365142@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit c4e941bb7654bcbdfb0b6f3341dc2acfdf235c8d upstream.

gcc has a bug with -ftrivial-auto-var-init=pattern that produces a
warning for correct code that uses sparse bitfields:

security/landlock/fs.c: In function 'is_access_to_paths_allowed.isra':
security/landlock/fs.c:767:28: error: '_layer_masks_child1' is used uninitialized [-Werror=uninitialized]
  767 |         struct layer_masks _layer_masks_child1, _layer_masks_child2;
      |                            ^~~~~~~~~~~~~~~~~~~
security/landlock/fs.c:767:28: note: '_layer_masks_child1' declared here
  767 |         struct layer_masks _layer_masks_child1, _layer_masks_child2;
      |                            ^~~~~~~~~~~~~~~~~~~
security/landlock/fs.c: In function 'hook_unix_find':
security/landlock/fs.c:1649:28: error: 'layer_masks' is used uninitialized [-Werror=uninitialized]
 1649 |         struct layer_masks layer_masks;
      |                            ^~~~~~~~~~~
security/landlock/fs.c:1649:28: note: 'layer_masks' declared here
 1649 |         struct layer_masks layer_masks;
      |                            ^~~~~~~~~~~

To work around this, change the definition of struct layer_mask to
use an explictit padding field.

Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=110743
Link: https://lore.kernel.org/all/20260619082133.3504146-1-arnd@kernel.org/
Fixes: a260c0055665 ("landlock: Add a place for flags to layer rules")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://patch.msgid.link/20260915201036.3527935-1-arnd@kernel.org
[mic: Use BITS_PER_TYPE(), fix kdoc warnings, fix commit message
according to v2 changes]
Cc: stable@vger.kernel.org
[mic: Backport: use CONFIG_AUDIT to calculate the padding width]
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/landlock/access.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/security/landlock/access.h
+++ b/security/landlock/access.h
@@ -61,6 +61,10 @@ union access_masks_all {
 static_assert(sizeof(typeof_member(union access_masks_all, masks)) ==
 	      sizeof(typeof_member(union access_masks_all, all)));
 
+#define _LANDLOCK_LAYER_MASK_PADDING                              \
+	(BITS_PER_TYPE(access_mask_t) - LANDLOCK_NUM_ACCESS_MAX - \
+	 IS_ENABLED(CONFIG_AUDIT))
+
 /**
  * struct layer_mask - The access rights and rule flags for a layer.
  *
@@ -81,6 +85,10 @@ struct layer_mask {
 	 */
 	access_mask_t quiet : 1;
 #endif /* CONFIG_AUDIT */
+	/**
+	 * @__pad: Padding for the compiler's bitfield initialization.
+	 */
+	access_mask_t __pad : _LANDLOCK_LAYER_MASK_PADDING;
 } __packed __aligned(sizeof(access_mask_t));
 
 /*


