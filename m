Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9419E3D6664;
	Fri,  4 Sep 2026 05:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499251; cv=none; b=BE3Hyeck/XKzoTV59aXwtFafyKO/LUb0p1IifUkASAH/ALgNcHpLsXGOaw5uRL+X8t/sCyRRupuX2ItDRdG5le2kjPD1HUKAV3hNCTSjmM/GOCLopTex0D4tpCMs/oGL9TxveO+OGbcctkf4UaEoFFg8ctuqC1mgVbGiBs7WF68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499251; c=relaxed/simple;
	bh=z3P5/w+JdpHYKLknGnN1/C/Ho2V5ZOxFQe0QRHO1Wok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mu/FRJtl5I5sgGbvDY9ObfY2teTIHl4uSbYjTZw2AbtR6RIymD+vliMmWhavMOb+R7DqEHHNbO9KW3YrzM8rcRjVqXRCU96wfomL0FJTKHx4RoeXTcOkfbTAuIy9pnNlH6UDdJ4Ce4PTjsTNVl1YwXDRO08RI50JSyvLnoxzmnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DJd1PUqK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DJd1PUqK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C141F00A3D;
	Fri,  4 Sep 2026 05:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499250;
	bh=QxabXp4n84eIt3d6HOIXxnGayB8ipPCy1uQDrFO3/Ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DJd1PUqK9pYPGLdd2wluL1KgcSGOWp054Zlc1ZGF3awgNvtvY5whlDINLHzWXtxt8
	 Cj+UMAaDNwLZgF9KMeqQiaKSEqG+I6tKHUujmCOiDVLz3cObcz46Fhskzu+876kDHm
	 /9FxbaT1PZVzrwB38s62I/1vWi6tf4DHTNScZbms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	"Pratyush Yadav (Google)" <pratyush@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH 7.2 349/713] kho: fix size calculation in kho_preserved_memory_reserve()
Date: Fri,  4 Sep 2026 06:55:17 +0200
Message-ID: <20260904045811.655322918@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Pratyush Yadav (Google) <pratyush@kernel.org>

commit 3a0b8fa2eb36afc88b62a95f33f0c77c71fa5ded upstream.

kho_preserved_memory_reserve() calculates the size of a preservation by
doing 1 << (order + PAGE_SHIFT). Since the '1' is a 32-bit integer, it
can only be shifted by 31. That is, it will only work for preservations
up to 2 GiB. Larger preservations will trigger undefined behaviour.

While preservations larger than 2 GiB can't be obtained via folios
currently, they can be obtained via kho_preserve_pages().

For example, memblock reserve_mem uses kho_preserve_pages().
Reservations larger than 2 GiB are valid and will trigger this bug if
properly aligned.

Fix it by using 1UL for shifting.

Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Link: https://patch.msgid.link/20260727150240.889555-1-pratyush@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/liveupdate/kexec_handover.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -501,7 +501,7 @@ static int __init kho_preserved_memory_r
 	struct page *page;
 	u64 sz;
 
-	sz = 1 << (order + PAGE_SHIFT);
+	sz = 1UL << (order + PAGE_SHIFT);
 	page = kho_get_preserved_page(phys, order);
 
 	/* Reserve the memory preserved in KHO in memblock */


