Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54FBA429CEE;
	Mon, 17 Aug 2026 14:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975877; cv=none; b=NqOT/TN7CUY9zgGzW58SU7Cq/BpxU2BJgMq9AxzYBKKVtLo/Eg/FLar009LZewTWzhMxLJaz9x/MfzmXfOtjfzv4YgdCY7Cayt/gvCUYPJoTWLGlThkHUvl2Jye4cBGbUzX5bqn8qGxB+PWAIBB+3MY5eloVuKY1P4se0RpTEys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975877; c=relaxed/simple;
	bh=vC79CrUjvP5s+0Z9KoFpQie69mtjymtd9XF14KCO4SQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kqeAgF3R+Ee+8+xGiu3EzneiPxGXsjg55ezk1NSmC+i+YW41Pem/FGMAjUuy7JnQqxAYN0TaFY/N+BxOEWyuX7jqyfUyBEE7AqdgIiexXuPj8y2+CdTBDNLGUOgDF9EFeCldaGJDjlgTYjlwm80jTUEzigoPvlI9ZDZq7mxC584=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cGV9lSAy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cGV9lSAy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D941F000E9;
	Mon, 17 Aug 2026 14:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975876;
	bh=h4NdIr3QMR/qT7p7ROWfBFEZwBUtmQ/zYFramZolLzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cGV9lSAy683Q+wQMiLjDenqNmanigptZa648FMEPv1SdfQdxUw0kHc9P17JLvZPoh
	 CY6UEimhoD2uakNMG6s2gsxB1sf9wajdcAWsJ6r2orhetHgTXe1ya255hwZUgz45gv
	 j5OdyHCbxjZTtvSQr/Ieh6vGuLmnGesxksIE+D10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 5.10 152/389] tracing: Fix mmiotrace possible NULL dereferencing of hiter->dev
Date: Mon, 17 Aug 2026 15:29:51 +0200
Message-ID: <20260817132545.120895913@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -148,7 +148,7 @@ static ssize_t mmio_read(struct trace_it
 		goto print_out;
 	}
 
-	if (!hiter)
+	if (!hiter || !hiter->dev)
 		return 0;
 
 	mmio_print_pcidev(s, hiter->dev);


