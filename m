Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7325E54BD2;
	Tue, 23 Jan 2024 00:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970596; cv=none; b=h5+fZHmcVYejYek2IeuVEfV5XeJmB2OI86JPlRPz/pvcv+ONqkTiz4q7Jr3hK1cGVhF7iRm8iWCdq7aSZbd+C/tD7y9uTyGdL0gm34amH5dM0pQyjyvjLTxahDeBnPGoUOcIYvTzWZz5qza94o+QLEjMd8nq+wfR2B3W67va0iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970596; c=relaxed/simple;
	bh=AU6dsrJE8sc+pnzP3lEEGtx7nwpjyAsWyOVVyz/gFdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BsFIAl4g4RM8MFYSrb4P4JRJhp9AVpot09iQEqKrPq8VT/qPU0LRbkudLoYy94qzWeULnTVIEk1IuJCBcnXJu68ipJy8vdBcoYVUc6NSVe4ShdITPiUAQJw0ZVlAB9bhxsbm4780tVtGijmdEbX8608f/FoJgo2jxtKfpBKOHXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C0oqxMag; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C0oqxMag"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A48D5C433C7;
	Tue, 23 Jan 2024 00:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970596;
	bh=AU6dsrJE8sc+pnzP3lEEGtx7nwpjyAsWyOVVyz/gFdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C0oqxMagaFJTC64cH2Q1uabZkiYlPobgRS6qsaoUO+SM/eaF9A6/raRKvDvX81Lb7
	 Sjm7v96q7T1fwKctgqYtFqf+Qm9QfzM4+5E3eiWsiFgf/SM34Jy/YrIuAswE/DzyVX
	 ML3uyrzPoHwz27ePyy+xrE7e6EclVKHNwG2KapzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Rae Moar <rmoar@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 031/417] kunit: debugfs: Fix unchecked dereference in debugfs_print_results()
Date: Mon, 22 Jan 2024 15:53:19 -0800
Message-ID: <20240122235752.670994222@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b08bb1fba106..de5e71458358 100644
--- a/lib/kunit/debugfs.c
+++ b/lib/kunit/debugfs.c
@@ -52,12 +52,14 @@ static void debugfs_print_result(struct seq_file *seq,
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



