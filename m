Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A44362171;
	Fri,  6 Dec 2024 15:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498616; cv=none; b=nih8uAzFs0O6jKbXjaZh2SdWUMJ9Tzo5VQUCQwWnf24G/lKo0bktzNZk2Rl5UAL6N1L0BEXg2acQ1lb7G0ito0ao3AZRmfihQkLZjGGZvELCFxuddYEPzeahFOovAWp7kvptFA8cfyiJrg21Q92e6MoIZRKqmrPlng4kwejAZbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498616; c=relaxed/simple;
	bh=tFPnaZZDzBQS8oKAUqXqtxKlB8tLumBRk0DlnThWdX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EzpX7mVj40MdBXM5oyfS2PCK/cDS6mNv5G9zgaV7iHgmwOz2VWiN7VqJS+7dKvqMPvAslatpy8N9pOcke0M7VPddwwga8wvfjroTsLM53eKgbQv0JmGj+ubfFKohm5mmQWzJPai0RwnCAWQBTGTN9quWS4/Xk0dgW1HXeuhGXd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R61ydkxP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R61ydkxP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4CB4C4CED1;
	Fri,  6 Dec 2024 15:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498616;
	bh=tFPnaZZDzBQS8oKAUqXqtxKlB8tLumBRk0DlnThWdX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R61ydkxPiCn0AAUO65c81fz4PI/ytRNQDQSqCb2zf2Zi1Cv7ZGhGM4F1lel3AHkgW
	 MaaUHoLfN8TDZqYmfBySFAPxynaM+2umDL8QbbreCJ5VjEdifeX29nMOSXySUi29hM
	 QYEbxyl5pEzOyByjl6otlOcg+xU8tMLs2X8coQMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 6.6 638/676] ARM: 9431/1: mm: Pair atomic_set_release() with _read_acquire()
Date: Fri,  6 Dec 2024 15:37:37 +0100
Message-ID: <20241206143718.293584804@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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


