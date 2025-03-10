Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960DC233136;
	Mon, 10 Mar 2025 17:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627425; cv=none; b=bLKN551pd3F3idnGk1jwoF0MpuOk/RJMFdEm9dalYZYiGRmTLxUkytjBU35ny6KkqCTKDThiJTWPb9HnL0JOyND8p+0bxEvtm34gfZf9Qw4Yls7pwjyRJn4/W1X6JzaGAvrvMEtWBlLxrNlZr+IE2VoacA5UYfbIVI2Zc8w145s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627425; c=relaxed/simple;
	bh=qFvTlWBTth0Ja3TyDzgukrwKT4kWlRkyzSNPElwXtV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RfFRZvsGll/566SEUA9TBDryLrkXvYpRTHKwhoH6NLH9GG+ju90xoqBWtb9ab/opgWgOpZ3KX7pyxJKH2LH5Uz6aT/o8YSxrIT/3B8DkcxsKekkD7nQwWRYDuEfwjGhDsobN9LvMUFzKU6SADRhMFQax5nHQkye/Lt3WNh5c5Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CDpHp4Vs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CDpHp4Vs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15029C4CEE5;
	Mon, 10 Mar 2025 17:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627425;
	bh=qFvTlWBTth0Ja3TyDzgukrwKT4kWlRkyzSNPElwXtV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CDpHp4Vsv4fnCR9x7Zhw1jzzoDwVfHtcLvzHJOmA1I1ofpcTUFOsaltgHBRgeQBFX
	 nXcLaXin4/OgetxBRk4cPVJ7azHV7n+/7LxvtFKyZZXXFsD3tblwAQ+zk8hU3hXVJH
	 a5B8U5wYhM0JYnXLyWNr/+QIPqGZkErRrMpB0ku4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 126/269] selftests/damon/damon_nr_regions: sort collected regiosn before checking with min/max boundaries
Date: Mon, 10 Mar 2025 18:04:39 +0100
Message-ID: <20250310170502.745969271@linuxfoundation.org>
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

commit 582ccf78f6090d88b1c7066b1e90b3d9ec952d08 upstream.

damon_nr_regions.py starts DAMON, periodically collect number of regions
in snapshots, and see if it is in the requested range.  The check code
assumes the numbers are sorted on the collection list, but there is no
such guarantee.  Hence this can result in false positive test success.
Sort the list before doing the check.

Link: https://lkml.kernel.org/r/20250225222333.505646-4-sj@kernel.org
Fixes: 781497347d1b ("selftests/damon: implement test for min/max_nr_regions")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/damon/damon_nr_regions.py |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/damon/damon_nr_regions.py
+++ b/tools/testing/selftests/damon/damon_nr_regions.py
@@ -65,6 +65,7 @@ def test_nr_regions(real_nr_regions, min
 
     test_name = 'nr_regions test with %d/%d/%d real/min/max nr_regions' % (
             real_nr_regions, min_nr_regions, max_nr_regions)
+    collected_nr_regions.sort()
     if (collected_nr_regions[0] < min_nr_regions or
         collected_nr_regions[-1] > max_nr_regions):
         print('fail %s' % test_name)


