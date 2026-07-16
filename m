Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50D93F7A83;
	Thu, 16 Jul 2026 13:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209663; cv=none; b=swBSRVhdSWH85ebtKHvKHegwUZhL25BtYmaU079IknrfFS58RsBeT1dgf6e78xg0BvPM2mw9U51xJqzNnNFpuByNatbXoCuc4VTVQ2TOjxr1QYAHOB2jGGt2KEWwE7unABozvup7kl6MXNafpsrKakXZtc3KrtaPIjVO3OxBB1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209663; c=relaxed/simple;
	bh=YHPrauyST4WqL5Vh3By2nStPL688bFvIo3M40BqrSlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DLBLm26LheZkWklfVqwl8DoR73KqoUvxdkJ56Q3shgPmUjChzxa8CaRIgm41bSVUHGjZVLJHcgevlMtDmJKfLwGO3CVkkw7ssOuhJp+6YhNs8UZPfDiFHlBjF3WuUP1zfOpp/I8a56eGwprKI8NOXPdlc16L/wYG6N5fYyFVM44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xokfQhN8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xokfQhN8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 849EC1F00AC4;
	Thu, 16 Jul 2026 13:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209655;
	bh=KPf+C5ljpq9jmLwe4hUJaFkQbnvm3IreyXQzYwQAdVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xokfQhN85weUxOgqjFtAcCPK31cPX0YJ+aLjfIlOFacq5dE5wASU4McSVis3Dvxb6
	 NBeNOClrtb/pyqpFmsWJypRonb6XUy4fjfXGYfTcjReojfl2hmCD5UTTu1+Yf9BKF6
	 FMaBuUjkK9PsisgAAxKR6TDUfUpeboPleu9PJQlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manish Khadka <maskmemanish@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.1 269/518] HID: hid-lenovo-go: cancel cfg_setup work in hid_go_cfg_remove()
Date: Thu, 16 Jul 2026 15:28:57 +0200
Message-ID: <20260716133053.702711624@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manish Khadka <maskmemanish@gmail.com>

commit 73fde0cbff7d9d618591774a12c23434232752c1 upstream.

hid_go_cfg_probe() initialises drvdata.go_cfg_setup and schedules it
to run 2 ms later:

    INIT_DELAYED_WORK(&drvdata.go_cfg_setup, &cfg_setup);
    schedule_delayed_work(&drvdata.go_cfg_setup, msecs_to_jiffies(2));

cfg_setup() dereferences drvdata.hdev to issue MCU command requests.
hid_go_cfg_remove() tears down sysfs and stops the HID device, but
never drains the delayed work.  If the device is unbound within the
2 ms scheduling delay (a probe failure rolling back via remove, or a
fast rmmod after probe), the work fires after hid_destroy_device()
has dropped its reference and released the underlying hdev struct,
leaving cfg_setup() with a stale drvdata.hdev pointer.

Mirror the sibling driver hid-lenovo-go-s.c, whose hid_gos_cfg_remove()
already calls cancel_delayed_work_sync() on its analogous work, and
drain go_cfg_setup at the top of hid_go_cfg_remove().  The cancel
must come before guard(mutex)(&drvdata.cfg_mutex) because cfg_setup()
acquires that mutex; reversing the order would deadlock.

Fixes: d69ccfcbc955 ("HID: hid-lenovo-go: Add Lenovo Legion Go Series HID Driver")
Cc: stable@vger.kernel.org
Signed-off-by: Manish Khadka <maskmemanish@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-lenovo-go.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/hid/hid-lenovo-go.c
+++ b/drivers/hid/hid-lenovo-go.c
@@ -2405,6 +2405,15 @@ static int hid_go_cfg_probe(struct hid_d
 
 static void hid_go_cfg_remove(struct hid_device *hdev)
 {
+	/*
+	 * cfg_setup is scheduled from hid_go_cfg_probe() with a 2 ms delay
+	 * and dereferences drvdata.hdev.  Drain it here before tearing
+	 * down so the workqueue cannot run after hid_destroy_device()'s
+	 * put_device() has released the underlying hdev and dereference
+	 * a stale drvdata.hdev pointer.
+	 */
+	cancel_delayed_work_sync(&drvdata.go_cfg_setup);
+
 	guard(mutex)(&drvdata.cfg_mutex);
 	sysfs_remove_groups(&hdev->dev.kobj, top_level_attr_groups);
 	hid_hw_close(hdev);


