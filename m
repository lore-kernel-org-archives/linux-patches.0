Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049652;
	b=EunF9Gb4W2BdczYuE7Hpy5PsxQfyb+QfQRJ/pB6uKdqTWjiLaQYnPvIOrKPknMcZQaf3
	 RKdcmrJHOO/EdJqrycW93CyxNQ+PfJ8uKXK6r+EzmGYRJRamKd6EHC4A3k2Qg/S5+LPWK
	 hMN+T9ofJYClBzGSveymhzEEyjgR4PYNVi/eRgdGOjVkg11qZr9HEQ8od4coipHvo1du4
	 vF+durYdAUazqsbEirziqciChj0TpuXzanH6ojJucsmoNhnpMmO8v5RmWlQkLoNj5ad68
	 F2hFpVDwJoyXlgY2wD1huEMGFkXdQKUVeqkRb4tW0Uqfx5gc1S3O6M3ddezWZso0fNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049652;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1aNnSspcvn+NUqn9BzvbXfGXt2Q60NYcsA3rotpktus=;
	b=BeQN5BGej0Q7AjO3iVZvo+cevcdSgOk49T0PHaBR5XzOArlN5ostBRUZCorrEOJH6Hcz
	 j88ZXiyFrpHScEFkaxYPJVTX6qOfVOzVwC42t1Iayzdo+UqAbJUP+Wf/yGfIH74oZtNdH
	 VMwctvOmT0tD/NouCFefcM8d8riYY4lFMl+MUvFrhUQcOFcnvCQAT9yU+RrA9uCUrst4X
	 lbUjJyKoUUe+JNhvbxgP+0Nom0mnvrXlEboarj3zNdkFcW5xgqSpX/+TfeisdLH8z6sat
	 xBv2QYopMa2ri0dXK6motbeaQ1siCf52lAR7gRycVCCAtPiJsyMMP7IzXq9UQ252SjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="mWVhO/af";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A96606A320;
	Thu, 19 Nov 2026 00:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mWVhO/af
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A767F1F000C5;
	Thu, 19 Nov 2026 00:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049652;
	bh=1aNnSspcvn+NUqn9BzvbXfGXt2Q60NYcsA3rotpktus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mWVhO/af1OisDQvLZx/fYmxiFolISrw3lUh7nKRlDsgowobkcxXiupdBI9UXkIF+g
	 09vFlBOJR0M3G+I552XE9Aqf1ciICWgngYEJOF3D7RjWcgFcIGwfWrMCQOc/n0wCcB
	 ZrBybAmi3p1tNzNY3wmBEfVSsIm6ta3j3CW4pIiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Schnelle <svens@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2428/2857] s390/uprobes: Fix off-by-one bug in emulated PER handling
Date: Wed, 18 Nov 2026 15:57:42 +0100
Message-ID: <20261118150328.982718092@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 2ba01cf7b2598571486425a0605f1434909b532d ]

The uprobes code emulates some instructions, and with that also
PER storage-alteration handling, in case a debugger is attached.

The PER storage-alteration handling contains an off-by-one bug, which
may lead to PER traps which should not happen. Adjust the comparison
in sim_stor_event() to fix that.

Fixes: 8d1a2427d8fc ("s390/uprobes: fix user space PER events")
Reviewed-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/uprobes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/uprobes.c b/arch/s390/kernel/uprobes.c
index b88345ef8bd9e..b8f09483c355f 100644
--- a/arch/s390/kernel/uprobes.c
+++ b/arch/s390/kernel/uprobes.c
@@ -248,7 +248,7 @@ static void sim_stor_event(struct pt_regs *regs, void *addr, int len)
 		return;
 	if (!(current->thread.per_user.control & PER_EVENT_STORE))
 		return;
-	if ((void *)current->thread.per_user.start > (addr + len))
+	if ((void *)current->thread.per_user.start > (addr + len - 1))
 		return;
 	if ((void *)current->thread.per_user.end < addr)
 		return;
-- 
2.53.0



