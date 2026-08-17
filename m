Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DABB2E8DEC;
	Mon, 17 Aug 2026 15:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979589; cv=none; b=qj6y66QToC4+8dkCa8YdeGSxDtRcphQliaoDfvECF8bf1aRomAXedpcwIRRZQb4EwH4XHoDg9a0uGxfTSFIr4120DX1IAnmzLeH6++Zsdag6GufKSs34FVPArIyDJCP3oo45ZBO3QNHrK/5QkloCSohy70czp/GXEg16lPImliU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979589; c=relaxed/simple;
	bh=LJ7O/z6TyAo1CVI6FuXqI5UfNq7Y8XWhqHzcaNvD6VQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uwzWX1L2VZpYxIdiXd5GVKSxZEbipm3hA3o0gNJydDqTUPZEDyKtE2rTd2hOg9o/X6fNsVjEyajesxf/mlqyYOaIx60QSOXORNxxDWpwv00a+A78t86PJE+zO31NCar81sPZ0P2yPbBI+5nQ3+nHhndZylcc8pWa2S0W9eD5qYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OoihXDKI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OoihXDKI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C52071F000E9;
	Mon, 17 Aug 2026 15:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979588;
	bh=8lpbOj+7Zf+7GhYrFv25NMciys19MbQh/LVoQj0KOTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OoihXDKIpio3d3oaW2zcfrNiDfg6nPWGOZYsTrGrp5wxXtHMUZeVS5ecqoEM/1jA2
	 r9iZOMSiIx27PMz+r8vHLr6KevBeXOtMDjPUHvtvfWAsR8lb1TGdRJ6a6CO1jh1o3C
	 rwXzWeRtrqcppHcZm8QYOcYPesL0Dpqi8LclOVT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.1 238/609] tracing: Fix mmiotrace possible NULL dereferencing of hiter->dev
Date: Mon, 17 Aug 2026 15:28:54 +0200
Message-ID: <20260817132552.040590446@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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


