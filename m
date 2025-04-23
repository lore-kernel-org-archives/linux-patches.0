Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1A828BA9C;
	Wed, 23 Apr 2025 15:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420688; cv=none; b=H87hQeEl3u+TD4gA6NHV1tg9bXnRlk9APCV4uyOwHjm5gS177zzAzbt+ODEPvekyvH5FcHJrmE6ZP8zASjsxmitfWM88wDY2fN6Ba7nZIYqkkrHeoleeaOAAg7m0BDf1SsyZCPgayvfFbDbVgkm2lY3Jl5DVNl9ji1yz05GMAZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420688; c=relaxed/simple;
	bh=z8ucmXlZdXNeToTrdFqxMLd0284wTNrqVjcppoF3Pgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z6CLt9FPW3yx7aMINMDZy2lsuSeVAIhaS6RqYyh7uecQLP9Ti+nQKQmOORpZ/3IYCLR5A6unDG9sLK2QDAbZMjoMUFYLJ1vnJwZNYVG/1Mdqe3XMS1Ey3OohUQKKmdCyKzXwQqUY845AdccMDQ1S/AckNrP4Gw8axKMt98wMRkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LPHqM3SJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LPHqM3SJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EDFCC4CEE2;
	Wed, 23 Apr 2025 15:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420687;
	bh=z8ucmXlZdXNeToTrdFqxMLd0284wTNrqVjcppoF3Pgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LPHqM3SJ7H1oZCj9Afuk4Yz8poetx+eKEeeqKbMcuncvX+Cap2v69ybvXxEkqhsTo
	 38Vzl1BfIUw9Nyz//ikPuPAnt11bm6KHc4Yw/olT7wOIsOj0Gck2iOum+T0nORJ9my
	 gsQYQ01PZ0wfJmuFYm7pQYHf6BXbHv6Tld5EYp/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	warthog9@eaglescrag.net,
	Ayush Jain <Ayush.jain3@amd.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 071/291] ktest: Fix Test Failures Due to Missing LOG_FILE Directories
Date: Wed, 23 Apr 2025 16:41:00 +0200
Message-ID: <20250423142627.274242294@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



