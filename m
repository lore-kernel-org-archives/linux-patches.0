Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10FC9233149;
	Mon, 10 Mar 2025 17:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627423; cv=none; b=Jqxc1HVzQpGT1YtpJF5ke3jgM/+2LCZwHy20L9HKbgnjluYQVFTUNw00an2dNN3IBRg5y6LVQAJAe5dHuYo5Xq+uKXjEo1AE4sab7Vh18ot8qdAV2JHmfJy50MiMKzihDP1dg4/Ghrt0cDP3iIDhec+B9qwS13fYeYLsfgj3o9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627423; c=relaxed/simple;
	bh=iFiFL8Z78geu32fs+bw9Q3E0oOyyG/1RoXUVWsVa/5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZsR15+F1m+0TdfNtZuOzNCRtzyqT82UoxwR/fv6+VTCpXshVZ1P1X1Vj6DRRD8Ld4Mu4GFfi2NtOLHSyx3lNQuXgyLDeHGh8uFt9thaxSrg45qImXV3MrQVfzVAzt6rzU/ePHEDOW4oX864e9kmefX/mBmZQQsmvgfLCQsYb+hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jT9NHZoG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jT9NHZoG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BF9FC4CEE5;
	Mon, 10 Mar 2025 17:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627422;
	bh=iFiFL8Z78geu32fs+bw9Q3E0oOyyG/1RoXUVWsVa/5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jT9NHZoGulbVouZAoSqk9ES8V1zm1vEOKGZKODKuMlhYEBITv8g5+LbZeGdePHbHI
	 tm1oMeeUnH52UyYVS+ChHb0Tzpgg0UWRybcQJGTFL/4gKlbHNrHx+7B6gXeocsrQIv
	 VAo6Ly4Wdb+36up+K4qPiWLW2b+/qNS/VsQU2lGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 125/269] selftests/damon/damon_nr_regions: set ops update for merge results check to 100ms
Date: Mon, 10 Mar 2025 18:04:38 +0100
Message-ID: <20250310170502.705951644@linuxfoundation.org>
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

commit 695469c07a65547acb6e229b3fdf6aaa881817e3 upstream.

damon_nr_regions.py updates max_nr_regions to a number smaller than
expected number of real regions and confirms DAMON respect the harsh
limit.  To give time for DAMON to make changes for the regions, 3
aggregation intervals (300 milliseconds) are given.

The internal mechanism works with not only the max_nr_regions, but also
sz_limit, though.  It avoids merging region if that casn make region of
size larger than sz_limit.  In the test, sz_limit is set too small to
achive the new max_nr_regions, unless it is updated for the new
min_nr_regions.  But the update is done only once per operations set
update interval, which is one second by default.

Hence, the test randomly incurs false positive failures.  Fix it by
setting the ops interval same to aggregation interval, to make sure
sz_limit is updated by the time of the check.

Link: https://lkml.kernel.org/r/20250225222333.505646-3-sj@kernel.org
Fixes: 8bf890c81612 ("selftests/damon/damon_nr_regions: test online-tuned max_nr_regions")
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
@@ -109,6 +109,7 @@ def main():
     attrs = kdamonds.kdamonds[0].contexts[0].monitoring_attrs
     attrs.min_nr_regions = 3
     attrs.max_nr_regions = 7
+    attrs.update_us = 100000
     err = kdamonds.kdamonds[0].commit()
     if err is not None:
         proc.terminate()


