Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92AEB3AFB0C;
	Tue, 21 Jul 2026 20:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665181; cv=none; b=U+o/YyfvIr4ee4SxZQdkw6FI+qy1NcWQV+2yxMT+qjxLvqeGhJCiZ5uDRLv7xeXrG9d5wsmBiBZq3GYJHP+wvRzp+CCoKViO9Z6KOyzluDI3oSg9EToJ2KJeZmmdvjEugxKReSekrvpgN+AkAzaAaE+yTSojrilAH2uN8E5jtF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665181; c=relaxed/simple;
	bh=cnKEjBsDm550rgkZE0BPXs5o5mFgqn1IqazSX8Qlm00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uK3ir/ztHOzy+1dsQ5nEHwjDkXjfT0XMmsEumZh/+KeM2Drt323coO2KYtfVeq274b+7ckfnwlwfWU/X5H9/Y/mEQa/7rpSxghjdGIgZFaTvjVm7tDIAL7TSMyOWnyDZZNqWaqK+y5bIy1iDxKAYLraOTszWOQsPh5fsddEHPKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j9uGgZdz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j9uGgZdz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA0CA1F00A3A;
	Tue, 21 Jul 2026 20:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665180;
	bh=eLJmcal2+Kpd39xcCBXU1sQYnIj8VDF6WXQ/3w/UyPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j9uGgZdzO8XNeEAULIEXrPmLaL7c2bNXxRfL21F0lOeUHjR5mEcmUzHXRWtPf/xmU
	 a/+QiKaVswaoSDT14da02euwJ/yTp8IuBKd4WRR+q6nJAc2KLMtC4UdZdZLmILp7qZ
	 v3eiLR+rH6Rp/rQL7McRj2KZfY5KkNzsirzZGCYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 0207/1266] cpufreq: pcc: fix use-after-free and double free in _OSC evaluation
Date: Tue, 21 Jul 2026 17:10:44 +0200
Message-ID: <20260721152446.446251613@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


