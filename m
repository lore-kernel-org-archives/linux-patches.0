Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5920146C850;
	Fri,  9 Oct 2026 14:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555526; cv=none; b=kZq1Hl9sBTSbk8k6+T0dlmhmGpRPKutDwCPOmRRFkYsjwkZMsgw2ZgNvYKKw3ifbLH3aEGkifApqvQjqHK8A3PI9m//JzzyCAXoJp5an91fewXGjWNizV/IPoi5PKN2HCyIPTtIGKBjnkQu6octbX/0bpv5Z1S2i43YTjSnvaiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555526; c=relaxed/simple;
	bh=9Xs33AaS2jlgs0Tl4hGKtoCQqVnf/FcxLLp9CVS8tG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mcNukMNqbX+OkzhYpLwh4P/9wQYQHZGvS4lXiMFbp5pTcS15SZVGzgZz6++jOGGxu1sDwjVHIKnPk97sxnsdinR8iOxiS/HhJEsbT6gQCSuJn4HiAkDTNJweIEOGI+fzGXcmLPayIeVRy95/rVtDn9BssEEUHP5VTZ0SVoIJroY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gHk1jmbQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gHk1jmbQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4CBE1F000FF;
	Fri,  9 Oct 2026 14:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555525;
	bh=jJLpgOQvW+uYOT6ohxrVRXl7NO6mOiSNpjAKLC4pZn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gHk1jmbQjqwKoG9/PS2y0ABhw9slf0Ve6yaZnCikPsFWFJK2C/C+CXYzjr9xIwhl/
	 R5phxqVZ/kSXFg/BJAq86VkhZyHuTpz4EeE8yDJQu2+X5K9bX/OhN6d67Yt/G6So2Y
	 +HLdZ3CphIE/lx3DLEnboYPwTiOETgTrjKLW1P/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI review <sashiko-bot@kernel.org>,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 7.2 023/428] HID: multitouch: stop the release timer from being rearmed on remove
Date: Fri,  9 Oct 2026 16:06:00 +0200
Message-ID: <20261009140946.571670667@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

commit 5acb2dace582f061aab5e14c399ac9480315f44b upstream.

mt_remove() quiesces the sticky-finger timer before stopping the
hardware:

    timer_delete_sync(&td->release_timer);

    sysfs_remove_group(&hdev->dev.kobj, &mt_attribute_group);
    hid_hw_stop(hdev);

timer_delete_sync() waits for a running callback and dequeues the timer,
but it does not stop the timer from being armed again. The transport is
still delivering reports at that point, and the report path rearms it:

    if (app->quirks & MT_QUIRK_STICKY_FINGERS) {
        if (td->mt_io_flags & MT_IO_SLOTS_MASK)
            mod_timer(&td->release_timer,
                      jiffies + msecs_to_jiffies(100));

A report that arrives after timer_delete_sync() has returned therefore
leaves the timer queued. td is allocated with devm_kzalloc() against
hdev->dev, so it is freed when the driver is unbound, after mt_remove()
returns. When the timer fires afterwards, mt_expired_timeout()
dereferences the freed td:

    struct mt_device *td = timer_container_of(td, t, release_timer);
    struct hid_device *hdev = td->hdev;

    if (test_and_set_bit_lock(MT_IO_FLAGS_RUNNING, &td->mt_io_flags))

Simply moving the teardown after hid_hw_stop() does not fix this on its
own, because mt_expired_timeout() calls mt_release_contacts(), which
walks hdev->inputs; the timer still has to be quiesced before
hid_hw_stop() tears the input devices down.

Use timer_shutdown_sync() instead, which additionally makes any later
mod_timer() a no-op, so neither ordering constraint has to be traded off
against the other. This is the final-teardown pattern the function was
introduced for, and hid-wiimote already uses it for the same reason.

Fixes: 4f4001bc76fd ("HID: multitouch: fix rare Win 8 cases when the touch up event gets missing")
Cc: stable@vger.kernel.org
Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260723224211.613112-1-you@example.com?part=1
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Reviewed-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-multitouch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -2260,7 +2260,7 @@ static void mt_remove(struct hid_device
 {
 	struct mt_device *td = hid_get_drvdata(hdev);
 
-	timer_delete_sync(&td->release_timer);
+	timer_shutdown_sync(&td->release_timer);
 
 	sysfs_remove_group(&hdev->dev.kobj, &mt_attribute_group);
 	hid_hw_stop(hdev);


