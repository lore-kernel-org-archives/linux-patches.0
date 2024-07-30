Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A901A6191;
	Tue, 30 Jul 2024 16:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355909; cv=none; b=oOvsF6xSr1Uykq5WfdBZT8Ri/QcyOJSdoHsbt0y4OHjBFNQNdUUObEhKSlhCng3pF+gU625R5O8D4VqRJZitirmDcddLBEFA6GZx3s0d/VRmyADPPbXrI+S7CIDmNbqCps/L76dhaxujoHUZ0LIpuXDhpA3npzDaMUEF5iJCSdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355909; c=relaxed/simple;
	bh=+R/sRYoFJ6ShnHou7IVIe9SCw5QLmbJ4tc7eVIO83u0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gH1ro8no2WeTG4Jkg1gJPb/RVKVcKOe4BAIejsmyLZjewhI4JgG4rfuzLypA7u9TmU67a5EyX9zHRyCCdEO+C59Rwa4Hc7zfO+l4EfbtU/xWBHQNS1Q4V2ygcZciuwomcVNArAg/OXOQgQzQ3UGKOK596Ro02iC0VpvPfcMZZEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y0p86qYT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y0p86qYT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BA74C32782;
	Tue, 30 Jul 2024 16:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355909;
	bh=+R/sRYoFJ6ShnHou7IVIe9SCw5QLmbJ4tc7eVIO83u0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y0p86qYT3KDmfWok6QW4lp8Ai7OyQlRapFNBUbaGrhDFvxShCKsmCEI5Tl7qIZRaX
	 iKNImhUrZn/OlcvDJkwd+Qo6T9OG5Ehf+Z7nbtKZttDc8FJdkHTs8+v7DZH9IfxOky
	 1sHtVjQ6zCm/ucfTm3uMxG9vkAUlLkoeAJWqF+oQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 143/440] s390/uv: Dont call folio_wait_writeback() without a folio reference
Date: Tue, 30 Jul 2024 17:46:16 +0200
Message-ID: <20240730151621.466344439@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand <david@redhat.com>

[ Upstream commit 3f29f6537f54d74e64bac0a390fb2e26da25800d ]

folio_wait_writeback() requires that no spinlocks are held and that
a folio reference is held, as documented. After we dropped the PTL, the
folio could get freed concurrently. So grab a temporary reference.

Fixes: 214d9bbcd3a6 ("s390/mm: provide memory management functions for protected KVM guests")
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/r/20240508182955.358628-2-david@redhat.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/uv.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 6f661add0a5d6..1ae7a04038049 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -299,6 +299,13 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
 			rc = make_folio_secure(folio, uvcb);
 			folio_unlock(folio);
 		}
+
+		/*
+		 * Once we drop the PTL, the folio may get unmapped and
+		 * freed immediately. We need a temporary reference.
+		 */
+		if (rc == -EAGAIN)
+			folio_get(folio);
 	}
 unlock:
 	pte_unmap_unlock(ptep, ptelock);
@@ -311,6 +318,7 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
 		 * completion, this is just a useless check, but it is safe.
 		 */
 		folio_wait_writeback(folio);
+		folio_put(folio);
 	} else if (rc == -EBUSY) {
 		/*
 		 * If we have tried a local drain and the folio refcount
-- 
2.43.0



