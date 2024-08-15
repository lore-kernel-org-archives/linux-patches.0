Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C131714A1;
	Thu, 15 Aug 2024 13:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730021; cv=none; b=OdqJG+PMDNnJg1Yegw6fOvcsMD3SLyDTtxx0KSG5EoeQT0Eke1G/Wmuf/pn10RlHCcicqu1291dxV0QJBUFEe9yPbVkBFE7OhouD+2pfD/3c3LhvJCeG7chyFzt50wJV6B9aKdHJ9xTf0uIJg3ndu47hABSB/DbABxFJ6tybcYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730021; c=relaxed/simple;
	bh=5XU2PvKxBYu0y+kfu+Ef5N+1u7z1bIpEn4EGstH5OEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kcnR4vkV8O8W9RjpGSQszu+g+BinEdglgU8TqwwEjWPUIrgnz4B6MuXmnKFDBE15RfvYLuOOBkLUtXRw2GgshjjEe9Sb3/oPkmfLSNIcvUvP8hzn5I8mmLPdSImFZQKlrWke6lnghHs07uf4kF0tIhRxHCmV1Fkek8UTDgRNn+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KYhZGXA0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KYhZGXA0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05601C4AF0A;
	Thu, 15 Aug 2024 13:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730021;
	bh=5XU2PvKxBYu0y+kfu+Ef5N+1u7z1bIpEn4EGstH5OEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KYhZGXA0yZj9RywDhzg6gE77dTTpkPWfjFP/2QZk82lTd/ZsYdEnd6Iko6NnVU8cE
	 8g66tr46LCMCxhUwvQ81QcjFPJarRYNf00pzpMC40zURU3HfnhHR2ILAoj8IdU4MxI
	 rA2ZWn1eQjFm0gEznNklJtMoa6809URXzGiou8pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 280/484] powerpc: fix a file leak in kvm_vcpu_ioctl_enable_cap()
Date: Thu, 15 Aug 2024 15:22:18 +0200
Message-ID: <20240815131952.221828011@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit b4cf5fc01ce83e5c0bcf3dbb9f929428646b9098 ]

missing fdput() on one of the failure exits

Fixes: eacc56bb9de3e # v5.2
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/powerpc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index ee305455bd8db..fc7174b32e982 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -1963,8 +1963,10 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 			break;
 
 		r = -ENXIO;
-		if (!xive_enabled())
+		if (!xive_enabled()) {
+			fdput(f);
 			break;
+		}
 
 		r = -EPERM;
 		dev = kvm_device_from_filp(f.file);
-- 
2.43.0



