Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FAF233C1AD;
	Fri,  7 Aug 2026 15:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115463; cv=none; b=T1oJ1YoQ6stMhwHF2o1vRa1XjhKg12gakl60XAt3B4dQ3WUXOPcR5OIzo4gqBIMcrdjE/u+pxfIfxyEeZJsETYflLSwpRlwlmOB+BS37BpO2AH7I9HbXXlqrNiQmpP9i08JiDB0J0jhiS8lc6LE1nJyntnGf3j5wt7AAe9KYrrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115463; c=relaxed/simple;
	bh=KJEvvVTIxiID7IOuURj6ni/p4Agw6Bbygm7Qjj3rgAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OJgKiRGfIuUE7JCmxD0lpnv0PwcRF2hBfjHS5lWX/j6X6UoVEeoYG8tCXg/erbbeDOVPKsNdJPMluZQKAJU87WfVmnBE9bUqeV5WE34tD2qR9rPCvxcrdexf6Su5f2hJ6xeR72+XyDuOSWP9kGpEgn1ifML0IiYm1H+hT0XfGIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S3LPQ7MK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S3LPQ7MK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 957B81F000E9;
	Fri,  7 Aug 2026 15:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115462;
	bh=1Wlvr+Px+T3wwPHSIRNjeYZD8RExj/G82MFoo+NZjgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S3LPQ7MKR+iG61p/ltDY3cTASe9HWU4GhTqyqe1yG3OQqG2snwy8CtQUPcoLiAFv/
	 Cu1XqMv4/rtygmJn1UpmMcBDAzpxiVlD8WrMc4f3V30YA6/e6j5WfB0fPq/BzzTeVk
	 qtycF5HPPI5d0qhcQO2Z7U8pZqqQMmWt90qv73IY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.18 241/396] powerpc/ps3: Fix map failure path in dma_ioc0_map_pages()
Date: Fri,  7 Aug 2026 16:36:41 +0200
Message-ID: <20260807143429.452106445@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

commit 0bb024f11d120abff3e8db9144a585b9d7fb8459 upstream.

If lv1_put_iopte() fails in dma_ioc0_map_pages(), the error path
decrements iopage but keeps using the failed mapping's offset. As a
result, it repeatedly tries to invalidate the failed IOPTE slot and
leaves the already installed IOPTEs valid.

Recompute offset and invalidate the installed IOPTEs instead.

Fixes: 6bb5cf102541 ("[POWERPC] PS3: System-bus rework")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260711130931.740719-3-thorsten.blum@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/ps3/mm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/platforms/ps3/mm.c
+++ b/arch/powerpc/platforms/ps3/mm.c
@@ -615,6 +615,7 @@ static int dma_ioc0_map_pages(struct ps3
 
 fail_map:
 	for (iopage--; 0 <= iopage; iopage--) {
+		offset = (1 << r->page_size) * iopage;
 		lv1_put_iopte(0,
 			      c->bus_addr + offset,
 			      c->lpar_addr + offset,


