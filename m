Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596D72210E3;
	Thu, 12 Dec 2024 17:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023683; cv=none; b=VRgwvd+SzcHSai0sUB4WiX1ohz1hwNPG5ForvWEwQ5JLi3w97opFNe8G5Rim/Bgc6Ys/TOLw2bm1c5gqHb4hF+cDievr95NpWKYQKEmF8cj5r5ztp06O3s3oF01AybaKcFIayTR9IwewRzbpowhsVuZ0Xq8otDk470BeO5sU4pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023683; c=relaxed/simple;
	bh=DuLiWxsPlA3iduJz1IDOSU2e6wBtXlqvk4COTnoYm4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rc564VmVhVlb7ZlLWi3137JN1wYxiG07NtIKOzMUIbOumRlvVNVgKfglygmGGh4Q5IA79RPlLhcKjtmT4vFwGYjsrXOVRUVEjIykgrPBw7nA+ih9VTsYEbzSD5/0iqRXc0psdb7f0w5TA+w96eylUpVmwO6+C/rm1QKYmJbIdSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lvbyQSTF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lvbyQSTF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93C0C4CECE;
	Thu, 12 Dec 2024 17:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023683;
	bh=DuLiWxsPlA3iduJz1IDOSU2e6wBtXlqvk4COTnoYm4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lvbyQSTFY5ZfGMQfDF09EpdoPI4awAIfn/ML7+uTHRk6mDN6XH7YqDK1og5xSb/zF
	 G4JexWZcSpeKXBRzeiDVNSmfTEGcRQT15YjaNxakOmbqPQR4ptz+bfTYgy2wsnJBSA
	 ketMXeIdFhMJdekKlLroHuJBi9rD6nVM0nLHFUT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wang <00107082@163.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 047/459] proc/softirqs: replace seq_printf with seq_put_decimal_ull_width
Date: Thu, 12 Dec 2024 15:56:25 +0100
Message-ID: <20241212144255.382295278@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



