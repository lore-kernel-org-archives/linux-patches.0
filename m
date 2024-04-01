Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF741E86C;
	Mon,  1 Apr 2024 16:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989125; cv=none; b=qBnKNh15Aoxk20QK17rkoZlCMBmkHlCPU5uAxjZGPc7ypbv+RTS37LxNZpKUtIpJaseaQoXivw7x8nYmtZSJE75ACMutK7RG9NnChwgCTErhFlNzUhbBsWO82ofgzseCXczX/iqcBiLv8LmGzh5uj8Rbi/euey04+v6FlkfBkls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989125; c=relaxed/simple;
	bh=I6A9Ra4VquZ75zF+/IHSbbg6mHgCpUTE+YmebGYZaZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KxaV/bf6f9wK9IPvU/QTbhqSfHeiaixu1iABAGtfNIoowtsyypAZa26fGel+REuGnWX8hWGX8q/Jg/tr5waN8JzskEhHXqmeEy1+iH1/UiZY6ygt32wo2S+kz8nrbeLNM+p65/jsU7ctH86hxa7UMQACRTX5uezzdeb8/BOuWoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JqNdDSvK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JqNdDSvK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58928C433F1;
	Mon,  1 Apr 2024 16:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989125;
	bh=I6A9Ra4VquZ75zF+/IHSbbg6mHgCpUTE+YmebGYZaZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JqNdDSvKZ6t735Url0wZb50nzDBBMlaCzPxq+1pZ3g70i8TCPDFV511QTwaqJKphu
	 yRQbHRP7wbZ7GKsTkClvmYWLWOPgb//ho9VjdaRAfDDeJmbTDpFGBFFJx6cu5+ywjS
	 Dde9HTiHdMnEkG1QNTXbgpiagTlFd3mHGfH8v5Fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6.7 381/432] usb: cdc-wdm: close race between read and workqueue
Date: Mon,  1 Apr 2024 17:46:08 +0200
Message-ID: <20240401152604.662674303@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

commit 339f83612f3a569b194680768b22bf113c26a29d upstream.

wdm_read() cannot race with itself. However, in
service_outstanding_interrupt() it can race with the
workqueue, which can be triggered by error handling.

Hence we need to make sure that the WDM_RESPONDING
flag is not just only set but tested.

Fixes: afba937e540c9 ("USB: CDC WDM driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20240314115132.3907-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-wdm.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -485,6 +485,7 @@ out_free_mem:
 static int service_outstanding_interrupt(struct wdm_device *desc)
 {
 	int rv = 0;
+	int used;
 
 	/* submit read urb only if the device is waiting for it */
 	if (!desc->resp_count || !--desc->resp_count)
@@ -499,7 +500,10 @@ static int service_outstanding_interrupt
 		goto out;
 	}
 
-	set_bit(WDM_RESPONDING, &desc->flags);
+	used = test_and_set_bit(WDM_RESPONDING, &desc->flags);
+	if (used)
+		goto out;
+
 	spin_unlock_irq(&desc->iuspin);
 	rv = usb_submit_urb(desc->response, GFP_KERNEL);
 	spin_lock_irq(&desc->iuspin);


