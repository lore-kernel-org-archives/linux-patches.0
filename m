Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054457;
	b=mGTxGxl1CInWaMBas5qVtrH7NFSSezB9VcqJqaLYkZd7dv/MjhCUnKYJi6jguGVdbTBt
	 /39VhMDTEazecRCSjtEOxL9/wnXmXe0NxBQtGZX/l2HY+jhw3R19G3LseUSGKpdouxJ0q
	 PXimYNtBBYy2qrNN41ZA4FN0kGT3TmxCjVMwKod8yaM1eoBkxTrX3/0REgJtQrdH6NmWq
	 lr/8ns53qrHotr4bnN9ZJFq3c7axMjeASflgJNKb5/JBaW3ksjLk3BWb+9JSo0wPsddj1
	 IgKiBPinFWygk89NvkZnaDv4O+bLHGhffzNdr9cgWKrDSUDGnhREmn9zXcoRPABjNBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054457;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=grQbv66oK7G82IaGG/QGWSMMzFskmEy/roMQydBxNbA=;
	b=tM8izqG4U5l2BlK3RbfBMk8vaQe3EwICZ7ue4sOw5Cc1jVbJBeoEKbZwpse4iJwT7+Wg
	 ihH13NIz7iprXwCs3+tgEbojsaXbswVYSmX7pQgvL0y7JlVeru0jDUSrmaxbNcLUqPOJ4
	 NMedfi2OAZi04drTPJ3iQLvIktX/R6CryHUs0UL26H/uxupG29tnEiCzOYoCaFVsUPrEi
	 s+0/8fg8S7dX1KHU5QrR03i/1yZOJVRFOyX+FeCdsp27oeKVPATMzqXnWuZlpG0/WoLGg
	 3IAfVaSqoeeoUy4Z8P+V7dHtYNDg/aGe36WwL3lmk+WqbbHzblrv0X0Fwx+KHzB+yPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oGjlRPrM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30C7606A330;
	Thu, 19 Nov 2026 02:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oGjlRPrM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34DA41F000C5;
	Thu, 19 Nov 2026 02:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054457;
	bh=grQbv66oK7G82IaGG/QGWSMMzFskmEy/roMQydBxNbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oGjlRPrM+0Bzry3TrO/06PkRNTdn5XKUgN8uU6xZD9VdjkGCIpEeS2JhWD3JD+4Jm
	 STqf2eVim+NJIrhr8btxGFdhcJsIjdBAJzJ2dMXuroj6+6GPx8dAtERKefJKBc6E/9
	 MGdOAqjsbjwjNQUhmEjqLRvbxtdwlOA9lUrazST8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1280/2214] mm/userfaultfd: compare exact registration modes before skipping
Date: Wed, 18 Nov 2026 15:49:16 +0100
Message-ID: <20261118150102.778121595@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Gregory Price <gourry@gourry.net>

[ Upstream commit 05f64f211a25f7d9771d4fde109aad97174a1cf3 ]

Changing registration from MISSING|WP to WP returns success but leaves
MISSING enabled. The no-op check sees that WP is already set and skips
the update, so later accesses to missing pages still wait for userspace.

Skip the update only when the current and requested UFFD modes match
exactly.

Fixes: 63b2d4174c4a ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
[ david: apply fixup from Lorenzo ]
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Link: https://patch.msgid.link/20261031-fixes_core-v3-26-d6437171ecc3@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
[ sashal: replaced vma_flags_t helpers with a direct vm_flags bitmask comparison ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/userfaultfd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index ea7e9db135eb4..1c4b0cb54d878 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1435,7 +1435,7 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 		 * userfaultfd and with the right tracking mode too.
 		 */
 		if (vma->vm_userfaultfd_ctx.ctx == ctx &&
-		    (vma->vm_flags & vm_flags) == vm_flags)
+		    (vma->vm_flags & __VM_UFFD_FLAGS) == vm_flags)
 			goto skip;
 
 		if (vma->vm_start > start)
-- 
2.53.0



