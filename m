Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A16A5217723;
	Thu, 30 Jul 2026 15:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424718; cv=none; b=BM21xoo+VsvML+MuHtUMKayonzwPLxRcJvN5FFHjo4V4pBHU21CZ0/4P5H+5MYM7G0mTYQKECqR1rnXKjifaZOwDNS54f3YcZTVxN4wQpFQvHTMM1hUYGufawZKITtHlU93fydxoEdlWRjLNp0BduEM5wl0wwnJ+HFDi0C38t6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424718; c=relaxed/simple;
	bh=F30t7h5Jqv66JIfcFZHswf/k7XQzFVod5H6t0vetIL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k42s7JZmzbcENOI5YrH5zIskzq0BLO2q3e0JzpL7SO/0/Pohmgo3GxL+ZGNbdUA9JrMU1rcJPjVKySNTdOr35xfvbdpxeVP7Wi+yFypB+DGuo5o4dkarP/iEDJtLNMkSD9ey0Zf2Pdz7+i9PXAn4v0zKAqpF1QmkNhBE940Q0m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d53YEZEf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d53YEZEf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07BA51F000E9;
	Thu, 30 Jul 2026 15:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424717;
	bh=Gp3hDVnBcPKzhHaETU636Fco8gohOildqQ9x1JC09mY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d53YEZEfakrCOIX/U3f/vIorl/QujSVtJoveYp098mX2gyKpzjwm1Svnjw3dDYaRH
	 V4Ns2O0bUvCHLtRb9D19OJinYcDx2NXTln1pbAbRsYu12q8XTNiVliiNTvG6J2XlyO
	 RdhBMoke3xi/o00xHKGUy00NJrGo4XQXTaTf77tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 491/675] tracing: Fix mmiotrace possible NULL dereferencing of hiter->dev
Date: Thu, 30 Jul 2026 16:13:41 +0200
Message-ID: <20260730141455.558448043@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


