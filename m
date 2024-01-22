Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0CC14831A;
	Tue, 23 Jan 2024 01:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972064; cv=none; b=OAeWjq4CNgS7XTUihFCcCLPsYGyYptnXxaEj4DRfOQmwTTViPpqBzCHYDt9laGCPERM+8E7SdZ23ljA2OJkBuyrEw4/frV9xCKq7TCVdqbjgSSwufoh4JIFMOiHGVsW4R1lYhuoFPVtB4unSLqqASY3i00AiOpCsX221iPBuNBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972064; c=relaxed/simple;
	bh=5yYpPdpkboP+UloqnFytlOW73PhWAtnw0AlimkRkUkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PmvIFc7pwOhmRuxbsYx1PLhfmidXfmrIXDMghAVf0VsTITW1xr0pkJHL8xXBwCJ/SxP7HxNnTSZr2e2n2GDYeXyIjry/58MWfHJzl0tYdtcu5she3bAzCy4SzeqngM8S7v9/pjuhHgYFCqAKiLI8uX0NMQka1vv1KJJO2NwwDvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CLZ7aU9v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CLZ7aU9v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24043C43390;
	Tue, 23 Jan 2024 01:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972064;
	bh=5yYpPdpkboP+UloqnFytlOW73PhWAtnw0AlimkRkUkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CLZ7aU9v2XT3sXPLsreaqHsnvIllxccESXrXSMgRNileQwq5GsmNITyMeZBFlzxk9
	 YYYZ6HyPc0aTrhDuyvwxjYnB62AWCGYXuhIhE34EDcMhj2jd0dYXjdwi3YqcdOjjqu
	 fa+hr0KtSgX9iaTv6FlxsxYritMfny2j18NU25Rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+afb726d49f84c8d95ee1@syzkaller.appspotmail.com,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.1 417/417] riscv: Fix wrong usage of lm_alias() when splitting a huge linear mapping
Date: Mon, 22 Jan 2024 15:59:45 -0800
Message-ID: <20240122235806.137097416@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

From: Alexandre Ghiti <alexghiti@rivosinc.com>

commit c29fc621e1a49949a14c7fa031dd4760087bfb29 upstream.

lm_alias() can only be used on kernel mappings since it explicitly uses
__pa_symbol(), so simply fix this by checking where the address belongs
to before.

Fixes: 311cd2f6e253 ("riscv: Fix set_memory_XX() and set_direct_map_XX() by splitting huge linear mappings")
Reported-by: syzbot+afb726d49f84c8d95ee1@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-riscv/000000000000620dd0060c02c5e1@google.com/
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
Link: https://lore.kernel.org/r/20231212195400.128457-1-alexghiti@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/mm/pageattr.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/arch/riscv/mm/pageattr.c
+++ b/arch/riscv/mm/pageattr.c
@@ -304,8 +304,13 @@ static int __set_memory(unsigned long ad
 				goto unlock;
 		}
 	} else if (is_kernel_mapping(start) || is_linear_mapping(start)) {
-		lm_start = (unsigned long)lm_alias(start);
-		lm_end = (unsigned long)lm_alias(end);
+		if (is_kernel_mapping(start)) {
+			lm_start = (unsigned long)lm_alias(start);
+			lm_end = (unsigned long)lm_alias(end);
+		} else {
+			lm_start = start;
+			lm_end = end;
+		}
 
 		ret = split_linear_mapping(lm_start, lm_end);
 		if (ret)


