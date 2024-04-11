Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0A613E897;
	Thu, 11 Apr 2024 10:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830670; cv=none; b=Fg8glDofqLqQJlHX/3ZMf05v7OBdbZD3M6wtbdmXDXciYoyuTTdSH3fdoQD77sJn5X1g6AWLFlhkYMYvMSBlF/+ORTEpFDe49ha+XLcwYPiHQIns3jwuEQKnG0ECF0v9SUOfx+vKrEZAbpE5whZEuVAZYwE7IFP9cDi6cIolIqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830670; c=relaxed/simple;
	bh=siq0WyUGTdQ/cFE3X2hvh0y5ZY6rUnnlqBoUe3gBhMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BNlXww4YmPVMW94/lCTfIFLMQYAeTUKEUlGT+ERne6qOisI9bWfbdCvZX1kwvXNaQrXXUb7LcbARA32B1MCvOkA/4BPFt4yhG7glvmo9WyZW3LZ5A6q1CoxCtzuBecBbBlkre0PH4hGvLPu/S1d3dMY8HPTFeQp6OfT7TEJ74T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lIIj0r8r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lIIj0r8r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57864C433F1;
	Thu, 11 Apr 2024 10:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830670;
	bh=siq0WyUGTdQ/cFE3X2hvh0y5ZY6rUnnlqBoUe3gBhMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lIIj0r8r22DGJdi1mCOhBCvvaXnE8DvGMsCP0qiepEVqzxZnGDcfLVIcIsnyNwbM/
	 mIjmQ+O1VVyz84eZtulMCfIqPIim/EieLYCuBaKqMGhgcXGxlgfD4A3Et6WwkFgD63
	 sJoJ0Gi3ZMrcUr2QuU2q7tyouLqmkyRpduPq8zxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Pittman <jpittman@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 079/215] dm snapshot: fix lockup in dm_exception_table_exit
Date: Thu, 11 Apr 2024 11:54:48 +0200
Message-ID: <20240411095427.283006110@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 6e7132ed3c07bd8a6ce3db4bb307ef2852b322dc ]

There was reported lockup when we exit a snapshot with many exceptions.
Fix this by adding "cond_resched" to the loop that frees the exceptions.

Reported-by: John Pittman <jpittman@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-snap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index e902aae685af9..d8902d2b6aa66 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -685,8 +685,10 @@ static void dm_exception_table_exit(struct dm_exception_table *et,
 	for (i = 0; i < size; i++) {
 		slot = et->table + i;
 
-		hlist_bl_for_each_entry_safe(ex, pos, n, slot, hash_list)
+		hlist_bl_for_each_entry_safe(ex, pos, n, slot, hash_list) {
 			kmem_cache_free(mem, ex);
+			cond_resched();
+		}
 	}
 
 	vfree(et->table);
-- 
2.43.0



