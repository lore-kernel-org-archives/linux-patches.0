Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536C82210DA;
	Thu, 12 Dec 2024 15:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018755; cv=none; b=i3q/35Va1okcCjXhXEWmSHYGugFDiuhbmFem7kfYp9X9x1anNEMY4/SFeR9GOxegdKORIDzxEFHNFnMT5yQS7Edkw//ig82HMGC6ivoCVQpF7ssRFvJYC9OTXys0TQ8KvNSbHqF1BWm96QDYNkCiK2ev97U+doRp78a9GIxUt7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018755; c=relaxed/simple;
	bh=qnyw22hAHUUS99GzZJAMHxRK85FCuzxIAbWMSabkDo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YbR3N0Dj/0f/bdiVIx+FxyO3vg3db56TnSiO6yNdslWRWZQ8O1lP88/tRCrRwujXe3WJ0wsZhftjNFSr2ZiDV1HXQv3vzrgKjVC7DDShmDEJBI7cSNu9Do+uP4iBBJxt/ATcgHcCjrS/SH9wytKFUSNqNT5mzZsrTDM2EohMM64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vKU5o8fK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vKU5o8fK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2E7C4CED3;
	Thu, 12 Dec 2024 15:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018755;
	bh=qnyw22hAHUUS99GzZJAMHxRK85FCuzxIAbWMSabkDo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vKU5o8fK1YOImTBrIAkOmJVACs8UkWUBaNXPv/FUEgP892bTFuJssO8NB+2dp8vSy
	 svDGiCaNvFQOV4LDUYOLZqMtl8dQpa3BPF7Ppm59tT8PnH/6djzqMs1iuM+9K8bTE9
	 +JnmFgHGvfIfdCrcOfseDE9BZ/jiTkdzf+1EaDUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wang <00107082@163.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 023/772] proc/softirqs: replace seq_printf with seq_put_decimal_ull_width
Date: Thu, 12 Dec 2024 15:49:28 +0100
Message-ID: <20241212144350.898837588@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



