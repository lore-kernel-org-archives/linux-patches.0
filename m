Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036697;
	b=mZdgrSbLYpLXC0Okhx6KCSKeDvwQmT2dS4qQy56MO9VJtn6tjJ9E8E2oj3HsVQe4gAOV
	 s3ATXwvJVF7bERUVhO+1c68CQO5Eq+1bQpjHeTYEdpmpq0/ArqZnNCj8jOXqWRu1IDcm1
	 1CqBG3kTbfhqdsdvQE88k7vbwBefx5IHcu3ibZ/OG9guiWR2Xdf6VQWVZ4Gfv6cCwN/83
	 ShuNwa+0nYkqWTNV8B2wMklv+F1KOOr2byMmnCsifvwo5/D+6SuekTtrHC5+ad40PYbTk
	 J4KK+o9j7myzSaJ6zmw4I+Wdi7L8v0lRnZEv3KiO8AIK545I8jpZkNrrzEgTMHL1y/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036697;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c1HCBm5u8W05v8g4x791O3PfHCMyPjM59wXAbTXk5vA=;
	b=bDUPMMW3C4rU2XuYTR3rw3/Fs8wCtOTMli9ceBaQBtWjkwVBvHELzGfw7zK7A64fGZQF
	 3hlJD3p0uHkdSSI2Aw7E6ORQnUcUWiAuyGt+/XK2H3uxNgyX8KC1urDVtbK5IJi205da7
	 N18MbpEBUAhNs7sJQojXOECT+qFD2qcCVrMQSVriUz6dQ5mjcoi66ERmBQ4Y+8ijqWXo8
	 s9CzKaYRni5eNqh5ib1OpcQ8ioc4SvjdCFWzrMfsNcPJ4bR9KwaXPaGxSjf6I7a8K6sPk
	 NowwInG1hPYLt3jhhPTSSGE07QnHkL1DWyHAzbq5r1umrWXjCVPzC3hO3s6o/RdPI4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k4WBPv6z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58491606A330;
	Wed, 18 Nov 2026 21:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k4WBPv6z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D48E1F000C4;
	Wed, 18 Nov 2026 21:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036697;
	bh=c1HCBm5u8W05v8g4x791O3PfHCMyPjM59wXAbTXk5vA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k4WBPv6zKSVYtNwQUQBIgT/S6rLbahKIJj8mDUd3OtzXIJSC9+isQviKk87AoMxxX
	 hKuyQfFYqhw4vjYkSUHcqgIFZyzOheGWtAyOJHY3Fr7Bl8ntYuSe85cY3QMX19mfRv
	 oX0cYjDoffgyR+pO5RGlkrdsAyAFFrK0/VTwOEsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1150/3318] alpha: fix the local TLB invalidate in the UP flush_tlb_page()
Date: Wed, 18 Nov 2026 15:29:32 +0100
Message-ID: <20261118150354.587715772@linuxfoundation.org>
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

From: Magnus Lindholm <linmag7@gmail.com>

[ Upstream commit c825bf802a7a43fd302c879ef25c975e067a2e94 ]

The uniprocessor flush_tlb_page() in asm/tlbflush.h has the same wrong
test as the SMP one: a targeted tbi() is only guaranteed to invalidate
the intended translations when the target mm's context is loaded, but
the gate is current->active_mm, which a lazily borrowed mm also
satisfies.

Test current->mm instead. The else branch it falls to already exists
here, so unlike the SMP side this is the whole fix.
arch/alpha/kernel/smp.c is not built with CONFIG_SMP=n, so this is how
the same defect reaches a uniprocessor, where the flusher kworker
necessarily shares the only CPU with the writer.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reviewed-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://lore.kernel.org/r/20261010142533.974797-7-linmag7@gmail.com
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/include/asm/tlbflush.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/alpha/include/asm/tlbflush.h b/arch/alpha/include/asm/tlbflush.h
index e78de2456ffae..d79d225da6c76 100644
--- a/arch/alpha/include/asm/tlbflush.h
+++ b/arch/alpha/include/asm/tlbflush.h
@@ -120,7 +120,8 @@ flush_tlb_page(struct vm_area_struct *vma, unsigned long addr)
 {
 	struct mm_struct *mm = vma->vm_mm;
 
-	if (mm == current->active_mm)
+	/* A targeted tbi() needs a thread of MM to be current.  */
+	if (mm == current->mm)
 		flush_tlb_current_page(mm, vma, addr);
 	else
 		flush_tlb_other(mm);
-- 
2.53.0



