Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9E91E2834;
	Wed, 25 Feb 2026 01:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983620; cv=none; b=DQDWSAkLgl9h9Ot+AxSgBwzXe3wRVA1W26pN1AcjXiH3iSc7BGCHINydNTyzXkT9K9Yv6Dq+iLrvIQa9aRefVRy2knR8vmVvr5iHZ3Pdq+/5+qcsoQgxb9KemehkdIIQipwHUjJ4x4YnDY51/aeONZQiDyW0fgNt8pGj8U7e08k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983620; c=relaxed/simple;
	bh=97R2Cv0yJyxvoRmXa/jdgktpCPsJqhp1n8ITfkwYO0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VNfVua3Bvk5HVeFvoFCaZNFO1qaJjO+xR52woLehJqhramR2Cm9lVetgcr/ODQl88fjGRDfyHXeJeXzOIfp7OAs60UEFt7wDa5j+4YIZfdoP+scbXHYhizDHkBMjmkBeawwRP/DftYpJ5Q4gKqq69hvtReed+DEVGt1gNPw+MAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W0EoDC9s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W0EoDC9s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79351C116D0;
	Wed, 25 Feb 2026 01:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983620;
	bh=97R2Cv0yJyxvoRmXa/jdgktpCPsJqhp1n8ITfkwYO0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W0EoDC9sMQeV1PngBNAJjHtzy82fElHLUVBbwqa7oRbh3+Kje0xd/e4gZN7GAgJus
	 tYIlSN40/b0/2v4tF2+yaZkQo4YM53DyxdfurOr+vlvXweLPRGZa6M1q9u7KjimHCO
	 fD7Wd66KKnHrYickBHyrPqENjGuj5KhJNLajvd30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Lee <ryan.lee@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 696/781] apparmor: fix boolean argument in apparmor_mmap_file
Date: Tue, 24 Feb 2026 17:23:25 -0800
Message-ID: <20260225012416.827627023@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index a87cd60ed2069..acca3d6efdbc8 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -584,7 +584,7 @@ static int common_mmap(const char *op, struct file *file, unsigned long prot,
 static int apparmor_mmap_file(struct file *file, unsigned long reqprot,
 			      unsigned long prot, unsigned long flags)
 {
-	return common_mmap(OP_FMMAP, file, prot, flags, GFP_ATOMIC);
+	return common_mmap(OP_FMMAP, file, prot, flags, false);
 }
 
 static int apparmor_file_mprotect(struct vm_area_struct *vma,
-- 
2.51.0



