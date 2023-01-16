Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6433A33EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:55:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2C19C433F0;
	Mon, 16 Jan 2023 15:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884545;
	bh=HxKMzrnBDY66TgaxR8FfWS1jCkIPGJDjvdE8uCHtZU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UTj1QkcWZ0otNUGxiO7FwnkYTkI2kCewU1oNg4tv3lmQeQNTg8h8Wp7N9HhMCN/0I
	 jSfPb1t7W2DlW7rSXWz1kdpKIEjkKPM7F5Z2KeFPnW7PgskKNeXG0hWLB1b6/FLKZv
	 PqiuHAeSuIWg3ju47UVpb9Tp35TA+1ixr6097FqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Luz <luzmaximilian@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.1 047/183] platform/surface: aggregator: Ignore command messages not intended for us
Date: Mon, 16 Jan 2023 16:49:30 +0100
Message-Id: <20230116154805.353986057@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maximilian Luz <luzmaximilian@gmail.com>

commit ae0fa0a3126a86c801c3220fcd8eefe03aa39f3e upstream.

It is possible that we (the host/kernel driver) receive command messages
that are not intended for us. Ignore those for now.

The whole story is a bit more complicated: It is possible to enable
debug output on SAM, which is sent via SSH command messages. By default
this output is sent to a debug connector, with its own target ID
(TID=0x03). It is possible to override the target of the debug output
and set it to the host/kernel driver. This, however, does not change the
original target ID of the message. Meaning, we receive messages with
TID=0x03 (debug) but expect to only receive messages with TID=0x00
(host).

The problem is that the different target ID also comes with a different
scope of request IDs. In particular, these do not follow the standard
event rules (i.e. do not fall into a set of small reserved values).
Therefore, current message handling interprets them as responses to
pending requests and tries to match them up via the request ID. However,
these debug output messages are not in fact responses, and therefore
this will at best fail to find the request and at worst pass on the
wrong data as response for a request.

Therefore ignore any command messages not intended for us (host) for
now. We can implement support for the debug messages once we have a
better understanding of them.

Note that this may also provide a bit more stability and avoid some
driver confusion in case any other targets want to talk to us in the
future, since we don't yet know what to do with those as well. A warning
for the dropped messages should suffice for now and also give us a
chance of discovering new targets if they come along without any
potential for bugs/instabilities.

Fixes: c167b9c7e3d6 ("platform/surface: Add Surface Aggregator subsystem")
Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
Link: https://lore.kernel.org/r/20221202223327.690880-2-luzmaximilian@gmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/surface/aggregator/ssh_request_layer.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/platform/surface/aggregator/ssh_request_layer.c
+++ b/drivers/platform/surface/aggregator/ssh_request_layer.c
@@ -916,6 +916,20 @@ static void ssh_rtl_rx_command(struct ss
 	if (sshp_parse_command(dev, data, &command, &command_data))
 		return;
 
+	/*
+	 * Check if the message was intended for us. If not, drop it.
+	 *
+	 * Note: We will need to change this to handle debug messages. On newer
+	 * generation devices, these seem to be sent to tid_out=0x03. We as
+	 * host can still receive them as they can be forwarded via an override
+	 * option on SAM, but doing so does not change tid_out=0x00.
+	 */
+	if (command->tid_out != 0x00) {
+		rtl_warn(rtl, "rtl: dropping message not intended for us (tid = %#04x)\n",
+			 command->tid_out);
+		return;
+	}
+
 	if (ssh_rqid_is_event(get_unaligned_le16(&command->rqid)))
 		ssh_rtl_rx_event(rtl, command, &command_data);
 	else


