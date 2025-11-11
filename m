Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E791DF258;
	Tue, 11 Nov 2025 00:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822759; cv=none; b=dCiHBpSeIupinwek6R5Twnu2Pl7GAlOjZFkYTv5Ii6j2RShdMfD5RViCOmG6aJYULLCuaMOBHfvPUBLOUBc/NTHCkwW1zDnHlMa5qXk3V0BPp7inLiJgRLKTofLneX4hbPq2cLop847swkI2k/Ebxf5tRl6O+iPQMlz3OiPZtUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822759; c=relaxed/simple;
	bh=ldR89eCnD3upbcGo+JWeWOa4dIh4dhh+Ljqc4CP8u4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ckqppqkd/yAikeBb4EV3W6fkE2FrVjsb0aG+cYGvednq+r0zss1QIYVsXCuk7f59qFOspVg1CDQ8fG28sqThMqrdqv+BdRABVPnlOJbRozk2lXv9PecBrfIgy9uo2uxP3ofbBnt4i7+9D0flzkGSVzsnXQCs60/rtJ28Rw6RmhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lKX6tWGj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lKX6tWGj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 731F5C4CEF5;
	Tue, 11 Nov 2025 00:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822759;
	bh=ldR89eCnD3upbcGo+JWeWOa4dIh4dhh+Ljqc4CP8u4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lKX6tWGjohGhyxHAe5NJTARCEq4gS/e0Erqo82qgs9nEyCR/AsSfeRjv+gKKmUmC4
	 S7CDh1XnRUi6h9h3PKClTGPX+ZUfH4Q2iCPSzYexUuHsFQ/rJC0WT3PW8JvLUYnSJ+
	 /yba6G9h3/GJ0V7dROqjFYotYj9JR1qtEZjq/5UI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.12 064/565] s390/mm: Fix memory leak in add_marker() when kvrealloc() fails
Date: Tue, 11 Nov 2025 09:38:40 +0900
Message-ID: <20251111004528.377785617@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

commit 07ad45e06b4039adf96882aefcb1d3299fb7c305 upstream.

The function has a memory leak when kvrealloc() fails.
The function directly assigns NULL to the markers pointer, losing the
reference to the previously allocated memory. This causes kvfree() in
pt_dump_init() to free NULL instead of the leaked memory.

Fix by:
1. Using kvrealloc() uniformly for all allocations
2. Using a temporary variable to preserve the original pointer until
   allocation succeeds
3. Removing the error path that sets markers_cnt=0 to keep
   consistency between markers and markers_cnt

Found via static analysis and this is similar to commit 42378a9ca553
("bpf, verifier: Fix memory leak in array reallocation for stack state")

Fixes: d0e7915d2ad3 ("s390/mm/ptdump: Generate address marker array dynamically")
Cc: stable@vger.kernel.org
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/mm/dump_pagetables.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

--- a/arch/s390/mm/dump_pagetables.c
+++ b/arch/s390/mm/dump_pagetables.c
@@ -247,16 +247,14 @@ static int ptdump_cmp(const void *a, con
 
 static int add_marker(unsigned long start, unsigned long end, const char *name)
 {
-	size_t oldsize, newsize;
+	struct addr_marker *new;
+	size_t newsize;
 
-	oldsize = markers_cnt * sizeof(*markers);
-	newsize = oldsize + 2 * sizeof(*markers);
-	if (!oldsize)
-		markers = kvmalloc(newsize, GFP_KERNEL);
-	else
-		markers = kvrealloc(markers, newsize, GFP_KERNEL);
-	if (!markers)
-		goto error;
+	newsize = (markers_cnt + 2) * sizeof(*markers);
+	new = kvrealloc(markers, newsize, GFP_KERNEL);
+	if (!new)
+		return -ENOMEM;
+	markers = new;
 	markers[markers_cnt].is_start = 1;
 	markers[markers_cnt].start_address = start;
 	markers[markers_cnt].size = end - start;
@@ -268,9 +266,6 @@ static int add_marker(unsigned long star
 	markers[markers_cnt].name = name;
 	markers_cnt++;
 	return 0;
-error:
-	markers_cnt = 0;
-	return -ENOMEM;
 }
 
 static int pt_dump_init(void)


