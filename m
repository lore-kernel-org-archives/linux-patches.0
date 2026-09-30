Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3622BEFEF;
	Wed, 30 Sep 2026 19:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795001; cv=none; b=Cx6wl4xO5u+hB25ysX+TKqguFwQvY1MAugy81rf4pSXjo4OrUkT3D7YpHYMzGWvRO8CJMz1T+Tp1AZjrRbXOST4oscm9kQuxlg5cx/5PWHG8KAjTfZf86pJzeU5j3MOCLttMvy78s2C4p5DcTckXAKjujqb8tXkPNWbMYdB1g10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795001; c=relaxed/simple;
	bh=KTm203oKp2pe2HQUQjAk/qKHfe1NeJubQ2JD3zYuyH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ewDz8lOcbjkvBxysCYpq8xOrPAEOXc+8peBQ9+Q0u4N34b5IwZ9T+D5TDKO6KLQMAKz6uN1Y8CO/Wd4cg0ZM5RzxZY4TVFz/eJXr5WZeZksg3o0bZ8jWNrKeYP0pYcCU6dW4Tf7V66qv8zdx45gbDV/jA0aLTUVCzX/tXrv0J2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QsnEGxSv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QsnEGxSv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C301F00899;
	Wed, 30 Sep 2026 19:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795000;
	bh=b3jHIBkFN5SaoXhTLfeIh0DYWh5O+W+OO0wSfruo9b0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QsnEGxSvVQuekCC46nwYm4fxGaO7/LT9jL/0IKjE9JmSrxDSsH2+b9W4tU38/jGK1
	 wpuW2egoTTuXOoRE55imDljAitR+vMJn8wzxW6bt5it7/RyN8xGNP8nqnP5sBKf4ws
	 NVbFLd+TvMzTKUVwp8VFUrfJQ/RuE9HFh5vHnvgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0407/1193] s390/checksum: call instrument_read() instead of kasan_check_read()
Date: Wed, 30 Sep 2026 17:18:11 +0200
Message-ID: <20260930152443.240037591@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 4ce69fcf17d067112f754414aa563e0cd74cc49d ]

Call instrument_read() from csum_partial() instead of kasan_check_read().
instrument_read() covers all memory access instrumentation methods.

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Stable-dep-of: 7f918871112e ("s390/ipl: Fix NULL deref in kdump without re-IPL parm block")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/checksum.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/checksum.h b/arch/s390/include/asm/checksum.h
index 69837eec2ff5d..fcef9ae433a7a 100644
--- a/arch/s390/include/asm/checksum.h
+++ b/arch/s390/include/asm/checksum.h
@@ -12,7 +12,7 @@
 #ifndef _S390_CHECKSUM_H
 #define _S390_CHECKSUM_H
 
-#include <linux/kasan-checks.h>
+#include <linux/instrumented.h>
 #include <linux/in6.h>
 
 /*
@@ -34,7 +34,7 @@ static inline __wsum csum_partial(const void *buff, int len, __wsum sum)
 		.odd = (unsigned long) len,
 	};
 
-	kasan_check_read(buff, len);
+	instrument_read(buff, len);
 	asm volatile(
 		"0:	cksm	%[sum],%[rp]\n"
 		"	jo	0b\n"
-- 
2.53.0



