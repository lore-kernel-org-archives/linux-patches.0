Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F082441616;
	Tue, 21 Jul 2026 22:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672950; cv=none; b=Rz1rKfwAZspeYb4fY7VBi/QxMoWo3W7GPU2V9zM3F0l6nYRu1PCftB+VdEAqlmpV8ul3SLWQeMcU2HYBJYSUtDVmQ9grdWRg40fQPMBTNuefxEdlS0+UgonZJRDEx1czuqakpa1fNwu/M49ieNReS0mKOmsnR0G+Fd9ZGrMJj0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672950; c=relaxed/simple;
	bh=1FuH1NI4BPwkwhRqYMgGNkAcesmBpBYXCfxSjIBu8og=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=guEDu74J+ihpl/zgWWhMG7BTTK1tnw7B9pKeupWHwq5lt7IBPe1QNrJo4YDCY7kpgusGzQ2wa2TZsTkYHRaNFfga91RJV01xbpafheBnln6xr9eIUATRihY7cMPTHaxNdY9sDlvKqkmWTJq/QLuc+L6jnG9cW3XRfYLQAhZ3Klc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OPiU/Fru; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OPiU/Fru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07E951F000E9;
	Tue, 21 Jul 2026 22:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672949;
	bh=xprAw9GrmrzEroqBSiciL7WtQlyru4oCvrgDMizQPuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OPiU/FruXxlyoZKR0kbR0bM62VyF53S/hGsoY2NRDqUwKi8YNlNgkfrkMUxq0KcGr
	 lmAsmgU7JNDdOsF73RJ7Yd8Muzdd368k1FEKiUEGvf40ERW71pJfBAPz8kzhWkerRs
	 gwXjVwIKF2uamjvkPx5NZ33VcXIulQzhkeomu11c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 775/843] netfilter: ebtables: zero chainstack array
Date: Tue, 21 Jul 2026 17:26:50 +0200
Message-ID: <20260721152423.489006301@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit cbfe53599eebffd188938ab6774cc41794f6f9d5 ]

sashiko reports:
 looking at ebtables table
 translation, could a sparse cpu_possible_mask lead to an uninitialized pointer
 free?

 If cpu_possible_mask is sparse (for example, CPU 0 and CPU 2 are possible,
 but CPU 1 is not), the allocation loop skips CPU 1. If vmalloc_node() fails at
 CPU 2, the cleanup loop will blindly decrement and call vfree() on
 newinfo->chainstack[1].

Not a real-world bug, such allocation isn't expected to fail
in the first place.

Cc: stable@vger.kernel.org
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/netfilter/ebtables.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -923,8 +923,7 @@ static int translate_table(struct net *n
 		 * if an error occurs
 		 */
 		newinfo->chainstack =
-			vmalloc_array(nr_cpu_ids,
-				      sizeof(*(newinfo->chainstack)));
+			vcalloc(nr_cpu_ids, sizeof(*(newinfo->chainstack)));
 		if (!newinfo->chainstack)
 			return -ENOMEM;
 		for_each_possible_cpu(i) {


