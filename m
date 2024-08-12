Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB79186E36;
	Mon, 12 Aug 2024 16:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479253; cv=none; b=UJVwmtIxcG+bso6J4bvLGgROBrYOUwrqfbxgemm30Bxu81qHVbrpakJOS+Hh/Ci6HPT2ldyzfB4WVh2wA79sZ4gK3exLlDVNUuxtebnrXVJtzOPA/vbYofLPKVPG5TQmEaHvxGvXnWbu+BXru81MMvrxHbD+KNA/ganEUharSbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479253; c=relaxed/simple;
	bh=iManYBu3PBTX0ebBtVXrrtRR3SCEWPfAEaTSGX//n/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XifG2+/+0mKlf8b6ozhaAA06w9SNtAHePsBtRz2IgW1X2Rw3K7Im1RcO0oJ1qtb4qadOW13J4I46JtK9lmUUjtw000/iuyuIqwSFDAurnoMVgl/To8PN3XGrRMy+uTM+dtqNjB00GKLd3L7sH3ZMe1rP+ttrE7A1GMV4ulVvPLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K//RCTjT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K//RCTjT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24EE5C32782;
	Mon, 12 Aug 2024 16:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479253;
	bh=iManYBu3PBTX0ebBtVXrrtRR3SCEWPfAEaTSGX//n/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K//RCTjTVyeEJyukWOv2nJfPEV7XAYB8QR7xvKJwfnnk3UxvQpjTZhn0SrNOfuFSR
	 KNrXnJINJOm4DXJ20CBfwGR+euCE+nsZGXOL5kxCF/XrQ9G76R9g9upN7a8OcP2hw4
	 S0R9ZZzv1b4f1KS5B978w9nzTpaAb50gcgS2tw6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 007/189] x86/mm: Fix pti_clone_entry_text() for i386
Date: Mon, 12 Aug 2024 18:01:03 +0200
Message-ID: <20240812160132.422615752@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 3db03fb4995ef85fc41e86262ead7b4852f4bcf0 ]

While x86_64 has PMD aligned text sections, i386 does not have this
luxery. Notably ALIGN_ENTRY_TEXT_END is empty and _etext has PAGE
alignment.

This means that text on i386 can be page granular at the tail end,
which in turn means that the PTI text clones should consistently
account for this.

Make pti_clone_entry_text() consistent with pti_clone_kernel_text().

Fixes: 16a3fe634f6a ("x86/mm/pti: Clone kernel-image on PTE level for 32 bit")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/pti.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/pti.c b/arch/x86/mm/pti.c
index f7d1bbe76eb94..41d8c8f475a7c 100644
--- a/arch/x86/mm/pti.c
+++ b/arch/x86/mm/pti.c
@@ -496,7 +496,7 @@ static void pti_clone_entry_text(void)
 {
 	pti_clone_pgtable((unsigned long) __entry_text_start,
 			  (unsigned long) __entry_text_end,
-			  PTI_CLONE_PMD);
+			  PTI_LEVEL_KERNEL_IMAGE);
 }
 
 /*
-- 
2.43.0



