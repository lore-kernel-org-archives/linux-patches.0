Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0176A9CA51
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vcaEVFDs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E724C433CB;
	Mon,  9 Oct 2023 13:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858125;
	bh=balH0JraqUVaR7i+UT72d1ERFLDLsKdWMlvfhZR5vq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vcaEVFDs2DD52znqJZEWMh4tXm4uc/ZJ46OXR1FDGX4FhZD4OHoQyvQbMqpbBSOqK
	 nuwDBXJMCnCpjKfs8WrIll4PAoE2Wi6clS3aIkvTxnnZSDbHyged7N8IAZQiubrNI5
	 pdDvI+2zJhjPxeC9G6/rcHG1ivqNBqB1QzEaln6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishan Gopal Sarawast <krishang@linux.vnet.ibm.com>,
	Kajol Jain <kjain@linux.ibm.com>,
	Disha Goel <disgoel@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 024/131] powerpc/perf/hv-24x7: Update domain value check
Date: Mon,  9 Oct 2023 15:01:04 +0200
Message-ID: <20231009130117.048058684@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130116.329529591@linuxfoundation.org>
References: <20231009130116.329529591@linuxfoundation.org>
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

From: Kajol Jain <kjain@linux.ibm.com>

[ Upstream commit 4ff3ba4db5943cac1045e3e4a3c0463ea10f6930 ]

Valid domain value is in range 1 to HV_PERF_DOMAIN_MAX. Current code has
check for domain value greater than or equal to HV_PERF_DOMAIN_MAX. But
the check for domain value 0 is missing.

Fix this issue by adding check for domain value 0.

Before:
  # ./perf stat -v -e hv_24x7/CPM_ADJUNCT_INST,domain=0,core=1/ sleep 1
  Using CPUID 00800200
  Control descriptor is not initialized
  Error:
  The sys_perf_event_open() syscall returned with 5 (Input/output error) for
  event (hv_24x7/CPM_ADJUNCT_INST,domain=0,core=1/).
  /bin/dmesg | grep -i perf may provide additional information.

  Result from dmesg:
  [   37.819387] hv-24x7: hcall failed: [0 0x60040000 0x100 0] => ret
  0xfffffffffffffffc (-4) detail=0x2000000 failing ix=0

After:
  # ./perf stat -v -e hv_24x7/CPM_ADJUNCT_INST,domain=0,core=1/ sleep 1
  Using CPUID 00800200
  Control descriptor is not initialized
  Warning:
  hv_24x7/CPM_ADJUNCT_INST,domain=0,core=1/ event is not supported by the kernel.
  failed to read counter hv_24x7/CPM_ADJUNCT_INST,domain=0,core=1/

Fixes: ebd4a5a3ebd9 ("powerpc/perf/hv-24x7: Minor improvements")
Reported-by: Krishan Gopal Sarawast <krishang@linux.vnet.ibm.com>
Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
Tested-by: Disha Goel <disgoel@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230825055601.360083-1-kjain@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/perf/hv-24x7.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/perf/hv-24x7.c b/arch/powerpc/perf/hv-24x7.c
index 48e8f4b17b91b..c5c7a30bd0fd4 100644
--- a/arch/powerpc/perf/hv-24x7.c
+++ b/arch/powerpc/perf/hv-24x7.c
@@ -1313,7 +1313,7 @@ static int h_24x7_event_init(struct perf_event *event)
 	}
 
 	domain = event_get_domain(event);
-	if (domain >= HV_PERF_DOMAIN_MAX) {
+	if (domain  == 0 || domain >= HV_PERF_DOMAIN_MAX) {
 		pr_devel("invalid domain %d\n", domain);
 		return -EINVAL;
 	}
-- 
2.40.1



