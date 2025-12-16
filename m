Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7189934253C;
	Tue, 16 Dec 2025 11:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885452; cv=none; b=HRkLd594CdTbD/TYneA5TrlTN9YbLTUnwoYFZPN5ifP4eVM0LfJrt/b4iv3X4tE9cHLCHtbvcG+ZChbqVjKFluiohhx71Nw21X2Qe2+MQeG6e1DSZBeNrK0+ZA69zc75ZyNN8oszDwRfvkIGTD3k7ET5PfNUW4y9tmiM64CF6/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885452; c=relaxed/simple;
	bh=Kxc5n0WWr3cHoaAllhumMYQAmQ2FXQbU8wlrGnMP1o0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pq/YjU+w2GOwHl6J1PEccm6s2liVtrQpmQlHWdS2VDU/d/QVRLySi7lVOaAu+J3EwQmNQrURzJlmBjgJJ4vIq9bEDxvDPYuc7kUfAkJvAbh8cSNW8WTY6lwlRG91hbgU/hNirZCp6ltlHx2N2Rpe0OpzpoxYGduRQ+bRi1FCgVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OQUErGYK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OQUErGYK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C36C4CEF1;
	Tue, 16 Dec 2025 11:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885452;
	bh=Kxc5n0WWr3cHoaAllhumMYQAmQ2FXQbU8wlrGnMP1o0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OQUErGYKKu3I0kdZiYZ6omtGJBL3d6bfBPZhLKcwUcAbF+ITEC2C/pa0lueynKZZN
	 mqMovQMFNRs2oKu0FSO+09DRYPpObdiKl1AJWVweu7klrwggiwg6DWYi3PSEJwKJ44
	 8ovpKgExBMw9WB+K3b2JsPCXaZ6DWj4CGpwVIz2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 144/507] interconnect: debugfs: Fix incorrect error handling for NULL path
Date: Tue, 16 Dec 2025 12:09:45 +0100
Message-ID: <20251216111350.745543802@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



