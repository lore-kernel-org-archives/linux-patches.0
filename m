Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C0C146D7E;
	Thu, 13 Jun 2024 11:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279732; cv=none; b=a9yr1Nr2AutavZ7nYvWZKPwjzrOhL+YmYfA/PNXrszvRdcsRyMrUPTqpfHWgy1kAsNeplJ4T+Ie8H84daUFDeFFVwRHb0LY958wB9RiulfKz+zyCOQX1FDXqJSuHOzaisbmk5vKSYjfs91VX6gV+Bx0drAYA3In1IZdrhqf+huo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279732; c=relaxed/simple;
	bh=ffTcdqgLz7rpvb4pWZSzDnlBrJ8VmWAoI5knQZGo+S4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQuaPw+R9adeshuBBvKZrMwRc4L3v+kxcy/own7qEIjS6sND9adKatXCMsDcTsEqM08PZMEgBJQOVrTdlO6yYb6d35hHBoomRyXzthe/imIIQ7wjbm0fq9cSQ36ZNtdW2pHLrxBiP0bnBhlwNcXua1wRHkxD8icRGL2g9kl4ESs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=09MXqJVy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="09MXqJVy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3F33C2BBFC;
	Thu, 13 Jun 2024 11:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279732;
	bh=ffTcdqgLz7rpvb4pWZSzDnlBrJ8VmWAoI5knQZGo+S4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=09MXqJVydN5bss9k7I2Z66FLzQblhNUefJUcNpwBmg/wTqfI3SXbwku8w/8UyKhLF
	 8s6Qr3IUMDE7zeYi+iRod4nN226+clpdm/781ubRP2uXqVLtcu34+IvgP2SKrQ5SlB
	 uiDd0hdJ4gUHXzlKZJw8+Rsqz2zn5cudSOimipvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	j51569436@gmail.com,
	Daniel Starke <daniel.starke@siemens.com>
Subject: [PATCH 5.4 002/202] tty: n_gsm: fix possible out-of-bounds in gsm0_receive()
Date: Thu, 13 Jun 2024 13:31:40 +0200
Message-ID: <20240613113227.857556048@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Starke <daniel.starke@siemens.com>

commit 47388e807f85948eefc403a8a5fdc5b406a65d5a upstream.

Assuming the following:
- side A configures the n_gsm in basic option mode
- side B sends the header of a basic option mode frame with data length 1
- side A switches to advanced option mode
- side B sends 2 data bytes which exceeds gsm->len
  Reason: gsm->len is not used in advanced option mode.
- side A switches to basic option mode
- side B keeps sending until gsm0_receive() writes past gsm->buf
  Reason: Neither gsm->state nor gsm->len have been reset after
  reconfiguration.

Fix this by changing gsm->count to gsm->len comparison from equal to less
than. Also add upper limit checks against the constant MAX_MRU in
gsm0_receive() and gsm1_receive() to harden against memory corruption of
gsm->len and gsm->mru.

All other checks remain as we still need to limit the data according to the
user configuration and actual payload size.

Reported-by: j51569436@gmail.com
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218708
Tested-by: j51569436@gmail.com
Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20240424054842.7741-1-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_gsm.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1974,8 +1974,12 @@ static void gsm0_receive(struct gsm_mux
 		break;
 	case GSM_DATA:		/* Data */
 		gsm->buf[gsm->count++] = c;
-		if (gsm->count == gsm->len)
+		if (gsm->count >= MAX_MRU) {
+			gsm->bad_size++;
+			gsm->state = GSM_SEARCH;
+		} else if (gsm->count >= gsm->len) {
 			gsm->state = GSM_FCS;
+		}
 		break;
 	case GSM_FCS:		/* FCS follows the packet */
 		gsm->received_fcs = c;
@@ -2055,7 +2059,7 @@ static void gsm1_receive(struct gsm_mux
 		gsm->state = GSM_DATA;
 		break;
 	case GSM_DATA:		/* Data */
-		if (gsm->count > gsm->mru) {	/* Allow one for the FCS */
+		if (gsm->count > gsm->mru || gsm->count > MAX_MRU) {	/* Allow one for the FCS */
 			gsm->state = GSM_OVERRUN;
 			gsm->bad_size++;
 		} else


