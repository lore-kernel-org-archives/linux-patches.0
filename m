Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC3F227EBD;
	Tue,  8 Apr 2025 11:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111829; cv=none; b=TAIDu57fSTK/eubPbFeV54zSdRjSvlyYN62tY31HNs7FWgLsPmoESJvWCf/4jurVb3d2sXA2oviAQowUmd5SIPY05yDCEJbR950tR5XvVbBo8OejVzW3JgLgp8UCG8eDj194bGhmTj48wbmrXpmOdjZErD16KgjULx7MupQKq1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111829; c=relaxed/simple;
	bh=qqdN7CnX/QJkPwBdSu4BUeOUwlitKoCWd2SHGOuMu1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BHF2W2WBfss7qhBF2Zbvz1rvDjrrUw6uzyJ/ZKP4EkQxbrSRxzFS5NxlvbmtKHlUlCW4isRcoUgaFG7turxbNPLP3BtEa8Qx+OGSQBBruXRRUlIgc0Ghq6q89D2/zhlqG3oGFV7z61wyVl0caCK3Rq5kM4uQJgszph9Oiz2hCSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XO3gZzVU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XO3gZzVU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BB16C4CEE5;
	Tue,  8 Apr 2025 11:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111828;
	bh=qqdN7CnX/QJkPwBdSu4BUeOUwlitKoCWd2SHGOuMu1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XO3gZzVUiULvmwwX6Jfd9XecYQUcNU1ruFr4mT4FjeGOamn6q2XOCk9qbKKLeya3Z
	 UXoyscWW9NVoyUu4YC4iweQJfNaFnpbb8CT79iz+DGshFdMF7EE9cQTJpWNIBhYUfK
	 W5hvj8AFtirC28+692AU3nOPfXbm2red0ZeJUINY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 575/731] nfs: Add missing release on error in nfs_lock_and_join_requests()
Date: Tue,  8 Apr 2025 12:47:52 +0200
Message-ID: <20250408104927.649193230@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index aa3d8bea3ec06..23df8b214474f 100644
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



