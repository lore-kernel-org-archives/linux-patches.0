Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3BA3D74
	for <patches@lists.linux.dev>; Mon, 21 Nov 2022 12:44:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D3AC433D6;
	Mon, 21 Nov 2022 12:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669034695;
	bh=JpfcBeUisSYa36MfwmHN5vbhw/yExsJG03jGFITkwuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tW0Lr4u4YsuetaQdzKuoNjExh1JPQu6y4e3z/2aT0t2rwLguX0HrZh29f0uOsW+xU
	 xXBCf3PNoNBEJJ4u7szfy/qSoL3pcx8tjAKH8YAqf6qEuOdqtc6yONEL932C6TSr1F
	 5WuGNAvPmN4WOiX0SIKyHl9QpQ2156gB09HJJiqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Borislav Petkov <bp@suse.de>,
	Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
	Suleiman Souhlal <suleiman@google.com>
Subject: [PATCH 4.19 22/34] x86/speculation: Fix SPEC_CTRL write on SMT state change
Date: Mon, 21 Nov 2022 13:43:44 +0100
Message-Id: <20221121124151.696744192@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221121124150.886779344@linuxfoundation.org>
References: <20221121124150.886779344@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Josh Poimboeuf <jpoimboe@kernel.org>

commit 56aa4d221f1ee2c3a49b45b800778ec6e0ab73c5 upstream.

If the SMT state changes, SSBD might get accidentally disabled.  Fix
that.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1335,7 +1335,8 @@ static void __init spectre_v2_select_mit
 
 static void update_stibp_msr(void * __unused)
 {
-	write_spec_ctrl_current(x86_spec_ctrl_base, true);
+	u64 val = spec_ctrl_current() | (x86_spec_ctrl_base & SPEC_CTRL_STIBP);
+	write_spec_ctrl_current(val, true);
 }
 
 /* Update x86_spec_ctrl_base in case SMT state changed. */


