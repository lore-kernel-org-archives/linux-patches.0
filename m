Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCE369951;
	Wed, 21 Feb 2024 13:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522841; cv=none; b=R8hi9LYhswrJ2FumjvTO2ssQRl/Tsll/My1JIwWGyB5fuVR7iHbmUVLI8C2bwFJ6TbyUpvR6ynrkkPSoQB9/Uwx1GAdypaJqcLWaU/H/U28FKA9n8HpnxdTqL/ugz2HVJhtOOMKmDUk38GOZ0Hrfs/hoaq6Z1RL3IYkutp4ICAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522841; c=relaxed/simple;
	bh=wlC8N2C99kK96Dul8h93bPlDzDWHrNZ45LvNDJxOhKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HrYkCd6nL68kIPkrn5uqmqnNosqdTRSYLuayki+qsQD41I+x5ykNUxjdFKScaEgRFvHYqucIFQtI08O7Dub0iXOxLGAb5UD0iaCVGNbPfRbrfWEYe/RoIBjiGXlzhcaeYfIqj+XezuPf7a6ip3WwKkhfQTlLjwI2hX7NKgOUqdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0rdGzH3D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0rdGzH3D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD17C433C7;
	Wed, 21 Feb 2024 13:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522841;
	bh=wlC8N2C99kK96Dul8h93bPlDzDWHrNZ45LvNDJxOhKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0rdGzH3D9Kfiy8lqRY6s1ti5bUH5/jtXrTqx+vk9Y6xU8SBHYCkS+irXqg7q8GCz7
	 XndaxkL4wiRdcf2isBCHcfkBwGBBRxZiQtqqkeoN43PCkPsFw1l4eZKkXbSHqBa1+f
	 FcD48v1yNKEZUqMU4/vOGoCQ6/FF23AYORp+tUyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 267/476] perf: Fix the nr_addr_filters fix
Date: Wed, 21 Feb 2024 14:05:18 +0100
Message-ID: <20240221130017.718452195@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 388a1fb7da6aaa1970c7e2a7d7fcd983a87a8484 ]

Thomas reported that commit 652ffc2104ec ("perf/core: Fix narrow
startup race when creating the perf nr_addr_filters sysfs file") made
the entire attribute group vanish, instead of only the nr_addr_filters
attribute.

Additionally a stray return.

Insufficient coffee was involved with both writing and merging the
patch.

Fixes: 652ffc2104ec ("perf/core: Fix narrow startup race when creating the perf nr_addr_filters sysfs file")
Reported-by: Thomas Richter <tmricht@linux.ibm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Thomas Richter <tmricht@linux.ibm.com>
Link: https://lkml.kernel.org/r/20231122100756.GP8262@noisy.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 0e03afd82348..4e5a73c7db12 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -11229,12 +11229,10 @@ static umode_t pmu_dev_is_visible(struct kobject *kobj, struct attribute *a, int
 	struct device *dev = kobj_to_dev(kobj);
 	struct pmu *pmu = dev_get_drvdata(dev);
 
-	if (!pmu->nr_addr_filters)
+	if (n == 2 && !pmu->nr_addr_filters)
 		return 0;
 
 	return a->mode;
-
-	return 0;
 }
 
 static struct attribute_group pmu_dev_attr_group = {
-- 
2.43.0



