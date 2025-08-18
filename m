Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09855334733;
	Mon, 18 Aug 2025 13:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523140; cv=none; b=tfcTp7qzVkeypLkGXE8tFikon62png232fwvqMs4RCgyaOfddwB4Ev7Dfx9YgmXb4x/juXMSHP/Q77485l9CFyThH84o/KKj+47znkJYrRpRabuPBE4C2H83nDz9MKGUzLX/0bYYZe3SoUVoA0MvjCxBNdHWmoIEaJsyD5Q3kDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523140; c=relaxed/simple;
	bh=/CJwod2//hK1/021M/r9nN/mSpYXMpHDY0MsHal4yKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iV976Vx0RAfhLboq472Pm0jbjA+74cWq5a7D8SY77HfEryu4zGmu+VlWGaJvvr8ZrJJnM1K1PxHokSwbFPrhaxg51D7K6xMgl3G2pTUsezyL1Jtae0bdb41oSBdjJW4QT20L+N1Pr+TBm6rDlCf6ZldMoKwVXwRetOBJRHOl/0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pYk3KZzK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pYk3KZzK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE0EC4CEEB;
	Mon, 18 Aug 2025 13:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523139;
	bh=/CJwod2//hK1/021M/r9nN/mSpYXMpHDY0MsHal4yKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pYk3KZzKW3K7+AFHSGmJgmJORRsUcOo/XM8xTlYyeReILr1D+FBLacV71KxGSlaoO
	 Fcj4lKw3TPbjfa6Z3hUMhTnQdXjXkrBk6hnqGwfDq+r8/XnhMwwNjvRMdb0P1Xuq4G
	 P67hIfTnJ/REdXiaa+XCK9fwLEV+XsU0WG9YMP78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zhijian <lizhijian@fujitsu.com>,
	Huang Ying <ying.huang@linux.alibaba.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.15 051/515] mm/memory-tier: fix abstract distance calculation overflow
Date: Mon, 18 Aug 2025 14:40:37 +0200
Message-ID: <20250818124500.384756167@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zhijian <lizhijian@fujitsu.com>

commit cce35103135c7ffc7bebc32ebfc74fe1f2c3cb5d upstream.

In mt_perf_to_adistance(), the calculation of abstract distance (adist)
involves multiplying several int values including
MEMTIER_ADISTANCE_DRAM.

*adist = MEMTIER_ADISTANCE_DRAM *
		(perf->read_latency + perf->write_latency) /
		(default_dram_perf.read_latency + default_dram_perf.write_latency) *
		(default_dram_perf.read_bandwidth + default_dram_perf.write_bandwidth) /
		(perf->read_bandwidth + perf->write_bandwidth);

Since these values can be large, the multiplication may exceed the
maximum value of an int (INT_MAX) and overflow (Our platform did),
leading to an incorrect adist.

User-visible impact:
The memory tiering subsystem will misinterpret slow memory (like CXL)
as faster than DRAM, causing inappropriate demotion of pages from
CXL (slow memory) to DRAM (fast memory).

For example, we will see the following demotion chains from the dmesg, where
Node0,1 are DRAM, and Node2,3 are CXL node:
 Demotion targets for Node 0: null
 Demotion targets for Node 1: null
 Demotion targets for Node 2: preferred: 0-1, fallback: 0-1
 Demotion targets for Node 3: preferred: 0-1, fallback: 0-1

Change MEMTIER_ADISTANCE_DRAM to be a long constant by writing it with
the 'L' suffix.  This prevents the overflow because the multiplication
will then be done in the long type which has a larger range.

Link: https://lkml.kernel.org/r/20250611023439.2845785-1-lizhijian@fujitsu.com
Link: https://lkml.kernel.org/r/20250610062751.2365436-1-lizhijian@fujitsu.com
Fixes: 3718c02dbd4c ("acpi, hmat: calculate abstract distance with HMAT")
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
Acked-by: Balbir Singh <balbirs@nvidia.com>
Reviewed-by: Donet Tom <donettom@linux.ibm.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/memory-tiers.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/memory-tiers.h
+++ b/include/linux/memory-tiers.h
@@ -18,7 +18,7 @@
  * adistance value (slightly faster) than default DRAM adistance to be part of
  * the same memory tier.
  */
-#define MEMTIER_ADISTANCE_DRAM	((4 * MEMTIER_CHUNK_SIZE) + (MEMTIER_CHUNK_SIZE >> 1))
+#define MEMTIER_ADISTANCE_DRAM	((4L * MEMTIER_CHUNK_SIZE) + (MEMTIER_CHUNK_SIZE >> 1))
 
 struct memory_tier;
 struct memory_dev_type {


