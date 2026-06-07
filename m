Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0802D8378;
	Sun,  7 Jun 2026 10:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829288; cv=none; b=dDA6oIIvwRq+t1B6wjDY7/Bhx6uhUcN7GkuKtc6OBM2AlO1ijV9eS4UApjsDqjsgFo3olWQWXWPia39oCrw4JIlzcstVI8nW0goyGZggRkA9hvhqCY2i5rnMbC52GzVPcHH7CF7F4dKT4ZXknBnjj9SBTi6oHZ+z5oCB03AosOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829288; c=relaxed/simple;
	bh=+2+S0O5MnTD9qqCf4qimSrznS3JYdxLz+qzd9gVveds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SipfeGfa+BJz5a1Lwe8fWNWgPKdwZ2Im04iW0zXz+EeLcu9/7HEdqvI4w/40MPJ5tjtKOGkTtXovnQJIzrJR/hvn9QEg3y3Yso7he2FRjRqavvnLeVyVaUsdW3qD4lB6IFkV7ScC3QKgSFMxEuTJYipWyPFWe+uDoV+Qgus6vLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IrV3XcXB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IrV3XcXB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A4E1F00893;
	Sun,  7 Jun 2026 10:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829287;
	bh=vhChUoGk5c+UgBLNFtuJOAM/HnwMPR0iaAISGCnSrwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IrV3XcXBgPsfmFfzqFmPwCLrajLpWODhURWS8G8Wz7vLe9CNUZAsglhouNhbQM5KD
	 u9imeqwp4wJ52QVyQ+AHzp0Au1hpTZYhr4Qnm192vjtmzYvJw3YvBiMAHLrdgZPN/T
	 Klgsebimfh8lur/xGYb6qJbNaJauMcAiF4UNmncw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 6.12 211/307] comedi: comedi_test: Fix limiting of convert_arg in waveform_ai_cmdtest()
Date: Sun,  7 Jun 2026 12:00:08 +0200
Message-ID: <20260607095735.466927678@linuxfoundation.org>
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
@@ -324,10 +324,10 @@ static int waveform_ai_cmdtest(struct co
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


