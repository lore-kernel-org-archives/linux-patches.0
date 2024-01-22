Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474AA5D8F9;
	Tue, 23 Jan 2024 01:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974391; cv=none; b=KNB+fOiyu+u5icCSLeVt9ZtPfGZNam6oXSrBSD9x+rq0aeIKu1MThSGoSr1cY/nqWQ5i3cDjjA1EFBi0Ywj3x5aA09JvlPasxVcWYXAnc/4TcEp10txA+rQi5usB4uFbuRJT8lxO/BFGJO+T8qt/NIukEGaPKXjcUNn/n9hZTqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974391; c=relaxed/simple;
	bh=FPA65sa25pXIEJ1GT9KuHhIK4ZwWFBvQmAkHq6+9e44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHR0chMDuXCpFJUkdpdkaN6OOWN0g1DU9WcreZXpwXqbsR0xxeRTGOF1QCXDSmRIc0mtBXOzT683Qz+ZfiqxE5WtqHR27tffsRcu8KMO9ZV+SNeBFH+Yho9yeO9gOfl5hG3AOKyVblGEGH/cDsNLpVsaU9EFVREcWtpBM2I6RjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yQ6d9Dmg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yQ6d9Dmg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11876C433C7;
	Tue, 23 Jan 2024 01:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974390;
	bh=FPA65sa25pXIEJ1GT9KuHhIK4ZwWFBvQmAkHq6+9e44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yQ6d9Dmga5gVes18z8Vm2h/+MGDkVbYp7EF1ay5hlXHiyAf74eSx2BGZvarkmE/0G
	 RTSOl78nfBj547RPkW+xvOWR9r9WrHJ8mOPvKUMg3HpIoJn3IB66Pj8uH++mqpzrN+
	 FYU14a6jgZt6lPNodHYhiHSqaYVirDuIb/lB8OpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David McKay <david.mckay@codasip.com>,
	Stuart Menefy <stuart.menefy@codasip.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 081/583] asm-generic: Fix 32 bit __generic_cmpxchg_local
Date: Mon, 22 Jan 2024 15:52:12 -0800
Message-ID: <20240122235814.632397807@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: David McKay <david.mckay@codasip.com>

[ Upstream commit d93cca2f3109f88c94a32d3322ec8b2854a9c339 ]

Commit 656e9007ef58 ("asm-generic: avoid __generic_cmpxchg_local
warnings") introduced a typo that means the code is incorrect for 32 bit
values. It will work fine for postive numbers, but will fail for
negative numbers on a system where longs are 64 bit.

Fixes: 656e9007ef58 ("asm-generic: avoid __generic_cmpxchg_local warnings")
Signed-off-by: David McKay <david.mckay@codasip.com>
Signed-off-by: Stuart Menefy <stuart.menefy@codasip.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/asm-generic/cmpxchg-local.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-generic/cmpxchg-local.h b/include/asm-generic/cmpxchg-local.h
index 3df9f59a544e..f27d66fdc00a 100644
--- a/include/asm-generic/cmpxchg-local.h
+++ b/include/asm-generic/cmpxchg-local.h
@@ -34,7 +34,7 @@ static inline unsigned long __generic_cmpxchg_local(volatile void *ptr,
 			*(u16 *)ptr = (new & 0xffffu);
 		break;
 	case 4: prev = *(u32 *)ptr;
-		if (prev == (old & 0xffffffffffu))
+		if (prev == (old & 0xffffffffu))
 			*(u32 *)ptr = (new & 0xffffffffu);
 		break;
 	case 8: prev = *(u64 *)ptr;
-- 
2.43.0



