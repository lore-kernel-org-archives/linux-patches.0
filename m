Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066B61E98EF;
	Sun,  7 Jun 2026 10:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829099; cv=none; b=dlXD2O/pEGyvH2Q897OR3P9r3ap9DHJpLnSJvEPyRhMCG5MJca0ockxHrbq5vjdk5ONgfHRHE6DYu+ylOmEPqJqcTXKim1XxHUS87T4PpFPoAvfsC2ZcDalXhSkD0DbFOAQkD6yrpShjgtRtorfZnMBvqPJAVYufCGjG1aMuOYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829099; c=relaxed/simple;
	bh=j4OpgDqOYjScj46Ux3yDW53tOB72oKczatvyEPIw1jo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qwKAYIJ2cgqgikv514SJBZyHAfetwoypaRlcU1eE8Ui4CfbhiLJkyx8iDqjURLARxPJcnSoT+MCS2fDeaXahx5FsCI/nXmgxSRvJYfwpa//w1KVol4uKMev39nSyrCKOZRtrql1/1KZ4OYsVj2aeKBsV+Leoec1gZQ5MWV3ctzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0uZ1n1tX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0uZ1n1tX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 462CC1F00893;
	Sun,  7 Jun 2026 10:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829098;
	bh=mvP99nVX3kqVW8FC1q2LN/BUFFtzsCWh/NQp/QQuPag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0uZ1n1tXdSMbJAUF66wJWUAUazOhvJ/5i8T7xSW2heQQCPPJtkY5p7uoUs6j8glaW
	 90k3NMgKGNyL9fhf5+aQM/7KC4LhmcXHzOOgUBA38rF3fFokQOohzx4zzfItRMChDP
	 KNzhdb3x94g1Qb+3a1pEyvHR0VICoIHDl4gw92zU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 6.18 217/315] comedi: comedi_test: fix check for valid scan_begin_src in waveform_ai_cmdtest()
Date: Sun,  7 Jun 2026 12:00:04 +0200
Message-ID: <20260607095735.543633307@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Ian Abbott <abbotti@mev.co.uk>

commit 542f5248cb481073203e0dadab5bcbd28aeae308 upstream.

Commit 783ddaebd397 ("staging: comedi: comedi_test: support
scan_begin_src == TRIG_FOLLOW") neglected to add a test that
`scan_begin_src` has only one bit set.  The allowed values are
`TRIG_FOLLOW` and `TRIG_TIMER`, but the code incorrectly also allows
`TRIG_FOLLOW | TRIG_TIMER`.  Add a call to
`comedi_check_trigger_is_unique()` to check that only one trigger source
bit is set.

Fixes: 783ddaebd397 ("staging: comedi: comedi_test: support scan_begin_src == TRIG_FOLLOW")
Cc: stable <stable@kernel.org>
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20260422162138.36003-1-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/comedi/drivers/comedi_test.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/comedi/drivers/comedi_test.c
+++ b/drivers/comedi/drivers/comedi_test.c
@@ -274,6 +274,7 @@ static int waveform_ai_cmdtest(struct co
 	/* Step 2a : make sure trigger sources are unique */
 
 	err |= comedi_check_trigger_is_unique(cmd->convert_src);
+	err |= comedi_check_trigger_is_unique(cmd->scan_begin_src);
 	err |= comedi_check_trigger_is_unique(cmd->stop_src);
 
 	/* Step 2b : and mutually compatible */


