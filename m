Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829203;
	b=j0+1CntKi4Pqhln2sLVs12NHBOtmW6W81iLydmPrX5/WTRtu+NOR4STCV08wuhrIHRwS
	 7nP2whTESJwyiyaV7spiYWHh2RXbJ2tB3PQoLnPFy8z60ITJs92QXIsWCUXBYC4QyMMow
	 qj2W/r5ZSKPdN2urUbfiD7CnANP3SibXuFyh17LCsvpTYrtfhxY3k6X+6mb112WjSHPjI
	 KOYR6QriMGpeAy0YYr06IiTVGPq0UWNmf9UkO9ZYzbT3fZUzzca7pOSnYLd5k4ySQuDk4
	 EFg/kgWkady+PtDE2C8FYGn1yRz7eUPr9LYv5FyQq5p3zMbshoKj/6nwPVm98fRioGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829203;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a+ZtQAV2tCczniWbf87UpoZ643FKThODf7clQOEkZeo=;
	b=L/6uowVZBwfyJn/7jsPsz/dZvCoRb00wOevqkOrz/JOwai7x4ACVTGk0KyZNFHiFPFQo
	 VO12NFLFcTMm5WuJVSmuNf2G0ZtgQgWi94CWeNq2AxGMlO4emJucHId3QhaRCoZLYrAcF
	 s9Viv8M20Wd30zb9iaQqXQ3A6J2LIhu6GwB9rUDqSfmiKLrt8FUdxbDsDav5ElY+r4ixl
	 hFOWxA0GOhvRdNMJnJDYUXCKCVY+0Y4KCH1LziEQ0OeTY5pqtkPZZM1PHLMlTNPgM+bpc
	 z8xYukjpGUiD374dduDgdkgJiBeJNo2BcGS9DtPY2b0pc174B1SV6qvtMNx37GsgSlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AZ2pv7B9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F884607030E;
	Wed,  4 Nov 2026 21:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AZ2pv7B9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F2D61F000C1;
	Wed,  4 Nov 2026 21:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829203;
	bh=a+ZtQAV2tCczniWbf87UpoZ643FKThODf7clQOEkZeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AZ2pv7B9MNnjFE0kyZpwyrQ6BxhtpZQxbuLbxqTc8knE7zEgaEUPMWhs47o7Px/6P
	 0vfUpDeCbhbgS5uX67msDFhCVlTLMes8H0XDT8cCF1t1mIQkv5W3u8OuTpRxcjl5Kz
	 XqX5ov/7dpc2V8tSzLsJXeq8wzlREFg5j1CVGeto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Derek J. Clark" <derekjohn.clark@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.3 511/547] HID: hid-lenovo-go-s: Bound stale reply window before reusing send_cmd_complete
Date: Wed,  4 Nov 2026 16:11:35 -0500
Message-ID: <20261104211052.908262112@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Derek J. Clark <derekjohn.clark@gmail.com>

commit 6224755416e627badf69b330afec9ac6b85e5098 upstream.

mcu_property_out() reinits send_cmd_complete immediately after a
timeout is detected, before the next command that reuses it is sent.
If the MCU's reply to the timed-out command arrives after this reinit
but before the next command's wait begins, it silently satisfies the
next, unrelated command's wait instead of the one it actually answers,
handing that caller stale data with no way to detect the mismatch.

Track when a command has timed out via cmd_orphaned. Before the next
command reuses the completion, wait a bounded 25ms for a stale reply
to arrive and be consumed, then unconditionally clear the flag and
reinit the completion. This does not fully eliminate the window in
which an unrelated reply could still be received, but bounds it to
a short interval right before a new command is sent. Behavior matches
the solution to the same problem in hid-msi.

Fixes: a23f3497bf208c59ad ("HID: hid-lenovo-go-s: Add Lenovo Legion Go S Series HID Driver")
Cc: stable@vger.kernel.org
Signed-off-by: Derek J. Clark <derekjohn.clark@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-lenovo-go-s.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/drivers/hid/hid-lenovo-go-s.c
+++ b/drivers/hid/hid-lenovo-go-s.c
@@ -37,6 +37,7 @@ static struct hid_gos_cfg {
 	struct completion send_cmd_complete;
 	struct led_classdev *led_cdev;
 	struct hid_device *hdev;
+	bool orphan_ack_pending;
 	struct mutex cfg_mutex; /*ensure single synchronous output report*/
 	bool gp_registered;
 	bool rgb_registered;
@@ -456,6 +457,19 @@ static int mcu_property_out(struct hid_d
 		return -EINVAL;
 
 	guard(mutex)(&drvdata.cfg_mutex);
+
+	/*
+	 * A reply to the previous command may still be in flight. Give it a
+	 * short window to arrive and be consumed before this call reinits the
+	 * completion, so a late reply can't be mistaken for this command's.
+	 */
+	if (drvdata.orphan_ack_pending) {
+		wait_for_completion_timeout(&drvdata.send_cmd_complete, msecs_to_jiffies(25));
+		drvdata.orphan_ack_pending = false;
+		drvdata.cmd_status = -ETIMEDOUT;
+	}
+	reinit_completion(&drvdata.send_cmd_complete);
+
 	/* We can't use a devm_alloc reusable buffer without side effects during suspend */
 	dmabuf = kzalloc(GO_S_PACKET_SIZE, GFP_KERNEL);
 	if (!dmabuf)
@@ -481,7 +495,9 @@ static int mcu_property_out(struct hid_d
 							msecs_to_jiffies(timeout));
 	ret = ret > 0 ? drvdata.cmd_status : ret ?: -EBUSY;
 
-	reinit_completion(&drvdata.send_cmd_complete);
+	if (ret)
+		drvdata.orphan_ack_pending = true;
+
 	return ret;
 }
 


