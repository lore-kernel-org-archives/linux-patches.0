Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56CB23911A9;
	Sat, 17 Oct 2026 17:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256766; cv=none; b=EJJ2aePyisyfOcLksCG+SgzsDaq9/2ugtY0oy5Hmi9GbffW392vcZSbphID5iWbNu5ovlSSSAnC6Or65yAKJv7u1zake7oTejjTwCJpVypXb+T3O5O878qKbM54lhTLr6KxiC56KqxK6Cz8J/jJcRQUSFdH9NtgMzQ+JxNxU+WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256766; c=relaxed/simple;
	bh=yC3Ubce2WwaZLWvnhJk78dzC1seAQNgDSk/dzBrwMhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EgZDEMKKanGZzv2TWfXOdJLaWofOptWRNc0vd0wCFl3i32OkMP0EwCuEwIJWDlSvq4RzD9cefIE1kWRlx/oJwUSUb/t4FZqGmPOk8KKcBfQn0P0shaIOHVMHVvOD/oVlHfwTsbtqG3F5tqFKI+u9SolCdhMT1j18d7sOY3iQOP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hGxUp5k5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hGxUp5k5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0095F1F000C4;
	Sat, 17 Oct 2026 17:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256764;
	bh=8ImTcgHJeJV8jwt/joz4fKQ6bEMmXxBkIqd+dzxOT3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hGxUp5k5fglujONg10kWPxFjxFFm15yGhR4fZmy0SRuQqpJ6Q0VIYSQtT0lxp0Zfo
	 /9Kk0eHzXo0+QiKNkKA78S0GfrrLkJaj4yoyswg7/zzgsotRa/8ug1GC+emObHs2NF
	 MsSCtF51cT1mIDfrPr2lDO45sbbc6tbcXH0j89nE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI review <sashiko-bot@kernel.org>,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0302/1674] HID: multitouch: stop the release timer from being rearmed on remove
Date: Sat, 17 Oct 2026 17:42:54 +0200
Message-ID: <20261017160438.871477794@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

[ Upstream commit 5acb2dace582f061aab5e14c399ac9480315f44b ]

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
[ sashal: Adapted the patch to replace del_timer_sync() instead of timer_delete_sync(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 4481bf5c9133d..422172ecf2bb2 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1895,7 +1895,7 @@ static void mt_remove(struct hid_device *hdev)
 {
 	struct mt_device *td = hid_get_drvdata(hdev);
 
-	del_timer_sync(&td->release_timer);
+	timer_shutdown_sync(&td->release_timer);
 
 	sysfs_remove_group(&hdev->dev.kobj, &mt_attribute_group);
 	hid_hw_stop(hdev);
-- 
2.53.0



