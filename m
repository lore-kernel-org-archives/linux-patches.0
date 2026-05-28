Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2442F8EA1;
	Thu, 28 May 2026 19:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998401; cv=none; b=Il7YJipXn8iiaLLe0VapUF+Gd6K4xaVBL15QnMiAuiUFtnOMfK2TgVNMklus/Dsc05c+UfS/mGFEXBLjs43fXhAzh9sn44339HZcIpW+yYGlpB5Qk9U4hqrZvEgSoe7knZ4fCAan6LQqIIL7utVSuQp3CDmmdFo2WLM5MkzELD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998401; c=relaxed/simple;
	bh=K5hYk2TgPAfuryRBQg1P4hDRQQK0xccoiVtpr+u0/Fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O+yDotQUN74qgVK4JHa0G9HmIALrIRxeeU9iP2x+z+8RXZATYgOV8R8tYBtSoBqASiVvJgxzl5/qEuztpKQq08PrV6wM/Acs+GBLB9dv8JEpwgo2vVObNofUsjKBadeiypcz30CMoc9yXUYLFuc/nMXqck40PQsFYQptBugdrYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P82zFmSb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P82zFmSb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 550DE1F000E9;
	Thu, 28 May 2026 19:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998399;
	bh=pl3eT0NU6g+u6lXVpYqnGdpIQao2O4NjD1CO6Bcw7YM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P82zFmSbhXokanjNQlIIhbv7YnPcgsX+djwzYFGrVg94yiRSHOMP+WW2mg/oEiDeH
	 JdakAWO6tH2cRwhHROLEOon3AadPcAYgkpkNw199EtSfgH9UEeQ7PfSo6GptkTpE/2
	 WBpLjLPg+KlMuAygT5MYwhFXyjghVYo1qRCFNCmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 7.0 123/461] s390/pai: Fix missing PAI counter increments under heavy load
Date: Thu, 28 May 2026 21:44:12 +0200
Message-ID: <20260528194650.542408383@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Richter <tmricht@linux.ibm.com>

commit 99269799bf2448aebccee164df56c22a7b85b02c upstream.

Machines with a larger number of CPUs and under heavy load sometimes
loose PAI counter increments during recording using events
-e CRYPTO_ÂLL or -e NNPA_ALL. Counting is not affected.
This happens when several PAI crypto counters are incremented during
the same cryptographic operation.

During schedule out the functions

paiXXX_sched_task() (with XXX either crypt or ext)
+--> pai_have_samples()
   +--> pai_have_sample()
	+--> pai_copy()
	+--> pai_push_sample()

are called to read out PAI counter values.
In pai_copy() the current values of PAI counters are read from the
PMU memory mapped page and compared to the values read during last
schedule out operation, which have been saved in a backup page
named PAI_SAVE_AREA(event). For each PAI counter a delta is calculated
and when the delta is positive, that PAI counter was incremented by
hardware. This positve delta is reported as raw data record attached
to a sample.
After all deltas have been calculated, the new PAI counter values
are saved in the backup page PAI_SAVE_AREA(event). However this is
done in pai_push_sample(), leaving a small window for missing hardware
triggered updates. Here is one scenario:

  PAI counter idx:   0   1   2   3   4   5   6   7  ....  N
                   +---+---+---+---+---+---+---+---+    +---+
  PAI counter page:|   |   | X |   |   |   |   |   |....| Y |
                   +---+---+---+---+---+---+---+---+    +---+

In pai_copy() each PAI counter value is read and compared
to its old value. This is done in a loop. When PAI counter indexed
N is read, the hardware might increment PAI counter indexed 2 again,
updating its value from X to X+1.
Later pai_push_sample() simply mem-copies the complete PAI counter
page to a backup page and the increment of X+1 is lost, because the
backup page now contains the new value.

Read each PAI counter and save this value in the backup page when
there is a positive delta. This omits any time window between read
and store. This also reduced the work load as only modified PAI
counters are saved.

Cc: stable@vger.kernel.org
Fixes: fe861b0c8d06 ("s390/pai: save PAI counter value page in event structure")
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Reviewed-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/perf_pai.c |   29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

--- a/arch/s390/kernel/perf_pai.c
+++ b/arch/s390/kernel/perf_pai.c
@@ -186,6 +186,13 @@ static u64 pai_getctr(unsigned long *pag
 	return page[nr];
 }
 
+static void pai_setctr(unsigned long *page, int nr, unsigned long offset, u64 v)
+{
+	if (offset)
+		nr += offset / sizeof(*page);
+	page[nr] = v;
+}
+
 /* Read the counter values. Return value from location in CMP. For base
  * event xxx_ALL sum up all events. Returns counter value.
  */
@@ -551,6 +558,8 @@ static void paicrypt_del(struct perf_eve
 /* Create raw data and save it in buffer. Calculate the delta for each
  * counter between this invocation and the last invocation.
  * Returns number of bytes copied.
+ * After reading from PAI counter page, save the read value to the old
+ * page to calculate PAI counter deltas.
  * Saves only entries with positive counter difference of the form
  * 2 bytes: Number of counter
  * 8 bytes: Value of counter
@@ -562,16 +571,22 @@ static size_t pai_copy(struct pai_userda
 	int i, outidx = 0;
 
 	for (i = 1; i <= pp->num_avail; i++) {
-		u64 val = 0, val_old = 0;
+		u64 val = 0, val_old = 0, val_k = 0, val_old_k = 0;
 
 		if (!exclude_kernel) {
-			val += pai_getctr(page, i, pp->kernel_offset);
-			val_old += pai_getctr(page_old, i, pp->kernel_offset);
+			val_k = pai_getctr(page, i, pp->kernel_offset);
+			val_old_k = pai_getctr(page_old, i, pp->kernel_offset);
+			if (val_k != val_old_k)
+				pai_setctr(page_old, i, pp->kernel_offset, val_k);
 		}
 		if (!exclude_user) {
-			val += pai_getctr(page, i, 0);
-			val_old += pai_getctr(page_old, i, 0);
+			val = pai_getctr(page, i, 0);
+			val_old = pai_getctr(page_old, i, 0);
+			if (val != val_old)
+				pai_setctr(page_old, i, 0, val);
 		}
+		val += val_k;
+		val_old += val_old_k;
 		if (val >= val_old)
 			val -= val_old;
 		else
@@ -602,8 +617,6 @@ static size_t pai_copy(struct pai_userda
 static int pai_push_sample(size_t rawsize, struct pai_map *cpump,
 			   struct perf_event *event)
 {
-	int idx = PAI_PMU_IDX(event);
-	struct pai_pmu *pp = &pai_pmu[idx];
 	struct perf_sample_data data;
 	struct perf_raw_record raw;
 	struct pt_regs regs;
@@ -634,8 +647,6 @@ static int pai_push_sample(size_t rawsiz
 
 	overflow = perf_event_overflow(event, &data, &regs);
 	perf_event_update_userpage(event);
-	/* Save crypto counter lowcore page after reading event data. */
-	memcpy((void *)PAI_SAVE_AREA(event), cpump->area, pp->area_size);
 	return overflow;
 }
 


