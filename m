Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE0610E0;
	Fri,  6 Dec 2024 14:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496519; cv=none; b=pIpd10DJ8etg931bSsHDJrP5Jwd1BTaHIrk/lP933bCVT4YdAsVthSQoIDNkxWYHLDVnw38Vo83zOs+54RjCq7N/sx5W7/f0oFMClYlb+FiMPV6wKp94pHS2hUKLD8Mex5GMCP5u7n6gFV9b2tC9EOp6I7DFG9tFr2rvPS1xrhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496519; c=relaxed/simple;
	bh=RXVH7slQwPRkBEaWdLacs/mi1XI+m7WxVlFFMaO0sHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LIS1nWsYtOEF11iMm4SVIryzKBZ2Li03pRdv3gG58ScHfvQZU0GdDHLy74d3B3JurmkRDcqqdyJ4DEYhsZPmPH2SkvV1cw56XjpcvQO1BuZ9B8nZPdB8u6xjFW/xjfh7s2KEHnekOHpZ9f+CA/WHcm4/XQghY3a+d3fPzn2kDvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wf62KdVh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wf62KdVh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 512AFC4CED1;
	Fri,  6 Dec 2024 14:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496519;
	bh=RXVH7slQwPRkBEaWdLacs/mi1XI+m7WxVlFFMaO0sHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wf62KdVhtavyyACme6NWjIqQLnFqo5DgpLDX3CaTMF9025EJrD9gPUbxbhhCkMWj6
	 8v2+AEGOwVm3XwmkA63h7XjbeFBPAf8prLhilNavYqhaI6co1GDh/cayJpA0wES3Ma
	 QmeDqiKQpC+oqDvMgUWSFYMusifgra9plUosriz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wang <00107082@163.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 028/676] proc/softirqs: replace seq_printf with seq_put_decimal_ull_width
Date: Fri,  6 Dec 2024 15:27:27 +0100
Message-ID: <20241206143654.456407960@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: David Wang <00107082@163.com>

[ Upstream commit 84b9749a3a704dcc824a88aa8267247c801d51e4 ]

seq_printf is costy, on a system with n CPUs, reading /proc/softirqs
would yield 10*n decimal values, and the extra cost parsing format string
grows linearly with number of cpus. Replace seq_printf with
seq_put_decimal_ull_width have significant performance improvement.
On an 8CPUs system, reading /proc/softirqs show ~40% performance
gain with this patch.

Signed-off-by: David Wang <00107082@163.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/softirqs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/proc/softirqs.c b/fs/proc/softirqs.c
index f4616083faef3..04bb29721419b 100644
--- a/fs/proc/softirqs.c
+++ b/fs/proc/softirqs.c
@@ -20,7 +20,7 @@ static int show_softirqs(struct seq_file *p, void *v)
 	for (i = 0; i < NR_SOFTIRQS; i++) {
 		seq_printf(p, "%12s:", softirq_to_name[i]);
 		for_each_possible_cpu(j)
-			seq_printf(p, " %10u", kstat_softirqs_cpu(i, j));
+			seq_put_decimal_ull_width(p, " ", kstat_softirqs_cpu(i, j), 10);
 		seq_putc(p, '\n');
 	}
 	return 0;
-- 
2.43.0



