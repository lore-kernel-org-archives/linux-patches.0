Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83F51D07B8;
	Wed,  2 Oct 2024 13:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876695; cv=none; b=d5/8/Dsjjb7zPXDcKAWPTL6FX/tLSlcJetdgwQ2VKcgnm0oTmSLZ5yRYdmSrqm335SksjFfQeOTNySieaRLBHebXPl7I7akcOPgcJ45LXrUrr4Pw+Awv+ocYkT7CKQZzqlishWNri8q3ZcxyMYg2LTH1aKaS0bdTdS7F4+IccGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876695; c=relaxed/simple;
	bh=p7i+sRGHxG/9uMgTtfAclRHvlnZRNCmqOjmCz9lN6I4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rBrmfyxH1DYj1ZBogRK7BJPQrj/oyOk65EkyyZrsFjR99+DLNfUaRVzf6hLOBQhcwivib0FoZNYuIYRQPGmt2A5dZ+FyjYBjLImoCoXxh4wASPCK3W7Ia5f6cj4lHwA1yfQaMhQP4A/1YpGDGa2LaI3UVJzqyJ/gB3r9UMFNDRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VedPq4N1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VedPq4N1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72038C4CECD;
	Wed,  2 Oct 2024 13:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876694;
	bh=p7i+sRGHxG/9uMgTtfAclRHvlnZRNCmqOjmCz9lN6I4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VedPq4N1pWTH4+88sYz4JGIzeAbwTcLdP5PKOfd2V8L2gZbz7sWzKIrwfchTVJB8a
	 1L19jCvqn1Uu+s8j3ynYgkwliwIT+pJnWF7Xi8OJZxb7C5nn3XrQMq9mSviEdAwfX+
	 6HXRYmDPqAPAt8OS/ReNR62S8/hwWF5iLsBp66hA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH 6.11 524/695] soc: fsl: cpm1: qmc: Update TRNSYNC only in transparent mode
Date: Wed,  2 Oct 2024 14:58:42 +0200
Message-ID: <20241002125843.402479456@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herve Codina <herve.codina@bootlin.com>

commit c3cc3e69b33fee3d276895e0e2d1a8fb37ea5d0e upstream.

The TRNSYNC feature is available (and enabled) only in transparent mode.

Since commit 7cc9bda9c163 ("soc: fsl: cpm1: qmc: Handle timeslot entries
at channel start() and stop()") TRNSYNC register is updated in
transparent and hdlc mode. In hdlc mode, the address of the TRNSYNC
register is used by the QMC for other internal purpose. Even if no weird
results were observed in hdlc mode, touching this register in this mode
is wrong.

Update TRNSYNC only in transparent mode.

Fixes: 7cc9bda9c163 ("soc: fsl: cpm1: qmc: Handle timeslot entries at channel start() and stop()")
Cc: stable@vger.kernel.org
Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Link: https://lore.kernel.org/r/20240808071132.149251-2-herve.codina@bootlin.com
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/fsl/qe/qmc.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

--- a/drivers/soc/fsl/qe/qmc.c
+++ b/drivers/soc/fsl/qe/qmc.c
@@ -940,11 +940,13 @@ static int qmc_chan_start_rx(struct qmc_
 		goto end;
 	}
 
-	ret = qmc_setup_chan_trnsync(chan->qmc, chan);
-	if (ret) {
-		dev_err(chan->qmc->dev, "chan %u: setup TRNSYNC failed (%d)\n",
-			chan->id, ret);
-		goto end;
+	if (chan->mode == QMC_TRANSPARENT) {
+		ret = qmc_setup_chan_trnsync(chan->qmc, chan);
+		if (ret) {
+			dev_err(chan->qmc->dev, "chan %u: setup TRNSYNC failed (%d)\n",
+				chan->id, ret);
+			goto end;
+		}
 	}
 
 	/* Restart the receiver */
@@ -982,11 +984,13 @@ static int qmc_chan_start_tx(struct qmc_
 		goto end;
 	}
 
-	ret = qmc_setup_chan_trnsync(chan->qmc, chan);
-	if (ret) {
-		dev_err(chan->qmc->dev, "chan %u: setup TRNSYNC failed (%d)\n",
-			chan->id, ret);
-		goto end;
+	if (chan->mode == QMC_TRANSPARENT) {
+		ret = qmc_setup_chan_trnsync(chan->qmc, chan);
+		if (ret) {
+			dev_err(chan->qmc->dev, "chan %u: setup TRNSYNC failed (%d)\n",
+				chan->id, ret);
+			goto end;
+		}
 	}
 
 	/*


