Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0EE21F7088;
	Tue,  3 Dec 2024 14:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237779; cv=none; b=DlXkYdiDix94I0lrj8RDn8vhQVvNcZ6OMxDN48AqQLplHRAvhJaT6xtepFDSeNud+cCFMpvGHs+qxyKBNLma4fPju22UIhvRK1ZjRYoW6+uqJ8Vh7l5kxx22OQSdumMdQJhBmOsfhDbwdV6ufn6VUwAIs+pcn7vDzFk2IbEYE9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237779; c=relaxed/simple;
	bh=8quSxeUOsc4kzDT2pRYv1Wy/9oLnsuhuNnj2XVWmg30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RekcTrNgmx1qH6LTeeeWvUVyUFYXHVkWr4ZdMVNaNTE4jz9OW6BzG/YAA6z5H0QJdZ6E9C/vLJpCi2+Lm10XOIysV3ANY3ur28vXRS9ECg8RU84wwGBdx4wW2R7nD+2NOfyXcDuvFOpiJO+TeNhkh9X1Yu64RfjWRosTnusUD98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KGR3vAEp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KGR3vAEp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE1CC4CED6;
	Tue,  3 Dec 2024 14:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237779;
	bh=8quSxeUOsc4kzDT2pRYv1Wy/9oLnsuhuNnj2XVWmg30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KGR3vAEpU5FHO3dzWiKRK1tqwuW4r9/TtGIT+6gtFcPV4hJCZKlRefgjgWCwjZH2H
	 BZ6sgEuSvTCPIC9aoBunngsAq1SWVQ7unEuafyqS4t4q3sivQ5nVAzR6Jf9ESvTUNd
	 gTqhepHKwNN/Nv4KU8KCLxZS71oDEAm/YNh6+FNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wang <00107082@163.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 036/817] proc/softirqs: replace seq_printf with seq_put_decimal_ull_width
Date: Tue,  3 Dec 2024 15:33:28 +0100
Message-ID: <20241203143957.060832110@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



