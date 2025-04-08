Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1917B267731;
	Tue,  8 Apr 2025 12:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115073; cv=none; b=HjE4J1iDiAcLJi2A+FCbJ/IA1MWcth6cxU+JMsbb+kC5N2+Zdh2TaDL2wRpipqH1eGkffmyZAgqW06qPueJp4/gbxAtniheiiIR6PVclPAwi59Ll5QJg0htVjXWjTSCZeH0Z8nXuo97oXdDsFXK3pgSCcvA09M2lV9BRjMriME4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115073; c=relaxed/simple;
	bh=col8mfYPAfUmurZMgO1s3rICv1TBTPzLG6OQAJcjGvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o/zwrf6kbvi4d65cER+QzWjlUrY9/FR57W2GQgIEZ7oH/X123YcnJg2kU/LGx8XPUQHkdofc1IQCFAeK/2JUZZCa2fUM5wCzkZqllhftwpvpD9un46ZKyjF6cQDp2RZrfm2quHDIRmUWi7VsvboNUDwzq7aFeFnJ3Q35fztaToM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=et28LI/W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="et28LI/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C243C4CEE7;
	Tue,  8 Apr 2025 12:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115073;
	bh=col8mfYPAfUmurZMgO1s3rICv1TBTPzLG6OQAJcjGvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=et28LI/WJyXV5DT4zpFCZioA0wSFqfixlT/Ts//IazCNVOmd2LcJuJn8hhJznRM2z
	 qcKLVOqTbsCpj+M1oaiudtnOWnH5oIaZILnmJoI3muXYOg2F0wiHADUX3LTMkcURxQ
	 bmCZt1EC9KbLxKCmgxA6cEJaBCx4sTCXZ3rLEYDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 299/499] nfs: Add missing release on error in nfs_lock_and_join_requests()
Date: Tue,  8 Apr 2025 12:48:31 +0200
Message-ID: <20250408104858.673219733@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 8e5419d6542fdf2dca9a0acdef2b8255f0e4ba69 ]

Call nfs_release_request() on this error path before returning.

Fixes: c3f2235782c3 ("nfs: fold nfs_folio_find_and_lock_request into nfs_lock_and_join_requests")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/3aaaa3d5-1c8a-41e4-98c7-717801ddd171@stanley.mountain
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/write.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 50fa539611f5e..7d71af3265673 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -579,8 +579,10 @@ static struct nfs_page *nfs_lock_and_join_requests(struct folio *folio)
 
 	while (!nfs_lock_request(head)) {
 		ret = nfs_wait_on_request(head);
-		if (ret < 0)
+		if (ret < 0) {
+			nfs_release_request(head);
 			return ERR_PTR(ret);
+		}
 	}
 
 	/* Ensure that nobody removed the request before we locked it */
-- 
2.39.5



