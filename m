Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8FC1C75F9;
	Sat, 12 Sep 2026 13:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220768; cv=none; b=QtRRC/r0Y+xu3zOkyo6MeUVoDQjGixu/mt8+YbpLnJXjNY4t/v04f27KSA2+lzSofDboaahlgsiaqD/klWogub0idkuYDgDlIte0L9br7WaPsxb4c7+b+rYtJ6DRhGk/Ngfb9fJ82F3InUd04KmRm0NB3xzUKYkiDVT016OwgF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220768; c=relaxed/simple;
	bh=b2JjpdJxAWLKFwch2qCv6J8x0ndrlHb83eesLkkJ66M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SJWyBLf93tQXJbHHAjqC6NNY+vQE8vlVIDhOLQRHkEuwYLm90mV7sEUDN5LhWyDE9t/ytSJ8SMlj10VRnUhjhe1WQOkrOa6Bw9fZvMAtXUWXvbRnx4mO2YipDabyxGYUtAm/gELE8puotwX9mTmVJLmYSVN1uL5BCja3WHhS7dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DIs/l5Vj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DIs/l5Vj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646071F000FF;
	Sat, 12 Sep 2026 13:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220767;
	bh=xRhZRPvlb4oz3q5o7UJpwRZYD04wLCoTyRtF/ZdFLkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DIs/l5Vje97Oa85k43HSXnY952DXa5A6MYpZRrkjnJf0AcmhMANh3TAvY7yWdDKIg
	 rUsu7pmd93BjfutNQqibENlPvTi+tdfFPCyDGnb/koa6ZyrEpBXMeDBt3q683oYLDr
	 OZkEO2dtngS23A8nbDq/uecwIwgR7Vt+MD8gdUEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.6 0244/1424] platform/x86: hp-bioscfg: fix heap OOB read on empty password write
Date: Sat, 12 Sep 2026 08:44:36 +0200
Message-ID: <20260912065612.745527074@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -67,7 +67,7 @@ static int validate_password_input(int i
 	struct password_data *password_data = &bioscfg_drv.password_data[instance_id];
 
 	length = strlen(buf);
-	if (buf[length - 1] == '\n')
+	if (length > 0 && buf[length - 1] == '\n')
 		length--;
 
 	if (length > MAX_PASSWD_SIZE)


