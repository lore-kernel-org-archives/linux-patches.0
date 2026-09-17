Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A4A4D4861;
	Thu, 17 Sep 2026 15:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660539; cv=none; b=XmsW68m+HNc9kPJclauxKAe9/RI964UwPV+LqFDp59w+eAMSUPEJ4wgSLcVgG8yvy/c0TalYywlyVopUZ8G4BaA5edYdBLm2Sc3LfRpl/8kmvJwFpG6GgKa3UNWXh/anP5yN9KS6IWhujP0oHjiQxr0os/KrqTk7G+5fgn8xM/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660539; c=relaxed/simple;
	bh=xMIt82w9YijONcfaFIyl38IIDKaeGWRqmn5TKQQOskA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FgK9d+u2kG03XTEYJPvIBewg9wYbKtTlYAIyHQn1HeSFY4Ml6OFAaM5B+XS/2/wDk9+uWLla0tcJrWKnZDyexSElEyooj5AzJynjPmKe2dVw+mUrfHoOfOg7u1DEVySV+35ccnyTsd00MYjmlAPHpkC6lkd/Hjvgj0AAIZiljrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zqASn8fV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zqASn8fV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42AB01F00898;
	Thu, 17 Sep 2026 15:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660537;
	bh=wEOkFlJQBR1A9KCNPNI1kvpoBGzBblkEakIt5BxlM18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zqASn8fVgmAKCm/VNxvpMGESkZVWkvykWEX+dQo9sqsA5s3XAoO9lw2E8k06+LUBp
	 7VbsGuutDHDh0mNNnMMQKNUoEUOD/SDKIA5IzHT/jflQx5NcEBIrSbiGwV5UzMukXN
	 v3+eMPAJgPIEb0BUiSoKQ1AhvXBt4B1CMUdKIOBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 618/733] selftests: mptcp: lib: dump nstat for the right test
Date: Thu, 17 Sep 2026 16:15:26 +0100
Message-ID: <20260917151407.927007942@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit e1a56368eac18b3b4b956b794526e8713c48a0ec upstream.

In case of errors, mptcp_lib_pr_nstat is called to dump the nstat
counters, but for some tests, it was dumping the counters for all
subtests, not just the current one.

That's an issue for tests that don't recreate the netns for each
subtest, e.g. mptcp_connect.sh. In this case, 'nstat -a' will look at
the absolute counters since the creation of the netns, making
debugging harder.

Instead, it should dump the counters for the current test, by using the
history recorded in /tmp/<ns>.nstat if available, and not using '-a'
which was dumping the absolute values instead of calculating increments.

While at it, rename the previous 'hist' variable to 'cache' as it was
used to look at the cache, not the nstat history.

Fixes: 658e53141780 ("selftests: mptcp: join: dump stats from history")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260908-net-mptcp-misc-fixes-7-3-rc1-v2-11-df1de70348b6@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_lib.sh |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_lib.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_lib.sh
@@ -108,12 +108,14 @@ mptcp_lib_pr_info() {
 
 mptcp_lib_pr_nstat() {
 	local ns="${1}"
-	local hist="/tmp/${ns}.out"
+	local cache="/tmp/${ns}.out"
+	local hist="/tmp/${ns}.nstat"
 
-	if [ -f "${hist}" ]; then
-		awk '$2 != 0 { print "  "$0 }' "${hist}"
+	if [ -f "${cache}" ]; then
+		awk '$2 != 0 { print "  "$0 }' "${cache}"
 	else
-		ip netns exec "${ns}" nstat -as | grep Tcp
+		NSTAT_HISTORY="${hist}" ip netns exec "${ns}" nstat -s |
+			grep Tcp
 	fi
 }
 


