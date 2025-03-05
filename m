Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF97F2505A7;
	Wed,  5 Mar 2025 17:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197326; cv=none; b=g2MCdrQu2wppnvHRrggfQcHZ8Rzwey3y7HuManJnE/qxknimAOGeTqMMylWjZ1j9jnoUf2AHNoBLlaFL817//Y+dyDlAyzxgDshFj18fJH7F6accLL+2Bc9qWG+Ofl0PHwBvrWyiAzF1TFJ0449a7rI9WT0iQ3bHFq2aLDSmYHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197326; c=relaxed/simple;
	bh=2mmBXDJ3hI8LnoJB4FsrWF8QosQ/JasnnqrC2gmD+6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TmDqNZuaDESyINZFU8trSzdYnsZRiR8jGgRfhAhQbtZp10SxscCov3Pa5kdEwIZUaruwfkGRVMWfwC1GceNtsdZk3aplu2wu/QPBaFwfxfUrzzmmAz9fVoVRshESbExmVfoMx/FWmkELp1WYXVMi3BaHsRmC2BLKc/Yf9wxCyLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xkXoSkb/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xkXoSkb/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9F7C4CED1;
	Wed,  5 Mar 2025 17:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197326;
	bh=2mmBXDJ3hI8LnoJB4FsrWF8QosQ/JasnnqrC2gmD+6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xkXoSkb/EKfj0fZ20jXyQ9L7MTY45wEnIai9W1E8G9ggC1AobzyCltesSJ4783Jkf
	 iDSOPOQE2U8CmQQ0LLGsbB+p68Rickgb52LHjxTACZZ9TxPQHmZeW3w9WXrFVIV7zW
	 6Ir02ippN2YoCMJBI26j9n0ckveLM/2jHR3GyFkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 118/176] afs: remove variable nr_servers
Date: Wed,  5 Mar 2025 18:48:07 +0100
Message-ID: <20250305174510.197015940@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit 318b83b71242998814a570c3420c042ee6165fca ]

Variable nr_servers is no longer being used, the last reference
to it was removed in commit 45df8462730d ("afs: Fix server list handling")
so clean up the code by removing it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Link: https://lore.kernel.org/r/20221020173923.21342-1-colin.i.king@gmail.com/
Stable-dep-of: add117e48df4 ("afs: Fix the server_list to unuse a displaced server rather than putting it")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/volume.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/afs/volume.c b/fs/afs/volume.c
index a146d70efa650..c028598a903c9 100644
--- a/fs/afs/volume.c
+++ b/fs/afs/volume.c
@@ -76,11 +76,7 @@ static struct afs_volume *afs_alloc_volume(struct afs_fs_context *params,
 {
 	struct afs_server_list *slist;
 	struct afs_volume *volume;
-	int ret = -ENOMEM, nr_servers = 0, i;
-
-	for (i = 0; i < vldb->nr_servers; i++)
-		if (vldb->fs_mask[i] & type_mask)
-			nr_servers++;
+	int ret = -ENOMEM;
 
 	volume = kzalloc(sizeof(struct afs_volume), GFP_KERNEL);
 	if (!volume)
-- 
2.39.5



