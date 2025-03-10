Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3295F233136;
	Mon, 10 Mar 2025 17:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627420; cv=none; b=ZqATmx/xHd6Mb67UV4Oj2Lr4mzbQ+3mnNYldlSsJSTDeJ5J9buRtmvjLO5hygfKfKRZFk10UADPKB1Vw9tmOvRHG0Zleieh0eyAa4GrdVVpssgIQAoV3+tV9osvC78tMCFPtziJ1zq9TXGB3YAy+IwZz5lt9d3cSddPa8e0ZAl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627420; c=relaxed/simple;
	bh=+1n/QqpjDKgeG9n2YP3ng+yMnEAR+oqvnKhseFK7DaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ilZ6JLogBCilxd+13KmBgIdbP95vMQUU9F/lOU3q9F4U75zNePWL9F0g2vulJMqdAvMdBK9IBojM4bhNs0xIhF4iVfNh5wCM0aGg/X7WogqDYZr3ML0lzuldBzQq0jI00D9oIn+7dZTebM3VycoW+QtTM2Ydq4RR46j+0XOtQzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q8o4OHxr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q8o4OHxr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A6EBC4CEE5;
	Mon, 10 Mar 2025 17:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627419;
	bh=+1n/QqpjDKgeG9n2YP3ng+yMnEAR+oqvnKhseFK7DaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q8o4OHxrQJ8tstVt/1KDOczvh4LsDIMcuy35SfLY+TSmwUQNZTXbdndaFHuiNphGI
	 UYVEyOMNFR6G4hmAqgMXA1S4/dPDS0oEPT83yHxlsXCxxHVmnPkm0m0oXksrBfrk35
	 8zecPMeJTru3gRN7sHsG3guxI3p5Yy7Lgr1r5Z1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 124/269] selftests/damon/damos_quota: make real expectation of quota exceeds
Date: Mon, 10 Mar 2025 18:04:37 +0100
Message-ID: <20250310170502.666137946@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 1c684d77dfbcf926e0dd28f6d260e8fdd8a58e85 upstream.

Patch series "selftests/damon: three fixes for false results".

Fix three DAMON selftest bugs that cause two and one false positive
failures and successes.


This patch (of 3):

damos_quota.py assumes the quota will always exceeded.  But whether quota
will be exceeded or not depend on the monitoring results.  Actually the
monitored workload has chaning access pattern and hence sometimes the
quota may not really be exceeded.  As a result, false positive test
failures happen.  Expect how much time the quota will be exceeded by
checking the monitoring results, and use it instead of the naive
assumption.

Link: https://lkml.kernel.org/r/20250225222333.505646-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250225222333.505646-2-sj@kernel.org
Fixes: 51f58c9da14b ("selftests/damon: add a test for DAMOS quota")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/damon/damos_quota.py |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/damon/damos_quota.py
+++ b/tools/testing/selftests/damon/damos_quota.py
@@ -51,16 +51,19 @@ def main():
         nr_quota_exceeds = scheme.stats.qt_exceeds
 
     wss_collected.sort()
+    nr_expected_quota_exceeds = 0
     for wss in wss_collected:
         if wss > sz_quota:
             print('quota is not kept: %s > %s' % (wss, sz_quota))
             print('collected samples are as below')
             print('\n'.join(['%d' % wss for wss in wss_collected]))
             exit(1)
+        if wss == sz_quota:
+            nr_expected_quota_exceeds += 1
 
-    if nr_quota_exceeds < len(wss_collected):
-        print('quota is not always exceeded: %d > %d' %
-              (len(wss_collected), nr_quota_exceeds))
+    if nr_quota_exceeds < nr_expected_quota_exceeds:
+        print('quota is exceeded less than expected: %d < %d' %
+              (nr_quota_exceeds, nr_expected_quota_exceeds))
         exit(1)
 
 if __name__ == '__main__':


