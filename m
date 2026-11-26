Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704564;
	b=Ow1In81LS70kKubYImx9grko+m2gG/njClg2rt7ksxYq69RX9GJHEjeRo/HL3zeCrQtI
	 /+/xdFMQ5IHIQ4AGG+bWRpNtzT3PQ12AHO04d/P/pZWlJmubW2Vnpm1PZ6Q4YEidlYTbH
	 24DRxrs1L+y1ywZrnSwhqQxcMScSdbDGMBF+Hzmo/tfS25RHp0l3ANReVKvcbIKKwbsQG
	 ZhIHklxrR9wXJbr65sI36Z1zhFbg4Z8yb7Tn0W8bTNtdOpgPmnApCFyg0alVyz+l9S2MM
	 FIidtrgP7MXbMDps7cfy8sDm96YsSt5r1dZXlzkcB5+B//rCyI6QRroS7vVPQVdoWCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704564;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3KKy07UIbERZzGNrxQyx816+ExyAOjemnaVcZRJuGdo=;
	b=zhLVgwqP40AfzID/ejQolnvSFmUXb/EZh4wzy91lpWjY+b6yEpUYchx1sDzAfvROyO2E
	 fhBXlCJ5/wQDk7MOPyNGgfsAGa66L9jr//XJxC5LWBKMBKH8RaS7gfpYg0CKMBNZpnkEl
	 BaO+gsfYAmA0mzPJUPwSB+iJ5yK5JnGvIYM9poGY9Q+RAk4GandOaMeGdvt+ypwGG1ZpQ
	 p3nBPD0OCpCOFgmsAGakijXMhhaOqf6qAPXc2u+4Fbs8iFfjydp8Dk9NAZpRuUI21bm3w
	 R0bRFs43ysLw2bhbs3YsWc2wviF4AbYgRQAkJ/zPt0Jm21wV9plylrhs7OdnD6WkJ7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MEXOUNbN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D2A606A326;
	Thu, 26 Nov 2026 14:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MEXOUNbN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0901F000CA;
	Thu, 26 Nov 2026 14:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704563;
	bh=3KKy07UIbERZzGNrxQyx816+ExyAOjemnaVcZRJuGdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MEXOUNbNlicO8/IltFF0OzqLVmQ5uyu437gmSL9oLR+6EzTX80dv3gWxU+yg7/K5W
	 Mag+6yWW3gXwp4ConuIVWhf9ti8cVR7wvZjIIR+hRtFwUkdVvxFnog3ngv4Pvua+h3
	 7795/lL2ES16va/NIp4ByJoQWahlj7RgTQR1HeXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Norris <briannorris@chromium.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.10 168/265] PM: runtime: Update last_busy in rpm_resume() for active devices
Date: Thu, 26 Nov 2026 15:38:18 +0100
Message-ID: <20261126143616.914685431@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -793,6 +793,12 @@ static int rpm_resume(struct device *dev
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


