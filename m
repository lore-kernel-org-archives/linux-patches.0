Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0969158215;
	Tue, 23 Jul 2024 18:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759825; cv=none; b=EjhXp5LqQiTUI2A3crHwmGZegroOy9P7ogDUQXEw9B+HYWEcjHrk8ULz/Jgema1MHG0VKhW20Zz5QrJaG0T7RuYYu8IXVypxsE04gV13MFUyMNAE8fyb9BMfUFm7CQSktomZjpyIW4alBfud5kJ9ECuKkAtksls8FvxkaDpm8j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759825; c=relaxed/simple;
	bh=A5UIjCaf77wULj1wPW65oqotVERLbbGWtNrLAMFtsHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V/4WiEqli9rH/UmaqmGzsbCzvMIm2aPvf5jmLmmWGv2LsIqCmFyTLlh7K8mf7zuDkrGDS4VYlPJh6524aANN7J99OKkdZYNrw3rFnS5mRCvHwN7q4GquKjTbm5WGzjvTuLoUXQnyV7hL3I6gPhvlqWrCEP3ZLWdySBc1NorCxLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wNwE0K3V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wNwE0K3V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF995C4AF09;
	Tue, 23 Jul 2024 18:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759825;
	bh=A5UIjCaf77wULj1wPW65oqotVERLbbGWtNrLAMFtsHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wNwE0K3VfafDg71VS7NM0/eAyQXk1deieyWT6vvqafOCqhhNJPRLAlRJHYIp7+rKw
	 alFs5lJjJL+i4RyL497LEn5cM7QZtDx0xC5/mOQPk56RxAsgT/ypkC8Gzx6lifsXay
	 B2pp9R3mszOGC0Km+Q3rJS3B+G53QZ272Za/tqgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ananth Narayan <Ananth.Narayan@amd.com>,
	Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 011/163] tools/power/cpupower: Fix Pstate frequency reporting on AMD Family 1Ah CPUs
Date: Tue, 23 Jul 2024 20:22:20 +0200
Message-ID: <20240723180143.906552814@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

From: Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>

[ Upstream commit 43cad521c6d228ea0c51e248f8e5b3a6295a2849 ]

Update cpupower's P-State frequency calculation and reporting with AMD
Family 1Ah+ processors, when using the acpi-cpufreq driver. This is due
to a change in the PStateDef MSR layout in AMD Family 1Ah+.

Tested on 4th and 5th Gen AMD EPYC system

Signed-off-by: Ananth Narayan <Ananth.Narayan@amd.com>
Signed-off-by: Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/cpupower/utils/helpers/amd.c | 26 +++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/tools/power/cpupower/utils/helpers/amd.c b/tools/power/cpupower/utils/helpers/amd.c
index c519cc89c97f4..0a56e22240fc8 100644
--- a/tools/power/cpupower/utils/helpers/amd.c
+++ b/tools/power/cpupower/utils/helpers/amd.c
@@ -41,6 +41,16 @@ union core_pstate {
 		unsigned res1:31;
 		unsigned en:1;
 	} pstatedef;
+	/* since fam 1Ah: */
+	struct {
+		unsigned fid:12;
+		unsigned res1:2;
+		unsigned vid:8;
+		unsigned iddval:8;
+		unsigned idddiv:2;
+		unsigned res2:31;
+		unsigned en:1;
+	} pstatedef2;
 	unsigned long long val;
 };
 
@@ -48,6 +58,10 @@ static int get_did(union core_pstate pstate)
 {
 	int t;
 
+	/* Fam 1Ah onward do not use did */
+	if (cpupower_cpu_info.family >= 0x1A)
+		return 0;
+
 	if (cpupower_cpu_info.caps & CPUPOWER_CAP_AMD_PSTATEDEF)
 		t = pstate.pstatedef.did;
 	else if (cpupower_cpu_info.family == 0x12)
@@ -61,12 +75,18 @@ static int get_did(union core_pstate pstate)
 static int get_cof(union core_pstate pstate)
 {
 	int t;
-	int fid, did, cof;
+	int fid, did, cof = 0;
 
 	did = get_did(pstate);
 	if (cpupower_cpu_info.caps & CPUPOWER_CAP_AMD_PSTATEDEF) {
-		fid = pstate.pstatedef.fid;
-		cof = 200 * fid / did;
+		if (cpupower_cpu_info.family >= 0x1A) {
+			fid = pstate.pstatedef2.fid;
+			if (fid > 0x0f)
+				cof = (fid * 5);
+		} else {
+			fid = pstate.pstatedef.fid;
+			cof = 200 * fid / did;
+		}
 	} else {
 		t = 0x10;
 		fid = pstate.pstate.fid;
-- 
2.43.0



