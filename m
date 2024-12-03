Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5F11F7062;
	Tue,  3 Dec 2024 14:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236423; cv=none; b=P2WiY+DY6yF0crsVy/VJC0oqZWPv9o13vT94QY9BN2+xEoSoSS7RWUGwcRfwx6/bGBTGdloUt9Qmxz+7Jf4SQUglMxmMuE/pE+uBBxN0wvP+V5SUikjNyVd5EDK2/TDRgrUiIxkVKp96G5VFSW04e7bEGcy6yyvqMX4g1hNvi88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236423; c=relaxed/simple;
	bh=rzafcT2HetplyBaLDX71G+mcpB/dQRWaGk8Qg7GVG1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WPvEFpSiA37EWKxzaAgRN+oADAjZwM8jvI6pnUkb+AIFF2PnoBlt3zZ5WpkYwA0rXCf3s4nu0ZewOtLLKWB8eCv4nYYM7gPg2HZW2piRffzefrfbBggmHsHWEEg0O+0ua409JNGeB9a2t5ekJg7G2ByRHqdCnZVqvXuR5zrPKUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pr3rDIA+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pr3rDIA+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF1DC4CED8;
	Tue,  3 Dec 2024 14:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236422;
	bh=rzafcT2HetplyBaLDX71G+mcpB/dQRWaGk8Qg7GVG1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pr3rDIA+yGAt/R7PVLtw8iNoxU5i183GuYjgcHcD4xYWZqN+S/zOigDurvwAWsgph
	 PKTFWE26FXlWFbZ+t8ucdC/91cvHSmGWI+g8IKWed7GzZ0hnnRa2e+zkn4szEJ7vaV
	 xAmwXhujDWQz42POuyqum4Ei90mbG8EJiFea8+3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wang <00107082@163.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 015/138] proc/softirqs: replace seq_printf with seq_put_decimal_ull_width
Date: Tue,  3 Dec 2024 15:30:44 +0100
Message-ID: <20241203141924.126772861@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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



