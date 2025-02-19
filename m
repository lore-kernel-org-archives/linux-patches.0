Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FAA21B86E9;
	Wed, 19 Feb 2025 09:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956731; cv=none; b=DSTejiaFZ87Apskb6g2VmoZhCX6UCAqcw0Sh1yG5cpsc7Fw5JJ83ateLqcjPY8fnkmMoKI8zQ8nnQt6FK7u+eDrLUgBsRmJWO7UUOAm5FZhVKOKMarqLoLzu58gh9CB5dleL38ZZbzGrhkD354qOqtmqEakN/0kEXUFOWJJ0/D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956731; c=relaxed/simple;
	bh=4I4gaqQvPIarmVNbykftnqxNWAPsQqZDEpx1LYVDSnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N35NJg1Ys35P6JYiR/FMITbDtt8aqsjhEL3rB/BDg3oJrqStR4fv87qdpA/9YpZMYK97g43pngtw3XTRq7T/+m56UDtO8oLzgCZoLzmHTJW/pkQcSJ6T1jayXoP8JO0Q5ZER+fW9MQdmhhKleBEtbqb4VdVj9cjjysMtJb4lX+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wXV0aYUM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wXV0aYUM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B8DC4CED1;
	Wed, 19 Feb 2025 09:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956731;
	bh=4I4gaqQvPIarmVNbykftnqxNWAPsQqZDEpx1LYVDSnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wXV0aYUMitgxHweueDnYFJFY+0eSfFYk2a0TfBP3rRsvet5P16NFe2Qg4Jh3C6yUp
	 EykxwaXmeH0Qtl1SKUZsbvLw+rRCMl57z5ac/9zCiIopiDC1wn7x0zucIeGRtJMimt
	 MND0rewzOWlM7JTaceUFFb5b9G9r35CLBAgYWr+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Hawley <warthog9@eaglescrag.net>,
	"Ricardo B. Marliere" <rbm@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.1 249/578] ktest.pl: Check kernelrelease return in get_version
Date: Wed, 19 Feb 2025 09:24:13 +0100
Message-ID: <20250219082702.824210316@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ricardo B. Marliere <rbm@suse.com>

commit a4e17a8f239a545c463f8ec27db4ed6e74b31841 upstream.

In the case of a test that uses the special option ${KERNEL_VERSION} in one
of its settings but has no configuration available in ${OUTPUT_DIR}, for
example if it's a new empty directory, then the `make kernelrelease` call
will fail and the subroutine will chomp an empty string, silently. Fix that
by adding an empty configuration and retrying.

Cc: stable@vger.kernel.org
Cc: John Hawley <warthog9@eaglescrag.net>
Fixes: 5f9b6ced04a4e ("ktest: Bisecting, install modules, add logging")
Link: https://lore.kernel.org/20241205-ktest_kver_fallback-v2-1-869dae4c7777@suse.com
Signed-off-by: Ricardo B. Marliere <rbm@suse.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/ktest/ktest.pl |    5 +++++
 1 file changed, 5 insertions(+)

--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -2399,6 +2399,11 @@ sub get_version {
     return if ($have_version);
     doprint "$make kernelrelease ... ";
     $version = `$make -s kernelrelease | tail -1`;
+    if (!length($version)) {
+	run_command "$make allnoconfig" or return 0;
+	doprint "$make kernelrelease ... ";
+	$version = `$make -s kernelrelease | tail -1`;
+    }
     chomp($version);
     doprint "$version\n";
     $have_version = 1;


