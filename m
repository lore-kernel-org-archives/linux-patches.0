Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02E427EC7D;
	Tue, 27 May 2025 17:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367588; cv=none; b=UxJs9CXdzUN+I+RwEJMPVAQNlvnbIopRUhvwaKhw5e55u6QrBmHiCfGHIapO3EEdPYcXGc7xXb7EhbaXdGch6dZhVgBVLimpAmVL0uu3THTOkJoZd/1/9xczQ2JZ3sWzDPpIuh4mOwEVdK5KTg70zVprAvRMFC6XetTgyERt/7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367588; c=relaxed/simple;
	bh=AdrxzyLeD7AGEZ4gZ3kDQAQFheTTAPzZ3EL9ieMAHBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p5pbQGjmIOMng2Wwl3MSU+FDiL0ALQw3MPhrbsW+aObJPSsJw47qga4H1ibiluBZEcvZ+DqWwTi+tqWjIiX1s1gx20Y9piZ9oI1vr2/VYE47d9TQFYdK9FVIgFkSZpgyQbJXsSh4RQKucm9YfMNDxstOgdrlIJ7LQuW7gS8X/kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VAwCo0sO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VAwCo0sO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E704C4CEE9;
	Tue, 27 May 2025 17:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367588;
	bh=AdrxzyLeD7AGEZ4gZ3kDQAQFheTTAPzZ3EL9ieMAHBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VAwCo0sOeZInCBXUUYYGQzszqH5w4x9vHzVlDbdIp3dOkd5Bbe7DbT65xZgXV4HM/
	 fOhfh9M9+/Pxtb2tRf8tEpmGUnAPYDXCLGkoo7kwycdbWFvZ8MkLvqJO8kzp6pIHhC
	 kxkMpNmB19hv0OB2VylBVjTO9ZVAjENi2N9Qq3AQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 435/783] firmware: arm_ffa: Handle the presence of host partition in the partition info
Date: Tue, 27 May 2025 18:23:52 +0200
Message-ID: <20250527162530.841347264@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 2f622a8b0722d332a2a149794a3add47bc9bdcf3 ]

Currently it is assumed that the firmware doesn't present the host
partition in the list of partitions presented as part of the response
to PARTITION_INFO_GET from the firmware. However, there are few
platforms that prefer to present the same in the list of partitions.
It is not manadatory but not restricted as well.

So handle the same by making sure to check the presence of the host
VM ID in the XArray partition information maintained/managed in the
driver before attempting to add it.

Tested-by: Viresh Kumar <viresh.kumar@linaro.org>
Message-Id: <20250217-ffa_updates-v3-7-bd1d9de615e7@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index ca9a27fceb1fd..d545d25132051 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -1458,6 +1458,10 @@ static int ffa_setup_partitions(void)
 
 	kfree(pbuf);
 
+	/* Check if the host is already added as part of partition info */
+	if (xa_load(&drv_info->partition_info, drv_info->vm_id))
+		return 0;
+
 	/* Allocate for the host */
 	ret = ffa_xa_add_partition_info(drv_info->vm_id);
 	if (ret)
-- 
2.39.5



