Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D49E8476
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:54:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F38AC433D2;
	Tue, 28 Mar 2023 14:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015241;
	bh=Jv4CbOcyhvGdX6l/WfwMoIKeOceYc/RF2tBccbRgETo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qbtzmwyW2g//ObNEhK3hrAhY9DyCXvJGa5I2qV6+tFIy4mV5e42wPZnjj1EAlj1Wi
	 1TaJFRBvpc/Kn0bJ6Vsr18crh1QJif8IvhkK0L0OUEybaqcCPW78sEDBZYyiakBtxn
	 /zXagGbdecxqqRQ5FaS50BfDnn1LKdKQ2zO7GcDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.2 200/240] usb: ucsi_acpi: Increase the command completion timeout
Date: Tue, 28 Mar 2023 16:42:43 +0200
Message-Id: <20230328142627.990664417@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hdegoede@redhat.com>

commit 02d210f434249a7edbc160969b75df030dc6934d upstream.

Commit 130a96d698d7 ("usb: typec: ucsi: acpi: Increase command
completion timeout value") increased the timeout from 5 seconds
to 60 seconds due to issues related to alternate mode discovery.

After the alternate mode discovery switch to polled mode
the timeout was reduced, but instead of being set back to
5 seconds it was reduced to 1 second.

This is causing problems when using a Lenovo ThinkPad X1 yoga gen7
connected over Type-C to a LG 27UL850-W (charging DP over Type-C).

When the monitor is already connected at boot the following error
is logged: "PPM init failed (-110)", /sys/class/typec is empty and
on unplugging the NULL pointer deref fixed earlier in this series
happens.

When the monitor is connected after boot the following error
is logged instead: "GET_CONNECTOR_STATUS failed (-110)".

Setting the timeout back to 5 seconds fixes both cases.

Fixes: e08065069fc7 ("usb: typec: ucsi: acpi: Reduce the command completion timeout")
Cc: stable@vger.kernel.org
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20230308154244.722337-4-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi_acpi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/typec/ucsi/ucsi_acpi.c
+++ b/drivers/usb/typec/ucsi/ucsi_acpi.c
@@ -78,7 +78,7 @@ static int ucsi_acpi_sync_write(struct u
 	if (ret)
 		goto out_clear_bit;
 
-	if (!wait_for_completion_timeout(&ua->complete, HZ))
+	if (!wait_for_completion_timeout(&ua->complete, 5 * HZ))
 		ret = -ETIMEDOUT;
 
 out_clear_bit:


