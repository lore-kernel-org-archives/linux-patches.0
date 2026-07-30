Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137E6446BF6;
	Thu, 30 Jul 2026 16:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427779; cv=none; b=jtx5TurPMtamHHGxn4yJb2+4tOHhOHsozVJ1HhED6/UrCyjMRnCV50nRJqmJCfD0QtNJnXkrVpzMjYQtJ6DTtEaKeENnFlHlbEyALySktl9rytILkp0F3PDxepnvdxF6D3GCZW6vYbCdeRx8DyU6qWZfhpVb282KTjh35fek2oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427779; c=relaxed/simple;
	bh=0BnuoSd6EvBwLUe81K+MIR6THjPYXEYZHC86KK/r18c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IOuyjcfnqB9AEo8348xW5ZnxqoZ73TmckpJJlW0ZrOOnZNjiQkUOEPuj+pHenkmLiO1XZcBjBi1qkgOOWyYcF2VHaxa36X53Xg5nEVSa0/M9hyTFzsVVKYKVlqu8MNt5MHLmDxf/2YNk0ZbBtmcISHASbDiCTmQewURt3YePj+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZFaaZ4dv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZFaaZ4dv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF321F000E9;
	Thu, 30 Jul 2026 16:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427778;
	bh=RajBL0L5nuX0Q4fhppGkEFUZ7r9K2akr2124GChp9vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZFaaZ4dvkZ6k1RhM/RpFEr8OZUAfzHy7JtPjv0Vs3vfUapQyjT3G384xPuppzB2kX
	 bnMFytG3DZlWYNbTGdSl/fFuCdGyyT3yFBA9nKFhUsdp64C/RPCENKHA3rGw/vex5r
	 9tQ+aj+6A9ATHfiGEIuaabMOw39YdtILW52oBwT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.6 291/484] tracing: Fix mmiotrace possible NULL dereferencing of hiter->dev
Date: Thu, 30 Jul 2026 16:13:08 +0200
Message-ID: <20260730141429.817263673@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: Steven Rostedt <rostedt@goodmis.org>

commit 144f29e85702234b23d2a62abf723e6a17eb5427 upstream.

If the mmio_pipe_open() fails to find a PCI device, the hiter->dev
will be assigned to NULL. The mmiotrace read() function dereferences the
hiter->dev if hiter exists.

Change the test of the read to not only check hiter being NULL, but also
the hiter->dev before dereferencing it.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260721211143.36dbd559@gandalf.local.home
Fixes: f984b51e0779 ("ftrace: add mmiotrace plugin")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260715143604.14481-1-gaikwad.dcg%40gmail.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_mmiotrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -146,7 +146,7 @@ static ssize_t mmio_read(struct trace_it
 		goto print_out;
 	}
 
-	if (!hiter)
+	if (!hiter || !hiter->dev)
 		return 0;
 
 	mmio_print_pcidev(s, hiter->dev);


