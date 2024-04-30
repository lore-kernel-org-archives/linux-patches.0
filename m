Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E41512D1E8;
	Tue, 30 Apr 2024 11:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475572; cv=none; b=moF/HgNypCX1op9wPDYJ/3o2idxPpQBCdqR7KFNg+5wbzuuMbl2n24sbT6GURNxRyTyJI7OEF29f1kO6Eg0gmefmP4mrVpplM+vcto/a9Q8Ke6qaDhiF4U7cy57OK6XKqLepXAUES4ZPAVBVmuizqd47ZDjpJZJxfQ/446j2Q1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475572; c=relaxed/simple;
	bh=NBfnvJx0VXjiVwqx8qsDHYxoqK1uvi4yLKAJg4vGu2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rp3DoQ037gpaZ3GTHuYvyGa2/FOOyjzgRJcrTlmnxBRE1dT5J0Lz0mShUYBnXDu3YhfoupxKmxIj3VT6//N4s08Jq5nn5kbOp8FJqKyV+StEgW+3GC+GuhvSTE5SEF364qyS7MeW5rHZYTXwsFbf0uXkc3IbLimsxBky7mvWy6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o/gFFiSw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o/gFFiSw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82480C2BBFC;
	Tue, 30 Apr 2024 11:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475571;
	bh=NBfnvJx0VXjiVwqx8qsDHYxoqK1uvi4yLKAJg4vGu2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o/gFFiSw5fuN8m2z5Gz0c5ZkhuiPYGqYvI+HePm9dfnqrBmugjrL9RNZ+X0dHwn9k
	 NA6ugv6MWc5BV+qtq72jHpIHfWGypjlM+lzVRlG2gP+KRfbLBeI5RRFR9h/B2MYR83
	 NemkHZ4CbZ1CyZxu4ddCDWEH+XviotuImXBQHsaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiantao Shan <shanjiantao@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 137/186] LoongArch: Fix access error when read fault on a write-only VMA
Date: Tue, 30 Apr 2024 12:39:49 +0200
Message-ID: <20240430103102.010267865@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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
@@ -202,10 +202,10 @@ good_area:
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


