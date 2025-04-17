Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0298E256C79;
	Thu, 17 Apr 2025 18:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914277; cv=none; b=BatgMvpBVzdaTwa9M1S7ufEz5H+mln9dPImniZo/w8x6s2htbIRBCO7jAbo4/iIhciGblCJsmD2/HCl1Ai5UCahCzosTvI/Zyoi0FXrRf+Jgyks7Cz2U2wj6vH74/Y+gBEN6BVELlSu8/IyyZPyUDuMH+0I5W8zO3ZZEPJpfP7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914277; c=relaxed/simple;
	bh=hg7+L3Und08Y/g+xvfnxNt31M4KGQk5WY9w3oRtt+30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JEam1ZnthZPxHCkO/45d1HvlFcwxsCTE3G8aQ0XswzmveavKFzF4Xh66IIcgJTONS6dXZGHmTCAnhANHZXb49Dt0IoQ7Y/ljLLk6SwY2E60UgWkoes3raFOb3I6ePH6HIGzsFdEOdgY5EIDSGKqXTaAcqDns+5WRL3ZIgyB8ejo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z4kb0avr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z4kb0avr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097B0C4CEE4;
	Thu, 17 Apr 2025 18:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914276;
	bh=hg7+L3Und08Y/g+xvfnxNt31M4KGQk5WY9w3oRtt+30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z4kb0avr+ZI9NjGgM7bcJ4PKKF6pvUignTzCSt/5W9O+7wSnUbj3N/3kCrrg/cc/X
	 sqEQMMt/pDDAZhKSuqx6l/+pmzrvreUr0uOVnvVZhhdVpL7PMZf0m8xX5z0247Y02v
	 XtQvsIXlF/9joqMNk0VfrTTf031naqiIDtcnxP30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	warthog9@eaglescrag.net,
	Ayush Jain <Ayush.jain3@amd.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 163/414] ktest: Fix Test Failures Due to Missing LOG_FILE Directories
Date: Thu, 17 Apr 2025 19:48:41 +0200
Message-ID: <20250417175117.996048926@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



