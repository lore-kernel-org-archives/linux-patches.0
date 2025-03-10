Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80904232787;
	Mon, 10 Mar 2025 17:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626642; cv=none; b=dqMiLG67YOFFGJCqaBJYjMgCwS9tfd8pQU73iNiGudB3wTm5ETzZVgYHno3rIXz6XyktBJzvZbLjo2tBptL5Y2KcDQYaudbHy7ELVv3XdMdremudCkkdsnvu0IZD8t9BgeYy4paGO6g8jeW0TZi3HYiXzczFjSwmTx2clmm95GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626642; c=relaxed/simple;
	bh=oXbQNI162UcxCAYbCfve6ZABZJ/7oddmO4yxHOD0Mik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rDUdUb2ISANJwu5C5D5oQLdT0SckI6zbywhvcm75zaHUfMH79z5v98Ny1xfZEeW4aoWJZmKlwMXTFOkwbYAtTaQBVCOBKJjZVR8KlINwgWbLIe4xz1OLQkZQ+S1ipfObAVI6Kf5TbdMvWNS/nqa+p7Qe3cCQAYqcuNV7cvJFAKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HNRLg8DB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HNRLg8DB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09398C4CEE5;
	Mon, 10 Mar 2025 17:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626642;
	bh=oXbQNI162UcxCAYbCfve6ZABZJ/7oddmO4yxHOD0Mik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HNRLg8DBjRYwEFJ7+v9vj0GeqLDwaYF2SbMNWVOH6RSPzKsPXV7nJU3Q1sCIzWTTK
	 ONKmWqZqCznDQQWnPkwVkqGlKo1FKiTyVheqo1ixVQbYSR4u+g5NFl+3fabEapIik+
	 7IoIpyNALA2GNBTqWFkRTwpY07ngJyIz7bBNs4jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	kernel test robot <oliver.sang@intel.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.13 062/207] selftests/damon/damos_quota_goal: handle minimum quota that cannot be further reduced
Date: Mon, 10 Mar 2025 18:04:15 +0100
Message-ID: <20250310170450.233359144@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

From: SeongJae Park <sj@kernel.org>

commit 349db086a66051bc6114b64b4446787c20ac3f00 upstream.

damos_quota_goal.py selftest see if DAMOS quota goals tuning feature
increases or reduces the effective size quota for given score as expected.
The tuning feature sets the minimum quota size as one byte, so if the
effective size quota is already one, we cannot expect it further be
reduced.  However the test is not aware of the edge case, and fails since
it shown no expected change of the effective quota.  Handle the case by
updating the failure logic for no change to see if it was the case, and
simply skips to next test input.

Link: https://lkml.kernel.org/r/20250217182304.45215-1-sj@kernel.org
Fixes: f1c07c0a1662 ("selftests/damon: add a test for DAMOS quota goal")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202502171423.b28a918d-lkp@intel.com
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>	[6.10.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/damon/damos_quota_goal.py |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/selftests/damon/damos_quota_goal.py
+++ b/tools/testing/selftests/damon/damos_quota_goal.py
@@ -63,6 +63,9 @@ def main():
             if last_effective_bytes != 0 else -1.0))
 
         if last_effective_bytes == goal.effective_bytes:
+            # effective quota was already minimum that cannot be more reduced
+            if expect_increase is False and last_effective_bytes == 1:
+                continue
             print('efective bytes not changed: %d' % goal.effective_bytes)
             exit(1)
 


