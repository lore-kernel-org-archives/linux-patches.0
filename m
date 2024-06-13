Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F0B13C68A;
	Thu, 13 Jun 2024 12:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281310; cv=none; b=Epxqjqg8XrZ29MCsV5rSjtz2aKskuWw/oKCi9iar/WuQvwjBegDSec+g9aDtUYhetzKQ1eKLT/7m2mKzXH8mLxGG1wALDs9gMaAZ639YjJQ4WwcSlx/5JBbNGOUohc949zXq25igKI59S1WE+bjxcc9UeHGnJacDMFdUMBTs9o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281310; c=relaxed/simple;
	bh=WPDk4suXbHa5zxOmshpeO1zx+1zCCmWQQQE/uxrMT/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C1jETCYudBR9lElpZ/CW6q24nVap3W34oiIfXiwjG8ERu5/F8omldb2L+cftKEDvH1MwqRUZjj110SgLNWBmnf4kN7s5RGwdRX8rKuCqh/cSZm77XaxuLz0S88tIchXzLzGTk9BGejuQnFK9/9v5AVYFo7CaNvfSbrqLWQbOY7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gMnrrWqJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gMnrrWqJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC3E5C2BBFC;
	Thu, 13 Jun 2024 12:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281310;
	bh=WPDk4suXbHa5zxOmshpeO1zx+1zCCmWQQQE/uxrMT/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gMnrrWqJ5I1qfLuQcTyN3HWcXDiJEuRNLyAz8esYbWKi4ZCee+7q5EXwe07JOfuwN
	 CAWVs43ksEfwEKgNE9saVkbLKJPejwPlPDN9Oxe1ucK44vGTjdm6zTr6kKny1RJMpi
	 8B/UDzXLHnX7X2jiJcZo5wMPmpJ+DI1DOz1RlsdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 212/317] powerpc/pseries: Add failure related checks for h_get_mpp and h_get_ppp
Date: Thu, 13 Jun 2024 13:33:50 +0200
Message-ID: <20240613113255.756646043@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 00c8cda1c9c31..1a60188f74ad8 100644
--- a/arch/powerpc/include/asm/hvcall.h
+++ b/arch/powerpc/include/asm/hvcall.h
@@ -494,7 +494,7 @@ struct hvcall_mpp_data {
 	unsigned long backing_mem;
 };
 
-int h_get_mpp(struct hvcall_mpp_data *);
+long h_get_mpp(struct hvcall_mpp_data *mpp_data);
 
 struct hvcall_mpp_x_data {
 	unsigned long coalesced_bytes;
diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms/pseries/lpar.c
index 4a3425fb19398..aed67f1a1bc56 100644
--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -1883,10 +1883,10 @@ void __trace_hcall_exit(long opcode, long retval, unsigned long *retbuf)
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
index a7d4e25ae82a1..e0c5fc9ab242e 100644
--- a/arch/powerpc/platforms/pseries/lparcfg.c
+++ b/arch/powerpc/platforms/pseries/lparcfg.c
@@ -112,8 +112,8 @@ struct hvcall_ppp_data {
  */
 static unsigned int h_get_ppp(struct hvcall_ppp_data *ppp_data)
 {
-	unsigned long rc;
-	unsigned long retbuf[PLPAR_HCALL9_BUFSIZE];
+	unsigned long retbuf[PLPAR_HCALL9_BUFSIZE] = {0};
+	long rc;
 
 	rc = plpar_hcall9(H_GET_PPP, retbuf);
 
@@ -192,7 +192,7 @@ static void parse_ppp_data(struct seq_file *m)
 	struct hvcall_ppp_data ppp_data;
 	struct device_node *root;
 	const __be32 *perf_level;
-	int rc;
+	long rc;
 
 	rc = h_get_ppp(&ppp_data);
 	if (rc)
-- 
2.43.0



