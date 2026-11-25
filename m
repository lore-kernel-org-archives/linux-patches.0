Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623110;
	b=adrCoS7BcsuoyYrAqcLxMJvOWQ4N4WAGPxegaWxe6HwJzYhCwhP4oxtrV6DiZdQ/6WMl
	 wt8d8usBHeIQPF74MawnH56n1cyggRkisOl0TwNeN/3UUe7CbRJEqpTMGNob8mrc7iQ+5
	 4B5c24h1rEaeUmzC5ndDBpQZvcxymXrq52OJLn4ZbYFTCurc1kPKRilBQkuyLu95w+KXP
	 MbVNbqo8AfTc1jxx8IvqB421mgWEdJveiIEZoLxC0eP19uGek8Rg9IOqYOfsJq5otlMYK
	 Cd+gtG/RFl2o4k702I5i+oCg9v9qjGiN7LJUBACF+ep0ZITACOs9n1TlyHKqE2fYXaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623110;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aqisfYTJw4WNbU7dB221oH0P7TRI/ztOAP5T+qFnBPA=;
	b=A06pml+hCjMXAP/7Qb9CwXdTzVaMN9oZP2DXTlAYRAzXX/Lzvwn+I+VrOv7xFIgN0oOL
	 kqH9BjC5RlX/Vpj9BndfZRgIb9eExlklLJ1JVStKoE7r8fo5TTD8i9Im6ZMpaFEO9jyrU
	 acXliH1RRspIx4HACLN2hvvEv5VBBOVQWYP8uNZPVCWHD+5htOT5ScKzmrs3rLqesiL/+
	 q+rOuJSvGTUIIE/V171hLer4Wogp3qhVoHwoq0wb/WwjW6gKhBEMpvc14obxBkPDRd+94
	 RiUnuCLM9Ukhaf8mggpqFEB+wP0s4lWnetorwnvHeYr3p3qp6Sq857BV7HA8IrcB4NA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=INGmsQeb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3580606A327;
	Wed, 25 Nov 2026 16:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=INGmsQeb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F81E1F000C4;
	Wed, 25 Nov 2026 16:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623110;
	bh=aqisfYTJw4WNbU7dB221oH0P7TRI/ztOAP5T+qFnBPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=INGmsQebx3UbA8LHST8Hz0536hPwuviemHmBGRPeSh1xi8ENKwzW7JKsBubNaTLBe
	 jAdR1osBRGaJ8j3KYYP5wI1x7d9sVRnV0dcwHSQyWa0QH1rqL5+zpOAZdpUXaZha1C
	 S39qF4xI+enattLGIHAZoKuzF0f/sVHVPQJ0w0A4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Norris <briannorris@chromium.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.18 737/990] PM: runtime: Update last_busy in rpm_resume() for active devices
Date: Wed, 25 Nov 2026 15:35:04 +0100
Message-ID: <20261125143839.330914760@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 55b2b8af704f845e01fa2f31ee259b07641ce3a9 upstream.

Setting an autosuspend delay for a device can be expected to cause a
runtime suspend of the device after calling, say, pm_runtime_put() to
be deferred, so the time between the last successful attempt to resume
the device and its subsequent suspend is at least equal to the
autosuspend delay.

However, that expectation is only met after the device has been actually
resumed in rpm_resume() by invoking its runtime resume callback.  If the
runtime PM status of the device is already "active" when rpm_resume()
runs for it, the device's last_busy timestamp is not updated which may
allow a subsequent pm_runtime_put() invocation (or similar) to suspend
it right away.

This is arguably inconsistent and confusing, so make rpm_resume() also
update the device's last_busy timestamp when it finds that the device is
already "active" and it is about to return 1 early.

Fixes: 56f487c78015 ("PM / Runtime: Update last_busy in rpm_resume")
Link: https://lore.kernel.org/linux-pm/CAJZ5v0jTX1FgeS9FCV=+V4uacSgLQBVsSPnU27ybgUGg57GUOA@mail.gmail.com/
Reported-by: Brian Norris <briannorris@chromium.org>
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Reviewed-by: Brian Norris <briannorris@chromium.org>
Tested-by: Brian Norris <briannorris@chromium.org>
Link: https://patch.msgid.link/13032301.O9o76ZdvQC@rafael.j.wysocki
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/power/runtime.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -822,6 +822,12 @@ static int rpm_resume(struct device *dev
 		pm_runtime_deactivate_timer(dev);
 
 	if (dev->power.runtime_status == RPM_ACTIVE) {
+		/*
+		 * The attempt to resume the device means that it is needed for
+		 * something, so update its last_busy timestamp as in the case
+		 * in which it actually resumes below.
+		 */
+		pm_runtime_mark_last_busy(dev);
 		retval = 1;
 		goto out;
 	}


