Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE091B96D;
	Thu, 18 Jan 2024 10:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575257; cv=none; b=tMpEvAi05/BLum5i3EEsdnblxLlXilD/3NNDJZ8/fBCZlYyeeH81chuECDqQkkbFy/bg7da16oFepezDG3xc9HbjxDTE4oItcgjQmMKTKa9B0rYzT9E7myqB238jSKQ+YqxCYptSUvOOWbjoh4xZvVFXY560196BVwQJIXlfoBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575257; c=relaxed/simple;
	bh=vnuX+LgN0jW9hMl3TtaU2bvGkupuAEDLBGZ+SpYYUlo=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=HyrUzU2NJraGzRuhKMITu0St+5q4+qhW0XQkpSy9nftIVbDtF+h+emaKyAHl5V7Q8dRNgiqFybeBWSpBqfS7EKTIpWtFhaEVzwpeLENQp6RE7Q8eRiRtYqPhDlZUBurRPGP1hZHahSJxBijE6FmEm4MnF1F9jjAXj9JsC9Nhai4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cZ+mRN1v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cZ+mRN1v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD04AC433F1;
	Thu, 18 Jan 2024 10:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575257;
	bh=vnuX+LgN0jW9hMl3TtaU2bvGkupuAEDLBGZ+SpYYUlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cZ+mRN1vVk+cJeDg45CuDvRB2EbkV0fH5Sqt0dgks4Tie9Y+jlZerYuTBwOP3UdyV
	 CJrm2gKgu5zMNEK4uSCy+Kkr60JQIzsSQ1QwAsWOT9ARIasBaGUhR15FehMJBMe3M5
	 Ui27QIBZuPDMGhQtm5hL45ewxs1zwNhvuyWP2xlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hengqi Chen <hengqi.chen@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 068/150] LoongArch: Preserve syscall nr across execve()
Date: Thu, 18 Jan 2024 11:48:10 +0100
Message-ID: <20240118104323.117387570@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

From: Hengqi Chen <hengqi.chen@gmail.com>

[ Upstream commit d6c5f06e46a836e6a70c7cfd95bb38a67d9252ec ]

Currently, we store syscall nr in pt_regs::regs[11] and syscall execve()
accidentally overrides it during its execution:

    sys_execve()
      -> do_execve()
        -> do_execveat_common()
          -> bprm_execve()
            -> exec_binprm()
              -> search_binary_handler()
                -> load_elf_binary()
                  -> ELF_PLAT_INIT()

ELF_PLAT_INIT() reset regs[11] to 0, so in syscall_exit_to_user_mode()
we later get a wrong syscall nr. This breaks tools like execsnoop since
it relies on execve() tracepoints.

Skip pt_regs::regs[11] reset in ELF_PLAT_INIT() to fix the issue.

Signed-off-by: Hengqi Chen <hengqi.chen@gmail.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/include/asm/elf.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/loongarch/include/asm/elf.h b/arch/loongarch/include/asm/elf.h
index b9a4ab54285c..9b16a3b8e706 100644
--- a/arch/loongarch/include/asm/elf.h
+++ b/arch/loongarch/include/asm/elf.h
@@ -293,7 +293,7 @@ extern const char *__elf_platform;
 #define ELF_PLAT_INIT(_r, load_addr)	do { \
 	_r->regs[1] = _r->regs[2] = _r->regs[3] = _r->regs[4] = 0;	\
 	_r->regs[5] = _r->regs[6] = _r->regs[7] = _r->regs[8] = 0;	\
-	_r->regs[9] = _r->regs[10] = _r->regs[11] = _r->regs[12] = 0;	\
+	_r->regs[9] = _r->regs[10] /* syscall n */ = _r->regs[12] = 0;	\
 	_r->regs[13] = _r->regs[14] = _r->regs[15] = _r->regs[16] = 0;	\
 	_r->regs[17] = _r->regs[18] = _r->regs[19] = _r->regs[20] = 0;	\
 	_r->regs[21] = _r->regs[22] = _r->regs[23] = _r->regs[24] = 0;	\
-- 
2.43.0



