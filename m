Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6C2132C35;
	Tue, 23 Jan 2024 00:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969125; cv=none; b=gBdsSPORzazfVC/d/9a2GEfngayI2aUU+/FHHZuZi/L3tkViqSQ0NB+s1Rzct4IHinusuSMh7TRvptflnjsj5kjnhQgFhZ88kdLBekZt2CuxG5MXOC4a9JtzUdy1dgZer2zNBSRCNCpQyJjMUJ5uBIBHVYmTpNKw5+TnBgDul1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969125; c=relaxed/simple;
	bh=tvz/2t1FZDK6VLnjZbbs3KHcjsDXFpdlKpvK8bPa92I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HfJpGTjqJ4uPcNljhaBaBgLWFghaRE7YOeZj2EgtwuUX/E4tKtJn4sILdCZMRt+fgko51jLoaKeImbh+/ZE9m0QmjSkqCKqKFIISy+BTlRlqvpc5wotGreRPfMZDoMkQyRwNCWutY2VkkCeoD98FwSDVxKSeo3ELQS4LXxqkusQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UCVkj8j2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UCVkj8j2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F2ACC433C7;
	Tue, 23 Jan 2024 00:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969125;
	bh=tvz/2t1FZDK6VLnjZbbs3KHcjsDXFpdlKpvK8bPa92I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UCVkj8j28jkpnM9DQykzda/vx/Z85UyVuhg75yw3fWOaXEQy5bDNiG4VCe6oJnkhC
	 nDLWiFSPjDrFIeoXfrA4T7Mrb5STInvV7LLiqSosaN+2KwTuRe5asHySpd7JQzwyfp
	 tiGnzuBGym/HCMx61/yZaYzHmK5+fqELa7fuJ3BM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Rae Moar <rmoar@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 037/641] kunit: debugfs: Fix unchecked dereference in debugfs_print_results()
Date: Mon, 22 Jan 2024 15:49:01 -0800
Message-ID: <20240122235819.244034250@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 270d185737e6..5bfc18ad5fff 100644
--- a/lib/kunit/debugfs.c
+++ b/lib/kunit/debugfs.c
@@ -60,12 +60,14 @@ static void debugfs_print_result(struct seq_file *seq, struct string_stream *log
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



