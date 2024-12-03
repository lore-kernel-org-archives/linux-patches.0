Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7674A1F8AF9;
	Tue,  3 Dec 2024 15:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239879; cv=none; b=nT/0zOqzpPiMLHfX2ufhxp2tZXVOqsPaMkQuVuMD6aAkaA72S4WxdHO21mDLElj1Ls7vkVCXNKdtSllHp6eakUNI5Soz0gLWmFZA0O5soGrOMoFJhaHPb1woXkbKecxRvPyv6YLrTBXpw35hihoCMxHaHDcnJ5vLRULt+ki+Vxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239879; c=relaxed/simple;
	bh=fYWqacPgxTwMtGNQwsI7dPitRwiv3VzParEZgbkPxWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cQ4IMZCG0ubKEf7wqs8aIwPePUmP1vFBd50+mJUWd4dNmKU7zKE9UttiplNYgESjeM4djt+OGmVMDoBt9+TGifwdmOZrL3pv0Fz2mkR1JujiU48Dql7kYYZXcwoB4yAuasjHs7NJVP4hOb4Wg+OYLudLQTmFnTzSfrhK3YHgXzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LDlYMsL9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LDlYMsL9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEFDEC4CECF;
	Tue,  3 Dec 2024 15:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239879;
	bh=fYWqacPgxTwMtGNQwsI7dPitRwiv3VzParEZgbkPxWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LDlYMsL9PE+iS8IRkzs7Zt8ZcWSsKiMTlJgN51mJnoFV9pdNz/5oxl0Kcw4onrTho
	 Iu7eGHRNVhoGVVipQEdDEmhQYrPTYmtjGmZ6uL4hds5nmsPl9m1H/OjaDoIVTPM7La
	 l7Etp2jo/uTFM00dzM4jofYFkgEkARVR8FqOX1G0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 765/817] um: Fix potential integer overflow during physmem setup
Date: Tue,  3 Dec 2024 15:45:37 +0100
Message-ID: <20241203144025.867399728@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



