Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBEC213E6F;
	Thu, 12 Dec 2024 17:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025000; cv=none; b=JalxXkkxIZoKunx6mSagxR0irgUK4CNvlhS8zf4a8+PmrAEn5JVY9YoNpy/uqsafV+ozckJPiDPLHCuZGYDEoOrC/RcvVjKnALq/b8/DMneLMbdCwJYfMpIkSXXu+q+nfIkWkRovE3EPdkClUZ69A7aW+pUuDEe4GVcabHmd/4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025000; c=relaxed/simple;
	bh=NqipYDFWYVngCSdcz6eHdo54/+R3OeqRZRHLSwUCvOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QWXY6AH0OTzUfBgbNz6qCVMnD2OcgI07DzvblVdNBgtzMiT7MVfgUIbZs63wkdh6bnLMIdWMbLezl1Mxm4Ks4LIKFK8rO0H/05pjexYTA3HeYuCeYD8n0LHPQUoI0I0qWc7eNgwlpYfgZSKMrKSQOqnvPC6Gxpl1umRITfpfqZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eoc/vC0A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eoc/vC0A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C7A2C4CECE;
	Thu, 12 Dec 2024 17:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025000;
	bh=NqipYDFWYVngCSdcz6eHdo54/+R3OeqRZRHLSwUCvOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eoc/vC0AXYthc6D/vjk3wZgMfMPwqKsbruosLJKc/qyvaVo5frXOeeswwgdFDZsiW
	 pL94kCVjYZDuDo3/yTGKLe4my8WDb2vq+OK1Fkng73TafEwMsv5Fp/Rovd4apDzfwf
	 h30OsjbOyuVbNj0lH7awli6ZBSi+2hMB0Y+8tlT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wang <00107082@163.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 023/321] proc/softirqs: replace seq_printf with seq_put_decimal_ull_width
Date: Thu, 12 Dec 2024 15:59:01 +0100
Message-ID: <20241212144230.825588180@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 12901dcf57e2b..d8f4e7d54d002 100644
--- a/fs/proc/softirqs.c
+++ b/fs/proc/softirqs.c
@@ -19,7 +19,7 @@ static int show_softirqs(struct seq_file *p, void *v)
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



