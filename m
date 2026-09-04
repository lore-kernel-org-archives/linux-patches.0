Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8002437A84A;
	Fri,  4 Sep 2026 06:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501841; cv=none; b=j5Lf3l/ESEQTGQSGve4ckj2oaibaYF8rEHrMa22NoV6Ujgca9GxEyIkinaD/U57J+cT+HBWBBzq7W4ykgV4APmuMPeJ8VPBnkKtGCALaq/MbJ9D39BQPE6nYTR/+CySnbDbIFm6SvtpRA/nFia10sErh6TnNg9r7qgrUFCzDmec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501841; c=relaxed/simple;
	bh=qNJnRJAtfCwXKWj9urql7v2nWMQPKDfU2NwbGdKAvtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qZVA7cAPQflMrIxvpyorIRrqVBGTF6N3e2UD301n3VNXifMJiAFo07rCOKGHaT7YIknNnWCD8IaVxEgV8UHOLubZGZ/aHCnusByr8BDr6YadyIb7ZOJqMpntHnmdtbqy36jUiEmBjuMyj5Gtnw74EZjJyvoxT11MhwaOrv4mbgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VlpwgfIq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VlpwgfIq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05781F00A3D;
	Fri,  4 Sep 2026 06:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501840;
	bh=jcvoJUCC7z8+lwLN91intiJTKgfzRnDQL1TB+XcOmy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VlpwgfIqp0kSuHkEwJ2FYp66oh9TXn1piLgT7wJV0AcI5ULCxslitExGVEHkY9L9i
	 kCG6seUNheFeWKqJvam5G2wvyOjnc1q8/vahTeEUyU3Ly7ntZX6IN4I+0DBrlORZlJ
	 aiZQsU/iyCDzW4PMC5kopZl8yCxz0DvgEJdYXTik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Injae Ryou <injaeryou@gmail.com>,
	Brendan Jackman <jackmanb@google.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 551/552] selftests/mm: fix on-fault-limit false failure under sudo-rs
Date: Fri,  4 Sep 2026 07:01:48 +0200
Message-ID: <20260904045803.086928166@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Injae Ryou <injaeryou@gmail.com>

commit 98df164036bed307a16e7c124ad023c2c13c4b76 upstream.

run_vmtests.sh runs on-fault-limit as the nobody user via "sudo -u nobody
./on-fault-limit", guarded by a check that nobody can access the binary
("sudo -u nobody ls ./on-fault-limit").

The guard resolves the relative path from the inherited working directory,
which only requires search permission on the test directory itself.
Classic sudo passes the relative path through to execve() the same way, so
the two agree.  However, sudo-rs (the default sudo implementation since
Ubuntu 25.10) canonicalizes the command to an absolute path before
executing it, which requires search permission on every ancestor
directory.  When the kernel tree lives under a private home directory
(mode 0750, the Ubuntu default for new users since 21.04), the guard
passes but the execution fails with "command not found", and the test is
reported as a false FAIL:

  # running sudo -u nobody ./on-fault-limit
  sudo: './on-fault-limit': command not found
  # [FAIL]

Wrap the command in "sh -c" so that sudo only resolves the shell binary,
and the relative path is resolved by nobody's shell from the inherited
working directory, matching what the guard checks.  This is the only "sudo
-u nobody" invocation in the script; uid, cwd, rlimits (including
RLIMIT_MEMLOCK, which this test exercises) and the exit status are
unchanged through sh.

Verified on Ubuntu 26.04 (sudo-rs 0.2.13): the test now runs and passes
instead of failing.  Verified on Ubuntu 24.04 (sudo 1.9.15p5): behavior is
unchanged.

Link: https://lore.kernel.org/20260713092700.464376-1-injaeryou@gmail.com
Fixes: 5d2146a3354f ("selftests/mm: skip mlock tests if nobody user can't read it")
Signed-off-by: Injae Ryou <injaeryou@gmail.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/run_vmtests.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -370,7 +370,7 @@ CATEGORY="compaction" run_test ./compact
 
 if command -v sudo &> /dev/null && sudo -u nobody ls ./on-fault-limit >/dev/null;
 then
-	CATEGORY="mlock" run_test sudo -u nobody ./on-fault-limit
+	CATEGORY="mlock" run_test sudo -u nobody sh -c ./on-fault-limit
 else
 	echo "# SKIP ./on-fault-limit"
 fi


