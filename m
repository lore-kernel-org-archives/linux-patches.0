Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2E43D7D79;
	Wed,  8 Apr 2026 19:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674866; cv=none; b=ffgkGvCgdNyHceMEadAzPJ1dkWftXZMx2lPzUkBjcoNdnQbOk0/ug8Y3ex/HmjB2uGcfEriveRBzyH+ORhFMI6WW+2PWZ0cNrNo1OG/BOMNYgQv0mDA8Wxr+NvwA39YWOLlC6oUQjgwv0pvkNZrfRohIONwa4MeDf/TD6GeA4w0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674866; c=relaxed/simple;
	bh=uzekdJQTwx0Aec9yhQuGoK1/XrGNXNUpJzDjk/MrMCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s1OuYtpywOQ7oY/uLLp7nTOEgX5wuJNa993zkd+mRQtEPN+wn5PEBoQpZnohpVC1+dkr5NOCb+NbBpOEWH7So6/C9WnzYzUF83BUgYeXho30+pdUFnyvETyi6V/PX2o+SRZo0bkj3IRimswE8jz2sR0Zh6Alhy+eP6jUbYJkk28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rAmVjkgG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rAmVjkgG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64FCC19421;
	Wed,  8 Apr 2026 19:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674866;
	bh=uzekdJQTwx0Aec9yhQuGoK1/XrGNXNUpJzDjk/MrMCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rAmVjkgGe786kO/GdA0uSRtr0ifNOlE5yJ8GkWT9Gx1Xa4m8tGUeCxuAHOQ5Yz5/a
	 bso0nIQ0feZEjlsVdQUYHGA7Ax0tAFGTUkssulm5QpCTVGjzDQPjuXVPhrSeX3mUyu
	 uX9ZlcpnprTmcVfjGiMNYD2mMnOQhULwtvASFHik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Hendrik Brueckner <brueckner@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.19 263/311] s390/cpum_sf: Cap sampling rate to prevent lsctl exception
Date: Wed,  8 Apr 2026 20:04:23 +0200
Message-ID: <20260408175949.204022217@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Richter <tmricht@linux.ibm.com>

commit 57ad0d4a00f5d3e80f33ba2da8d560c73d83dc22 upstream.

commit fcc43a7e294f ("s390/configs: Set HZ=1000") changed the interrupt
frequency of the system. On machines with heavy load and many perf event
overflows, this might lead to an exception. Dmesg displays these entries:
  [112.242542] cpum_sf: Loading sampling controls failed: op 1 err -22
One line per CPU online.

The root cause is the CPU Measurement sampling facility overflow
adjustment. Whenever an overflow (too much samples per tick) occurs, the
sampling rate is adjusted and increased. This was done without observing
the maximum sampling rate limit. When the current sampling interval is
higher than the maximum sampling rate limit, the lsctl instruction raises
an exception. The error messages is the result of such an exception.
Observe the upper limit when the new sampling rate is recalculated.

Cc: stable@vger.kernel.org
Fixes: 39d4a501a9ef ("s390/cpum_sf: Adjust sampling interval to avoid hitting sample limits")
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Reviewed-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Reviewed-by: Hendrik Brueckner <brueckner@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/perf_cpum_sf.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/s390/kernel/perf_cpum_sf.c
+++ b/arch/s390/kernel/perf_cpum_sf.c
@@ -1168,6 +1168,7 @@ static void hw_collect_samples(struct pe
 static void hw_perf_event_update(struct perf_event *event, int flush_all)
 {
 	unsigned long long event_overflow, sampl_overflow, num_sdb;
+	struct cpu_hw_sf *cpuhw = this_cpu_ptr(&cpu_hw_sf);
 	struct hw_perf_event *hwc = &event->hw;
 	union hws_trailer_header prev, new;
 	struct hws_trailer_entry *te;
@@ -1247,8 +1248,11 @@ static void hw_perf_event_update(struct
 	 * are dropped.
 	 * Slightly increase the interval to avoid hitting this limit.
 	 */
-	if (event_overflow)
+	if (event_overflow) {
 		SAMPL_RATE(hwc) += DIV_ROUND_UP(SAMPL_RATE(hwc), 10);
+		if (SAMPL_RATE(hwc) > cpuhw->qsi.max_sampl_rate)
+			SAMPL_RATE(hwc) = cpuhw->qsi.max_sampl_rate;
+	}
 }
 
 static inline unsigned long aux_sdb_index(struct aux_buffer *aux,


