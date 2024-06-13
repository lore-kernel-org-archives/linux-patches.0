Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC50147C7D;
	Thu, 13 Jun 2024 12:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280065; cv=none; b=sZqVOMkQKEyLALhUviXw2dsKkeCaFT2gPhGCY9levLWYeo16Wl7s0aekQo4Orsedya7f3IJf7IS+5WRDKNepDCmNrgdiV1JCrgG++gPYqRmZZU5Tp/M9ydjDBcVPLeyYBw2+mfpEtiDqagA1w64F6TYrPgjba+g/tApUKwvVpYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280065; c=relaxed/simple;
	bh=nepRRp8ub5GJVjPP4sRy/Ok+Gx75XhYDhi85pW4iNFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eyMVrWUcwd/hqAs0EmkGlSq6S4xPU+bRXllNXlclezs+ootAPvr5EHB481V0rj0GyTzd8mE78as7hX6XC4F3V4DC5FkFwAUw13YgIVJgvCE0OZdC21Fsa9t7F16tX39WoQJR75jiD9ZNVBrF+6Gg4gzFQnR4hraEQKjmLS4rSuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ni9kUGY1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ni9kUGY1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 255BFC2BBFC;
	Thu, 13 Jun 2024 12:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280065;
	bh=nepRRp8ub5GJVjPP4sRy/Ok+Gx75XhYDhi85pW4iNFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ni9kUGY1jjuIN5n1RjMO9CNd6DbXUKAaWk3lfGQw1+ytmu9puVNnO8gigsn8uFEXT
	 NURuKJPZG7NSoU0fPs8vE8+lm1wMtZxJVHGu+i/mdBTUbiPBGldrrD9di51T9u9uv9
	 Wt9coLQao88D85V4npT0g5VeViauW9+0f4+BZpkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 131/202] powerpc/pseries: Add failure related checks for h_get_mpp and h_get_ppp
Date: Thu, 13 Jun 2024 13:33:49 +0200
Message-ID: <20240613113232.817794466@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 11112023e327d..0826c4ed83770 100644
--- a/arch/powerpc/include/asm/hvcall.h
+++ b/arch/powerpc/include/asm/hvcall.h
@@ -444,7 +444,7 @@ struct hvcall_mpp_data {
 	unsigned long backing_mem;
 };
 
-int h_get_mpp(struct hvcall_mpp_data *);
+long h_get_mpp(struct hvcall_mpp_data *mpp_data);
 
 struct hvcall_mpp_x_data {
 	unsigned long coalesced_bytes;
diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms/pseries/lpar.c
index 52e466d4a33ca..d5700ef27e36c 100644
--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -1871,10 +1871,10 @@ void __trace_hcall_exit(long opcode, long retval, unsigned long *retbuf)
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
index e12cf62357f29..676a60927dad9 100644
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
 
@@ -159,7 +159,7 @@ static void parse_ppp_data(struct seq_file *m)
 	struct hvcall_ppp_data ppp_data;
 	struct device_node *root;
 	const __be32 *perf_level;
-	int rc;
+	long rc;
 
 	rc = h_get_ppp(&ppp_data);
 	if (rc)
-- 
2.43.0



