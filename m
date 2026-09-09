Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14752545D95;
	Wed,  9 Sep 2026 14:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962944; cv=none; b=LTX2kxdJc3DIKsqLbNyUXjJaPaNUpqd9BWlSwq+7jdb9NLLMv+D7okC2bMpGlMQAclFB/l5GLkotdI9VIaFVcYOO2sWdrkouIq/27Jat13xolaml1EQkVmlKdZPshoHcSJseJBdAoGDuXWGu6/s5u2W1dSYmPhn05Uwqob6C5wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962944; c=relaxed/simple;
	bh=ZpnSK3AEPItrZ/VvFTUevXdy8g4J/WlJyPAEHzMBlss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QtKCkfKIY2MTDTdHSub2t1l/Os6525FfQnDex28JSWyI8sCcKNpvZWwWT2/7Vfwz5TD28oPP3Wo2nXOWLAA7ZdCwFGbjdd9sGo5SZ8xdL3QXstCU4UpvU5UlbAdwhCFlf2OAOPU1OBoLijijPLpANnx01HH6t+lnh2+t0Cr3fuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vT9BEIvm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vT9BEIvm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6651F00A3A;
	Wed,  9 Sep 2026 14:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962943;
	bh=/4xJW2I+hAQDIMhnIKDvxasgeWROakvfcddAKbMst74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vT9BEIvm9crybcXJJKITsEof8SJz7RWddD+vMC1OuRVcjMqDCVakaMzlAXI+0YGXm
	 GpwtHZlXi+rBhUbQi9qtvRGsTVmwZYzH5Ljmsh0FDu9uyszjachxHfpfkqmf04DGO9
	 iFalp3MxALV5PiK+cUZ/L6C7aDyonflJTlJ7lbLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 7.2 466/556] f2fs: fix to clear dirty flag on folio in error path
Date: Wed,  9 Sep 2026 15:42:26 +0200
Message-ID: <20260909134246.949520624@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

commit 5b86eab84ac8e9289b5afc52ef88ab18ba5bacab upstream.

If node block is corrupted due to chksum mismatch or inconsistent
footer info, it needs to drop clear flag of node folio, in order
to persist inconsistent node data to storage.

Cc: stable@kernel.org
Fixes: b42b179bda9f ("f2fs: fix to do checksum even if inode page is uptodate")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/node.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1618,7 +1618,7 @@ page_hit:
 	if (!err)
 		return folio;
 out_err:
-	folio_clear_uptodate(folio);
+	clear_node_folio_dirty(folio);
 out_put_err:
 	/* ENOENT comes from read_node_folio which is not an error. */
 	if (err != -ENOENT)


