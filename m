Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6D44F6477;
	Tue, 13 Oct 2026 12:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895159; cv=none; b=lbgFAYZ+tOol5MbwWpAK4TaW57jrXx7XSSUMwD/rURy6qQsEaBMh7tNZUVjkwsCgnauqNI91Qij0At/d1qSkYAAu6EavxnGJueHOhY2wFSbquPqTqsXf/1ck1mwpGGDqWzczFCHKJjSwTqCR9MSavB1/cXvt000H0PCnsLCloNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895159; c=relaxed/simple;
	bh=SBDT8fqAZ7iRQ5bQKaSZLhYVhw5H7nRw4dFxVSMugSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JJVCu+giNPcOutHWy7eR6wdFwvX49W+x3Vl7FJ9QZGU6gjns7dQFbKCZLDFkk8lSxrBmwggkZrQyAAm/2WZcaCL0CD2CAEgMCf32gej5WW7PylaiozgT62JoMwe+VMbEzXs8qiSbJ8TXw0h/DJS3eCNT98X6ZiVWfH4nCJXFp8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yRgEeEdE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yRgEeEdE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F8571F000FF;
	Tue, 13 Oct 2026 12:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895158;
	bh=qzj0V2zzJjBETd9jcLKC4mJiHN/cJPhdKyslccH0WJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yRgEeEdEz/t2AfbwakOmnLZQZdpPCr1J2BNSiDKrhN1wkjNK1fjkKcuiezn7R+lxF
	 g/O1YqyXi0ZHStlixRknoigkenil2UcXHJM2gXXpxmd93kZjk8OQUC3fzKoV67rNjM
	 GU1QpXl5oIfqUfWEj6HoBDhZ9qZQ5LKNH6q+dd7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Fluhr <mathieu.fluhr@gmail.com>,
	stable <stable@kernel.org>,
	Lovekesh Solanki <lovekeshsolanki00@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.12 137/497] usb: hub: use shorter 120ms post resume hold for SS root hubs
Date: Tue, 13 Oct 2026 13:35:04 +0200
Message-ID: <20261013112911.142062982@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Lovekesh Solanki <lovekeshsolanki00@gmail.com>

commit 29480b05e6e226594dc11ccf2a036fbd5cdd0e42 upstream.

Holding a USB3 hub PM runtime reference for 200ms at hub resume triggers
an AMD platform issue.  Users running Android adb report crashes after
adb has been polling and waking up the USB subsystem once a second for
some time.  Vendors are working on a solution.  Disabling USB runtime PM
is one way to prevent this issue, but it is also proven that reducing the
hold time to 120ms in resume also mitigates it.  See Link for more
details.

Reducing the hold time to 120ms for the USB3 roothub is in itself a valid
change and optimization, as the current 200ms is excessive: a root hub
has no upstream suspended hub whose wake propagation needs to be
accounted for, but still need some time for USB3 link training to
complete.

Keep the 200ms hold for external hubs that commit 8f5b7e2bec1c
("usb: hub: fix detection of high tier USB3 devices behind suspended
hubs") is intended for.

Reported-by: Mathieu Fluhr <mathieu.fluhr@gmail.com>
Link: https://lore.kernel.org/all/CAPyJwA_D9qw0T72f8zwM1yKjP+To=maVANbcdsWM7yRmbBxYvw@mail.gmail.com/
Cc: stable <stable@kernel.org>
Fixes: 8f5b7e2bec1c ("usb: hub: fix detection of high tier USB3 devices behind suspended hubs")
Signed-off-by: Lovekesh Solanki <lovekeshsolanki00@gmail.com>
Acked-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20260903112903.542719-1-lovekeshsolanki00@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -70,8 +70,11 @@
 /*
  * Give SS hubs 200ms time after wake to train downstream links before
  * assuming no port activity and allowing hub to runtime suspend back.
+ * Root hubs have no upstream hub whose wake propagation needs to be
+ * accounted for, so they need less time, use 120ms for them.
  */
 #define USB_SS_PORT_U0_WAKE_TIME	200  /* ms */
+#define USB_SS_RH_PORT_U0_WAKE_TIME     120 /* ms */
 
 /* Protect struct usb_device->state and ->children members
  * Note: Both are also protected by ->dev.sem, except that ->state can
@@ -1361,7 +1364,9 @@ static void hub_activate(struct usb_hub
 
 		queue_delayed_work(system_power_efficient_wq,
 				   &hub->post_resume_work,
-				   msecs_to_jiffies(USB_SS_PORT_U0_WAKE_TIME));
+				   msecs_to_jiffies(hdev->parent ?
+				USB_SS_PORT_U0_WAKE_TIME :
+				USB_SS_RH_PORT_U0_WAKE_TIME));
 		return;
 	}
 


