Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043A91C29
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:27:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74153C433EF;
	Mon, 20 Mar 2023 15:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679326030;
	bh=rv+GyJiahLQZejHLFzkvnbHOD0LwUBvUB6ioqNnkT6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sl/jKAYKoy/cB0VeJApXKUN7Oai0t5u+oO7cW6vNoQbiZafPHYTf1ujvYsYApYi3L
	 JHKiljvW92vuZgf/rttffeHRrsvNyFHCU2WzofLvA55ox8kZm9L3v2W2Cj8nlClW8N
	 J8/IdpI+cW5wYVVRRRe5Yn96yNz/Wjt7HefXYTtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	stable@kernel.org
Subject: [PATCH 6.1 188/198] x86/mm: Fix use of uninitialized buffer in sme_enable()
Date: Mon, 20 Mar 2023 15:55:26 +0100
Message-Id: <20230320145515.348786212@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

commit cbebd68f59f03633469f3ecf9bea99cd6cce3854 upstream.

cmdline_find_option() may fail before doing any initialization of
the buffer array. This may lead to unpredictable results when the same
buffer is used later in calls to strncmp() function.  Fix the issue by
returning early if cmdline_find_option() returns an error.

Found by Linux Verification Center (linuxtesting.org) with static
analysis tool SVACE.

Fixes: aca20d546214 ("x86/mm: Add support to make use of Secure Memory Encryption")
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/20230306160656.14844-1-n.zhandarovich@fintech.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/mem_encrypt_identity.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/mm/mem_encrypt_identity.c
+++ b/arch/x86/mm/mem_encrypt_identity.c
@@ -600,7 +600,8 @@ void __init sme_enable(struct boot_param
 	cmdline_ptr = (const char *)((u64)bp->hdr.cmd_line_ptr |
 				     ((u64)bp->ext_cmd_line_ptr << 32));
 
-	cmdline_find_option(cmdline_ptr, cmdline_arg, buffer, sizeof(buffer));
+	if (cmdline_find_option(cmdline_ptr, cmdline_arg, buffer, sizeof(buffer)) < 0)
+		return;
 
 	if (!strncmp(buffer, cmdline_on, sizeof(buffer)))
 		sme_me_mask = me_mask;


