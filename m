Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27548F5B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:26:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93CFC433C8;
	Sun, 16 Jul 2023 20:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539190;
	bh=8R0PrA9qErlW8QwzAjAUWE0x8v9ZipQ2Rjmzxjgu8Q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FmXRUg3+rzu3YhmIVkxMwWVO5FJsA81YOTJwDeWVxIxH/gtA3t3mOxPNmgqxeMhtZ
	 v0jPwX2G1RnY4XagPQPBegzSOhq8IL9qcA/SyxsaWaLaD/rQaBTxrJ0FeIlxBNVYj1
	 WPz3SdYdFEEmYuGy9HBXQv1j9obZy5DBYMvUqNbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.4 718/800] arm64/signal: Restore TPIDR2 register rather than memory state
Date: Sun, 16 Jul 2023 21:49:31 +0200
Message-ID: <20230716195005.795837369@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mark Brown <broonie@kernel.org>

commit 616cb2f4b141852cac3dfffe8354c8bf19e9999d upstream.

Currently when restoring the TPIDR2 signal context we set the new value
from the signal frame in the thread data structure but not the register,
following the pattern for the rest of the data we are restoring. This does
not work in the case of TPIDR2, the register always has the value for the
current task. This means that either we return to userspace and ignore the
new value or we context switch and save the register value on top of the
newly restored value.

Load the value from the signal context into the register instead.

Fixes: 39e54499280f ("arm64/signal: Include TPIDR2 in the signal context")
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: <stable@vger.kernel.org> # 6.3.x
Link: https://lore.kernel.org/r/20230621-arm64-fix-tpidr2-signal-restore-v2-1-c8e8fcc10302@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -398,7 +398,7 @@ static int restore_tpidr2_context(struct
 
 	__get_user_error(tpidr2_el0, &user->tpidr2->tpidr2, err);
 	if (!err)
-		current->thread.tpidr2_el0 = tpidr2_el0;
+		write_sysreg_s(tpidr2_el0, SYS_TPIDR2_EL0);
 
 	return err;
 }


