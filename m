Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED0E15C127;
	Mon, 12 Aug 2024 16:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480530; cv=none; b=GqyqStwkhdFDrMZzoc/ulqO0yPE43eCus01Am+mxQeMOnOEQKfkmtA3Dm2Ko2HUrRfayBF3w64mfFS+qNJ2YFuPWl/VZ+1wLQP9U12bWW7csBVXT2VqNQlKsuE15rOJlLW8bQoJPH+yr05/XF6PYSCfUgyXNYERdSUtFXmlqiQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480530; c=relaxed/simple;
	bh=iwxnfjzbni3EY0bouXKtXgeWr1Es91F2DMK7UxmbFo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ga+xYDD9C8DN5azEtd4GXneh+vGgkm7Tg40twT9mAKtjEeXWmpqbdnWMzWz3sTf1nE8wpCdKg7ps7RvlLEdlzm+vo6INqG6QP06sY1QIon5zxeF4BroHnl28pAjaealzLBWo6EVTH/C7oU4DQTwzhiQidIwcPSn0Z6sTeDyYSNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J0uQzXZ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J0uQzXZ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E805C32782;
	Mon, 12 Aug 2024 16:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480529;
	bh=iwxnfjzbni3EY0bouXKtXgeWr1Es91F2DMK7UxmbFo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J0uQzXZ5+aTLr0SvQRXQeWsp8WDob06+wE5s8sQd6oL7rmP8QA38tErk45/QL7PbE
	 K9IhUf4+UHZv9PFpY+5R5ft8gQgnC8ri8bAJvkK5Iek16BdBtimm2DH2TNGOrrSl+V
	 ZiutlW/8pyvJcD40hI0A4I4O33gIAtX7QolqI7po=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	William McVicker <willmcvicker@google.com>,
	Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: [PATCH 6.10 192/263] usb: gadget: f_fs: restore ffs_func_disable() functionality
Date: Mon, 12 Aug 2024 18:03:13 +0200
Message-ID: <20240812160153.894877059@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tudor Ambarus <tudor.ambarus@linaro.org>

commit 382b6eabb0316b7334d97afbdcf33a4e20b0ecd8 upstream.

The blamed commit made ffs_func_disable() always return -EINVAL as the
method calls ffs_func_set_alt() with the ``alt`` argument being
``(unsigned)-1``, which is always greater than MAX_ALT_SETTINGS.
Use the MAX_ALT_SETTINGS check just in the f->set_alt() code path,
f->disable() doesn't care about the ``alt`` parameter.

Make a surgical fix, but really the f->disable() code shall be pulled
out from ffs_func_set_alt(), the code will become clearer. A patch will
follow.

Note that ffs_func_disable() always returning -EINVAL made pixel6 crash
on USB disconnect.

Fixes: 2f550553e23c ("usb: gadget: f_fs: Add the missing get_alt callback")
Cc: stable <stable@kernel.org>
Reported-by: William McVicker <willmcvicker@google.com>
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Link: https://lore.kernel.org/r/20240802140428.2000312-2-tudor.ambarus@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_fs.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -3731,10 +3731,10 @@ static int ffs_func_set_alt(struct usb_f
 	struct ffs_data *ffs = func->ffs;
 	int ret = 0, intf;
 
-	if (alt > MAX_ALT_SETTINGS)
-		return -EINVAL;
-
 	if (alt != (unsigned)-1) {
+		if (alt > MAX_ALT_SETTINGS)
+			return -EINVAL;
+
 		intf = ffs_func_revmap_intf(func, interface);
 		if (intf < 0)
 			return intf;


