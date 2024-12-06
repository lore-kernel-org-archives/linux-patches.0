Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D737C1494D9;
	Fri,  6 Dec 2024 14:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496135; cv=none; b=bAbqNNTuj/wvEK9lKBTO5NolNJs2q+886xh2eIDJ8y5Pcq2AkY/ICJtuwvXAPJwMPOVFccU1g+AYp7mbU0Wz+RL11nqW8kPqhUt7/hUBssr4t/dR5YEA+sIBNvA4NNMq/PHs7IqlI8K1hGc/zT4bmTGzZh3yNMMgmvd4eO8pI3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496135; c=relaxed/simple;
	bh=u2+iGPcCv0Kde2f3zvLHom2cgZAX/gbt1O6qLnfRWK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YH43xe7xmtX/cGRr4S7bW2Z9VP3n1pRenRRlYWES6BGmHsAT21A9kwBiTvimCoKZKT6g1pndohYaxDWBAiA+JoV9Wax19RGNpBLZAcenewLXqyLLsEhDZmn4ll5h7xfT8N1ArHIA5zA2K2sIZCup6kHVSy0sRuZBCUguQl/05rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ABinxw8z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ABinxw8z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF592C4CED1;
	Fri,  6 Dec 2024 14:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496135;
	bh=u2+iGPcCv0Kde2f3zvLHom2cgZAX/gbt1O6qLnfRWK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ABinxw8zVKCvJIikmnsSuFWQ1zBC9VmnpH2GNfC22PXq9ooLKJDCCevJT0RwgyEG0
	 hS1geAoEWXtL+w/ZU10OjFvzGYEDEUS2P1BKDiw7uDDwCcrzgqp27IndrnKoc6JbpF
	 lNeHLu6jZKuf/ylUspOMhMt17ysMn8HDsOxgNeBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 6.12 062/146] ARM: 9431/1: mm: Pair atomic_set_release() with _read_acquire()
Date: Fri,  6 Dec 2024 15:36:33 +0100
Message-ID: <20241206143530.050867248@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


