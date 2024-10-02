Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B2D1EA80;
	Wed,  2 Oct 2024 14:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880240; cv=none; b=OTjvicco3X5D6HLyythfjLwa1xpjPeWbUitDpCiV81bLy9U0lElCJPu/p8WsNzkbyCBqELUSHzvznPtyVaAsXPk9+Fm81DSWfTLX9mRrt9sJFlZYs/8qSRhSMLBpmB3n3xoDaVXudvRqof8BJTNQJv4iPp8/F0AJbgjrs/OWUQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880240; c=relaxed/simple;
	bh=yJjjfylSHtK1Hv5fxIOimrVPSj5tdsoj8gFp3tIgSZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J480qm1aJAP/hvxOmwovnZpEDZfl3w5Mg0m2kDetS8v2iM+ImyiEoX0DmT9S/2v9Y2fS0ybrXhJw/ixGVBOehJYmQYXa4i315QpOsBYVsQ9TMB2s9kdno/KKk7hLBDkh/nAzny+IcOnXYUuhRWSFOTwQPmFN1HM/gS2OypAYjN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sVpHxDQY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sVpHxDQY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA3BC4CEC2;
	Wed,  2 Oct 2024 14:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880240;
	bh=yJjjfylSHtK1Hv5fxIOimrVPSj5tdsoj8gFp3tIgSZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sVpHxDQYsmb8vjDCdBh2LAicJgz0FAXX47tTlUQwbV5whU0JZ7Fr3R2QiPvUXdYXV
	 pUC4r3cm6/DLjicfQ8gR4aeT1YUt6nakWOfYlsTTfcVS7mq3uOEMi/eln5pKY+tQ9f
	 uLW+x9HLrjafNFS2dEHnStruQ9mfBzPlx+0Gh+ys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Moessbauer <felix.moessbauer@siemens.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 391/538] io_uring/sqpoll: do not put cpumask on stack
Date: Wed,  2 Oct 2024 15:00:30 +0200
Message-ID: <20241002125807.866403362@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Felix Moessbauer <felix.moessbauer@siemens.com>

commit 7f44beadcc11adb98220556d2ddbe9c97aa6d42d upstream.

Putting the cpumask on the stack is deprecated for a long time (since
2d3854a37e8), as these can be big. Given that, change the on-stack
allocation of allowed_mask to be dynamically allocated.

Fixes: f011c9cf04c0 ("io_uring/sqpoll: do not allow pinning outside of cpuset")
Signed-off-by: Felix Moessbauer <felix.moessbauer@siemens.com>
Link: https://lore.kernel.org/r/20240916111150.1266191-1-felix.moessbauer@siemens.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/sqpoll.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -402,15 +402,22 @@ __cold int io_sq_offload_create(struct i
 			return 0;
 
 		if (p->flags & IORING_SETUP_SQ_AFF) {
-			struct cpumask allowed_mask;
+			cpumask_var_t allowed_mask;
 			int cpu = p->sq_thread_cpu;
 
 			ret = -EINVAL;
 			if (cpu >= nr_cpu_ids || !cpu_online(cpu))
 				goto err_sqpoll;
-			cpuset_cpus_allowed(current, &allowed_mask);
-			if (!cpumask_test_cpu(cpu, &allowed_mask))
+			ret = -ENOMEM;
+			if (!alloc_cpumask_var(&allowed_mask, GFP_KERNEL))
 				goto err_sqpoll;
+			ret = -EINVAL;
+			cpuset_cpus_allowed(current, allowed_mask);
+			if (!cpumask_test_cpu(cpu, allowed_mask)) {
+				free_cpumask_var(allowed_mask);
+				goto err_sqpoll;
+			}
+			free_cpumask_var(allowed_mask);
 			sqd->sq_cpu = cpu;
 		} else {
 			sqd->sq_cpu = -1;


