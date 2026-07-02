Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921B824E4C3;
	Thu,  2 Jul 2026 16:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011355; cv=none; b=gavtulUqmQ7e4wtpv8/+J93x2a8YDryUr0EkqCAPAZupofazbI8Ap2aM0nmn/GtjOtooJq9rG7FDrm/26CcMg8aidSwVTvTgCn34IIJO3n3oIQfHh0KcVkHPTJHB/YkOqHTsPHGly1yt0kyeg3CmTLjIZPNJn/0NZ6XaRVX4PGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011355; c=relaxed/simple;
	bh=ALNcZSft5uXfXlvq9LZO4cK65OiwhHQg0doShVW4LDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YFV7qw9pkWhaLJIcOOJRLDqWtz2Cqb9AMHQYG+2BRkRvVY8Jm2O7jNmlili504lAqPHv+81FY6HE1ktWixAakFTMUZ8seEbO2CzPEBj90N/aGc10ZjAkyge5nvRMH/JuGoy486eNfZbaK9ZZO1WG6hY4ZkPW1cRD7JUIUCg1gMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l38ZlfPh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l38ZlfPh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08DD51F000E9;
	Thu,  2 Jul 2026 16:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011354;
	bh=fO0zZ+xNN7gIHHzw1963/e91cNwQtD81zDu3e64NQRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l38ZlfPhUHYGOXnjEFmwhyf2OWvlMXrAimzEqDcbl6ZkWDh94M+ysPmBdQCefiyxQ
	 qBMQ6IB0zuI79QjZlPCal/hsSSmxG7H38TyIcRaEwxhWMqfY4NlPh3yRr09vV5+X6s
	 Z2ZieEQFwFONwRqXUj5t+L1VpdZmn6N2dFHtqboo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Peter Xu <peterx@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 050/108] userfaultfd: ensure mremap_userfaultfd_fail() releases mmap_changing
Date: Thu,  2 Jul 2026 18:20:47 +0200
Message-ID: <20260702155113.145722202@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.110058792@linuxfoundation.org>
References: <20260702155112.110058792@linuxfoundation.org>
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

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

commit 0496a59745b0723ea74274db16fd5c8b1379b9a9 upstream.

Sashiko says:

  mremap_userfaultfd_prep() increments ctx->mmap_changing to stall
  concurrent operations, but mremap_userfaultfd_fail() does not
  decrement it before dropping the context reference.

If an mremap operation fails, ctx->mmap_changing remains elevated. This
will causes subsequent userfaultfd operations like a UFFDIO_COPY to fail
with -EAGAIN.

Decrement ctx->mmap_changing in mremap_userfaultfd_fail().

Link: https://sashiko.dev/#/patchset/20260430113512.115938-1-rppt@kernel.org
Link: https://lore.kernel.org/20260513081416.495963-1-rppt@kernel.org
Fixes: df2cc96e7701 ("userfaultfd: prevent non-cooperative events vs mcopy_atomic races")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/userfaultfd.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -767,6 +767,8 @@ void mremap_userfaultfd_fail(struct vm_u
 	if (!ctx)
 		return;
 
+	atomic_dec(&ctx->mmap_changing);
+	VM_WARN_ON_ONCE(atomic_read(&ctx->mmap_changing) < 0);
 	userfaultfd_ctx_put(ctx);
 }
 


