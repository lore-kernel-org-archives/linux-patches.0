Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07FC6143861;
	Thu, 13 Jun 2024 12:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281648; cv=none; b=eeUwLZOOdDuv0/0uP9TUX3py1B9lm+xfso1p5mh8aPjcMoOrVapiOgHuoe+19dYqM9nz9/FjuvDCxxk3UXl+cXuuD9eRwCQlndUks3DIYJhFrJk/4G9QvukeeN7p9Ie6lI+estcs2xto7qhfosRMkV0T5zpoc63js00zKGlL20o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281648; c=relaxed/simple;
	bh=Niqbzv5yVesmO2TbR2DNAMaf4+r5jdyWsOGSJgmWmrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NVOJU7q+efztX4D/0WUQtEfkt/kcn7454wAKdJmxHi+r2n8VIsB9hLN1sSqZpJf8bmDITOuSGqdABR/pxHdiIGgtAzo7En/SLKoGq9vqvowL+NzqNK2vUKhABL60VH6f0dh+OiY3wr33DtL+wJYkdCdaWUwxtTrAbeqt6Tk6Qis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BaZUxV4v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BaZUxV4v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84BB2C2BBFC;
	Thu, 13 Jun 2024 12:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281647;
	bh=Niqbzv5yVesmO2TbR2DNAMaf4+r5jdyWsOGSJgmWmrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BaZUxV4v1id+0v96HwIeEOqbIiHv+IRjpE8hjpL4liteySidj9EZsxv7a658eZH7X
	 Jhxov/bzZddS0qlzg43tztjgRBa3nT2KRhGVwgqTIHaRhyf+8kgbsaMhrNXyp0byOb
	 Hvvkt+Csa/v9nUAKgSB8TLckzFNh2stcjmH3qFvk=
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
Subject: [PATCH 5.15 001/402] x86/tsc: Trust initial offset in architectural TSC-adjust MSRs
Date: Thu, 13 Jun 2024 13:29:18 +0200
Message-ID: <20240613113302.178183547@linuxfoundation.org>
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


