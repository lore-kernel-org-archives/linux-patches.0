Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528B319A29D;
	Thu,  6 Jun 2024 14:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683015; cv=none; b=V8an3lKByzEfndlPePtmwWhy37hJG7Ft8/MVS2sXzeN41MfA0TTgLIcajcTB6PoPL/X3TA57Zm+anQ5MOhhCajYD1aEOW2Ax1tE5YQkkTQgL7g3NaLm+Hf1/jRvxVxZZFXecsa2d46VzElb8W7UtRMRqgS/stD4jXqkUihhyYMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683015; c=relaxed/simple;
	bh=7WrRFIJZL+oUkNNK0XtzkH8RGWy7haWPUO6PlNqN3kQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lDm/KKFk5itrRaP5yoqHTF3pX9x9opQNiPmOLLpHztzZJsP67H72kCx86ty2RzLIEgeqQw1esWEJ3uPETlbDgSKarbkhYLDycvV/Uh1M16Vld9Pnvd/5YlxRJB9A8mQ/OBtNOzrg+k51r4fOIK2f6+mVfn/vXtcLj98TdBXnZTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X/YwFGx8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X/YwFGx8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FCCDC32781;
	Thu,  6 Jun 2024 14:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683015;
	bh=7WrRFIJZL+oUkNNK0XtzkH8RGWy7haWPUO6PlNqN3kQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X/YwFGx87deSE9rJ3apd5snJcoO5uhx8XkMKKbStpah9cP4K/sKWsbL2UZzWiFVuV
	 Le4fiMQVgzQu1U497QPUY+54M3AYD6SABvH0IRevlN7uf0W2pSVTyvHl9Ob+AAaIrY
	 vksdikM6vs4rcbpnDS254sw5woA2EqyH4kxiF8kA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 190/374] powerpc/pseries: Add failure related checks for h_get_mpp and h_get_ppp
Date: Thu,  6 Jun 2024 16:02:49 +0200
Message-ID: <20240606131658.234186093@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shrikanth Hegde <sshegde@linux.ibm.com>

[ Upstream commit 6d4341638516bf97b9a34947e0bd95035a8230a5 ]

Couple of Minor fixes:

- hcall return values are long. Fix that for h_get_mpp, h_get_ppp and
parse_ppp_data

- If hcall fails, values set should be at-least zero. It shouldn't be
uninitialized values. Fix that for h_get_mpp and h_get_ppp

Signed-off-by: Shrikanth Hegde <sshegde@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240412092047.455483-3-sshegde@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/hvcall.h        | 2 +-
 arch/powerpc/platforms/pseries/lpar.c    | 6 +++---
 arch/powerpc/platforms/pseries/lparcfg.c | 6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/include/asm/hvcall.h b/arch/powerpc/include/asm/hvcall.h
index a41e542ba94dd..51172625fa3a5 100644
--- a/arch/powerpc/include/asm/hvcall.h
+++ b/arch/powerpc/include/asm/hvcall.h
@@ -570,7 +570,7 @@ struct hvcall_mpp_data {
 	unsigned long backing_mem;
 };
 
-int h_get_mpp(struct hvcall_mpp_data *);
+long h_get_mpp(struct hvcall_mpp_data *mpp_data);
 
 struct hvcall_mpp_x_data {
 	unsigned long coalesced_bytes;
diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms/pseries/lpar.c
index 4e9916bb03d71..c1d8bee8f7018 100644
--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -1886,10 +1886,10 @@ notrace void __trace_hcall_exit(long opcode, long retval, unsigned long *retbuf)
  * h_get_mpp
  * H_GET_MPP hcall returns info in 7 parms
  */
-int h_get_mpp(struct hvcall_mpp_data *mpp_data)
+long h_get_mpp(struct hvcall_mpp_data *mpp_data)
 {
-	int rc;
-	unsigned long retbuf[PLPAR_HCALL9_BUFSIZE];
+	unsigned long retbuf[PLPAR_HCALL9_BUFSIZE] = {0};
+	long rc;
 
 	rc = plpar_hcall9(H_GET_MPP, retbuf);
 
diff --git a/arch/powerpc/platforms/pseries/lparcfg.c b/arch/powerpc/platforms/pseries/lparcfg.c
index f73c4d1c26af9..fb0189af2dea1 100644
--- a/arch/powerpc/platforms/pseries/lparcfg.c
+++ b/arch/powerpc/platforms/pseries/lparcfg.c
@@ -113,8 +113,8 @@ struct hvcall_ppp_data {
  */
 static unsigned int h_get_ppp(struct hvcall_ppp_data *ppp_data)
 {
-	unsigned long rc;
-	unsigned long retbuf[PLPAR_HCALL9_BUFSIZE];
+	unsigned long retbuf[PLPAR_HCALL9_BUFSIZE] = {0};
+	long rc;
 
 	rc = plpar_hcall9(H_GET_PPP, retbuf);
 
@@ -193,7 +193,7 @@ static void parse_ppp_data(struct seq_file *m)
 	struct hvcall_ppp_data ppp_data;
 	struct device_node *root;
 	const __be32 *perf_level;
-	int rc;
+	long rc;
 
 	rc = h_get_ppp(&ppp_data);
 	if (rc)
-- 
2.43.0



