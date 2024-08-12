Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB15215C127;
	Mon, 12 Aug 2024 16:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480587; cv=none; b=Vd0f4XB6vfhQbqAB3DD5JFng4FQdqcIB8AvjVXSPnBDsgVD+raltXIW7WdRUNDX3gmWVVokTvZXc7lS5GrNdpuawGdWITKdWcL8khMb2si20vAqdgViAFBEYksH7KcwydAkK1g62MPzfspchH0/BBN+/NOyJfE+/olDrpOIuJY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480587; c=relaxed/simple;
	bh=gFdGwDpQHBS0fTSjcbi4dNUAFAkEWL4YSQv3kLN5THw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pTe/1kpI3Fm6tT+6Vxm0Kmf1L1GvOjnPV8XmhgDyDdYUZkqKjRvtxzhGFxYml3BgHOYyTnkfgTTVIz7p8mDwnPHOHfcn5F72LgFK/LzKZ4Wn8mbUUwUxR6AqgFO1Jgv3iiOLVCMvsvM2+uHIn3EI7MDYvHpEdrTbM2U62YUOw/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ThQV4vwm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ThQV4vwm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07055C32782;
	Mon, 12 Aug 2024 16:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480587;
	bh=gFdGwDpQHBS0fTSjcbi4dNUAFAkEWL4YSQv3kLN5THw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ThQV4vwmEjqkIj2QuguMLZKGnh5i7Noqquk1C+w9YKprTNBswjbg3ELWSge5935sx
	 sJKuLoNJtATzS09crgWyDqnBynG11KYJt7UHs9sKxxowN4KjtD5IUsxR2txQ4T3MGX
	 3ml6Xv5KV9Skpq1i3smopmWgqCnuAI82N/uAUIrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yang Yingliang <yangyingliang@huawei.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.10 241/263] sched/core: Fix unbalance set_rq_online/offline() in sched_cpu_deactivate()
Date: Mon, 12 Aug 2024 18:04:02 +0200
Message-ID: <20240812160155.760845323@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Yingliang <yangyingliang@huawei.com>

commit fe7a11c78d2a9bdb8b50afc278a31ac177000948 upstream.

If cpuset_cpu_inactive() fails, set_rq_online() need be called to rollback.

Fixes: 120455c514f7 ("sched: Fix hotplug vs CPU bandwidth control")
Cc: stable@kernel.org
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240703031610.587047-5-yangyingliang@huaweicloud.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -9781,6 +9781,7 @@ int sched_cpu_deactivate(unsigned int cp
 	ret = cpuset_cpu_inactive(cpu);
 	if (ret) {
 		sched_smt_present_inc(cpu);
+		sched_set_rq_online(rq, cpu);
 		balance_push_set(cpu, false);
 		set_cpu_active(cpu, true);
 		sched_update_numa(cpu, true);


