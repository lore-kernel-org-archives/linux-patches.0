Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4681877;
	Thu, 13 Jun 2024 12:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282416; cv=none; b=kKmVxye5pWDobUheRLKICvEE6nC016yVXbpbgRyerkyAUBi/82XaKbAQSa2wZhw8qLHrPwB7ypjPHOIni5A+o+jp3LfJNu60lNsYvqnFcoP0oZm+e23/JA6/KAgv/obpbsmVPPBifowq/BUT5N4P7UUHre7N580v+86BkWnqhqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282416; c=relaxed/simple;
	bh=xlGJFFyiGOUtUVbJ4QKzvYpWZpbhvIcALPrlIcKv5LY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cMlM67uXCb2PmLT8LNy7xvDWy3LPhDEPJEzbNSJK3Ohwe1OexQu9PWAtzC/d8ZOiFyf2YrtXRoVf96lUxF9KpDebt/1afh+4RpXHYW6l8B29OXgqnj54gSQdLJBn9GvLDS25ZaztAcLRL/LI5whuBAr4RbEeV5+q4lyQ+8gsWbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NLKpxAae; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NLKpxAae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7C1C2BBFC;
	Thu, 13 Jun 2024 12:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282415;
	bh=xlGJFFyiGOUtUVbJ4QKzvYpWZpbhvIcALPrlIcKv5LY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NLKpxAaeD7pmYGx0dKzu2JL7wRYQAh8lG2FfSnKofsLQufk6PchF0C0plABIAEVfK
	 Zoy8avpBhyGtvXm3OUE1hkz31mHq0Zugro7KtwsEwS0TtyTBkcYaZb+LCTKoJfiLlb
	 x4yoXAVwKtwb1Yq+HNcI+KAmToGLNvK2i+f3Wrt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 269/402] powerpc/pseries: Add failure related checks for h_get_mpp and h_get_ppp
Date: Thu, 13 Jun 2024 13:33:46 +0200
Message-ID: <20240613113312.646458290@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9bcf345cb208b..c25f160bb9978 100644
--- a/arch/powerpc/include/asm/hvcall.h
+++ b/arch/powerpc/include/asm/hvcall.h
@@ -513,7 +513,7 @@ struct hvcall_mpp_data {
 	unsigned long backing_mem;
 };
 
-int h_get_mpp(struct hvcall_mpp_data *);
+long h_get_mpp(struct hvcall_mpp_data *mpp_data);
 
 struct hvcall_mpp_x_data {
 	unsigned long coalesced_bytes;
diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms/pseries/lpar.c
index 6c196b9413553..c2fff9a339285 100644
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
index a291b5a94d4da..fea4dfa54e3c2 100644
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



