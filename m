Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D48131740;
	Tue, 23 Jan 2024 00:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969087; cv=none; b=jQsaHcdHuxQ+4Wu4nVdMIGu6aj6Pm1u4+b7azrDjhbLZ/FrHWQuAqpLIlwNmWaTgGkua3i4Di9BVPosNaxlMsOY63iSyK9pWHcOiwGuDAZJ4IFdnlZGIwulGk9CJ9Zd9eFYETaaJR+FC56tQfYcqxNun44hOxKS8jIaaAbTUm/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969087; c=relaxed/simple;
	bh=HeSR4+/WFoF00HR3SkRFmQnqsMZrdbNy4fgKkTszMcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T9Ob6V1XLNmkoZto0MgUwJNtgJc4rVM1X6Z1gKPLVHVT32BlprOervtZIk7YG1NENsJ9RsstQtrfbegOiXmQm6JESheKOpWpZxCyaahRlssOsUH8T1R4jIO1SVZ6mVhCNxxdNlCTF2YdMZQvVUiwU4q326yGRTXn84HjsJEmPXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pmLlsEM1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pmLlsEM1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F720C433F1;
	Tue, 23 Jan 2024 00:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969087;
	bh=HeSR4+/WFoF00HR3SkRFmQnqsMZrdbNy4fgKkTszMcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pmLlsEM19rjMd1Jwj6ttZFZhTGR+khbejAzLbh4sJUAaq4f7SG1lJ3Qbt52VNmorb
	 JBK/k3Iop3ZJHzvVOikw4BUhIK+IVSOEe2lHqYUjd15VAdLB/HmHShtx1OJIJZkm7b
	 tIj5rkOtCQY1JzUEVX7dkGvCugNUXsEpIv9wamMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Disha Goel <disgoel@linux.vnet.ibm.com>,
	Kajol Jain <kjain@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 014/641] powerpc/hv-gpci: Add return value check in affinity_domain_via_partition_show function
Date: Mon, 22 Jan 2024 15:48:38 -0800
Message-ID: <20240122235818.558814274@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kajol Jain <kjain@linux.ibm.com>

[ Upstream commit 070b71f428facd9130319707db854ed8bd24637a ]

To access hv-gpci kernel interface files data, the
"Enable Performance Information Collection" option has to be set
in hmc. Incase that option is not set and user try to read
the interface files, it should give error message as
operation not permitted.

Result of accessing added interface files with disabled
performance collection option:

[command]# cat processor_bus_topology
cat: processor_bus_topology: Operation not permitted

[command]# cat processor_config
cat: processor_config: Operation not permitted

[command]# cat affinity_domain_via_domain
cat: affinity_domain_via_domain: Operation not permitted

[command]# cat affinity_domain_via_virtual_processor
cat: affinity_domain_via_virtual_processor: Operation not permitted

[command]# cat affinity_domain_via_partition

Based on above result there is no error message when reading
affinity_domain_via_partition file because of missing
check for failed hcall. Fix this issue by adding
a check in the start of affinity_domain_via_partition_show
function, to return error incase hcall fails, with error type
other then H_PARAMETER.

Fixes: a15e0d6a6929 ("powerpc/hv_gpci: Add sysfs file inside hv_gpci device to show affinity domain via partition information")
Reported-by: Disha Goel <disgoel@linux.vnet.ibm.com>
Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20231116122033.160964-1-kjain@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/perf/hv-gpci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/powerpc/perf/hv-gpci.c b/arch/powerpc/perf/hv-gpci.c
index 39dbe6b348df..27f18119fda1 100644
--- a/arch/powerpc/perf/hv-gpci.c
+++ b/arch/powerpc/perf/hv-gpci.c
@@ -534,6 +534,9 @@ static ssize_t affinity_domain_via_partition_show(struct device *dev, struct dev
 	if (!ret)
 		goto parse_result;
 
+	if (ret && (ret != H_PARAMETER))
+		goto out;
+
 	/*
 	 * ret value as 'H_PARAMETER' implies that the current buffer size
 	 * can't accommodate all the information, and a partial buffer
-- 
2.43.0



