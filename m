Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF3707A13A;
	Tue, 17 Feb 2026 20:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361274; cv=none; b=hrd0r4rfXaSryHa2hN5hSmf1fI2ENvkyIWYjFazHwlSFbTQckhhSfPdyHRCF02Yf/sJyXJELlCgvKZrsI6czXjyiel1kXpUPrqCwb+ZyzJ1fAx+0dD6sDr11cwbwtOhsN6bLFNkYt50ggdyrdFcFAAA9v39acgG9xzcW/twdiY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361274; c=relaxed/simple;
	bh=Zo/zLj+c02HE5GrO0s+GPZFkODCbmt3FJKDNyXj8kh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dww3tsjiNq/llv8hGyhsOuwO4AJy6ljU/r488O4j0e7nrFGfCf8TNiX9qJTnupOm6BzBNYOo0QkUXrHJReOwWH7uvCpvwQHduCPGipehxhPft8C3mg0YG1mCqPjzzkIFeUESA2Epv0Z7SloUi7e1J9sZu/P51BU1B2CBZ2KjgpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=129XdUiu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="129XdUiu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F9F6C4CEF7;
	Tue, 17 Feb 2026 20:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361274;
	bh=Zo/zLj+c02HE5GrO0s+GPZFkODCbmt3FJKDNyXj8kh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=129XdUiudHpQCKvRl3o1VJHMdSRkSdJoIC3rF6uFKOL7+8gxo6gN71vshOhOBDMFQ
	 7QG9dlLFmHyaBAlGAMqnUv115zB/BpwZ/3CtAa9wIrryLRk4FfhDMUCzLD1RJ4rN3x
	 x2YR88SrNd9WCgdsfICIvQUDXYiTPPVRe7nZaKzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	Jane Chu <jane.chu@oracle.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Rajani Kantha <681739313@139.com>
Subject: [PATCH 6.1 52/64] ACPI: APEI: send SIGBUS to current task if synchronous memory error not recovered
Date: Tue, 17 Feb 2026 21:31:48 +0100
Message-ID: <20260217200009.457100841@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200007.505931165@linuxfoundation.org>
References: <20260217200007.505931165@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuai Xue <xueshuai@linux.alibaba.com>

[ Upstream commit 79a5ae3c4c5eb7e38e0ebe4d6bf602d296080060 ]

If a synchronous error is detected as a result of user-space process
triggering a 2-bit uncorrected error, the CPU will take a synchronous
error exception such as Synchronous External Abort (SEA) on Arm64. The
kernel will queue a memory_failure() work which poisons the related
page, unmaps the page, and then sends a SIGBUS to the process, so that
a system wide panic can be avoided.

However, no memory_failure() work will be queued when abnormal
synchronous errors occur. These errors can include situations like
invalid PA, unexpected severity, no memory failure config support,
invalid GUID section, etc. In such a case, the user-space process will
trigger SEA again.  This loop can potentially exceed the platform
firmware threshold or even trigger a kernel hard lockup, leading to a
system reboot.

Fix it by performing a force kill if no memory_failure() work is queued
for synchronous errors.

Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Yazen Ghannam <yazen.ghannam@amd.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Hanjun Guo <guohanjun@huawei.com>
Link: https://patch.msgid.link/20250714114212.31660-2-xueshuai@linux.alibaba.com
[ rjw: Changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
[ Using pr_err instead of dev_err due to ghes doesn't have member "dev"]
Signed-off-by: Rajani Kantha <681739313@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/apei/ghes.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -684,6 +684,16 @@ static bool ghes_do_proc(struct ghes *gh
 		}
 	}
 
+	/*
+	 * If no memory failure work is queued for abnormal synchronous
+	 * errors, do a force kill.
+	 */
+	if (sync && !queued) {
+		pr_err(GHES_PFX "%s:%d: synchronous unrecoverable error (SIGBUS)\n",
+			current->comm, task_pid_nr(current));
+		force_sig(SIGBUS);
+	}
+
 	return queued;
 }
 


