Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5251990D1;
	Thu,  6 Jun 2024 14:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683130; cv=none; b=TpkoI4R/ffiZUMpY4JfEyDp5GF6OdzA2RUHztuMZQKFqJ1fmlnie8Kac8RVUlhSZgyJlFsKZnfj1qoYXcV2wG4+s+0uY+0uQDO4ERsLCpbNPOtZ96sgttGxtousr0RSAu53l/k5S8R1FBG2SnGDNkiCy8vHRfm+qpUJBV8JAoZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683130; c=relaxed/simple;
	bh=TPOvDKk0/isTS/59wlz6UlRFdQacZHgwALGH+fmnrLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u52wJ+/8PEL1KDqS/BFbdiGZO7PPzU6Ckqg/06kJLnUSb85Y1oFWn7Wb4yOR5biT1mNJI7Fq0jY3Vkq1AjPlNryEfEgKyTGcP6N5QqmU3nwYCaYc9TP4TCTjTNIyx3CLGzZTI1o9kQspZVmv8XzpgjILODiQ1nxJkJuCHOUCIUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OXOqLiOD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OXOqLiOD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53060C2BD10;
	Thu,  6 Jun 2024 14:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683130;
	bh=TPOvDKk0/isTS/59wlz6UlRFdQacZHgwALGH+fmnrLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OXOqLiODL77bkYxzJY1CWT6R3+XCLrqXkHsgN8NQWc2zqmVlkTAXphroKZi8nTxUa
	 GCtWvM6/XWFbHmjTM6jW2oOXFMvAVySei3VIdNG5JRvTuXbVbnzkdQHkntpeiCnRSd
	 FvMK7+wKufQt0elqTlCaq9aD/S4RY+wzD4Q+6X3Y=
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
Subject: [PATCH 6.1 001/473] x86/tsc: Trust initial offset in architectural TSC-adjust MSRs
Date: Thu,  6 Jun 2024 15:58:50 +0200
Message-ID: <20240606131659.846950535@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -192,11 +192,9 @@ bool tsc_store_and_check_tsc_adjust(bool
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


