Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A2628DBA
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KKJcTV2H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3C7C433C9;
	Mon, 16 Oct 2023 14:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697468007;
	bh=AsgX9uviDWVHczM8NppvEPOpv9cpzQK5bMc5YqBAytg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KKJcTV2HhS+cHYH0yKma0XfOq7CkrZ2JogyN5wJW56NcUOkKngItrJX4nzO7I6aN6
	 z8AU61ubijCSiHBsVTcdEe7BG0JDFOhmAJgcbFVZ3rLgGQXC37lD92mixr7FpZJlz7
	 8aPEQMf9/gqIHntVrB4AZM+8j3je9Kdp5aQVJHFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Luz <luzmaximilian@gmail.com>,
	stable <stable@kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.5 133/191] serial: core: Fix checks for tx runtime PM state
Date: Mon, 16 Oct 2023 10:41:58 +0200
Message-ID: <20231016084018.496334320@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Lindgren <tony@atomide.com>

commit 81a61051e0ce5fd7e09225c0d5985da08c7954a7 upstream.

Maximilian reported that surface_serial_hub serdev tx does not work during
system suspend. During system suspend, runtime PM gets disabled in
__device_suspend_late(), and tx is unable to wake-up the serial core port
device that we use to check if tx is safe to start. Johan summarized the
regression noting that serdev tx no longer always works as earlier when the
serdev device is runtime PM active.

The serdev device and the serial core controller devices are siblings of
the serial port hardware device. The runtime PM usage count from serdev
device does not propagate to the serial core device siblings, it only
propagates to the parent.

In addition to the tx issue for suspend, testing for the serial core port
device can cause an unnecessary delay in enabling tx while waiting for the
serial core port device to wake-up. The serial core port device wake-up is
only needed to flush pending tx when the serial port hardware device was
in runtime PM suspended state.

To fix the regression, we need to check the runtime PM state of the parent
serial port hardware device for tx instead of the serial core port device.

As the serial port device drivers may or may not implement runtime PM, we
need to also add a check for pm_runtime_enabled().

Reported-by: Maximilian Luz <luzmaximilian@gmail.com>
Cc: stable <stable@kernel.org>
Fixes: 84a9582fd203 ("serial: core: Start managing serial controllers to enable runtime PM")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Tested-by: Maximilian Luz <luzmaximilian@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20231005075644.25936-1-tony@atomide.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -157,7 +157,7 @@ static void __uart_start(struct tty_stru
 	 * enabled, serial_port_runtime_resume() calls start_tx() again
 	 * after enabling the device.
 	 */
-	if (pm_runtime_active(&port_dev->dev))
+	if (!pm_runtime_enabled(port->dev) || pm_runtime_active(port->dev))
 		port->ops->start_tx(port);
 	pm_runtime_mark_last_busy(&port_dev->dev);
 	pm_runtime_put_autosuspend(&port_dev->dev);


