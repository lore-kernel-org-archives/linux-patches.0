Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4BE4137B2;
	Fri,  4 Sep 2026 05:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500274; cv=none; b=DIQeHmJzgMqJIlPiZGpaySY3q6Kt+NeeEcS/h1yZeg4/qvgEHujP3ep99DrAdbXuYKFlUB479ReG94BVj+DGJN0ZGqDAsCT1Sf8/GdpBU4gBzRX1tJcAS2/2KiOUcR+CKD570OWWx6uy1rT3CJm3gl5fndXLrXRGpkRkhEgChWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500274; c=relaxed/simple;
	bh=277QS+bnOzOM/mJP4J0jP/By0eH+2vQ7JLngtoC9zzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bdxEdXS2gvaKkL7HqQzoRUG/DW2Egb/o3ws9tYGm7wvDyKLThxOv64p5AAH2beUW07UU0RuhKuMhfbvrgCdy8K8N55R86bhF7eDMSAkav14a5EADep+tJcdgPe+tl22B3e50u1QsKGDHSG44iXg1tZCrnQZr2Rpq/3S/spZkMhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jgXqyeBo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jgXqyeBo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6381F00A3D;
	Fri,  4 Sep 2026 05:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500273;
	bh=3fIdmkQIopeLAD9ROUyL0xQ90Mwr4PFzAWBUMbinSzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jgXqyeBobG1onwy/g5ZxfF5mdAHDvoVxYrEsKoyR4Wvc/Ci0R1LKU6V2j7/ZWGdZz
	 /RNQK2SKKiLFmO33oBcjf/MG41npFZkHYqSvxl65qJaFw/HnjjuCKGikcxDsxnbP9j
	 s1dHpBqnVFKs2mXSnVEK/yGyKceQ1wGCsUPWv6ug=
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
Subject: [PATCH 7.2 711/713] selftests/mm: fix on-fault-limit false failure under sudo-rs
Date: Fri,  4 Sep 2026 07:01:19 +0200
Message-ID: <20260904045819.785389929@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -303,7 +303,7 @@ CATEGORY="compaction" run_test ./compact
 
 if command -v sudo &> /dev/null && sudo -u nobody ls ./on-fault-limit >/dev/null;
 then
-	CATEGORY="mlock" run_test sudo -u nobody ./on-fault-limit
+	CATEGORY="mlock" run_test sudo -u nobody sh -c ./on-fault-limit
 else
 	echo "# SKIP ./on-fault-limit"
 fi


