Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41283341AC7;
	Sat, 30 May 2026 17:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163443; cv=none; b=Gf6jRg2ba3Ld6+8gptDum0FEkHAz5If7TlTZnjk4M7uGXIMpE4bS6f2y+wxrCGsf8icZcUSfY40To388sHhO3QoZPQlX570bF8c7/aOH9Ti3vBKtBrhLhdIlB5r3E6bsVAldOpZ2EaQzIQc3uhB/iwK180+MUzj6r64/flAgHzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163443; c=relaxed/simple;
	bh=1jLsF/vD/d/xs0l1BZxDeGkOW6IPSLLm1BYwLLlIfjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D8gF+tqvQXUA3KnlJ6Y6o9UgNL+KgwplWnLG153C/FdDwM7k44prOMeV1ygNZNyH9tF0YxIS37EeE0TtstVWP1R7v1966Vdrs9mBqCKx8GQQW0nIqxT1F3hlUG2FaQ9LxH8u9dp2M8fjBJ9QltUtf748fDjUttYEYp1M2aOoHZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vVa8u6sM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vVa8u6sM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E761F00893;
	Sat, 30 May 2026 17:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163441;
	bh=MoRPONwUtTepOgMNK3zHY97cOm535b3/w9ZfCYtWTGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vVa8u6sMyBtLjL837wO2J0Q09X3/+OFO/qgo7H+N8ff7KLayPmyiLpvUeMlzT+iAS
	 xE8gQ4GVStnFNDBXi3cUbzyt6o03KlMxPWCaCHiCHOXLABX8pMuE7aLymTK/O5h1O/
	 UVpFc6rgDO/qiXwTN/r6yoULu58Gn68S31NzAqas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Warthog9 Hawley <warthog9@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 5.15 258/776] ktest: Fix the month in the name of the failure directory
Date: Sat, 30 May 2026 17:59:32 +0200
Message-ID: <20260530160247.205909311@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Steven Rostedt <rostedt@goodmis.org>

commit 768059ede35f197575a38b10797b52402d9d4d2f upstream.

The Perl localtime() function returns the month starting at 0 not 1. This
caused the date produced to create the directory for saving files of a
failed run to have the month off by one.

  machine-test-useconfig-fail-20260314073628

The above happened in April, not March. The correct name should have been:

  machine-test-useconfig-fail-20260414073628

This was somewhat confusing.

Cc: stable@vger.kernel.org
Cc: John 'Warthog9' Hawley <warthog9@kernel.org>
Link: https://patch.msgid.link/20260420142426.33ad0293@fedora
Fixes: 7faafbd69639b ("ktest: Add open and close console and start stop monitor")
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/ktest/ktest.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1770,7 +1770,7 @@ sub save_logs {
     my ($result, $basedir) = @_;
     my @t = localtime;
     my $date = sprintf "%04d%02d%02d%02d%02d%02d",
-	1900+$t[5],$t[4],$t[3],$t[2],$t[1],$t[0];
+	1900+$t[5],$t[4]+1,$t[3],$t[2],$t[1],$t[0];
 
     my $type = $build_type;
     if ($type =~ /useconfig/) {


