Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371AD54F93;
	Thu, 30 Nov 2023 16:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uP66cMgp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52170C433C7;
	Thu, 30 Nov 2023 16:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361542;
	bh=KBf3ckFH8ZZdbhJFP2ziQdIn7EjeCpKZg3OLh74OB9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uP66cMgpkzD9pkSU5JOK89Gd0VTwBkJ5YMJoApwI/hAkWsz+KkodCm6WnGe7PgdSZ
	 q5RZhltvwtI+14a8Fa5Stkf1wI6ZbDBld97nFL3SUDU8EMI95nYTvktU65+rbdZ4xe
	 w0MNpyZdttR6f9GjTIcnWoVo/xTa25XO+7pWAVUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw@amazon.co.uk>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 064/112] ACPI: processor_idle: use raw_safe_halt() in acpi_idle_play_dead()
Date: Thu, 30 Nov 2023 16:21:51 +0000
Message-ID: <20231130162142.352058541@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Woodhouse <dwmw@amazon.co.uk>

commit 9bb69ba4c177dccaa1f5b5cbdf80b67813328348 upstream.

Xen HVM guests were observed taking triple-faults when attempting to
online a previously offlined vCPU.

Investigation showed that the fault was coming from a failing call
to lockdep_assert_irqs_disabled(), in load_current_idt() which was
too early in the CPU bringup to actually catch the exception and
report the failure cleanly.

This was a false positive, caused by acpi_idle_play_dead() setting
the per-cpu hardirqs_enabled flag by calling safe_halt(). Switch it
to use raw_safe_halt() instead, which doesn't do so.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: 6.6+ <stable@vger.kernel.org> # 6.6+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/processor_idle.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 3a34a8c425fe..55437f5e0c3a 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -592,7 +592,7 @@ static int acpi_idle_play_dead(struct cpuidle_device *dev, int index)
 	while (1) {
 
 		if (cx->entry_method == ACPI_CSTATE_HALT)
-			safe_halt();
+			raw_safe_halt();
 		else if (cx->entry_method == ACPI_CSTATE_SYSTEMIO) {
 			io_idle(cx->address);
 		} else
-- 
2.43.0



