Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13FE3195EF;
	Thu, 16 Jul 2026 14:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210968; cv=none; b=XBXiTX1tCJZrbXMsUWRfH2z1kgyagtzvwTQfnMGoVq9ytDqF/A0wETh55Ur1ePh4NZ0J21kksHMObnFSAWKgmmPn/PKcxSWj/APM5Zw7irJY0wf7zP75ZrlAf1HZlhCaVYV2wkQrNxT6bJXCkHbrrwEXoduiswGokeoqZ+1/RLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210968; c=relaxed/simple;
	bh=/AsUCjBGHCLGjw2Xt7mK1rqzXZE02g73bbQnqvZqua4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Licus8tOOl71lcY5/Z7Q7SNraB3ZDBtQ0gHbcMCmisEjICInMBwJ/LkKn8ZcfbNhhdFhoOcI5wkIIgzbTN9WRW5HKHPU6Zw2GV+mBBCVXVt6CvxDf3vYWHiRUmBtv+nhC1KbmWcxyNCg0zL9SU5Hvr5+lDcwU27Bc1YAG7ygGUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TyL+oFt9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TyL+oFt9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C721F000E9;
	Thu, 16 Jul 2026 14:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210967;
	bh=L7i9KDhAS0Jq5jAJO3irr1ern0xvYZCZBEwX/SvC0Q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TyL+oFt9lrc6OXDSCHHes8uCTX+GRw4lnLBUHbwexh4gPPssbhzTfH8O1XXTb0NIA
	 i742UPJ79Cav+me6MI/Sec78C93PiaXfuBRmOx3VQHiLOI50hi+cm1PzqqDY26HTJq
	 vAmALpbsl9bQwXrH4zeByem29s0OKQfd0kNS8sYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.18 249/480] cpufreq: pcc: fix use-after-free and double free in _OSC evaluation
Date: Thu, 16 Jul 2026 15:29:56 +0200
Message-ID: <20260716133050.204238954@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Yuho Choi <dbgh9129@gmail.com>

commit 266d3dd8b757b48a576e90f018b51f7b7563cc32 upstream.

pcc_cpufreq_do_osc() calls acpi_evaluate_object() twice for the
two-phase _OSC negotiation. Between the two calls it freed
output.pointer but left output.length unchanged. Since
acpi_evaluate_object() treats a non-zero length with a non-NULL
pointer as an existing buffer to write into, the second call wrote
into freed memory (use-after-free). The subsequent kfree(output.pointer)
at out_free then freed the same pointer a second time (double free).

Reset output.pointer to NULL and output.length to ACPI_ALLOCATE_BUFFER
after freeing the first result, so ACPICA allocates a fresh buffer for
each phase independently.

Fixes: 0f1d683fb35d ("[CPUFREQ] Processor Clocking Control interface driver")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Cc: All applicable <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260416144621.93964-1-dbgh9129@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/pcc-cpufreq.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/cpufreq/pcc-cpufreq.c
+++ b/drivers/cpufreq/pcc-cpufreq.c
@@ -352,6 +352,8 @@ static int __init pcc_cpufreq_do_osc(acp
 	}
 
 	kfree(output.pointer);
+	output.pointer = NULL;
+	output.length = ACPI_ALLOCATE_BUFFER;
 	capabilities[0] = 0x0;
 	capabilities[1] = 0x1;
 


