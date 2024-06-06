Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2854F196C9F;
	Thu,  6 Jun 2024 14:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682976; cv=none; b=ndKEtWqgHqa3VT6sZmSGcj4n3D5H6UIIxJarTiP9ukS0xJIVRsTbuNLn45ee0vr4Fq2KTRsMmthjtSAdoQVbEYGLilWwmmCmJOFu0j28JxlmHCxk3EaOd3tZ7KcIBDG/mL+SQFf+Sy7YIx4D0bPrZ2GUtqygBKb9TZciz57TpNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682976; c=relaxed/simple;
	bh=sw28r/rB/YIOgw0NLCO8Du+ORUpv9vQ/tB0KC7VwiFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M06kOSakzmye6iWXGMVC/Ry86NQSlaZbh6R+bkeUoxJGAqtQh0e9/UMJy7yDYAqAVLBkEmbzCeiDNt2Ux8oRyga7if43VQejC92j531EVP3PgmmtuUDCzXPRFRemSDdJvQhB8PH10H79icqLc/l1K+x35wMXhDhGsDKO0aHFb2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rJo7mENd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rJo7mENd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 087BDC2BD10;
	Thu,  6 Jun 2024 14:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682976;
	bh=sw28r/rB/YIOgw0NLCO8Du+ORUpv9vQ/tB0KC7VwiFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rJo7mENdoXWROhvPS7LNz24p7OeY2PB5EG4zrny+tXLBK+uTfZZjgKhc8awuFVNlb
	 Z+waLtT8Ncop2FUI46PQ3rsKGCijXmcUfI+lkZ1aBWeOrYB2UjRSVN7Mo8g1tNdwlM
	 +S1UrEgp+qXtscFjvISyqmEyPDbVwgV3OWvOxu34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlemagne Lasse <charlemagnelasse@gmail.com>,
	Uros Bizjak <ubizjak@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 154/374] x86/percpu: Use __force to cast from __percpu address space
Date: Thu,  6 Jun 2024 16:02:13 +0200
Message-ID: <20240606131657.074546439@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uros Bizjak <ubizjak@gmail.com>

[ Upstream commit a55c1fdad5f61b4bfe42319694b23671a758cb28 ]

Fix Sparse warning when casting from __percpu address space by using
__force in the cast. x86 named address spaces are not considered to
be subspaces of the generic (flat) address space, so explicit casts
are required to convert pointers between these address spaces and the
generic address space (the application should cast to uintptr_t and
apply the segment base offset). The cast to uintptr_t removes
__percpu address space tag and Sparse reports:

  warning: cast removes address space '__percpu' of expression

Use __force to inform Sparse that the cast is intentional.

Fixes: 9a462b9eafa6 ("x86/percpu: Use compiler segment prefix qualifier")
Reported-by: Charlemagne Lasse <charlemagnelasse@gmail.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/20240402175058.52649-1-ubizjak@gmail.com

Closes: https://lore.kernel.org/lkml/CAFGhKbzev7W4aHwhFPWwMZQEHenVgZUj7=aunFieVqZg3mt14A@mail.gmail.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/percpu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index dbfde44d88a31..ce5111cec36e2 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -77,7 +77,7 @@
 #define arch_raw_cpu_ptr(_ptr)					\
 ({								\
 	unsigned long tcp_ptr__ = __raw_my_cpu_offset;		\
-	tcp_ptr__ += (unsigned long)(_ptr);			\
+	tcp_ptr__ += (__force unsigned long)(_ptr);		\
 	(typeof(*(_ptr)) __kernel __force *)tcp_ptr__;		\
 })
 #else
-- 
2.43.0



