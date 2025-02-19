Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF8C1DF748;
	Wed, 19 Feb 2025 08:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953976; cv=none; b=MVo53a8EtWWocIEK56ZCbbMngGDk4eqvd6ZEymybYydfn33Bedn5kA7SjVwJr++JjJQk1rn6PErLaQY5UCWG638+QurUOuv9J87DYphUcIG6CWIm0upZyxCWk0S4nFNXIz+tJfWe7ZaZ1JMQKXgMkNUw+utd4aoJMCCtCassAB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953976; c=relaxed/simple;
	bh=a8KG23otsOW4mcim+6rCNctGbUQSTmjOf8WtIXogw2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nf84O17yQgzXF2IdOLt0S1nG0V38tUL3Jq0IzlnWrLPwwNTof7XVRa7zwUwUktRyo9cwshFNdtuFJpdy++Uhty9S82hENscY2ByaPk1Caq+Sgvi7rFV5qd8KUR3dYlTN9csTX8+nbBtb8Z8m+Sz/7KqqR/sR02MhICD1CX3qOz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bZHY8MUY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bZHY8MUY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23A3BC4CEE7;
	Wed, 19 Feb 2025 08:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739953976;
	bh=a8KG23otsOW4mcim+6rCNctGbUQSTmjOf8WtIXogw2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bZHY8MUYrIwrSuKqMRBP2vhSlTshtNueB0OExtZET2Z2RW0MP17osDFD6ypgRP9AT
	 Cpy8cK7PdqkA/y1JdH7DvzbMX+KuHVwwHJvX3wOyqzoZ2m0Iyn1jKFzWdSYc3OV1Vn
	 iIrAjYxTgswrgL2QkUdoj+LkmzvsQYx1415PzVl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 056/274] um: properly align signal stack on x86_64
Date: Wed, 19 Feb 2025 09:25:10 +0100
Message-ID: <20250219082611.711652642@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit 3c2fc7434d90338cf4c1b37bc95994208d23bfc6 ]

The stack needs to be properly aligned so 16 byte memory accesses on the
stack are correct. This was broken when introducing the dynamic math
register sizing as the rounding was not moved appropriately.

Fixes: 3f17fed21491 ("um: switch to regset API and depend on XSTATE")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Link: https://patch.msgid.link/20250107133509.265576-1-benjamin@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/um/signal.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/um/signal.c b/arch/x86/um/signal.c
index ea5b3bcc42456..2934e170b0fe0 100644
--- a/arch/x86/um/signal.c
+++ b/arch/x86/um/signal.c
@@ -372,11 +372,13 @@ int setup_signal_stack_si(unsigned long stack_top, struct ksignal *ksig,
 	int err = 0, sig = ksig->sig;
 	unsigned long fp_to;
 
-	frame = (struct rt_sigframe __user *)
-		round_down(stack_top - sizeof(struct rt_sigframe), 16);
+	frame = (void __user *)stack_top - sizeof(struct rt_sigframe);
 
 	/* Add required space for math frame */
-	frame = (struct rt_sigframe __user *)((unsigned long)frame - math_size);
+	frame = (void __user *)((unsigned long)frame - math_size);
+
+	/* ABI requires 16 byte boundary alignment */
+	frame = (void __user *)round_down((unsigned long)frame, 16);
 
 	/* Subtract 128 for a red zone and 8 for proper alignment */
 	frame = (struct rt_sigframe __user *) ((unsigned long) frame - 128 - 8);
-- 
2.39.5



