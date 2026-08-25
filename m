Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A6847DD79;
	Tue, 25 Aug 2026 13:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664656; cv=none; b=buh4ZNu91p25yKCkqixOjKwlAWasXyNRFd07wxS5L5JJEcJ0G/cdtz1APbTXvg6+7Az7WQB1C2GZeBHTlDLBjI7mfIqUyrbD8EXDWj4Kf8PGF/1j5IVl4c3047sGJ6cuZimtM77NVYexngM3A/U4B/bHGuhH2Bguach8BMNIddo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664656; c=relaxed/simple;
	bh=YfZP+PEVkCrAnaxHhhAsyJDr/Imk3fNGv3IUyvoK0Fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DKTfwCwJntISVz7ePMqLBwLfB/UZ1BOtZng6yuYY9h4LN3HOEzymR9kGqI96t1J/+xQlUX5ieBqat2KK5DPWoEWsx3VsNEOiQvuBtuZwq9pjzOpOSIiLZBgA290nR9KcHs+7LWs5TO5negbFwwrC9Ky9duM/2Hm1yykCPe19zJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aqs0Pvz0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aqs0Pvz0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E60641F000E9;
	Tue, 25 Aug 2026 13:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664655;
	bh=y55ikQUFIGs7M4V2FyDyswp1PajIKv6g289oZ4/UKQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aqs0Pvz0Y/4nAfoIg7Ge9DVHiqSr5HAJhOma2ZM1l7S4srahzm33i2SyU4WPzcbaq
	 acBCwbKA2xI4qKIsZVxFs3uBnsTtIU3opKhrwoOlTkJ01vhWcvjN/wdHWFgJSX0kw9
	 gtBcfUIHKSMTv3/9tbjGKHOk8H8YEICafppXjh1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 7.2 08/82] nvmet: fix NULL pointer dereference in nvmet_execute_identify_nslist()
Date: Tue, 25 Aug 2026 15:24:55 +0200
Message-ID: <20260825132541.860433924@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.560541185@linuxfoundation.org>
References: <20260825132541.560541185@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

commit 79aba4c9403419d822972d2851f2a96a2c0531cf upstream.

When a host issues an Identify command with CNS 07h (Active Namespace ID
List for a specific I/O Command Set), nvmet_execute_identify_nslist() is
called with match_css set. The command-set filter dereferences req->ns,
but this handler never calls nvmet_req_find_ns(), so req->ns is always
NULL (nvmet_req_init() resets it to NULL). As soon as an enabled
namespace with an NSID greater than the requested value exists,
req->ns->csi dereferences a NULL pointer and oopses.

Besides the crash, the comparison is logically wrong: to filter the list
by command set it must test the command set of the namespace being
iterated, not a single fixed value. Use the loop variable ns->csi.

Fixes: 61c9967cd634 ("nvmet: implement active command set ns list")
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/admin-cmd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -958,7 +958,7 @@ static void nvmet_execute_identify_nslis
 	nvmet_for_each_enabled_ns(&ctrl->subsys->namespaces, idx, ns) {
 		if (ns->nsid <= min_nsid)
 			continue;
-		if (match_css && req->ns->csi != req->cmd->identify.csi)
+		if (match_css && ns->csi != req->cmd->identify.csi)
 			continue;
 		list[i++] = cpu_to_le32(ns->nsid);
 		if (i == buf_size / sizeof(__le32))


