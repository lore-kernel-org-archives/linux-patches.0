Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6C539B95A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302531; cv=none; b=Ye6RjWPpT3O3jPbyGsDgHH8o6tah7esqxG9K+w3VH9mDCZ7HjEBKKZlL9qVd8gOyuaJv2SG/9LjyD+aJhaXpCqzdK4GvbjeMh8Y0aiANRMUCIpysXjheDrjI8wjWAy8fr+qThlzFuhzC299EWPGtvPSRQ1dsnwbhl2oQZs2VFds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302531; c=relaxed/simple;
	bh=ex585FaLr/MIVeOUnmRcMxc2onEOLUPNLiaFi7fW6Hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uhJWkTpeGdiFtovfpwKauNiVLIlvyCAUzh/cIuNoHb9aYycbVwMVuVK5tqhvKDJZAL4QO6zLIN+cWXLFUIEcNIe7H+WtvlAGvcSFiNmgVnr5HxaOJL2DIHz+8snrW+VdAQzPb70e6PatPsTzlM71J4Slua9s6ByL5Nk8ciemRik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hFvbYDCK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hFvbYDCK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEE66C116D0;
	Sat, 28 Feb 2026 18:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302531;
	bh=ex585FaLr/MIVeOUnmRcMxc2onEOLUPNLiaFi7fW6Hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hFvbYDCKEaxagKcPUgw9wH94KFo58+pIMFUD0+l3spe/vzQX+C7qen/VLaj0biovz
	 AuuvuQdw40IdtHNdQOXZ2pY2kTx4NCS7x8o1JUdyFM4sKvUZue9f/WPlzwUvDlFk8z
	 YuQ1s7UOEOjssdbG2OuyFsubHO1TG/7gH+0UfXc75jsM7c7MFsmSGmkMpV53FUpAHc
	 SdR8q4q9qicfW8/+wdk7i8zGu4uH8GJ6asD09HOD1mL+xdVTKuFDl+GUvjBdehybqp
	 iOcaVzv8xklRRnMxSYZKKH2Kn6yYxu/krGhONMsanymdqfvei7Wn8f2Rq1MZZJuo05
	 hb87O7dupBCrQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dan Carpenter <dan.carpenter@linaro.org>,
	Tony Luck <tony.luck@intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 031/164] EDAC/i5000: Fix snprintf() size calculation in calculate_dimm_size()
Date: Sat, 28 Feb 2026 13:12:50 -0500
Message-ID: <20260228181505.1600663-31-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 7b5c7e83ac405ff9ecbdd92b37a477f4288f8814 ]

The snprintf() can't really overflow because we're writing a max of 42
bytes to a PAGE_SIZE buffer.  But the limit calculation doesn't take
the first 11 bytes that we wrote into consideration so the limit is
not correct.  Just fix it for correctness even though it doesn't
affect runtime.

Fixes: 64e1fdaf55d6 ("i5000_edac: Fix the logic that retrieves memory information")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Link: https://patch.msgid.link/07cd652c51e77aad5a8350e1a7cd9407e5bbe373.1765290801.git.dan.carpenter@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/i5000_edac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/edac/i5000_edac.c b/drivers/edac/i5000_edac.c
index ba46057d42207..3d82ab8eb2c71 100644
--- a/drivers/edac/i5000_edac.c
+++ b/drivers/edac/i5000_edac.c
@@ -1111,6 +1111,7 @@ static void calculate_dimm_size(struct i5000_pvt *pvt)
 
 	n = snprintf(p, space, "           ");
 	p += n;
+	space -= n;
 	for (branch = 0; branch < MAX_BRANCHES; branch++) {
 		n = snprintf(p, space, "       branch %d       | ", branch);
 		p += n;
-- 
2.51.0

