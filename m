Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B225351C44;
	Tue, 23 Jan 2024 01:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974041; cv=none; b=Vpz3CE2d0WU9iqtakBlT3Z2KvxumPKlsyWL/qa+xXmWJxRrDbM9n6jbKT0q3xPS1fX/CZG6rpzxtkWGj0GjvsN2zgScFebs0s79VEKjtimM+HsoSt/7q+bUxLplRfMQ3uj4B8q0sO60bKEgm9dDogi+4tj2mcA7C+OElgKuI4Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974041; c=relaxed/simple;
	bh=jXESM8dxoUhx546fUFHqYxmxAcE6RGCF50RsRKRqnx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H+21Y3ep8rAniH2N6wVJlfGW6eXZ6IzHmpq7t4dsuaZk9lna5L7iOjGPqZRl8ryF0yYZOall0TJ8UwNjVynR50o+zkZ9E7//a/GWwe6e1C5ruP59h0nJXYtihU25AMLS6QtuytJ9fBPYDX0iuymHCg0/HXzC0NBaHOE64/JXLZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xW5lGjxK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xW5lGjxK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A53C43394;
	Tue, 23 Jan 2024 01:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974041;
	bh=jXESM8dxoUhx546fUFHqYxmxAcE6RGCF50RsRKRqnx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xW5lGjxKWjTFVjZuLWCzggwMYkHp/TtMx1Y51wTIL/5t/2Ci77WFXg1zmpijFsjpK
	 NaTQ7+rKdFj3R2V4r/K0OcewDx/I+dBn0SX8ZjKFdN0PqvJy6ZNH7KITo21TVEDC0e
	 qPd/t9DKXgfBcisKxCk1dQyL/SLcH7s4gSWs9Jig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Disha Goel <disgoel@linux.vnet.ibm.com>,
	Kajol Jain <kjain@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 014/583] powerpc/hv-gpci: Add return value check in affinity_domain_via_partition_show function
Date: Mon, 22 Jan 2024 15:51:05 -0800
Message-ID: <20240122235812.659876241@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



