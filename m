Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD44221719;
	Tue, 29 Apr 2025 17:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948581; cv=none; b=uHy5lhIwwnKC/mOhbEkQCkyE2K5a7mk+dl+JRsnlLjfq0PRERxCg7VoSqWcLNnMr0/eIm21Q9iSb7VXrVY6imDCrL5kH/mykkeoKdfJFl9AOrpZ/jod/uw8iyGIFISJal+DkYfhOZL+xdxv1WI3HMkEdheG/i3S5BbtY02w2Waw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948581; c=relaxed/simple;
	bh=Azrp22opc26iLF3iYqtejU3qy2B6gXORTIqcwuQ1oLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bz2VuD45uqSLoU/sxSkdKnNu9qJgfOymB6+wTYtESnhLzoZkYOlRreJLVVnT//XK2f1vnBoZmhurc98oOAtplxhKRbCd3lckkSj7526jHkciZfoIwTJQcCP5fyZEc32VnTLbh2oAzJPEShbf4efmCzg214hGUqBS4uOlOUtJ/R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kYUVkNK5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kYUVkNK5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E8AC4CEE3;
	Tue, 29 Apr 2025 17:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948580;
	bh=Azrp22opc26iLF3iYqtejU3qy2B6gXORTIqcwuQ1oLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kYUVkNK5bzlEXY8NQVTK6deOJr1BrQkzLZ9+21xlJHLc33S+HLz8T+yib3rfpyylo
	 mDT490qWgi68qtrKcsZo47KcG9dZXQcFhf34iuEQb+IapwYRUasiDBfxdK7H85epCi
	 oVz3f8MLVaUz7S21gtn/eVF3AF4BMd2UoFyvSR3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	warthog9@eaglescrag.net,
	Ayush Jain <Ayush.jain3@amd.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 050/373] ktest: Fix Test Failures Due to Missing LOG_FILE Directories
Date: Tue, 29 Apr 2025 18:38:47 +0200
Message-ID: <20250429161125.189514840@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index aecea16cbd02f..2109bd42c144a 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -4282,6 +4282,14 @@ if (defined($opt{"LOG_FILE"})) {
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



