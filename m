Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D830D2BDC03;
	Wed, 25 Feb 2026 06:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002765; cv=none; b=X9W3JnqzIVi9QTKnhWwNI76vuvZfP/ovm1tg7knFZaN5vB6ofimP2ib7YaOG2UjyY7htvakf/0sh1KemhioUUPYxyAt+Ds4qgHI/RodbxU3ISEUHgA4KkpckboVO6DnH/SyonhmMu3uOn6TZJ1w8Lr8S2lHbO0DZYVWh3vD+4Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002765; c=relaxed/simple;
	bh=GuWTbpIuy1Qj9rDdofkj7bp08xvuNqqzKWFJQMSdKtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+nLTlMnhBq2zFiptNmUudAQr0aOWU6E84ByD4ht+M2pDlXGGOpF8p3R0dF8PIC9BcBrQjXnrBqKAavzUxCljdRtD0axazw3ZkYtdOUDheIxPjBLuLId86gjsHB0HIEmDYy6eOmZEULV+laXgFoqZE1HxPmBGWDwJa0uHkrfhNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CZKcM03x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CZKcM03x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFA53C2BCB3;
	Wed, 25 Feb 2026 06:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002765;
	bh=GuWTbpIuy1Qj9rDdofkj7bp08xvuNqqzKWFJQMSdKtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CZKcM03xTLzqw8qzUb8bHfyzx1KaZLYheBaB0T8hpEsoH7OIIbJUEtDFx8PEJkr0K
	 d1Q/EdrjCH/9++ijxEBClhOdf0O6xTdrGcVtg/He2pXBvPC0B9NbhQiAV3KLNK1sNs
	 RVOt/6iMtdZuXuwnD0BGY6Fwpzqm2qqj5DyVp2iw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Lee <ryan.lee@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 568/641] apparmor: fix boolean argument in apparmor_mmap_file
Date: Tue, 24 Feb 2026 17:24:54 -0800
Message-ID: <20260225012402.284733601@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Lee <ryan.lee@canonical.com>

[ Upstream commit 48d5268e911abcf7674ec33c9b0b3e952be1175e ]

The previous value of GFP_ATOMIC is an int and not a bool, potentially
resulting in UB when being assigned to a bool. In addition, the mmap hook
is called outside of locks (i.e. in a non-atomic context), so we can pass
a fixed constant value of false instead to common_mmap.

Signed-off-by: Ryan Lee <ryan.lee@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Stable-dep-of: 4a134723f9f1 ("apparmor: move check for aa_null file to cover all cases")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/lsm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index b3f7a3258a2cf..b02c6c8951cd6 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -583,7 +583,7 @@ static int common_mmap(const char *op, struct file *file, unsigned long prot,
 static int apparmor_mmap_file(struct file *file, unsigned long reqprot,
 			      unsigned long prot, unsigned long flags)
 {
-	return common_mmap(OP_FMMAP, file, prot, flags, GFP_ATOMIC);
+	return common_mmap(OP_FMMAP, file, prot, flags, false);
 }
 
 static int apparmor_file_mprotect(struct vm_area_struct *vma,
-- 
2.51.0



