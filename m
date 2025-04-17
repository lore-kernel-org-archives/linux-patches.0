Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71EE418C034;
	Thu, 17 Apr 2025 18:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912974; cv=none; b=dbr3FsoT5xnuzRhW9rt4b+Ek6L3KUNV6fSyqfT/i8eonzPpuVlomZExUOb4hlSPMIYOjGmhNIPBUqKg92qHCY2LW9G8c04Yn5OrqmIww8oILIYgFJaxDv1sT/bbNKHkQIsP0m5VQQSCeWSiEkVGh5y+r2RED7nM6ZuTgQSCaGJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912974; c=relaxed/simple;
	bh=tddZTNag4BhFs6OwvqCOa0EYJ1+2GF3x13mx7ncwsck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qn5n0Ueja5G/cyU/BDZoCfJintcAq0oXiydJngXoINoblsYDi2UwGAFOdZkr70ZUoyeSuCBe1eOkuYWd8mNsAyhOOGp+nLTVZ1QEHQzEv54Oki7Pkzic/6xfEaU1F4gamZ5UGGuVjiVNrMGasqo8LpYj5HGwUL/dAebDJOdys/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lzzj5T/d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lzzj5T/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70A39C4CEE4;
	Thu, 17 Apr 2025 18:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912973;
	bh=tddZTNag4BhFs6OwvqCOa0EYJ1+2GF3x13mx7ncwsck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lzzj5T/d7efF3tHxTJm3u53WedxgVcLW0U3ppVTC6VKdesnKt0G8QyFAlYfVJlprH
	 EyFJf0TMjgn3odCOvVcNkeopTWb6JA5RexsvzJAsHrbXihCPg1x3fNSgEjHsO60LBR
	 ZmANsxhjv7tWvuumlkkyTk5i2RmhrrpMDQ6WwzVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	warthog9@eaglescrag.net,
	Ayush Jain <Ayush.jain3@amd.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 185/449] ktest: Fix Test Failures Due to Missing LOG_FILE Directories
Date: Thu, 17 Apr 2025 19:47:53 +0200
Message-ID: <20250417175125.420368915@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 8c8da966c641b..a5f7fdd0c1fbb 100755
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



