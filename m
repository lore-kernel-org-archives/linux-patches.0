Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3681239085;
	Wed, 23 Apr 2025 15:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420786; cv=none; b=BP2qkbc/UEBJVIYVHbYQ2Zq1Xu61B1pfGgSH/ME6sziWphCMRr2Ctb1lwNAwe3yJeZhne0vqkDaYEjtLXnqtCionfmNShZ/8/XLBjk/IUYkhxdPmZ2dSb5AUCe6ebVYOy8EBWhrF6unmE/4cRfPOA/rAHmhBrAGHiYXU2lcZs0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420786; c=relaxed/simple;
	bh=U6qB1DNDlpP9ieprBJPfApkoWiVDcTQ6jDa1L95D+IU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HB+guixpe8EtxwwIPe6yRNdw6ql0Bd7TlpYjtjHl/R4ONUC5tDGprY4WLTNgokYZUuJiN61LlyR4l3Uk18AmLhNZJmVomfW7N+tGbRh3Z2tNCaL6HqAE+CvsHH7v+bcI43AbQbe66UHBDyEC3XrGkMjzd9QAMdMPmXAAxFyLZO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dONZHjGH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dONZHjGH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17AA5C4CEE2;
	Wed, 23 Apr 2025 15:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420785;
	bh=U6qB1DNDlpP9ieprBJPfApkoWiVDcTQ6jDa1L95D+IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dONZHjGHnuva051V91ncvQh4T/onAszsTtIUfH7Blk5URFcWaefOXSycOIjI5PViM
	 j8HIKn8fVILisEIpUoP4JdKLNBRvC0Svb1ap4KsrxnkwGwvRX9j9Bvp1ak6hhr1YWS
	 Y4a26COPtvu8oe9qFNhvOB/FMOCYFGTmOWcxS1+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	warthog9@eaglescrag.net,
	Ayush Jain <Ayush.jain3@amd.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 112/393] ktest: Fix Test Failures Due to Missing LOG_FILE Directories
Date: Wed, 23 Apr 2025 16:40:08 +0200
Message-ID: <20250423142647.992084415@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 83d65c2abaf01..3316015757433 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -4289,6 +4289,14 @@ if (defined($opt{"LOG_FILE"})) {
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



