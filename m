Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD47D1E2613;
	Tue,  3 Dec 2024 16:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242666; cv=none; b=LdshrcVKUCm6ajWZj6FWwqqCXbuJp5S5VqTXFQkV7QHlrm1eSFXPKNrAj+agvo3N8u8/ueztc5/6hpOEcppMTCd1V6qy4EcRuZu6OAfhhG3+RDudILtPeIhmstEYSJXdh2d1LCBAD4jZyx308PxkVDe0aVU16izqFkOGOEl5ucs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242666; c=relaxed/simple;
	bh=de7KA7KFVKzwdbE20mBstCiI9sI2s/2FWz34UiBzd8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fN4Apj4WwChlUvzoDUiY1ve3Pw3L47/Xfh/JnWR4+Qk0ML9MkBUrdJXQ+bG9+E5eF6Y+7GzvKWuFDNR73Hh0aTVF4MfmVxepg88Z4eOCERf93n7wTuqBqZQVDyjILT++LZ1ilBEYgzGKs8+KJGUezR03CfrFWwk2k4JrtFzHmDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GFrDpwJ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GFrDpwJ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECFDFC4CECF;
	Tue,  3 Dec 2024 16:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242666;
	bh=de7KA7KFVKzwdbE20mBstCiI9sI2s/2FWz34UiBzd8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GFrDpwJ7yh4rMj8jqgPP97C+n8BSO4rXb9QrwhrNhri+Jm+QL2+bGSyO2pjaM2X9E
	 KJaSrVvwy/T4S673l3MGg+57r+tchD7itPg4RnBIeJ6Gn9eUWffYSr1U+RXgK1H/hi
	 1XS90umd8HWl3Mc5tPJpxZm9Mx7mPaQu/grQpUvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 772/826] um: Fix potential integer overflow during physmem setup
Date: Tue,  3 Dec 2024 15:48:19 +0100
Message-ID: <20241203144813.881864424@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiwei Bie <tiwei.btw@antgroup.com>

[ Upstream commit a98b7761f697e590ed5d610d87fa12be66f23419 ]

This issue happens when the real map size is greater than LONG_MAX,
which can be easily triggered on UML/i386.

Fixes: fe205bdd1321 ("um: Print minimum physical memory requirement")
Signed-off-by: Tiwei Bie <tiwei.btw@antgroup.com>
Link: https://patch.msgid.link/20240916045950.508910-3-tiwei.btw@antgroup.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/kernel/physmem.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/um/kernel/physmem.c b/arch/um/kernel/physmem.c
index fb2adfb499452..ee693e0b2b58b 100644
--- a/arch/um/kernel/physmem.c
+++ b/arch/um/kernel/physmem.c
@@ -81,10 +81,10 @@ void __init setup_physmem(unsigned long start, unsigned long reserve_end,
 			  unsigned long len, unsigned long long highmem)
 {
 	unsigned long reserve = reserve_end - start;
-	long map_size = len - reserve;
+	unsigned long map_size = len - reserve;
 	int err;
 
-	if(map_size <= 0) {
+	if (len <= reserve) {
 		os_warn("Too few physical memory! Needed=%lu, given=%lu\n",
 			reserve, len);
 		exit(1);
@@ -95,7 +95,7 @@ void __init setup_physmem(unsigned long start, unsigned long reserve_end,
 	err = os_map_memory((void *) reserve_end, physmem_fd, reserve,
 			    map_size, 1, 1, 1);
 	if (err < 0) {
-		os_warn("setup_physmem - mapping %ld bytes of memory at 0x%p "
+		os_warn("setup_physmem - mapping %lu bytes of memory at 0x%p "
 			"failed - errno = %d\n", map_size,
 			(void *) reserve_end, err);
 		exit(1);
-- 
2.43.0



