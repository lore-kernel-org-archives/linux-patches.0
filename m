Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEBB5476CCD;
	Mon, 31 Aug 2026 13:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183342; cv=none; b=GvfVTPQJdZnzajN6lROnbuk9qtj0cAUmCLsYxKRMvjYdpZ42AWppi2qE+NyeTsDPnNxtYJVL4pggQQEilf9yRp99n1huW7cau+6B96+ixd90VcrZKD1EZ+/CoVyGPZ8ZX8cNWcois8BBR9svX5NgPLLlCGLJVwn19dinbD9tbo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183342; c=relaxed/simple;
	bh=vzdtW2Q0jzegF+B3yhYPe6bZ62+BYKmhULOvcEgwNmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S8+xD8wztb7qINGGKJBLHacUJ4gTI2+CMCLbm4S8jn+4i2FEXir5HTT1pVHAF56WE1U9hO3kFdO9t38Mf9stCTXt3wvwCYjldcwcq0aOCtDow4JWKUlyv9KtLgsKTuw6GxMt//uxShitP/L4+K7HWx1ZJ4DxiQLauNCw3bh8COY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V4ZkvIst; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V4ZkvIst"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF3FA1F00ACA;
	Mon, 31 Aug 2026 13:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183340;
	bh=ZsRwSc/DASuYnJlskj7/TZawZTNs+XQ/4VSmLWAqHfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V4ZkvIstgp3oD2i1tcypzdBooDwAmpYqza2UnCd5Sd7LJ0HBWbt9oeMPunYcS2SXm
	 amjaAtDJd7J1sBE16dg6xKJjxm2EHo3UtqTcg6aq/d7Y2YDqetxZ/TZ43+d2ZWOdB5
	 UgFSu06iN4Z/7hSfT2ZXOOrM6kN57+o7feak/xninhmvcJStKhW/gYfyafeAQlFc1y
	 YGRYlpZ4nBuMOmShUMtB9r5sB7pwMSMBlROFzPPA2kXl7xiLGE7w0z0Bsk4UmcYb/m
	 tSeWbzuzWiugR7YTAtg2WpIv1LvbHsQMh0dydIC32UcbdXMDvA4K5Ul13wUi0wLAxk
	 3wxVD8i6O8m3A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Adriano Vero <adri.vero.dev@gmail.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] powerpc/fadump: Add timeout to RTAS busy-wait loops
Date: Mon, 31 Aug 2026 09:21:58 -0400
Message-ID: <20260831133314.4125787-90-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Adriano Vero <adri.vero.dev@gmail.com>

[ Upstream commit b3580dd1c68cec23d44a39c439e18b4686c13480 ]

The ibm,configure-kernel-dump RTAS call sites in
rtas_fadump_register(), rtas_fadump_unregister(), and
rtas_fadump_invalidate() polled indefinitely while firmware returned
a busy status. A misbehaving or hung firmware could stall these paths
forever, blocking fadump registration at boot or preventing clean
teardown.

Introduce rtas_fadump_call(), a helper that wraps the common
busy-wait pattern shared by all three sites. The helper accumulates
the total delay and returns -ETIMEDOUT if firmware keeps returning a
busy status beyond RTAS_FADUMP_MAX_WAIT_MS (60 seconds). A pr_debug()
message is emitted on each busy iteration to aid diagnosis when the
timeout is hit.

Signed-off-by: Adriano Vero <adri.vero.dev@gmail.com>
Reviewed-by: Sourabh Jain <sourabhjain@linux.ibm.com>
[Maddy: Fixed newline after Signed-off-by]
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260506222024.30352-1-adri.vero.dev@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Both background searches finished and match the earlier analysis:

- **No timeout fix in this tree** — searches for `"upper time limit"`,
  `"rtas_fadump_call"`, and `"timeout to RTAS busy-wait"` returned
  nothing.
- The only hit from the broader `"fadump.*timeout"` search was
  unrelated: `ba608c4fa12cf` (pstore/fadump race fix).

So the unbounded RTAS busy-wait loops with the `TODO` comments are still
present in **6.18.44**, and the timeout patch would be a new backport.
The prior **YES** recommendation stands.

 arch/powerpc/platforms/pseries/rtas-fadump.c | 80 ++++++++++++--------
 arch/powerpc/platforms/pseries/rtas-fadump.h |  6 ++
 2 files changed, 53 insertions(+), 33 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/rtas-fadump.c b/arch/powerpc/platforms/pseries/rtas-fadump.c
index eceb3289383ec..3bb4ac2ab6cc3 100644
--- a/arch/powerpc/platforms/pseries/rtas-fadump.c
+++ b/arch/powerpc/platforms/pseries/rtas-fadump.c
@@ -179,9 +179,42 @@ static u64 rtas_fadump_get_bootmem_min(void)
 	return RTAS_FADUMP_MIN_BOOT_MEM;
 }
 
+/*
+ * Helper to make an ibm,configure-kernel-dump RTAS call with a bounded
+ * busy-wait loop. Returns the RTAS return code on completion, or
+ * -ETIMEDOUT if firmware keeps returning a busy status beyond
+ * RTAS_FADUMP_MAX_WAIT_MS milliseconds.
+ */
+static int rtas_fadump_call(struct fw_dump *fadump_conf, int operation,
+			    void *fdm_ptr, unsigned int fdm_size,
+			    const char *op_name)
+{
+	unsigned int wait_time, total_wait = 0;
+	int rc;
+
+	do {
+		rc = rtas_call(fadump_conf->ibm_configure_kernel_dump, 3, 1,
+			       NULL, operation, fdm_ptr, fdm_size);
+		wait_time = rtas_busy_delay_time(rc);
+		if (wait_time) {
+			pr_debug("Firmware busy during fadump %s, waiting %ums (total %ums)\n",
+				 op_name, wait_time, total_wait);
+			if (total_wait >= RTAS_FADUMP_MAX_WAIT_MS) {
+				pr_err("Timed out waiting for firmware to complete fadump %s\n",
+				       op_name);
+				return -ETIMEDOUT;
+			}
+			total_wait += wait_time;
+			mdelay(wait_time);
+		}
+	} while (wait_time);
+
+	return rc;
+}
+
 static int rtas_fadump_register(struct fw_dump *fadump_conf)
 {
-	unsigned int wait_time, fdm_size;
+	unsigned int fdm_size;
 	int rc, err = -EIO;
 
 	/*
@@ -192,16 +225,10 @@ static int rtas_fadump_register(struct fw_dump *fadump_conf)
 	fdm_size = sizeof(struct rtas_fadump_section_header);
 	fdm_size += be16_to_cpu(fdm.header.dump_num_sections) * sizeof(struct rtas_fadump_section);
 
-	/* TODO: Add upper time limit for the delay */
-	do {
-		rc =  rtas_call(fadump_conf->ibm_configure_kernel_dump, 3, 1,
-				NULL, FADUMP_REGISTER, &fdm, fdm_size);
-
-		wait_time = rtas_busy_delay_time(rc);
-		if (wait_time)
-			mdelay(wait_time);
-
-	} while (wait_time);
+	rc = rtas_fadump_call(fadump_conf, FADUMP_REGISTER, &fdm, fdm_size,
+			      "register");
+	if (rc == -ETIMEDOUT)
+		return -ETIMEDOUT;
 
 	switch (rc) {
 	case 0:
@@ -234,19 +261,12 @@ static int rtas_fadump_register(struct fw_dump *fadump_conf)
 
 static int rtas_fadump_unregister(struct fw_dump *fadump_conf)
 {
-	unsigned int wait_time;
 	int rc;
 
-	/* TODO: Add upper time limit for the delay */
-	do {
-		rc =  rtas_call(fadump_conf->ibm_configure_kernel_dump, 3, 1,
-				NULL, FADUMP_UNREGISTER, &fdm,
-				sizeof(struct rtas_fadump_mem_struct));
-
-		wait_time = rtas_busy_delay_time(rc);
-		if (wait_time)
-			mdelay(wait_time);
-	} while (wait_time);
+	rc = rtas_fadump_call(fadump_conf, FADUMP_UNREGISTER, &fdm,
+			      sizeof(struct rtas_fadump_mem_struct), "unregister");
+	if (rc == -ETIMEDOUT)
+		return -ETIMEDOUT;
 
 	if (rc) {
 		pr_err("Failed to un-register - unexpected error(%d).\n", rc);
@@ -259,19 +279,13 @@ static int rtas_fadump_unregister(struct fw_dump *fadump_conf)
 
 static int rtas_fadump_invalidate(struct fw_dump *fadump_conf)
 {
-	unsigned int wait_time;
 	int rc;
 
-	/* TODO: Add upper time limit for the delay */
-	do {
-		rc =  rtas_call(fadump_conf->ibm_configure_kernel_dump, 3, 1,
-				NULL, FADUMP_INVALIDATE, fdm_active,
-				sizeof(struct rtas_fadump_mem_struct));
-
-		wait_time = rtas_busy_delay_time(rc);
-		if (wait_time)
-			mdelay(wait_time);
-	} while (wait_time);
+	rc = rtas_fadump_call(fadump_conf, FADUMP_INVALIDATE,
+			      (void *)fdm_active,
+			      sizeof(struct rtas_fadump_mem_struct), "invalidate");
+	if (rc == -ETIMEDOUT)
+		return -ETIMEDOUT;
 
 	if (rc) {
 		pr_err("Failed to invalidate - unexpected error (%d).\n", rc);
diff --git a/arch/powerpc/platforms/pseries/rtas-fadump.h b/arch/powerpc/platforms/pseries/rtas-fadump.h
index c109abf6befd9..65fdab7b5b8d3 100644
--- a/arch/powerpc/platforms/pseries/rtas-fadump.h
+++ b/arch/powerpc/platforms/pseries/rtas-fadump.h
@@ -41,6 +41,12 @@
 #define MAX_SECTIONS				10
 #define RTAS_FADUMP_MAX_BOOT_MEM_REGS		7
 
+/*
+ * Maximum time to wait for firmware to respond to an
+ * ibm,configure-kernel-dump RTAS call before giving up.
+ */
+#define RTAS_FADUMP_MAX_WAIT_MS			60000U
+
 /* Kernel Dump section info */
 struct rtas_fadump_section {
 	__be32	request_flag;
-- 
2.53.0

