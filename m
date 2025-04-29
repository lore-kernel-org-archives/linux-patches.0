Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C0621ABDB;
	Tue, 29 Apr 2025 17:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947757; cv=none; b=Cug78POzwh5igoMKS6rea4c0p/uWwYgDVd9z0/QLVjyd4rFaVOK5Tf/ynl4cczOx4oIOYrBXfbbV+lyw6GeW8PGT3/jpLQVADTnUb+GsJXLTmAa9d4LjARu7s2xDCEAwdQpc/QLKoYV9Yjq5GtJLPaX8Pqg8sKrfD/A+N/z+4L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947757; c=relaxed/simple;
	bh=0Cm6UkkuE6glQCL34YujNhugk+uAr9MNuZJiznsN864=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IsttAEh5OGJHiTC5rgviWvS/Q2Mdj1B294WKPdxe4IKAL05k4WzLe+gGZHIcnYtRIpSZnSGrYpowedCtqf7HiSToo6sJTeTOvnpbcFe+lQhRE4ewSt36vWJA3gx49HYuWejHuGkcI5FjgT3n5vl8qohNkK5nDBtI9ERTk71p5JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PQF2GcwK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PQF2GcwK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EECAC4CEE9;
	Tue, 29 Apr 2025 17:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947757;
	bh=0Cm6UkkuE6glQCL34YujNhugk+uAr9MNuZJiznsN864=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PQF2GcwKy+k2pofc9xhP8A+HaZ3YcAVjjwJu6yoq+mh+byoYvVKij1WCyPp7Rr2AI
	 ezyd0vbWhtrW9/kq7HZadhZOnJVX4gTWBWhsZMuvrIan2UTJWQPEmdlljcbJ7mdaDr
	 3q+8E4dMOLmLH66zm70t/l8AWYtGGsZ7kpTT034A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rik van Riel <riel@surriel.com>,
	Breno Leitao <leitao@debian.org>,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.12 095/280] sched_ext: Use kvzalloc for large exit_dump allocation
Date: Tue, 29 Apr 2025 18:40:36 +0200
Message-ID: <20250429161118.995559978@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

commit 47068309b5777313b6ac84a77d8d10dc7312260a upstream.

Replace kzalloc with kvzalloc for the exit_dump buffer allocation, which
can require large contiguous memory depending on the implementation.
This change prevents allocation failures by allowing the system to fall
back to vmalloc when contiguous memory allocation fails.

Since this buffer is only used for debugging purposes, physical memory
contiguity is not required, making vmalloc a suitable alternative.

Cc: stable@vger.kernel.org
Fixes: 07814a9439a3b0 ("sched_ext: Print debug dump after an error exit")
Suggested-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
Acked-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -4530,7 +4530,7 @@ unlock:
 
 static void free_exit_info(struct scx_exit_info *ei)
 {
-	kfree(ei->dump);
+	kvfree(ei->dump);
 	kfree(ei->msg);
 	kfree(ei->bt);
 	kfree(ei);
@@ -4546,7 +4546,7 @@ static struct scx_exit_info *alloc_exit_
 
 	ei->bt = kcalloc(SCX_EXIT_BT_LEN, sizeof(ei->bt[0]), GFP_KERNEL);
 	ei->msg = kzalloc(SCX_EXIT_MSG_LEN, GFP_KERNEL);
-	ei->dump = kzalloc(exit_dump_len, GFP_KERNEL);
+	ei->dump = kvzalloc(exit_dump_len, GFP_KERNEL);
 
 	if (!ei->bt || !ei->msg || !ei->dump) {
 		free_exit_info(ei);


