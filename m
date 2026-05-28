Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6B0329396;
	Thu, 28 May 2026 20:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001216; cv=none; b=YWLGq92VDKejKnkOZEoREZDoU8953CSFUsRGaoGVcgZqGsfbAsGZn38BTYf9PZAmCYSYgsFqKCA+iaPIg5UNpYdVnkwSFxSgsuwrdgDhbgg9DnYkhsqXK1wznhGuOSVSv6U8dftYbjQTVNb9ixcg4enkHumWI35JabZ0z/poajo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001216; c=relaxed/simple;
	bh=kdh1UFJmbNQuM/VbocTQiiaZAk4nu/+62LtqadoE4Xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OjmrzagIvP+bx8lT6nQdRKTSqb57fpFC27cWSnFrltYtjl93JJWd5DtPfBDaCwGijRVz8mm5f07uxe1LgX0jFYGieZYQb9oryemSIqQnLYOOx/zXn7aqeUr1x3RxLE0G4VGTauo1cSXpyQWv4qCmeN5B4ZwC3xmr+NrLm4OazEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=csdvOwds; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="csdvOwds"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A2401F000E9;
	Thu, 28 May 2026 20:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001214;
	bh=dTVdbdeio/vXn6KcWifgVdDUFMbBLCLQyLltXOxrFYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=csdvOwds/3K2WVSlXaVxJFdj/ZB+t4IgAJ0+AIyvilGVPDKoyM6V1d3uLaIyQ3SVC
	 QvUOwaItbuBcrzfU8/y1anAeK6lybdA7N2wYyt2j1b06zN9AZt/yua3T9KFBAlyaIC
	 0BairqR6EmSLMgaU4HcPrP8UCi5Xw5wVu7ySsoyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 048/186] qed: fix double free in qed_cxt_tables_alloc()
Date: Thu, 28 May 2026 21:48:48 +0200
Message-ID: <20260528194930.268269033@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dawei Feng <dawei.feng@seu.edu.cn>

commit 2bccfb8476ca5f3548afbd623dc7a6980d4e77de upstream.

If one of the later PF or VF CID bitmap allocations fails,
qed_cid_map_alloc() jumps to cid_map_fail and frees the previously
allocated CID bitmaps before returning an error. qed_cxt_tables_alloc()
then calls qed_cxt_mngr_free(), which invokes qed_cid_map_free()
again.

Fix this by setting each CID bitmap pointer to NULL after bitmap_free()
to avoid double free.

The bug was first flagged by an experimental analysis tool we are
developing for kernel memory-management bugs while analyzing
v6.13-rc1. The tool is still under development and is not yet publicly
available. Manual inspection confirms that the bug is still
present in v7.1-rc3.

Runtime reproduction was not attempted because exercising the failing
allocation path requires device-specific setup.

Fixes: fe56b9e6a8d9 ("qed: Add module with basic common support")
Cc: stable@vger.kernel.org
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>
Link: https://patch.msgid.link/20260520070323.2762379-1-dawei.feng@seu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qlogic/qed/qed_cxt.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/qlogic/qed/qed_cxt.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
@@ -1038,11 +1038,13 @@ static void qed_cid_map_free(struct qed_
 
 	for (type = 0; type < MAX_CONN_TYPES; type++) {
 		bitmap_free(p_mngr->acquired[type].cid_map);
+		p_mngr->acquired[type].cid_map = NULL;
 		p_mngr->acquired[type].max_count = 0;
 		p_mngr->acquired[type].start_cid = 0;
 
 		for (vf = 0; vf < MAX_NUM_VFS; vf++) {
 			bitmap_free(p_mngr->acquired_vf[type][vf].cid_map);
+			p_mngr->acquired_vf[type][vf].cid_map = NULL;
 			p_mngr->acquired_vf[type][vf].max_count = 0;
 			p_mngr->acquired_vf[type][vf].start_cid = 0;
 		}


