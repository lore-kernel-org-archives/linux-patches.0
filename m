Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9EB4502F;
	Thu, 17 Apr 2025 18:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915613; cv=none; b=c5/XbgWdUDGgi8iyP2GjfLV+lETe0yIZj7EffHrzDZnPFjMR9aMMC83ZXMTFkBout6yCHKCA2eMUK9Byd/gCicF/kOw9Xr3eoFeqspKgVzDS6UstlWpUXdxSpYgXphAfyRmyOlsdBR0RlbizVBcTtDGR2PT1df72oI74r++n6nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915613; c=relaxed/simple;
	bh=dvdxbMuGwSf8w9qSWPQY1Tl4/XlpiLO6gtW1wPTQBxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q7wiZQs4fCiaD9sSTMPhWWTD+zEf/G42nMQtUOIgBEU/AEnaOV+zj/CDEuNM0RLyLYZ+yfs8QOBMu9DGiuAx8HpunMF/r0BQVVekSWmWQ6UrceWay9KQvXjhRjPQ1o8WcnAUXYEH6DmyVz25DvEkArUDA2LEnoVP6dIs9IMl6EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E/KnRkMS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E/KnRkMS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DDA5C4CEE4;
	Thu, 17 Apr 2025 18:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915613;
	bh=dvdxbMuGwSf8w9qSWPQY1Tl4/XlpiLO6gtW1wPTQBxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E/KnRkMSWvwvdw9IJESc2HAd8Uy5/5e86WBGumjN3YnhozkXt1ORCdDRPVUoBWbsI
	 5lvsadcumjq2VE49dnYwsE6LSAWcCWscZxYzJtirCKO+UH4nLU0+K5gpsGBzXU7IPh
	 cHheJ/oSmIxpD9O+EX2OXphVTY8xiA04WZnkDtws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	warthog9@eaglescrag.net,
	Ayush Jain <Ayush.jain3@amd.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 156/393] ktest: Fix Test Failures Due to Missing LOG_FILE Directories
Date: Thu, 17 Apr 2025 19:49:25 +0200
Message-ID: <20250417175113.859633174@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ayush Jain <Ayush.jain3@amd.com>

[ Upstream commit 5a1bed232781d356f842576daacc260f0d0c8d2e ]

Handle missing parent directories for LOG_FILE path to prevent test
failures. If the parent directories don't exist, create them to ensure
the tests proceed successfully.

Cc: <warthog9@eaglescrag.net>
Link: https://lore.kernel.org/20250307043854.2518539-1-Ayush.jain3@amd.com
Signed-off-by: Ayush Jain <Ayush.jain3@amd.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/ktest/ktest.pl | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index c76ad0be54e2e..7e524601e01ad 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -4303,6 +4303,14 @@ if (defined($opt{"LOG_FILE"})) {
     if ($opt{"CLEAR_LOG"}) {
 	unlink $opt{"LOG_FILE"};
     }
+
+    if (! -e $opt{"LOG_FILE"} && $opt{"LOG_FILE"} =~ m,^(.*/),) {
+        my $dir = $1;
+        if (! -d $dir) {
+            mkpath($dir) or die "Failed to create directories '$dir': $!";
+            print "\nThe log directory $dir did not exist, so it was created.\n";
+        }
+    }
     open(LOG, ">> $opt{LOG_FILE}") or die "Can't write to $opt{LOG_FILE}";
     LOG->autoflush(1);
 }
-- 
2.39.5



