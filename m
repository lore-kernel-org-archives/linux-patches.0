Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86BD5A59;
	Sun,  7 Jun 2026 10:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829114; cv=none; b=e/G3bi7lUTGRYccYQwYqJ8BNge/nC56wofEpAQqlQUJtfPmpH4/0lj6ubuzoy64/XrfmF7+mK0kxeYNO1U49fYuoSHA68DWJkWTCOu4VnNXGhXCioaNtud0PjVwzFN4Z0x7b58Vdqkd9KtwEIiSJFTChiEzctNU65++vD6yHALs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829114; c=relaxed/simple;
	bh=Hr8HIK4tlFx2OYVp4fkAm/iuW9Njc3/N3BsyGQVbVNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fhrCDlLQtJB1kPWjEMFQA2cGYjHMToJ++ZATWZC1/XiGFvAgd9BwTzLKwyH0+yYQuinPXFr44Mbk2uweyV/zBCv1g8F0QHliHf1Chz+rGeIVp7ybkwgOlWGZg0GoOjh9za3Ad/728Cw+OeFShJe75Ui5tcmTTcumS9jsUI5Kg68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d4JkChic; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d4JkChic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E1E1F00893;
	Sun,  7 Jun 2026 10:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829113;
	bh=uSPGb8bCgyPbzO13W4mY4EYPx/isG09+1coiYHoFcJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d4JkChicSU3X1SRpqG1Ks9h/5UUlHOkEOJ/1odwtgqHGa2b3ARTxp4I6oo1XxrvvL
	 4DXUXweRBCx5NAG/IF1r7dPbZOqiOqYY1JWbhFCWKS7hqnB7iiKXvEz9cofVp9iTSD
	 MEq3tjGWOB2jteaYXY51c5ABvaKfmUzErd4s2LLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 6.18 218/315] comedi: comedi_test: Fix limiting of convert_arg in waveform_ai_cmdtest()
Date: Sun,  7 Jun 2026 12:00:05 +0200
Message-ID: <20260607095735.583551579@linuxfoundation.org>
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

commit 8a3bee801d420be8a7a0bae4a26547b353b8fe22 upstream.

The function checks and possibly modifies the description of an
asynchronous command to be run on the analog input subdevice of a comedi
device attached to the "comedi_test" driver, returning 0 if no
modifications were required, or a positive value that indicates which
step of the checking process it failed on.  Step 4 fixes up various
argument values for various trigger sources.

There are two bugs in the fixing up of the `convert_arg` value to keep
the `scan_begin_arg` value within the range of `unsigned int` when
`scan_begin_src` and `convert_src` both have the value `TRIG_TIMER`,
which indicates that the corresponding `_arg` values hold a time period
in nanoseconds.  The code also uses `scan_end_arg` which hold the number
of "conversions" within each "scan".  The goal is to end up with the
scan period being less than or equal to the convert period multiplied by
the number of conversions per scan.  It intends to do that by clamping
the `convert_arg` value to a maximum value of `UINT_MAX / scan_end_arg`
rounded down to a multiple of 1000 (`NSEC_PER_USEC`).

(The rounding from nanoseconds to microseconds is because the driver is
modelling a device that uses a 1 MHz clock for timing.  This is partly
because that is a more typical timing base for real hardware devices
driven by comedi, and partly because the driver used to use `struct
timeval` internally.)

The first bug is that the code checks if `scan_begin_arg == TRIG_TIMER`
when it should be checking if `scan_begin_src == TRIG_TIMER`.  The
bugged check will always fail because if `scan_begin_src == TRIG_TIMER`,
then `scan_begin_arg` will be at least 1000 (`NSEC_PER_USEC`), otherwise
`scan_begin_src == TRIG_FOLLOW` and `scan_begin_arg` will be 0.  (N.B
`TRIG_TIMER` is defined as `0x10`.)  The second bug is that is rounding
the maximum value down to a multiple of 1000000000 (`NSEC_PER_SEC`)
instead of 1000 (`NSEC_PER_USEC`), however this bug is not reached due
to the first bug.  This patch fixes both bugs.

Fixes: 783ddaebd397 ("staging: comedi: comedi_test: support scan_begin_src == TRIG_FOLLOW")
Fixes: 5afdcad2f818 ("staging: comedi: comedi_test: limit maximum convert_arg")
Cc: stable <stable@kernel.org>
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20260422144637.27692-1-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/comedi/drivers/comedi_test.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/comedi/drivers/comedi_test.c
+++ b/drivers/comedi/drivers/comedi_test.c
@@ -325,10 +325,10 @@ static int waveform_ai_cmdtest(struct co
 		arg = min(arg,
 			  rounddown(UINT_MAX, (unsigned int)NSEC_PER_USEC));
 		arg = NSEC_PER_USEC * DIV_ROUND_CLOSEST(arg, NSEC_PER_USEC);
-		if (cmd->scan_begin_arg == TRIG_TIMER) {
+		if (cmd->scan_begin_src == TRIG_TIMER) {
 			/* limit convert_arg to keep scan_begin_arg in range */
 			limit = UINT_MAX / cmd->scan_end_arg;
-			limit = rounddown(limit, (unsigned int)NSEC_PER_SEC);
+			limit = rounddown(limit, (unsigned int)NSEC_PER_USEC);
 			arg = min(arg, limit);
 		}
 		err |= comedi_check_trigger_arg_is(&cmd->convert_arg, arg);


