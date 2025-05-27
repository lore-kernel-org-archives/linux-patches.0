Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB4A25A323;
	Tue, 27 May 2025 17:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365449; cv=none; b=r0KP+bqiQWVGN+X8LsC0XOsMScUV9KiFlIxO2ks/NlaZjOS8g6Qc7AcILgLCcjRTjE+2Mg369HjqgmO6xBDWzpE/ZmYKAOzxv8x75ldajy/kAPEryM7t6DdP3KL9F9N7ZmSESvSy0vywI3Rw3zUG21QEpCH7hyFaXMJL6z2jPJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365449; c=relaxed/simple;
	bh=Cw18aI5W16mOMYnu4TpO79oesd+fhAiSmTifcQ/jl00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CrjmPM8HIbL52OH1nrdHiKY6QGFmgj9H37Vf3YcWMAYI5Gm3ADs2knQF7rfnUJNdjNeKNKKHnyFcCbOnxhZkNyK2RYn0TMtMNauuXzMN1haQnUWQtd+Rn+fZEHU6frr9qHJnuqdrxTO9iGp1G0INZwCXIMG7xIHpHKQpEVcWs0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IAhUbgpp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IAhUbgpp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF96C4CEE9;
	Tue, 27 May 2025 17:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365449;
	bh=Cw18aI5W16mOMYnu4TpO79oesd+fhAiSmTifcQ/jl00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IAhUbgppC0fUw+G0ut9QDvZ5pSj6jtlx3ycNUfi0cjazeyyqSZHhWLh6wVn0U1e4M
	 8+GBz3s2/P3kHs0NrPYl2jXfWO7a2xKcPCSKV6Z3L5GjvierKcz3EObWvyTIzbRRxB
	 gMux1UFfaauJdk7YsuNJoXXshirJmlMUSyLkoesQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Gerst <brgerst@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 349/626] x86/boot: Disable stack protector for early boot code
Date: Tue, 27 May 2025 18:24:02 +0200
Message-ID: <20250527162459.199509696@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Gerst <brgerst@gmail.com>

[ Upstream commit a9a76b38aaf577887103e3ebb41d70e6aa5a4b19 ]

On 64-bit, this will prevent crashes when the canary access is changed
from %gs:40 to %gs:__stack_chk_guard(%rip).  RIP-relative addresses from
the identity-mapped early boot code will target the wrong address with
zero-based percpu.  KASLR could then shift that address to an unmapped
page causing a crash on boot.

This early boot code runs well before user-space is active and does not
need stack protector enabled.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/20250123190747.745588-4-brgerst@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index f7918980667a3..f42c0903ef86d 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -44,6 +44,8 @@ KCOV_INSTRUMENT_unwind_orc.o				:= n
 KCOV_INSTRUMENT_unwind_frame.o				:= n
 KCOV_INSTRUMENT_unwind_guess.o				:= n
 
+CFLAGS_head32.o := -fno-stack-protector
+CFLAGS_head64.o := -fno-stack-protector
 CFLAGS_irq.o := -I $(src)/../include/asm/trace
 
 obj-y			+= head_$(BITS).o
-- 
2.39.5



