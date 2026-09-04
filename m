Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6AF7401A25;
	Fri,  4 Sep 2026 05:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501525; cv=none; b=dl6omiUpwfmyjf2o7sHqDpbZrVwhNq8RfqbMsbgZfQm8geypIQxaqI424A1v3Wfo3Syn8FsIBUdwGSltsTEG/t07Y+dW0z9pdT1PkBX8yVfm+or1WF5zcjRUsXJsSh9dCWyainQGnmAXZBh9KAcDlPy+ELvgK/KpMktxxGxGOHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501525; c=relaxed/simple;
	bh=m7O7ZWGgkqdM4QcHESWRL5YxNSUQWrqK0vPkm0gRZY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tKctZbkLDaaBknn4AXcf0fmMQQrvj8amWv7cYGgYhXwoSj9OXDBlZrleQgAHrg9zWH9C/w6yDkA6b+29c9NL5bFIQy5+RbCJwkxre1X+c7gEvzn49bLf4Sl7xceJg0MeJNC0mQC/gZ0VR4IpIbls5EcTlEa713PHoPKSbBbi6vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vwuu1Rq5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vwuu1Rq5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 426A11F00A3D;
	Fri,  4 Sep 2026 05:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501523;
	bh=Ls9xnsCXj8ZYSd8gS2ZuugfegBBricKbOPvr7TInf9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vwuu1Rq534Y7xQ+1mpRwpXVqAsSM0p/vGgnIiUzXLAkuAJxyIsGolRIx65+2UG6Dd
	 Ky5cdzw01GyK/vl6sPKo3lmlxyv9/ELPAxeV+OmIQrnuhqzgV/46h766jTmANEKAqh
	 1ibbT/18iGWQCpkfyeTwTvnO1vGM06qS96Fie/0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.18 438/552] platform/x86: hp-bioscfg: fix heap OOB read on empty password write
Date: Fri,  4 Sep 2026 06:59:55 +0200
Message-ID: <20260904045800.523189781@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Bilal <meatuni001@gmail.com>

commit 2b2ec354f905c14e3270e8ec3ab50f7d8ad73bab upstream.

validate_password_input() computes length = strlen(buf) and then
checks buf[length - 1] to strip a trailing newline, without checking
that length is nonzero first. Writing an empty string (a bare '\n')
to current_password or new_password gives length == 0, and
buf[length - 1] reads buf[-1], one byte before the heap allocation
holding the copied input.

KASAN confirms this directly:

  BUG: KASAN: slab-out-of-bounds in store_password_instance.constprop.0+0x223/0x2a0 [hp_bioscfg]
  Read of size 1 at addr ffff88811bd8da9f by task sh/13740
  ...
  store_password_instance.constprop.0+0x223/0x2a0 [hp_bioscfg]
  current_password_store+0x14/0x20 [hp_bioscfg]
  ...
  The buggy address is located 23 bytes to the right of
  allocated 8-byte region [ffff88811bd8da80, ffff88811bd8da88)

Reproduced identically via new_password_store. Execution continues
past the bad read (the garbage byte only affects whether "length" is
decremented by one), so the write completes and returns success; this
is a pure information read past the buffer, not a crash, but it is
still an out-of-bounds access KASAN correctly flags.

Fix by only checking buf[length - 1] when length is nonzero.

Fixes: 8646a3b5ee3a ("platform/x86: hp-bioscfg: passwdobj-attributes")
Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://patch.msgid.link/20260812111829.172273-4-meatuni001@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c
@@ -66,7 +66,7 @@ static int validate_password_input(int i
 	struct password_data *password_data = &bioscfg_drv.password_data[instance_id];
 
 	length = strlen(buf);
-	if (buf[length - 1] == '\n')
+	if (length > 0 && buf[length - 1] == '\n')
 		length--;
 
 	if (length > MAX_PASSWD_SIZE)


