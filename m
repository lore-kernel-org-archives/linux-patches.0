Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD7533A712;
	Fri,  9 Jan 2026 11:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959675; cv=none; b=Fl1lkxOyc/vS2+fMhHCpZ9bhsLNeQAWJAPv4j6XBJ2uvbS9LWcpa5sDC968pvfoYmh/MyQCAKzpt1R3lQzftfyesLjIXvioHNZ6SAeHAYT7R/dgWqZ/5defOWQ/ou9crPF4AKjt84pj/hOa6vOMNqolspiZP4O9SSrNwdBAozEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959675; c=relaxed/simple;
	bh=X/GsknKRNjbOxO0w3nd1RcywI72ypQZhlrm8ZWFw3IU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QwRAAF6MF95L2hKLrFemC/nRUe9oX1FO2Ec9Hi7gEnfmMaqE3VOGBvlRXTluc90fvijnknSwOTqNXDow4EC7S1wDtkYNNcQBYYWcnfiA0Vo0fmCRqLASueqc74z9gF9XYxhZuzcfBSK2vSdZxDQhP3RF9pOwTX1QAZAmkR5N2/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FKBJWPUs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FKBJWPUs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A6E3C4CEF1;
	Fri,  9 Jan 2026 11:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959675;
	bh=X/GsknKRNjbOxO0w3nd1RcywI72ypQZhlrm8ZWFw3IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FKBJWPUsu/E9zY6tnjIsn3HoBNN1K0hs3fEMYyHC1RJGoUzmOPtdqrGb65A2JVwEI
	 LU2kC0ycatsYNgU0PHwZ8oAbHTG5TOnwBkHrA/wjfBVUkBgHDMTF2uzAYaHsUvT3GD
	 Clec4eYROFufM/eVfWDG08784pRYH2PTpjpvA4mQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 108/737] interconnect: debugfs: Fix incorrect error handling for NULL path
Date: Fri,  9 Jan 2026 12:34:07 +0100
Message-ID: <20260109112138.065648985@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Kuan-Wei Chiu <visitorckw@gmail.com>

[ Upstream commit 6bfe104fd0f94d0248af22c256ce725ee087157b ]

The icc_commit_set() function, used by the debugfs interface, checks
the validity of the global cur_path pointer using IS_ERR_OR_NULL().
However, in the specific case where cur_path is NULL, while
IS_ERR_OR_NULL(NULL) correctly evaluates to true, the subsequent call
to PTR_ERR(NULL) returns 0.

This causes the function to return a success code (0) instead of an
error, misleading the user into believing their bandwidth request was
successfully committed when, in fact, no operation was performed.

Fix this by adding an explicit check to return -EINVAL if cur_path is
NULL. This prevents silent failures and ensures that an invalid
operational sequence is immediately and clearly reported as an error.

Fixes: 770c69f037c1 ("interconnect: Add debugfs test client")
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Link: https://lore.kernel.org/r/20251010151447.2289779-1-visitorckw@gmail.com
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/debugfs-client.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/interconnect/debugfs-client.c b/drivers/interconnect/debugfs-client.c
index bc3fd8a7b9eb4..778deeb4a7e8a 100644
--- a/drivers/interconnect/debugfs-client.c
+++ b/drivers/interconnect/debugfs-client.c
@@ -117,7 +117,12 @@ static int icc_commit_set(void *data, u64 val)
 
 	mutex_lock(&debugfs_lock);
 
-	if (IS_ERR_OR_NULL(cur_path)) {
+	if (!cur_path) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (IS_ERR(cur_path)) {
 		ret = PTR_ERR(cur_path);
 		goto out;
 	}
-- 
2.51.0



