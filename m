Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B06168C4;
	Mon, 27 May 2024 19:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837456; cv=none; b=cVYxjXY528DcrWUXQ4gW6XK0fz1OMPY7G97on7DiNobWI4rbI3PCup+gYcjhpDMONXI3vj+gLcmZHvs5IQU2xBkFDuyE+2uUFUA0pLc8HTzGTbWx+WIakfmNheXjPvsbS2dC7xlsUkh+iMgBixnzclc2SRxpsERi7CrRViuEkYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837456; c=relaxed/simple;
	bh=eG4y+dqm8iBqyhfGuR/xSRzzLShdRuub2V9Uc/lADHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cFUqbrOoEGCAzTU9JBGLNEc0FB7WmNRgWVk0IxgmKp2h9LLOcRKFPT7KZGjbrVHk9QeCpGiOcNsxDuDAV820hrXMTp5PGyFNxk5zGHAn5wVSWdBrRQUXZ8+CzuEkE0tikhMAdmCN1a/qRwL+h/Oa/yxDaS/o/DVUjn1fsRKWDb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uko7g2Mk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uko7g2Mk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C45AC2BBFC;
	Mon, 27 May 2024 19:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837456;
	bh=eG4y+dqm8iBqyhfGuR/xSRzzLShdRuub2V9Uc/lADHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uko7g2Mk0C0DsEXqqGF77Hq6u4FXrke+mMAClEooUw5478iRQZgWe6N3jccSQHq9v
	 2YJCOa+wnDPn3M/KXzwCYbEtY35fxTpxCnuBQ5b5Fey+CfEDJhjgCH4UG3RJu0UHrw
	 VOft4T8D+FvgkPvOvuy843qYqYXpZ2rbxm1JzxII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel J Blueman <daniel@quora.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Steffen Persvold <sp@numascale.com>,
	James Cleverdon <james.cleverdon.external@eviden.com>,
	Dimitri Sivanich <sivanich@hpe.com>,
	Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH 6.8 002/493] x86/tsc: Trust initial offset in architectural TSC-adjust MSRs
Date: Mon, 27 May 2024 20:50:04 +0200
Message-ID: <20240527185626.760223171@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel J Blueman <daniel@quora.org>

commit 455f9075f14484f358b3c1d6845b4a438de198a7 upstream.

When the BIOS configures the architectural TSC-adjust MSRs on secondary
sockets to correct a constant inter-chassis offset, after Linux brings the
cores online, the TSC sync check later resets the core-local MSR to 0,
triggering HPET fallback and leading to performance loss.

Fix this by unconditionally using the initial adjust values read from the
MSRs. Trusting the initial offsets in this architectural mechanism is a
better approach than special-casing workarounds for specific platforms.

Signed-off-by: Daniel J Blueman <daniel@quora.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Steffen Persvold <sp@numascale.com>
Reviewed-by: James Cleverdon <james.cleverdon.external@eviden.com>
Reviewed-by: Dimitri Sivanich <sivanich@hpe.com>
Reviewed-by: Prarit Bhargava <prarit@redhat.com>
Link: https://lore.kernel.org/r/20240419085146.175665-1-daniel@quora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/tsc_sync.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/arch/x86/kernel/tsc_sync.c
+++ b/arch/x86/kernel/tsc_sync.c
@@ -193,11 +193,9 @@ bool tsc_store_and_check_tsc_adjust(bool
 	cur->warned = false;
 
 	/*
-	 * If a non-zero TSC value for socket 0 may be valid then the default
-	 * adjusted value cannot assumed to be zero either.
+	 * The default adjust value cannot be assumed to be zero on any socket.
 	 */
-	if (tsc_async_resets)
-		cur->adjusted = bootval;
+	cur->adjusted = bootval;
 
 	/*
 	 * Check whether this CPU is the first in a package to come up. In


