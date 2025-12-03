Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BFF30C63C;
	Wed,  3 Dec 2025 15:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764775949; cv=none; b=fR2sbYe52xxVQwk+3oZol9btvrrULEheV9kcUFaAlidUZhDhFXhNKyfGYL7HNV7aixyKlDa+rnXB5pUvVKRruHwhAlzHrWDph01j9qdea9UdXdagtZKvjsj94jaXPqFMvogoRc5XnzIP4aUJm8ZpUCnFViF2jYVJ1wpcyBkUiwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764775949; c=relaxed/simple;
	bh=fAGQXlmpLWqb5ZqqQI1XfT9e6TxiBJ2UUooE3ApT9/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fPknsFOZ9Zvtd8AeYQ4ukdlXh3LFM595sqPA32eyxmCGbEEjJSXNn5kPsCmkoWrsBfeapJOufHM4oMW4cTYk6lDsiJkgGTQDdzwDIbsh13VaFTWCep1BRI67DqVpmT4XzG41/8zHqGFzzbdEsNmqNSv4ZjKxyz4sEb8Fe2cn6yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V6NxolbZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V6NxolbZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 172C7C4CEF5;
	Wed,  3 Dec 2025 15:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764775948;
	bh=fAGQXlmpLWqb5ZqqQI1XfT9e6TxiBJ2UUooE3ApT9/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V6NxolbZWFe0ZH1iaAYAXLeN+5ze3vgRcY5K5z5pDd5Q2FdcwAMYJ8Waf1MUW/QFy
	 GLVbdP8gOXirz65L5V+QbYhiaEeqk+o98N3mpZcK+JShoNiXwWyUEZgdeXqmhsNY/x
	 FRIWtM1Il7BcRkCudeFMIvUU/+NjelcmdK6VX8ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Owen Gu <guhuinan@xiaomi.com>
Subject: [PATCH 5.10 036/300] usb: gadget: f_fs: Fix epfile null pointer access after ep enable.
Date: Wed,  3 Dec 2025 16:24:00 +0100
Message-ID: <20251203152401.805094251@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

From: Owen Gu <guhuinan@xiaomi.com>

commit cfd6f1a7b42f62523c96d9703ef32b0dbc495ba4 upstream.

A race condition occurs when ffs_func_eps_enable() runs concurrently
with ffs_data_reset(). The ffs_data_clear() called in ffs_data_reset()
sets ffs->epfiles to NULL before resetting ffs->eps_count to 0, leading
to a NULL pointer dereference when accessing epfile->ep in
ffs_func_eps_enable() after successful usb_ep_enable().

The ffs->epfiles pointer is set to NULL in both ffs_data_clear() and
ffs_data_close() functions, and its modification is protected by the
spinlock ffs->eps_lock. And the whole ffs_func_eps_enable() function
is also protected by ffs->eps_lock.

Thus, add NULL pointer handling for ffs->epfiles in the
ffs_func_eps_enable() function to fix issues

Signed-off-by: Owen Gu <guhuinan@xiaomi.com>
Link: https://lore.kernel.org/r/20250915092907.17802-1-guhuinan@xiaomi.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_fs.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1993,7 +1993,12 @@ static int ffs_func_eps_enable(struct ff
 	ep = func->eps;
 	epfile = ffs->epfiles;
 	count = ffs->eps_count;
-	while(count--) {
+	if (!epfile) {
+		ret = -ENOMEM;
+		goto done;
+	}
+
+	while (count--) {
 		ep->ep->driver_data = ep;
 
 		ret = config_ep_by_speed(func->gadget, &func->function, ep->ep);
@@ -2017,6 +2022,7 @@ static int ffs_func_eps_enable(struct ff
 	}
 
 	wake_up_interruptible(&ffs->wait);
+done:
 	spin_unlock_irqrestore(&func->ffs->eps_lock, flags);
 
 	return ret;


