Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4037D13A25D;
	Tue, 27 Feb 2024 13:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041394; cv=none; b=aayAyvdNWALYjr0U7u99g5BqLpxdrQ3FWkVDcoqcV+iuEkp/jWVRDvPdoMuylnff5E//HuQbgCWnViv2opJu00sL1FiDnU8Pl3kvwSOYAb5cIbVdWlB30Ur78RKXhd56Yb/OH2zoKMRw8MN4ewk7G9inLE6ZzQr9tDz0W93RQj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041394; c=relaxed/simple;
	bh=4afOWf19tEbgXVvyZN0FQSfrY6fQQ5bQt1I4RNAN6yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dm0I9sB1MFpHnS4XnsaG+fuNuCwwPI1K0wnFKWnVSBLx3PQ7vy9zYwnGPxyQ6ObIlq5vq0EEfoPdvnEqtgHjT9/ZE/JvzmXbKkjT0yyw+maipPa/Q3v1AW/fYI53dJNXRPgt79pvyYIA6Xk1uVCqmRav4m7xr05yzg91eavdXQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BCIzbdln; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BCIzbdln"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18E7C433F1;
	Tue, 27 Feb 2024 13:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041394;
	bh=4afOWf19tEbgXVvyZN0FQSfrY6fQQ5bQt1I4RNAN6yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BCIzbdlnhGWo6D8NBZt2XaMGlSKsjWbqIXDCQoob1xZBiF7mLKgisTvsdogfVdSau
	 Y0uTChbiojN7fb2Rf42mW0URrw5RyA4ugIyRcEzphUdhgFY80o1ZnzxaGR3ONyQ7L+
	 ocSBoHFCVSrQTdVRSJVVWV/SInWHO64S9noHQN24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 325/334] selftests/iommu: fix the config fragment
Date: Tue, 27 Feb 2024 14:23:03 +0100
Message-ID: <20240227131641.606330166@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Usama Anjum <usama.anjum@collabora.com>

[ Upstream commit 510325e5ac5f45c1180189d3bfc108c54bf64544 ]

The config fragment doesn't follow the correct format to enable those
config options which make the config options getting missed while
merging with other configs.

➜ merge_config.sh -m .config tools/testing/selftests/iommu/config
Using .config as base
Merging tools/testing/selftests/iommu/config
➜ make olddefconfig
.config:5295:warning: unexpected data: CONFIG_IOMMUFD
.config:5296:warning: unexpected data: CONFIG_IOMMUFD_TEST

While at it, add CONFIG_FAULT_INJECTION as well which is needed for
CONFIG_IOMMUFD_TEST. If CONFIG_FAULT_INJECTION isn't present in base
config (such as x86 defconfig), CONFIG_IOMMUFD_TEST doesn't get enabled.

Fixes: 57f0988706fe ("iommufd: Add a selftest")
Link: https://lore.kernel.org/r/20240222074934.71380-1-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/iommu/config | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/iommu/config b/tools/testing/selftests/iommu/config
index 6c4f901d6fed3..110d73917615d 100644
--- a/tools/testing/selftests/iommu/config
+++ b/tools/testing/selftests/iommu/config
@@ -1,2 +1,3 @@
-CONFIG_IOMMUFD
-CONFIG_IOMMUFD_TEST
+CONFIG_IOMMUFD=y
+CONFIG_FAULT_INJECTION=y
+CONFIG_IOMMUFD_TEST=y
-- 
2.43.0



