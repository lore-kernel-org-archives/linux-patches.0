Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799C62C0261;
	Tue, 16 Jun 2026 18:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635731; cv=none; b=Tx/SzmwAAt7e1pHkw+YMqUUxj6Rj9uowvQiWl9qO0+2M7eK9Joj8owG2T8R7AHaJdHHhMX08OA8e2j8VVbEeFhD9Fxn/PJKvH5YQ6ZpPhV97nhYjtMJx3IxindAp818ZDMq+HFVruvnVBVysrTvos7NoqBA4ZFW1p4qAbg5NI7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635731; c=relaxed/simple;
	bh=crZ0mmcoYgiTunMpDmt2ofXGkmefg20KA1+yhlCXorI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TUvj8c0Wtggob9v5yvePpViSmgh3CSXUsKYDKei53uMqiOyhTSRmEYQmG0v9hB2P4Aq0D4qgtW5mK1XxQVE3Sgj2Cg1hMfndw1U6MGyh2pr/l6M3KNGpehtPSFK+nGLTug/sIB0LYQ8ACe8LTzmsYY2mDdnPp5YEI8sPY7wV1AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b7uU3r16; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b7uU3r16"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537F01F000E9;
	Tue, 16 Jun 2026 18:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635730;
	bh=LTse0El9Jvjsj/LZn4c+INuiS+R/LO3mscT66VGMKRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b7uU3r16oiPy+NkPEJHiaXz5olri84G5iLvzoFxjtno3eqHdiimH4TDBHbbScJ9QS
	 1omjnJMZXLNfohwwiuBJ0umdBd3HwU6RwlHa0v+85JjMXnAn9d67rPKPGEUJtEw78f
	 RQkEjYUds828VEB9WHtv1axNAEizYaJqhNoIVrsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 5.10 087/342] comedi: comedi_test: fix check for valid scan_begin_src in waveform_ai_cmdtest()
Date: Tue, 16 Jun 2026 20:26:23 +0530
Message-ID: <20260616145052.297381429@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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
---
 drivers/staging/comedi/drivers/comedi_test.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/comedi/drivers/comedi_test.c
+++ b/drivers/staging/comedi/drivers/comedi_test.c
@@ -273,6 +273,7 @@ static int waveform_ai_cmdtest(struct co
 	/* Step 2a : make sure trigger sources are unique */
 
 	err |= comedi_check_trigger_is_unique(cmd->convert_src);
+	err |= comedi_check_trigger_is_unique(cmd->scan_begin_src);
 	err |= comedi_check_trigger_is_unique(cmd->stop_src);
 
 	/* Step 2b : and mutually compatible */


