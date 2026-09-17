Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DFEA4EDCCF;
	Thu, 17 Sep 2026 16:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664197; cv=none; b=tSktQFcfzGRIYK9k9XKYhLZEZjmCa4qlDJZa7tZ/yR8eQE4fLWT8TE9ZhMmS2a/GjQft6nOgXSNrv4eDkU3G0JCRxLXYcf7DzDDvyewTJs4SQ7IlRTbAY+84YrPWNQPnMwLKQFk9rglTw1VQ7K3TdzxunUJTTjaiq5qpn78TEQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664197; c=relaxed/simple;
	bh=br75WcXHHgKlIBs1Uk71m5JgU+Qet6N2/Mhv+ZrUn3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EXPxgmMfMJ555NYPE9ybHxW5tMHb4HLDiWUvkmUTzxKCRrK7mqtWEPxWZviwE3SbadnctmMaOoDvgx7Mx6Vb1WEXWKJ9KSubBwwIJDGk+YXb/cQmuQVa57R1cMyQSQy06eHwJ16CjuT2FIgvWssKQ4LQqRUzP5w1FAkbfnq+0ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dWdTjdiA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dWdTjdiA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D301F00893;
	Thu, 17 Sep 2026 16:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664196;
	bh=3+gAnkZ/trBMfMnf9cKvN+2eCSa10y1Wdsw4coCvOCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dWdTjdiAb3tKzA0D+v847DlGUGl5infD5MrnVH4tQHI9ZPbQqT8hcky47slgNWqVz
	 /CWf+1/GTpfjY0Zv0+3Qq2mseZpXDxhRy18FM3dBNwfbbXQEPGYyIPj1AZVMIdSYXD
	 37kvfd+2C+9Dw30Ivra1Fgt9PiPsO609CeqtraEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adriano Vero <adri.vero.dev@gmail.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0290/1250] powerpc/fadump: Add timeout to RTAS busy-wait loops
Date: Thu, 17 Sep 2026 16:01:25 +0100
Message-ID: <20260917151559.989598458@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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



