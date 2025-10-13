Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C1730DEDC;
	Mon, 13 Oct 2025 15:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370134; cv=none; b=l6K3PIE5uNs8QnmsTp4zujavKdHBsuA4V3vn96nLHFZCedTvX2uJnMPQOEUP+ePiZelGPYOOwnknJZb6iFABG5KxlszWk662+vIhL63CZRsMqTo6uubraWrduepYsApMLwGaIUy/PhLB4MwVADVc7qZSr8bB+v4sJ0dJGyxdpMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370134; c=relaxed/simple;
	bh=36FZGd4nd2adIXtYQnH4J8z9p2N5OWTOJ9ylGdfO5WQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G8Te4+reGtZHXyKWb2wLeIXlbaUG/VyVJpyyIZ8Con3hba8bHS08zYHoJv7B0CaO09CEdOIJoqNgFAimtpQbixTlI8RGkasyDbp+U8jj3ET5zYU+WlaAi7PVcLYX1DGj2ojIJSb6/QQZuGTB0WWNAwZH0PGalOuYrrAX4yBq4VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uK7QNUFe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uK7QNUFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B69AFC4CEE7;
	Mon, 13 Oct 2025 15:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370134;
	bh=36FZGd4nd2adIXtYQnH4J8z9p2N5OWTOJ9ylGdfO5WQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uK7QNUFeu0YQ9JHAnElxdHQ4CDwREiT0DaokrPHo+AuRNxTOBD4bVAAowotzWlGtx
	 PafJIOdQIjLayExYP/ng1pQeAqfFyYROIJiaXzcD+hNURmkKurPy/QE6oXRFxCYkso
	 T8WFr8K/7yW+tTFFd5owxLBba0VoC6e1cF6KCiww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alessandro Zanni <alessandro.zanni87@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 447/563] iommu/selftest: prevent use of uninitialized variable
Date: Mon, 13 Oct 2025 16:45:08 +0200
Message-ID: <20251013144427.475036772@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alessandro Zanni <alessandro.zanni87@gmail.com>

[ Upstream commit 1d235d8494259b588bc3b7d29bc73ce34bf885bc ]

Fix to avoid the usage of the `res` variable uninitialized in the
following macro expansions.

It solves the following warning:
In function ‘iommufd_viommu_vdevice_alloc’,
  inlined from ‘wrapper_iommufd_viommu_vdevice_alloc’ at iommufd.c:2889:1:
../kselftest_harness.h:760:12: warning: ‘ret’ may be used uninitialized [-Wmaybe-uninitialized]
  760 |   if (!(__exp _t __seen)) { \
      |      ^
../kselftest_harness.h:513:9: note: in expansion of macro ‘__EXPECT’
  513 |   __EXPECT(expected, #expected, seen, #seen, ==, 1)
      |   ^~~~~~~~
iommufd_utils.h:1057:9: note: in expansion of macro ‘ASSERT_EQ’
 1057 |   ASSERT_EQ(0, _test_cmd_trigger_vevents(self->fd, dev_id, nvevents))
      |   ^~~~~~~~~
iommufd.c:2924:17: note: in expansion of macro ‘test_cmd_trigger_vevents’
 2924 |   test_cmd_trigger_vevents(dev_id, 3);
      |   ^~~~~~~~~~~~~~~~~~~~~~~~

The issue can be reproduced, building the tests, with the command: make -C
tools/testing/selftests TARGETS=iommu

Link: https://patch.msgid.link/r/20250924171629.50266-1-alessandro.zanni87@gmail.com
Fixes: 97717a1f283f ("iommufd/selftest: Add IOMMU_VEVENTQ_ALLOC test coverage")
Signed-off-by: Alessandro Zanni <alessandro.zanni87@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/iommu/iommufd_utils.h | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/iommu/iommufd_utils.h b/tools/testing/selftests/iommu/iommufd_utils.h
index 3c3e08b8c90eb..772ca1db6e597 100644
--- a/tools/testing/selftests/iommu/iommufd_utils.h
+++ b/tools/testing/selftests/iommu/iommufd_utils.h
@@ -1042,15 +1042,13 @@ static int _test_cmd_trigger_vevents(int fd, __u32 dev_id, __u32 nvevents)
 			.dev_id = dev_id,
 		},
 	};
-	int ret;
 
 	while (nvevents--) {
-		ret = ioctl(fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_TRIGGER_VEVENT),
-			    &trigger_vevent_cmd);
-		if (ret < 0)
+		if (!ioctl(fd, _IOMMU_TEST_CMD(IOMMU_TEST_OP_TRIGGER_VEVENT),
+			    &trigger_vevent_cmd))
 			return -1;
 	}
-	return ret;
+	return 0;
 }
 
 #define test_cmd_trigger_vevents(dev_id, nvevents) \
-- 
2.51.0



