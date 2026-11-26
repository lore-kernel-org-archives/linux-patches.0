Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705455;
	b=VTe/E7uoToJ27kBKbvfNjOI+F/mBYMz/uc/hgg27dqCa64EemdWmtMKiU3NtbCYi6epO
	 bjImu9PzpYNiVMaUh0PadWrGn14fhanOB8FVl86PGgslwJ2cs/6xuSzuthDomzoH9B4pY
	 86PDjqb0FwRYMMGwdSU6ShT2o4bTA61x0Mu37rSz4/W4sdKJNaZtUYQlj7h5SVdFit0WI
	 +MvpZ5SYt9JbDkjmu7ZuwenHoqNZP9hkR3m24AWui4SBcchAfPAvDLRKl+DVGz4Gra0lm
	 5QSKNFAj7+xPXjs44xQfZW0QlqyVBL/qxMZzdlHog2r2qjlitrMa0lfI94v56mje1gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705455;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OdzjgUq2ZGammE58uYcRYckmitEw7v9aiWMCG3ON9ys=;
	b=ypmxrv2ppvBflmibG4GTGJ9/yinmbWbzES9EyIrsufu6EyXXjO9A7kueL3bvAToJrEKY
	 I+296msltkRU8+BTlggog1WioMqDBslIY+7OBM8YwIjv2czslkRij8UkuP9tuqrT1+Abf
	 xasO2yLU3NB+vxaJcTd3CiLvNHt/DqKMlwvux3cC23Y1umH2aQ/ikgIFkiHLWIXCviRk1
	 y73zkakISdLO8YGEPthGiTcHn7VZ4XKM2SSWEI5I0iicqJaXt2jThpCPa3vtAd8arPsQP
	 dQuTz/eoL2ZuZa8Z1lJnbAk8p6VUCELmKQi9MuRUEe2PCP2tNx7A6IsCK/WrVjSrq7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E6d+6BMV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B572606A31C;
	Thu, 26 Nov 2026 15:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E6d+6BMV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A5C1F000F4;
	Thu, 26 Nov 2026 15:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705454;
	bh=OdzjgUq2ZGammE58uYcRYckmitEw7v9aiWMCG3ON9ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E6d+6BMVJA+bbGR1ZHdqp6PKtVtI1uNbuUnGlmKlqTKImpelRxho8c8ZkcADcYjOT
	 LM9dI9BmFVV1eoFqKj9BSb1UX5X/choBuCEulqQLQH18EpcUbh/DIvEitqM2MCjuG7
	 cD15upmR59vV1BCmh43knMLOOKep2XURr3CNAAVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Norris <briannorris@chromium.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.15 203/319] PM: runtime: Update last_busy in rpm_resume() for active devices
Date: Thu, 26 Nov 2026 15:39:31 +0100
Message-ID: <20261126144011.326479330@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -791,6 +791,12 @@ static int rpm_resume(struct device *dev
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


