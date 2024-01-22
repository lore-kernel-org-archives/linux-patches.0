Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE9E54BD6;
	Tue, 23 Jan 2024 01:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974010; cv=none; b=cs+gkOmuoWvgajCuhteh3dXxb2HJ3lUCTsr50MlwUCYhAssh6Lk2XysGHK5NXHvaCQAH1IOOnESGWLKmo+uR/c3E57Y9YAjuEqEDTYIyE6ykqKQoduOWNiRY+ZsOlAruD6yV6ScZ346B4DkEbOTEqNXZnGiqJ1MDcsbr2pklpV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974010; c=relaxed/simple;
	bh=3+JlpAmvAkSq+MW17aoTy4sXDF/bUrjnH0FcsEp5CkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GHVYG961i95ryiL5hgurwyuAkd7JNccil5Borc+FkrCi3cNTJJr5b2mjaPqHghaCu+0btCU1+LEY6zBWtQENORc+pF5ewOe6piG02y0fzKRDx/9gxj6NuN0IotkrTshZBrINx2XXfVRXiF2p+sLCiSekqSo3J1byqfk63omUulA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HWOSmbyY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HWOSmbyY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05DA5C433C7;
	Tue, 23 Jan 2024 01:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974010;
	bh=3+JlpAmvAkSq+MW17aoTy4sXDF/bUrjnH0FcsEp5CkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HWOSmbyYL4BYLZp9d38igIVTYF9uzofx2h2zvhqJlt0RR0KmnH9glJiIMEpUjTvsO
	 8vJH1l0B9Lv/1B/3bK2ugaBAsBz0qLpZJn/lGAhKCU76WkkuiR/u3EJMPMrrCpnKdQ
	 99JGMSDm/m3CL0lbpa/Y7BJ0PdBH4FRkjzFoji7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Rae Moar <rmoar@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 091/374] kunit: debugfs: Fix unchecked dereference in debugfs_print_results()
Date: Mon, 22 Jan 2024 15:55:47 -0800
Message-ID: <20240122235747.776563604@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1048ef1b8d6e..4c4b84db8f4a 100644
--- a/lib/kunit/debugfs.c
+++ b/lib/kunit/debugfs.c
@@ -52,12 +52,14 @@ static void debugfs_print_result(struct seq_file *seq,
 static int debugfs_print_results(struct seq_file *seq, void *v)
 {
 	struct kunit_suite *suite = (struct kunit_suite *)seq->private;
-	enum kunit_status success = kunit_suite_has_succeeded(suite);
+	enum kunit_status success;
 	struct kunit_case *test_case;
 
 	if (!suite || !suite->log)
 		return 0;
 
+	success = kunit_suite_has_succeeded(suite);
+
 	seq_printf(seq, "%s", suite->log);
 
 	kunit_suite_for_each_test_case(suite, test_case)
-- 
2.43.0



