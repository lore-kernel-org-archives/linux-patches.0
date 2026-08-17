Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2903F7A9B;
	Mon, 17 Aug 2026 14:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977152; cv=none; b=O4/tWX4t8A7f7cb3uSZmADiEJmRjp6MazD24suQFY2e391hV6Je3vuibLIuILE+xs8ESxJSpDr6AqtUsC7BJAEyBtnyOs6fpvHtoDMycepMgr3NxIoKRHh8dNgqOFnDF4wfi9trDmNk6lqs3wZzq1Fa3u7S+iejLHIoA8UpVLcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977152; c=relaxed/simple;
	bh=dglPiEDTM8Jxm+FF85QHcpEv8TSMSg1BkpmgeYjqG98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gHhG2iabt6cwwhbcuD4wjHW6eNY/2ewWNJ3Yb8NX0EKUz3hAnvuuWJ9WdvPBXY2lhMIAkbOmCMWlDg67K8SrcMDm7bisLapFk/YTyiJ1QX/YsWJd4WU0awK9AAd0mbc2mKXhlYn/DnIPsy/bFvEKwnIV9kiREzu5SyYobgdlVxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u/4vcB3W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u/4vcB3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEFB61F00A3D;
	Mon, 17 Aug 2026 14:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977151;
	bh=1oyhdItVFQzpYyE6wT+My9qUtm5zb51Eo7vFtkI2uiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u/4vcB3Wv4C3+J2mleSKtDKhJVQUPnWSZxQcMJORlt5sF0pwyakTPnxLIBLLI2wlX
	 +cQIBv8MsyFC3OrooDD/Nck6ITwejKOK4qFYJaGsI4x7JxDyo2opxRYj5VTDNHP0y/
	 dXLUfBRZzoojXHjFAZyk41BznQXRexDPVtt7yjlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 5.15 191/456] tracing: Fix mmiotrace possible NULL dereferencing of hiter->dev
Date: Mon, 17 Aug 2026 15:29:41 +0200
Message-ID: <20260817132547.589867338@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


