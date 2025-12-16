Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA2E355026;
	Tue, 16 Dec 2025 11:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885905; cv=none; b=X9SjhC3xL3akDDo8MNFR/2jJZm7NPAhTFrgbfmd8tctUU9XY99N2JQfhjKHgygvaOr4AZEPx/GSxuv1HQu0NVvItsg92yY5SLJ7fBtlRZP1c0dqKY/fnaz+1+cWDYesDn97eLNzM6jYrCbaRhRRcyY4gqKacbDXjtagdOaZeh88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885905; c=relaxed/simple;
	bh=FCCWh2MQPIE4it4UTGdBhIGkIRC0tk1ItktYFFWLpIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XtuOqm77MIfrhL6HyVJHu7ZwV/J1WPrSsnvNCsLkWcMU0TSAIqRZigoLlEVfSBvGi9x70fvpgLYaLAdzJqs0Z+60YEX3jDGEtWZGrl4K5OBydc7INFjmjAHjTCO2xnFkzcd+nOXqggYcHURXL3GjdHrfVP3Alpc0W7SKxqXbYy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=utJd542I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="utJd542I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D15A3C4CEF1;
	Tue, 16 Dec 2025 11:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885905;
	bh=FCCWh2MQPIE4it4UTGdBhIGkIRC0tk1ItktYFFWLpIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=utJd542IU36UNP9G7mo3g7A2wCqpMtNLz8pWHPp49zgoHt8qqSFWMZ/2FqTXK11zW
	 6vdocn5OAz3VaHGoNDorydPj0g6cfIb593Cn9XspA0MO+sP4Ahu7vigNg11w++HbRe
	 wm1Fh5iEAGOeCkg5UWaKsPo6c56+zRYnDA463S0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Das Neves <nunodasneves@linux.microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 246/507] mshv: Fix deposit memory in MSHV_ROOT_HVCALL
Date: Tue, 16 Dec 2025 12:11:27 +0100
Message-ID: <20251216111354.408070503@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Das Neves <nunodasneves@linux.microsoft.com>

[ Upstream commit 4cc1aa469cd6b714adc958547a4866247bfd60a9 ]

When the MSHV_ROOT_HVCALL ioctl is executing a hypercall, and gets
HV_STATUS_INSUFFICIENT_MEMORY, it deposits memory and then returns
-EAGAIN to userspace. The expectation is that the VMM will retry.

However, some VMM code in the wild doesn't do this and simply fails.
Rather than force the VMM to retry, change the ioctl to deposit
memory on demand and immediately retry the hypercall as is done with
all the other hypercall helper functions.

In addition to making the ioctl easier to use, removing the need for
multiple syscalls improves performance.

There is a complication: unlike the other hypercall helper functions,
in MSHV_ROOT_HVCALL the input is opaque to the kernel. This is
problematic for rep hypercalls, because the next part of the input
list can't be copied on each loop after depositing pages (this was
the original reason for returning -EAGAIN in this case).

Introduce hv_do_rep_hypercall_ex(), which adds a 'rep_start'
parameter. This solves the issue, allowing the deposit loop in
MSHV_ROOT_HVCALL to restart a rep hypercall after depositing pages
partway through.

Fixes: 621191d709b1 ("Drivers: hv: Introduce mshv_root module to expose /dev/mshv to VMMs")
Signed-off-by: Nuno Das Neves <nunodasneves@linux.microsoft.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/mshv_root_main.c    | 58 ++++++++++++++++++----------------
 include/asm-generic/mshyperv.h | 17 ++++++++--
 2 files changed, 44 insertions(+), 31 deletions(-)

diff --git a/drivers/hv/mshv_root_main.c b/drivers/hv/mshv_root_main.c
index cad09ff5f94dc..618cac041441a 100644
--- a/drivers/hv/mshv_root_main.c
+++ b/drivers/hv/mshv_root_main.c
@@ -164,6 +164,7 @@ static int mshv_ioctl_passthru_hvcall(struct mshv_partition *partition,
 	unsigned int pages_order;
 	void *input_pg = NULL;
 	void *output_pg = NULL;
+	u16 reps_completed;
 
 	if (copy_from_user(&args, user_args, sizeof(args)))
 		return -EFAULT;
@@ -215,41 +216,42 @@ static int mshv_ioctl_passthru_hvcall(struct mshv_partition *partition,
 	 */
 	*(u64 *)input_pg = partition->pt_id;
 
-	if (args.reps)
-		status = hv_do_rep_hypercall(args.code, args.reps, 0,
-					     input_pg, output_pg);
-	else
-		status = hv_do_hypercall(args.code, input_pg, output_pg);
-
-	if (hv_result(status) == HV_STATUS_CALL_PENDING) {
-		if (is_async) {
-			mshv_async_hvcall_handler(partition, &status);
-		} else { /* Paranoia check. This shouldn't happen! */
-			ret = -EBADFD;
-			goto free_pages_out;
+	reps_completed = 0;
+	do {
+		if (args.reps) {
+			status = hv_do_rep_hypercall_ex(args.code, args.reps,
+							0, reps_completed,
+							input_pg, output_pg);
+			reps_completed = hv_repcomp(status);
+		} else {
+			status = hv_do_hypercall(args.code, input_pg, output_pg);
 		}
-	}
 
-	if (hv_result(status) == HV_STATUS_INSUFFICIENT_MEMORY) {
-		ret = hv_call_deposit_pages(NUMA_NO_NODE, partition->pt_id, 1);
-		if (!ret)
-			ret = -EAGAIN;
-	} else if (!hv_result_success(status)) {
-		ret = hv_result_to_errno(status);
-	}
+		if (hv_result(status) == HV_STATUS_CALL_PENDING) {
+			if (is_async) {
+				mshv_async_hvcall_handler(partition, &status);
+			} else { /* Paranoia check. This shouldn't happen! */
+				ret = -EBADFD;
+				goto free_pages_out;
+			}
+		}
+
+		if (hv_result_success(status))
+			break;
+
+		if (hv_result(status) != HV_STATUS_INSUFFICIENT_MEMORY)
+			ret = hv_result_to_errno(status);
+		else
+			ret = hv_call_deposit_pages(NUMA_NO_NODE,
+						    partition->pt_id, 1);
+	} while (!ret);
 
-	/*
-	 * Always return the status and output data regardless of result.
-	 * The VMM may need it to determine how to proceed. E.g. the status may
-	 * contain the number of reps completed if a rep hypercall partially
-	 * succeeded.
-	 */
 	args.status = hv_result(status);
-	args.reps = args.reps ? hv_repcomp(status) : 0;
+	args.reps = reps_completed;
 	if (copy_to_user(user_args, &args, sizeof(args)))
 		ret = -EFAULT;
 
-	if (output_pg &&
+	if (!ret && output_pg &&
 	    copy_to_user((void __user *)args.out_ptr, output_pg, args.out_sz))
 		ret = -EFAULT;
 
diff --git a/include/asm-generic/mshyperv.h b/include/asm-generic/mshyperv.h
index a729b77983fab..18ee23174da03 100644
--- a/include/asm-generic/mshyperv.h
+++ b/include/asm-generic/mshyperv.h
@@ -123,10 +123,12 @@ static inline unsigned int hv_repcomp(u64 status)
 
 /*
  * Rep hypercalls. Callers of this functions are supposed to ensure that
- * rep_count and varhead_size comply with Hyper-V hypercall definition.
+ * rep_count, varhead_size, and rep_start comply with Hyper-V hypercall
+ * definition.
  */
-static inline u64 hv_do_rep_hypercall(u16 code, u16 rep_count, u16 varhead_size,
-				      void *input, void *output)
+static inline u64 hv_do_rep_hypercall_ex(u16 code, u16 rep_count,
+					 u16 varhead_size, u16 rep_start,
+					 void *input, void *output)
 {
 	u64 control = code;
 	u64 status;
@@ -134,6 +136,7 @@ static inline u64 hv_do_rep_hypercall(u16 code, u16 rep_count, u16 varhead_size,
 
 	control |= (u64)varhead_size << HV_HYPERCALL_VARHEAD_OFFSET;
 	control |= (u64)rep_count << HV_HYPERCALL_REP_COMP_OFFSET;
+	control |= (u64)rep_start << HV_HYPERCALL_REP_START_OFFSET;
 
 	do {
 		status = hv_do_hypercall(control, input, output);
@@ -151,6 +154,14 @@ static inline u64 hv_do_rep_hypercall(u16 code, u16 rep_count, u16 varhead_size,
 	return status;
 }
 
+/* For the typical case where rep_start is 0 */
+static inline u64 hv_do_rep_hypercall(u16 code, u16 rep_count, u16 varhead_size,
+				      void *input, void *output)
+{
+	return hv_do_rep_hypercall_ex(code, rep_count, varhead_size, 0,
+				      input, output);
+}
+
 /* Generate the guest OS identifier as described in the Hyper-V TLFS */
 static inline u64 hv_generate_guest_id(u64 kernel_version)
 {
-- 
2.51.0



