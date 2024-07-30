Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E55E189503;
	Tue, 30 Jul 2024 16:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356401; cv=none; b=KGNuWD8ato5TNXZNvl1vGkdvMNBshuPb9QC0EvUSHFYy9T2LarjomIHej0BOpPnb/Fkw/SDux2O3KbV9H4OL9p6+2sj0BHM+NlbWLz4WeRbmCj4FVQD14pp6GdtL0K2I/BdUlQzhq5dn8yfrJ4+7L/G0AUoM3TtdVJ97SCEcs0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356401; c=relaxed/simple;
	bh=PJyBwxIxh4dWqkpdxlZyxwqrJex1L7O9MVJ04LHKHFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/QhJyYNFtrUlMH6cUWfKaViNUD3frHBv5ahl2tZUW9Z+7BsHT3gIvPNw2ZBexMQFWeQnFwaOuuFTGL0dhQq1lF/suWusMpD2dyTkZVPB8BbOFaZsJnoMy/oxA/hpdi4FWDpIL7NQFU2DSPjY+U07NKx0suYe+TSSj/9bax0+Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RfBRe25h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RfBRe25h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10FACC32782;
	Tue, 30 Jul 2024 16:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356401;
	bh=PJyBwxIxh4dWqkpdxlZyxwqrJex1L7O9MVJ04LHKHFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RfBRe25hdtGq8wXnE1v5nuGRHi6EExvkATcsGJiH8ncqQvUX0UdeBpoZcVOCwx2GU
	 NVzJywO7PE1cV2CcyndM3c5f2bpY5nZT+Fn+S4T9/Rt5hCayQyIaecI6GbddNRlNnp
	 Q9CuZ7MwaiLKLJK1ngK5f2ZdhsHoow+CeFdurDb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Gray <bgray@linux.ibm.com>,
	Andrew Donnellan <ajd@linux.ibm.com>,
	Russell Currey <ruscur@russell.cc>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 188/440] powerpc/pseries: Fix alignment of PLPKS structures and buffers
Date: Tue, 30 Jul 2024 17:47:01 +0200
Message-ID: <20240730151623.217205054@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

From: Andrew Donnellan <ajd@linux.ibm.com>

[ Upstream commit fcf63d6b8ab9b12c2ce1b4bde12a3c391029c998 ]

A number of structures and buffers passed to PKS hcalls have alignment
requirements, which could on occasion cause problems:

- Authorisation structures must be 16-byte aligned and must not cross a
  page boundary

- Label structures must not cross page boundaries

- Password output buffers must not cross page boundaries

To ensure correct alignment, we adjust the allocation size of each of
these structures/buffers to be the closest power of 2 that is at least the
size of the structure/buffer (since kmalloc() guarantees that an
allocation of a power of 2 size will be aligned to at least that size).

Reported-by: Benjamin Gray <bgray@linux.ibm.com>
Fixes: 2454a7af0f2a ("powerpc/pseries: define driver for Platform KeyStore")
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
Reviewed-by: Russell Currey <ruscur@russell.cc>
Signed-off-by: Russell Currey <ruscur@russell.cc>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20230210080401.345462-3-ajd@linux.ibm.com
Stable-dep-of: 932bed412170 ("powerpc/kexec_file: fix cpus node update to FDT")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/plpks.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/plpks.c b/arch/powerpc/platforms/pseries/plpks.c
index 25f95440a773b..d54188a355c9c 100644
--- a/arch/powerpc/platforms/pseries/plpks.c
+++ b/arch/powerpc/platforms/pseries/plpks.c
@@ -113,7 +113,8 @@ static int plpks_gen_password(void)
 	u8 *password, consumer = PLPKS_OS_OWNER;
 	int rc;
 
-	password = kzalloc(maxpwsize, GFP_KERNEL);
+	// The password must not cross a page boundary, so we align to the next power of 2
+	password = kzalloc(roundup_pow_of_two(maxpwsize), GFP_KERNEL);
 	if (!password)
 		return -ENOMEM;
 
@@ -149,7 +150,9 @@ static struct plpks_auth *construct_auth(u8 consumer)
 	if (consumer > PLPKS_OS_OWNER)
 		return ERR_PTR(-EINVAL);
 
-	auth = kzalloc(struct_size(auth, password, maxpwsize), GFP_KERNEL);
+	// The auth structure must not cross a page boundary and must be
+	// 16 byte aligned. We align to the next largest power of 2
+	auth = kzalloc(roundup_pow_of_two(struct_size(auth, password, maxpwsize)), GFP_KERNEL);
 	if (!auth)
 		return ERR_PTR(-ENOMEM);
 
@@ -183,7 +186,8 @@ static struct label *construct_label(char *component, u8 varos, u8 *name,
 	if (component && slen > sizeof(label->attr.prefix))
 		return ERR_PTR(-EINVAL);
 
-	label = kzalloc(sizeof(*label), GFP_KERNEL);
+	// The label structure must not cross a page boundary, so we align to the next power of 2
+	label = kzalloc(roundup_pow_of_two(sizeof(*label)), GFP_KERNEL);
 	if (!label)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.43.0



