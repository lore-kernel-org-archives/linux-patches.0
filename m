Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49AA16BE17;
	Thu, 13 Feb 2025 15:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459259; cv=none; b=P6Sg6ZEVjd8rrb/HlT0pPoSYSgsYCRAgcqIT4gElGOgKoQFkZKmQnlflDLZrVHF1DWwnq3yjLiAUQJJYunxHttVHvpe8VSo2oSIaAlWMeD4qCyiN1l4EUxl5GcIj+dQdqr4UqDGHL8vro2OxAje8cctOteW83ofCtI6y+35J1ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459259; c=relaxed/simple;
	bh=1RYuAqPjm/6kFarOqphXN1HeIKGg8VplI42uaxqEbNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zb5n9G/h5DW5SPZLU3x+tIp4JHjPcAtpL/RlMBqIPC9BbxCcefPO8LjEM42TLgbHmzlMDaA3XiB/nUmYw6c+AHec8SKyDiuJSPlo3fKUUlGdN6OTa0zBle1e24m7MGuxrw0BhSihbtU3Qp+t3N2keLkNgpnkhvGYD2mjewjq+M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eRYp1kiJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eRYp1kiJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0667C4CED1;
	Thu, 13 Feb 2025 15:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459259;
	bh=1RYuAqPjm/6kFarOqphXN1HeIKGg8VplI42uaxqEbNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eRYp1kiJ3Xe4ItPhCKXcQQsaM6SVa4/ZxTuOHwQ2Di45X5FreXO4rGPROQJyjn+cD
	 lgQKYuny4QebwWLdWUeA46xEUtUqH6BB8nq85gAUTkImXPJ/7seJGYSQViFKVfPRQJ
	 YBMYd2lvXfjqPVqkB4+v0fe7whM95oq/nTTvoJj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	James Clark <james.clark@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 6.13 213/443] perf bench: Fix undefined behavior in cmpworker()
Date: Thu, 13 Feb 2025 15:26:18 +0100
Message-ID: <20250213142448.836836799@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuan-Wei Chiu <visitorckw@gmail.com>

commit 62892e77b8a64b9dc0e1da75980aa145347b6820 upstream.

The comparison function cmpworker() violates the C standard's
requirements for qsort() comparison functions, which mandate symmetry
and transitivity:

Symmetry: If x < y, then y > x.
Transitivity: If x < y and y < z, then x < z.

In its current implementation, cmpworker() incorrectly returns 0 when
w1->tid < w2->tid, which breaks both symmetry and transitivity. This
violation causes undefined behavior, potentially leading to issues such
as memory corruption in glibc [1].

Fix the issue by returning -1 when w1->tid < w2->tid, ensuring
compliance with the C standard and preventing undefined behavior.

Link: https://www.qualys.com/2024/01/30/qsort.txt [1]
Fixes: 121dd9ea0116 ("perf bench: Add epoll parallel epoll_wait benchmark")
Cc: stable@vger.kernel.org
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Link: https://lore.kernel.org/r/20250116110842.4087530-1-visitorckw@gmail.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/bench/epoll-wait.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/tools/perf/bench/epoll-wait.c
+++ b/tools/perf/bench/epoll-wait.c
@@ -420,7 +420,12 @@ static int cmpworker(const void *p1, con
 
 	struct worker *w1 = (struct worker *) p1;
 	struct worker *w2 = (struct worker *) p2;
-	return w1->tid > w2->tid;
+
+	if (w1->tid > w2->tid)
+		return 1;
+	if (w1->tid < w2->tid)
+		return -1;
+	return 0;
 }
 
 int bench_epoll_wait(int argc, const char **argv)


