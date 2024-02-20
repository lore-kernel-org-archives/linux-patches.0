Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7849476C9C;
	Tue, 20 Feb 2024 21:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463306; cv=none; b=GzbuAOit7cox2HVuNAmyuE71RJi8vdkEK3976d3SPVwOVrI/JiYa5GhVp5VaqlEaaPzkNvWk0DMC7SX5RjwgWBn9rNMMAezpruSNKI8TpZS12l2ypS8X4RuEHptX0XrgaJKa5uXAeeowDUvccwhncaxqqIpphbJFybx7d/ziNRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463306; c=relaxed/simple;
	bh=2JOrfx9Jf8GdaH7Jn6XJmJ2bcDWM7vDsqon0BBttjvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sdshwM6QBuTwTfCO3Rn8/HnGSsJ3D82xqNA4gyNnPesAc89HTGh/XE9B3gjr8LdHmhxERWdgbNfqCzb6LKAKUMFR1FmQ42ULJAzP9AjhBEZq2ZRCAYxDBnuI/TMtuDJ5Emzxj7GlKuAASCU3rLfPfFQmDLqKfPUQyC/CBeYtcwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0lf+MhNW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0lf+MhNW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D28C433F1;
	Tue, 20 Feb 2024 21:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463306;
	bh=2JOrfx9Jf8GdaH7Jn6XJmJ2bcDWM7vDsqon0BBttjvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0lf+MhNWhZDpjJ0Jti8gvUl5yq5Z1wme9ewxOCw3L7wcWFdd/yl0BmrIIrTc5qHzv
	 /rzmOSS4w47EHaVdPRvDmuzlgmmFHnm/7BVOI+q4ikRMgS0mn6v7DongLbvkTfpeUA
	 mZstK9iqA4fvCXj4N01YLWKS2xg2T8AZFqZaL9t8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Audra Mitchell <audra@redhat.com>,
	Rafael Aquini <raquini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Adam Sindelar <adam@wowsignal.io>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 171/197] selftests/mm: Update va_high_addr_switch.sh to check CPU for la57 flag
Date: Tue, 20 Feb 2024 21:52:10 +0100
Message-ID: <20240220204846.189134750@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Audra Mitchell <audra@redhat.com>

[ Upstream commit 52e63d67b5bb423b33d7a262ac7f8bd375a90145 ]

In order for the page table level 5 to be in use, the CPU must have the
setting enabled in addition to the CONFIG option. Check for the flag to be
set to avoid false test failures on systems that do not have this cpu flag
set.

The test does a series of mmap calls including three using the
MAP_FIXED flag and specifying an address that is 1<<47 or 1<<48.  These
addresses are only available if you are using level 5 page tables,
which requires both the CPU to have the capabiltiy (la57 flag) and the
kernel to be configured.  Currently the test only checks for the kernel
configuration option, so this test can still report a false positive.
Here are the three failing lines:

$ ./va_high_addr_switch | grep FAILED
mmap(ADDR_SWITCH_HINT, 2 * PAGE_SIZE, MAP_FIXED): 0xffffffffffffffff - FAILED
mmap(HIGH_ADDR, MAP_FIXED): 0xffffffffffffffff - FAILED
mmap(ADDR_SWITCH_HINT, 2 * PAGE_SIZE, MAP_FIXED): 0xffffffffffffffff - FAILED

I thought (for about a second) refactoring the test so that these three
mmap calls will only be run on systems with the level 5 page tables
available, but the whole point of the test is to check the level 5
feature...

Link: https://lkml.kernel.org/r/20240119205801.62769-1-audra@redhat.com
Fixes: 4f2930c6718a ("selftests/vm: only run 128TBswitch with 5-level paging")
Signed-off-by: Audra Mitchell <audra@redhat.com>
Cc: Rafael Aquini <raquini@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Adam Sindelar <adam@wowsignal.io>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vm/va_128TBswitch.sh | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/vm/va_128TBswitch.sh b/tools/testing/selftests/vm/va_128TBswitch.sh
index 41580751dc51..231622b3a232 100755
--- a/tools/testing/selftests/vm/va_128TBswitch.sh
+++ b/tools/testing/selftests/vm/va_128TBswitch.sh
@@ -29,9 +29,15 @@ check_supported_x86_64()
 	# See man 1 gzip under '-f'.
 	local pg_table_levels=$(gzip -dcfq "${config}" | grep PGTABLE_LEVELS | cut -d'=' -f 2)
 
+	local cpu_supports_pl5=$(awk '/^flags/ {if (/la57/) {print 0;}
+		else {print 1}; exit}' /proc/cpuinfo 2>/dev/null)
+
 	if [[ "${pg_table_levels}" -lt 5 ]]; then
 		echo "$0: PGTABLE_LEVELS=${pg_table_levels}, must be >= 5 to run this test"
 		exit $ksft_skip
+	elif [[ "${cpu_supports_pl5}" -ne 0 ]]; then
+		echo "$0: CPU does not have the necessary la57 flag to support page table level 5"
+		exit $ksft_skip
 	fi
 }
 
-- 
2.43.0



