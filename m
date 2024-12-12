Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F68215799;
	Thu, 12 Dec 2024 16:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020502; cv=none; b=upCIs3K8xNeeOPjQD8mxzEvRFE+5c+Kg3KonQS/iQCAhFGhI2TGudjDcY+Yvt+iXkVR0EeOlR9SGa4wdAvZcJKhxe19azXhiu4BMfBcqGYM1L6OzYIpHCChIZpqU/5kRlgytkcBUakHP6ylFonClbeZObFU2QG8Pa3Nw6G1mHtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020502; c=relaxed/simple;
	bh=TnBt14yr/9NhZiYnAhAa6u/lH0ac7C422oMO/Z4+uVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R6Oa0nU+czd/WyyTKX1AXoHFzlXs81Wen83PqlkDa7VL8ZlISbIR64F/eCm53E3BpfGO1k4hJFZQqKv0BOFL3xxqLQg4zHS0/5ftD1ZFnUn0rX/9JEUjj+syjkyPU66ws8QAN1xrM7KkknnGdiQBZVPUYIRxK+mUfECnecdeU40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YTwNMfzi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YTwNMfzi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B51D3C4CED0;
	Thu, 12 Dec 2024 16:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020502;
	bh=TnBt14yr/9NhZiYnAhAa6u/lH0ac7C422oMO/Z4+uVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YTwNMfziyCJHa/XeZgc2NKzEXRx/3rRmN6K8IhF4j+eDrLVoyhy8YFQ2MrLKRo9iw
	 1cuNVzx8kM6JMKY7icUN5t7DqUIWZjAUzQjmVNTlh4uZ3o/v79B9hdGBfwcLgOBnLe
	 w1G3dIh68ez7cV9LNjYtTjyRq+dHe13zCygdZGeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 6.1 482/772] ARM: 9431/1: mm: Pair atomic_set_release() with _read_acquire()
Date: Thu, 12 Dec 2024 15:57:07 +0100
Message-ID: <20241212144409.850929340@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Linus Walleij <linus.walleij@linaro.org>

commit 93ee385254d53849c01dd8ab9bc9d02790ee7f0e upstream.

The code for syncing vmalloc memory PGD pointers is using
atomic_read() in pair with atomic_set_release() but the
proper pairing is atomic_read_acquire() paired with
atomic_set_release().

This is done to clearly instruct the compiler to not
reorder the memcpy() or similar calls inside the section
so that we do not observe changes to init_mm. memcpy()
calls should be identified by the compiler as having
unpredictable side effects, but let's try to be on the
safe side.

Cc: stable@vger.kernel.org
Fixes: d31e23aff011 ("ARM: mm: make vmalloc_seq handling SMP safe")
Suggested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mm/ioremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mm/ioremap.c
+++ b/arch/arm/mm/ioremap.c
@@ -141,7 +141,7 @@ void __check_vmalloc_seq(struct mm_struc
 	int seq;
 
 	do {
-		seq = atomic_read(&init_mm.context.vmalloc_seq);
+		seq = atomic_read_acquire(&init_mm.context.vmalloc_seq);
 		memcpy_pgd(mm, VMALLOC_START, VMALLOC_END);
 		if (IS_ENABLED(CONFIG_KASAN_VMALLOC)) {
 			unsigned long start =


