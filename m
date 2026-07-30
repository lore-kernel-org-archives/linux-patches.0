Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB35437756C;
	Thu, 30 Jul 2026 14:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422896; cv=none; b=O/vve1c+Z2OMoQ4xa0ca11OaHD0VFwoKT1GF9EdxVzbntikOT5TwTx6r+TP9NIWc5vwLyyHfA9SlSv/dEWBtzUoP+e+0fpOsP2vBDeeHrdfFf9II5PnGfghJGEI5BfMoWB4NLzP7GJG2Lq5X81TE9l8MWf+47ShdNWK21CjU6X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422896; c=relaxed/simple;
	bh=MNotbVcxIh93cF0Cc5vf4JIDQN6rltc5wAjmi6TnUOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VmGTnFfDzTr4lOi7B0sJqSMj3uTkm2vz86j5vP9rEeA+hznIPeTnju0iSybZj/6o+Mcisi+nldSD91J+5hVWWbsIBN5Yd83obix/yQtX1XrWbrNST8rLO5F2DQnC78IrWOfiuU+p1JIqKRv22ncS4zMUK19hH7AwMxdGE53y+mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ahuycjBY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ahuycjBY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D2A1F00A3D;
	Thu, 30 Jul 2026 14:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422895;
	bh=N/a1F2dzrvv38MPkuSbeWIasJN3rHdTdZNPpD97dYPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ahuycjBY5K6JHNoe4CziNWJwLC0GS8H8PYEipxXCwcgLwiBBOlrhXjpuj8RU7df+n
	 Ly7y9l4IWjqPVloYG99iUog3wiI9hcAXsOmH+ZATSAnZ6rk1uQ4eXB8tLglKbXCq47
	 YqwFBmoWKtDJaSN75JolrJ0P8hbl2J7hV/z6Auy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.1 592/744] tracing: Fix mmiotrace possible NULL dereferencing of hiter->dev
Date: Thu, 30 Jul 2026 16:14:25 +0200
Message-ID: <20260730141456.863944094@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


