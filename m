Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9455D4502F;
	Tue, 16 Jun 2026 16:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628855; cv=none; b=Ennh5o6MNE9PjXafDwOhA0KYiFilugzotTH0gff9joNfAUThRELw/3lKIx74j5hcazQX1Wo76mCo435QwUvniWecRm8dWgbkOf8gEPpkhNcRZYQ2BiC0/M92QRw09Cx4H9HrWCUgnqejvgICR5BcM5gQ9RrI7SWU0VdL1hsQbKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628855; c=relaxed/simple;
	bh=MA1IaZ3JyaeIIIslq9f5/OzfhGNyeoVvdFhW+2JgMis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gvEp+X/cREdNz2w4D1/xgmP/yjPoTB9jUqg4X30UqsGUeg6F4JKwW2vBJupnvVSvYGRLjEe8W31Pv/0vsVgPLHnif3lhJXXQ2MZU6UHvv29CdTYyO0PzNWgtJZcI3Zv/FMzlNKVv4bajONTXLZrNONBGbSlXFHIfe0WWposQ188=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vZapU1vI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vZapU1vI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933C71F000E9;
	Tue, 16 Jun 2026 16:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628854;
	bh=b3BnC4FV6iEb70NIFESc2sKaPEO1uy1BNiBMF9vtafo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vZapU1vIwjsmBFfAcx0MCI8LR+507xD0R/2adCD2he3JTJ8xUZosvEbMj8msc5B01
	 Beg+kg8da066BT/Je8b/RbfBuLAp76HVvdT17D6+v9/45NfYZ+1btgFQwOv+4jWefq
	 1D9lzgyJtWkDNNzWsfSRBGzBTY6nci1G+XsWOdFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 6.6 147/452] comedi: comedi_test: fix check for valid scan_begin_src in waveform_ai_cmdtest()
Date: Tue, 16 Jun 2026 20:26:14 +0530
Message-ID: <20260616145125.423477479@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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
@@ -273,6 +273,7 @@ static int waveform_ai_cmdtest(struct co
 	/* Step 2a : make sure trigger sources are unique */
 
 	err |= comedi_check_trigger_is_unique(cmd->convert_src);
+	err |= comedi_check_trigger_is_unique(cmd->scan_begin_src);
 	err |= comedi_check_trigger_is_unique(cmd->stop_src);
 
 	/* Step 2b : and mutually compatible */


