Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063483;
	b=Bll7LXF1vu3KPOmh7abjGy7PAO1864Be6QzbcAegeI/gvfJeuWqShgVcmU5TqcTgQEZ9
	 wtXLaCW6615iMb+Li5Wb40r68SEZIhOFEqGNWmJIqDHM4cgu6ANwmI/l2/kkHtLaZkWN2
	 UrfvEy53KIdzK+Jlaci6+wBTV3pjtjT02nbOgs2sJzwS/DI2KXs59L8A31pSzcCE3FNYP
	 enZygzyHQqzDnYavaRyqTC2zRRyLxbbCCTAGTtYI6V8sDEde6Ku+MsaKPxS1GurNElKLW
	 AbBsJg8vD0MQNDPsDnc8izR29J73vAOTXZyT92iqDLO75Sqyfps0pdJCc8nqzZsZRPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063483;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n1xP8WXhPQfk9qTqRq7WJyVcW1NNO46yDTK6seqxoSE=;
	b=XsH/zdMSVaZKb3G6D0WmZc6039GOg1y/4X57jsFddNhJQsu/nUf/ZbVoNvD8HQRpDz7u
	 1EeJTclm4LIT8dB6T+dDcpU2lGBc8AS62v0IeNaSJxT7kAc5TJIq1rppofaf12aPc7SSt
	 gPOLhSuMhnlDqu9vxhQYzXe2CUuSfWtFakL1I1WAaLsZizYZyZuuv240B02RNY1xxysBj
	 R4EemytgAuorgibDEwko/drKTtHHurI4AVCXNpn1hiQS91t4UJwzAcJrxGTRuRM9FhUIq
	 iSErhwVrzAZURV5ejzd5QvwxzlWz/c0bjbYzP9lj6qp4QJsOooyQHwbyQni12vP94Kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O8QY5jjb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48FF2606A9E4;
	Sat,  7 Nov 2026 14:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O8QY5jjb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB6A1F008AB;
	Sat,  7 Nov 2026 14:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063483;
	bh=n1xP8WXhPQfk9qTqRq7WJyVcW1NNO46yDTK6seqxoSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O8QY5jjb8ft5qAyZRqwPTlsLhfu1dxmKm67/X4hf9Hc3/yAWYJmmmEWa5mfKjR18t
	 G8vQGVK3V5JkR2hGw992MwJfXbwWcR680PqR/G6M29+x/vGtyEC9ooFkaDyN5Jtdbd
	 TRDtmtKRgE/ToDe8Z/tmdWmku4B1zyU1JhUKOnGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 630/869] alpha: fix the local TLB invalidate in the UP flush_tlb_page()
Date: Sat,  7 Nov 2026 08:55:12 -0500
Message-ID: <20261107134914.340655713@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 0c8529997f54e..9ae1902faf8ec 100644
--- a/arch/alpha/include/asm/tlbflush.h
+++ b/arch/alpha/include/asm/tlbflush.h
@@ -87,7 +87,8 @@ flush_tlb_page(struct vm_area_struct *vma, unsigned long addr)
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



