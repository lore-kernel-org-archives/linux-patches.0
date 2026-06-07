Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9622D8378;
	Sun,  7 Jun 2026 10:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829277; cv=none; b=r4zbJPqe2/1x12MWh47cje/VbITrnSknD+Fxn7gNcGBJrkQSp5JO2bVucgg7t/epDSNyk7XVv6Zs7p05oDqUNOzXhPtLWfNM19r8w8u1nyN9mXq2/IjE1Z1QNhXaH/zrHDHidMjFjCdbAg6ywMBJUUnTJAvWotiuCPAFzKOZWNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829277; c=relaxed/simple;
	bh=B4mZ2Kqh0C6eg+G66E6Q1nytG34kMvyj0W1frrT8Cuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lnIbnaszenK2q7S9RpfdLXbnVuOK3tP2/xa/ba31unLb9I1OYJgsRkwo/QcxakQEOYfplK3tpmuuYC2av958Sjf9m0E9PzWLN/Yb2tauoYBllyhPXYERbB5mMq9wF0Fdspjmgiu22Uk2uoyIgqz1RQItTq2/D+5vPKZolcsDjhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yXM/ocfy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yXM/ocfy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F941F00893;
	Sun,  7 Jun 2026 10:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829276;
	bh=4mYMaK7aB9+sjBvdlcsq/maPRJbqhN1tFFIOflQDT94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yXM/ocfykLAQbEHvz2/w+i42gvFaDHOSzL/aoEtXR80PGWW0N9PKsjNtNWoh4moEQ
	 Oltd7q05Rf/XQi1aPQi5bEy+XLavuLhjRnml4ucov1zT9KkRMNDlOUbiGeq0yihbH5
	 iFo4bxZzdKBseULT9VBCwj0mQsIhrTAVQeOSuUTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 6.12 210/307] comedi: comedi_test: fix check for valid scan_begin_src in waveform_ai_cmdtest()
Date: Sun,  7 Jun 2026 12:00:07 +0200
Message-ID: <20260607095735.429822124@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


