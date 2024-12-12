Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C56813C918;
	Thu, 12 Dec 2024 17:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025556; cv=none; b=TyuWhphmuv+wZHfjC+auSaM0wCe5JnZ3e8qmbdtr5vR1y4tSGOea7wm+7oZ4f3az5/MsSWH6+Wvm1LffDvui0ejC/qG2ICF7FtFMQni+qkgYJxBu4+1K1EzmTzjzw7JURh+DtvZMiPRXm50f+FXiEHxHcaJ8V42SaPYLudkKqpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025556; c=relaxed/simple;
	bh=6Q3ryqNQ8xyy2giDrcwLSITSlr0SmS+qa5+M9kDMN4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D4Qeb8+Bg/WI1xhiAea63yRFlWj+lwEFHeJUlxEec+tnFGxypLFKhSEfy95LuXxN1xiq7Ebv71UUTtB6AkrWxJDf+1HdGI3kG28PWT2FJbyz5NTGPTtC0BSruqx/ozyfR26tJYpiqr/f5Usk9G5rBUBaehfy68LWVZB7UecoJDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BvS853qv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BvS853qv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 949BAC4CECE;
	Thu, 12 Dec 2024 17:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025556;
	bh=6Q3ryqNQ8xyy2giDrcwLSITSlr0SmS+qa5+M9kDMN4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BvS853qvAGGBM/F2qDCqPNSy+5wsi3DTBRjtbheK1T9Rt8jhhxNuhTys/To6D36Lt
	 GWLPalucoOAajVmntkVbFxX0AKPpdztbbAokKFlQzc7CjxeM83tUdnmKzOWtGyroqe
	 la/mYqfxZzPHH9XiFPyXU+RgdavIUTMCEBJacajs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 178/321] um: Fix potential integer overflow during physmem setup
Date: Thu, 12 Dec 2024 16:01:36 +0100
Message-ID: <20241212144237.020243101@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index e7c7b53a1435b..87b51089b0616 100644
--- a/arch/um/kernel/physmem.c
+++ b/arch/um/kernel/physmem.c
@@ -80,10 +80,10 @@ void __init setup_physmem(unsigned long start, unsigned long reserve_end,
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
@@ -94,7 +94,7 @@ void __init setup_physmem(unsigned long start, unsigned long reserve_end,
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



