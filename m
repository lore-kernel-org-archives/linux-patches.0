Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6620451056;
	Tue, 16 Jun 2026 16:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625677; cv=none; b=RBkshB/tRA1trIs60I6qM+DOLW73ukoxFk+neKC9WAexoexIxz5iP/E4TD+yJoHa7E7H2JSxBW0MqiZgAAVT5ALZk+oB1OWnvGjA9fX4Ncl43zmkPVTc32G6SFACLT7Kjg2gdKlBlskPL6UF0lK4ou/P8fAHILoEsBEPGSEgdbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625677; c=relaxed/simple;
	bh=uEQmmFT8xIOfSDpHQIi00/5ZlgpxI6fbNuk3HR2ivc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fYVFl2o/F/35tXIhHG6ybxvc9DkcMDzSwYUX9LaspZUAH1I9Owl8XJA/+/d9DZSg6tzbL+rnE/6q7WPKXk9uj6nDlSLiCRJpUxOBvbGQShAoApwS+b203bmfdwHoqC2uQBgHS4QTD11jlk3UUfd0QxBy6xDkHHCf5Fg7uZpciYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SQ66Oc71; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SQ66Oc71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF5661F000E9;
	Tue, 16 Jun 2026 16:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625675;
	bh=cssafI7vi29pRVDH5G97J8AaAo9MbHXVhlgPwFwbECo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SQ66Oc71bHBd8G8fNgQFX3VRHJNZIxIZ0Eq+V12Ysk/PD6RNFBgfczay7QaAZrczW
	 dDVkDbi5dMA7TO4AFYQJoEfKL/0YWPI4jEoCVUoMkoUotv50x+2746mOipKd40ZF82
	 b5YWGWpOffL8XZnrOQY6g5B9NmnDjSPK1DktbPdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.18 187/325] RDMA/core: Validate cpu_id against nr_cpu_ids in DMAH alloc
Date: Tue, 16 Jun 2026 20:29:43 +0530
Message-ID: <20260616145107.218920687@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yishai Hadas <yishaih@nvidia.com>

commit 323c98a4ff06aa28114f2bf658fb43eb3b536bbc upstream.

The cpu_id attribute supplied by user space through
UVERBS_ATTR_ALLOC_DMAH_CPU_ID is passed directly to cpumask_test_cpu()
without first verifying that the value is within the valid CPU range.

Passing such untrusted data to cpumask_test_cpu() may lead to an
out-of-bounds read of the underlying cpumask bitmap: the helper expands
to a test_bit() that indexes the bitmap by cpu_id / BITS_PER_LONG with
no bound check.

In addition, on kernels built with CONFIG_DEBUG_PER_CPU_MAPS it trips
the WARN_ON_ONCE() in cpumask_check(); combined with panic_on_warn this
turns a bad user input into a machine reboot.

Reject any cpu_id that is not smaller than nr_cpu_ids with -EINVAL
before it is used.

Reported by Smatch.

Fixes: d83edab562a4 ("RDMA/core: Introduce a DMAH object and its alloc/free APIs")
Link: https://patch.msgid.link/r/20260525142136.28165-1-yishaih@nvidia.com
Cc: stable@vger.kernel.org
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/ag68qoAW3P04J7pT@stanley.mountain/
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/uverbs_std_types_dmah.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_std_types_dmah.c b/drivers/infiniband/core/uverbs_std_types_dmah.c
index 453ce656c6f2..97101e093826 100644
--- a/drivers/infiniband/core/uverbs_std_types_dmah.c
+++ b/drivers/infiniband/core/uverbs_std_types_dmah.c
@@ -47,6 +47,11 @@ static int UVERBS_HANDLER(UVERBS_METHOD_DMAH_ALLOC)(
 		if (ret)
 			goto err;
 
+		if (dmah->cpu_id >= nr_cpu_ids) {
+			ret = -EINVAL;
+			goto err;
+		}
+
 		if (!cpumask_test_cpu(dmah->cpu_id, current->cpus_ptr)) {
 			ret = -EPERM;
 			goto err;
-- 
2.54.0



