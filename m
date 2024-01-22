Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B70D6AA6;
	Tue, 23 Jan 2024 01:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974097; cv=none; b=jZ8H2sO+fvBf/rMB1f10mMyObVd1RPHCLLYFDmkMkK77IS7EsJaXFwP6oRuaO3F7Ps5XQje4V5RWYg7WPx15+0dyVkwraqgHD2RDFVe+aP9Kj7hwTzd/PtSikvgg/lE04DC/eixI3OnKEjLKYFrzOOb8Url5PY+T5eo9KjGNcxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974097; c=relaxed/simple;
	bh=8uhAKQTybVcUQjGjyDCEYZtiXfV8BEN9qyfZeROp1yM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C4UDsESrq0e0OrAg5EdZsErPY/ajgDoEAcD4DRBEm/56osunx9F3yCx5QFsCmo/k+yIS24y0ivPt6/y8V2caCOd8Ar58WaJWXUay0SoAHjd8M0FTOUX8jhleccR7zm4OoZaBvxKwXUbJGpF7ttt9uRd5Qye6tHK9sTa0fYE9cpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bMTqMzSs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bMTqMzSs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D251C43399;
	Tue, 23 Jan 2024 01:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974097;
	bh=8uhAKQTybVcUQjGjyDCEYZtiXfV8BEN9qyfZeROp1yM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bMTqMzSsxQGlDQgKoqOoE1sov0lw0doy7Ba7SVhcyVVvSADUcrdFMFNAW51AzptpI
	 qQNGL3MBKdo6avF9jdzSudn9GooJIYg1Tgou117eL8Hh+GBa3Jptm02dj6h8HbNKTX
	 he8yjIr0CxbIroP0F1pV2WyvMihPxwzX8/EqFaZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Rae Moar <rmoar@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 037/583] kunit: debugfs: Fix unchecked dereference in debugfs_print_results()
Date: Mon, 22 Jan 2024 15:51:28 -0800
Message-ID: <20240122235813.294351264@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 34dfd5bb2e5507e69d9b6d6c90f546600c7a4977 ]

Move the call to kunit_suite_has_succeeded() after the check that
the kunit_suite pointer is valid.

This was found by smatch:

 lib/kunit/debugfs.c:66 debugfs_print_results() warn: variable
 dereferenced before check 'suite' (see line 63)

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes: 38289a26e1b8 ("kunit: fix debugfs code to use enum kunit_status, not bool")
Reviewed-by: Rae Moar <rmoar@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kunit/debugfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/kunit/debugfs.c b/lib/kunit/debugfs.c
index 22c5c496a68f..35ddb329dad6 100644
--- a/lib/kunit/debugfs.c
+++ b/lib/kunit/debugfs.c
@@ -53,12 +53,14 @@ static void debugfs_print_result(struct seq_file *seq,
 static int debugfs_print_results(struct seq_file *seq, void *v)
 {
 	struct kunit_suite *suite = (struct kunit_suite *)seq->private;
-	enum kunit_status success = kunit_suite_has_succeeded(suite);
+	enum kunit_status success;
 	struct kunit_case *test_case;
 
 	if (!suite)
 		return 0;
 
+	success = kunit_suite_has_succeeded(suite);
+
 	/* Print KTAP header so the debugfs log can be parsed as valid KTAP. */
 	seq_puts(seq, "KTAP version 1\n");
 	seq_puts(seq, "1..1\n");
-- 
2.43.0



