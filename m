Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC3F1C57BD;
	Tue, 27 Aug 2024 14:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770267; cv=none; b=QY7llCBnUweFFDvjwTuSsTn3aUiRMabPHMP4rTXKOP0I7Lk/JF0GY1nxx8Ig+wEIRQKZiM/C4BwfgQGLY8LmK6EVFmR8Zk6xc4zje1AbzPDDCngItix1bIBMWC2ocFHmDbEI0UVhdasVdSGA0GUX0/icKABLUneRjxUI1kYWVAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770267; c=relaxed/simple;
	bh=zacF1ZLgh3Vyo+7+pAcJYu7qUY+k0jxccVKHnZO6cHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m21Dv6sZn27JTmLSYXfqioLPbqXY6XVKj0+l4Agmz4ZG7SNTrGWsJUqhVLa2QGjMWul57LF1K75NaYZc4urBVAIMvhTZePKvppVe3chfNq6M3r1mLq0Q4K3PjOnIXlddfERmxFV1ZZ9Waa4AFnk/8MEbTmOycYVSEKxXGI6eOEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QKqeGWWy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QKqeGWWy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D26C4DDFF;
	Tue, 27 Aug 2024 14:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770267;
	bh=zacF1ZLgh3Vyo+7+pAcJYu7qUY+k0jxccVKHnZO6cHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QKqeGWWy1MBIbirTqMMXQIvmfDQggnIofJTGlN8GWZRbLDizU+xKD/Huql5JvMmud
	 +q+PXndf9gB6cD71gvkpaBnqQz+eMKKYJT2PCyc4w2E1w03h9RzPjldbg9jmmppWMH
	 aTl2wCXWQ190RRPdkGAwWGOUSQb62S/Di7MukfMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	y0un9n132@gmail.com,
	Kees Cook <keescook@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 177/341] x86: Increase brk randomness entropy for 64-bit systems
Date: Tue, 27 Aug 2024 16:36:48 +0200
Message-ID: <20240827143850.149472707@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 44c76825d6eefee9eb7ce06c38e1a6632ac7eb7d ]

In commit c1d171a00294 ("x86: randomize brk"), arch_randomize_brk() was
defined to use a 32MB range (13 bits of entropy), but was never increased
when moving to 64-bit. The default arch_randomize_brk() uses 32MB for
32-bit tasks, and 1GB (18 bits of entropy) for 64-bit tasks.

Update x86_64 to match the entropy used by arm64 and other 64-bit
architectures.

Reported-by: y0un9n132@gmail.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Jiri Kosina <jkosina@suse.com>
Closes: https://lore.kernel.org/linux-hardening/CA+2EKTVLvc8hDZc+2Yhwmus=dzOUG5E4gV7ayCbu0MPJTZzWkw@mail.gmail.com/
Link: https://lore.kernel.org/r/20240217062545.1631668-1-keescook@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/process.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index b6f4e8399fca2..5351f293f770b 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -1030,7 +1030,10 @@ unsigned long arch_align_stack(unsigned long sp)
 
 unsigned long arch_randomize_brk(struct mm_struct *mm)
 {
-	return randomize_page(mm->brk, 0x02000000);
+	if (mmap_is_ia32())
+		return randomize_page(mm->brk, SZ_32M);
+
+	return randomize_page(mm->brk, SZ_1G);
 }
 
 /*
-- 
2.43.0



