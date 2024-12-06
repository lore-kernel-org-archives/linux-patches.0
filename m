Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8339014D2BD;
	Fri,  6 Dec 2024 15:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498426; cv=none; b=S9+WSCzxvmF8L7dfG2IdIPQ9SnHTifUJ5vSZgYzRnQ7iNOGfAdIQC5rSLTjwyFzjrWWZ0SPp1UAoRA8Z93nhU+fJLyOrNNQvU2aQlVmuPDOfxq+3S0mKfoOzojJvwSPyWMvwxDz3miRDQ8I/9XbbogO72/h91CE1k8vPRXrgjVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498426; c=relaxed/simple;
	bh=6qCkCkM8eGklvn1k/W9cl0X7y1PO8pnD3LG6PGZUBfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VqbeYKfgv6xQ0g2qLhfeEtGj8oSquSCo8H7jU079lBpma5xH//pK6cSeP28IE6klfhQxsLyRrngcwPXY2jYMdGqyiVu0XToge6VqysNK7CM3DUPrc2zzXHyp1+OPLCFQSbcUW7U1/nbM4UR5IgYOoMRMv9nnCIveCVsfHY//tCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wY7YZlSV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wY7YZlSV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 045F1C4CEDE;
	Fri,  6 Dec 2024 15:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498426;
	bh=6qCkCkM8eGklvn1k/W9cl0X7y1PO8pnD3LG6PGZUBfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wY7YZlSVlCx3BmBYMAF6c45d6NfkoI8/z6+eeCkraIHJjvreCgUCF97zZdZufz/2H
	 TRvYCgS+2c1Dqfxz9VHbRm2wZYiVARJzphSXVfIaRoWiAstVCIoTRkXXZxlQhDcDeP
	 iqcjRRxuDP2coVOkLsVEqno9Tr4NfYBwcsJKOtfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 554/676] um: Fix potential integer overflow during physmem setup
Date: Fri,  6 Dec 2024 15:36:13 +0100
Message-ID: <20241206143715.007463967@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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
index 91485119ae67a..4339580f5a4f6 100644
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



