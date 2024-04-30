Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB23F12BF32;
	Tue, 30 Apr 2024 11:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476579; cv=none; b=UB8GorLsskl5HBfrPDs0+YFb+Dc2SDJR8D8OAoRXDb5+cuzysHeRzTozp1jGwEH7nA3avcThmPoJMLjJbEmEHVBRVPgB0BqQh8F/shgWqdf8/DoR3gMxy/gam7uw85OPlf1dlw1+8ti86AkxquKFkDR5SKRZ/Uk9rjtToI72qw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476579; c=relaxed/simple;
	bh=I0T9B/BHBDTZYRwqFOn48zFYEB4QNEAW5MZWg5h1Bgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CI4VvXOa1349K26IA04swfQ1rcYiwOH9C6TKrxzahGFdV95VZuSwnWTOD/8Mo52kNAgyPA3V272pyXaG9mHiLXz1LVgCoJT63Eu9s6wrWopR/HpSWnHyzixl4yc25rJDO8AtJKdHwsFyZ+8iK/dOZQifFAfkplaWonsND6bf8Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VHnbvO2y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VHnbvO2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65984C2BBFC;
	Tue, 30 Apr 2024 11:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476579;
	bh=I0T9B/BHBDTZYRwqFOn48zFYEB4QNEAW5MZWg5h1Bgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VHnbvO2yvYVWrOuX6IAUnx+/FqCz8lxHPFbJRaZf1ZXECvfurhJFkh7bOjsFyncrK
	 HmFZ+qnCng9sXcY53xL1Gs73gqBYiDvqu4ht7alrZkh/e6zl8BaWjAlssXdNzvdjCi
	 QIHCoynGf4zXh/0MpTJTf69YldZ8yuRuLjLe6RXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiantao Shan <shanjiantao@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.1 076/110] LoongArch: Fix access error when read fault on a write-only VMA
Date: Tue, 30 Apr 2024 12:40:45 +0200
Message-ID: <20240430103049.810033677@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
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

From: Jiantao Shan <shanjiantao@loongson.cn>

commit efb44ff64c95340b06331fc48634b99efc9dd77c upstream.

As with most architectures, allow handling of read faults in VMAs that
have VM_WRITE but without VM_READ (WRITE implies READ).

Otherwise, reading before writing a write-only memory will error while
reading after writing everything is fine.

BTW, move the VM_EXEC judgement before VM_READ/VM_WRITE to make logic a
little clearer.

Cc: stable@vger.kernel.org
Fixes: 09cfefb7fa70c3af01 ("LoongArch: Add memory management")
Signed-off-by: Jiantao Shan <shanjiantao@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/mm/fault.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/loongarch/mm/fault.c
+++ b/arch/loongarch/mm/fault.c
@@ -193,10 +193,10 @@ good_area:
 		if (!(vma->vm_flags & VM_WRITE))
 			goto bad_area;
 	} else {
-		if (!(vma->vm_flags & VM_READ) && address != exception_era(regs))
-			goto bad_area;
 		if (!(vma->vm_flags & VM_EXEC) && address == exception_era(regs))
 			goto bad_area;
+		if (!(vma->vm_flags & (VM_READ | VM_WRITE)) && address != exception_era(regs))
+			goto bad_area;
 	}
 
 	/*


