Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623769;
	b=XmMmZUdxpnb++mpQ4nNEjUrcdPJcdXWJuY0Dg3JJFl1LdkZ+GW1zmfGsvNuFuUnVOaSm
	 lkFb562MO9y4E9ZDXwqdZaVDnYnW+4UHd2Bv1mvGfCRvs11YcS676dlrKUrJZ6KBcRGvc
	 kTTRXZBwbiHxN6icRXiJXabN73J6E245X6rnCB8NyTGWjIFOfUfwKKXg5PUzbHG6IJ2OB
	 ciChgEYKNyk6yPCanRISJne6acmNg1uReau/1NfNrsy+hZgiJZWh1J81X79bevQYmap2y
	 OZJ0hHFFEL+9R6phtNHVEiKFoFWplEdSwjyX9d8LPNt1thf2zXNxCXrkokjw5T/ZdEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623769;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9WBQpVQC/bELDlswi3JxKWsNWvwAelJajccj14N91+8=;
	b=Vk1RKdfobpeJ0iXjhNgyVLe5osXqJPzQH+7dAFN7CesfbfqYWjcdMrbLjnKCVlz/yMAU
	 5bek482k/+RwVsHGQ2fcjjSQdGt1mX2DFK0aJLC+o8R2hOM4tdjzCD8qKKmOFrFTiPwwU
	 0QUbTcy2pe55romI1Jw81DQy3Df0Gs02sGSYHIv1q2eAxUVwCD09vbiA89Tm4VgrCfHmJ
	 4TgTM+tWYif6fJyba3NirulPVgkE7jOxc3lfzMJKUufAD3adMZdpB9/QI7Djo40aTdjyI
	 UGJ94B37x5c4lwKdZuh5+Um2J6w8wV0HUIxJnN0gpiHaM0av8C7JbQE1e3O3amm6F/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f9NOAgIU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE2B606A321;
	Wed, 25 Nov 2026 16:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f9NOAgIU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFB861F000C4;
	Wed, 25 Nov 2026 16:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623769;
	bh=9WBQpVQC/bELDlswi3JxKWsNWvwAelJajccj14N91+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f9NOAgIUksTBdDs/AKNGD6tFynQlBAQ2ngcIFycOjm4xVSnDAJ9LM1WqnJCRbO7Ch
	 Wuqu/ncevgUkPaqyX9loltCsICajBbBtKbOzIousv5bj3V46lukMA0xghOhB4H+q4M
	 yoHqZBKgC37DfjNXdUDNfrkAzqvFhuU71I/3QH/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnav Kapoor <kapoorarnav43@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 964/990] iio: proximity: sx9500: ignore event config writes that dont change state
Date: Wed, 25 Nov 2026 15:38:51 +0100
Message-ID: <20261125143844.565592563@linuxfoundation.org>
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

From: Arnav Kapoor <kapoorarnav43@gmail.com>

commit b8ed9165906597b69a46fabf39ab41690721ebe8 upstream.

sx9500_write_event_config() adjusts the channel and close/far user
counts on every write, even when the event is already in the requested
state. Writing 0 to a disabled event and then 1 leaves the counts at 0,
so the channel and its interrupts stay off while the event reads as
enabled. As channel_users[] is shared with raw reads, those can then
wait forever for a conversion. Writing 1 twice and then 0 has the
opposite effect.

Return early when the state doesn't change, as
sx_common_write_event_config() does.

Fixes: 4193c0f1d863 ("iio: driver for Semtech SX9500 proximity solution")
Signed-off-by: Arnav Kapoor <kapoorarnav43@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/proximity/sx9500.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/iio/proximity/sx9500.c
+++ b/drivers/iio/proximity/sx9500.c
@@ -548,6 +548,12 @@ static int sx9500_write_event_config(str
 
 	mutex_lock(&data->mutex);
 
+	/* The user counts must only change when the state does. */
+	if (data->event_enabled[chan->channel] == state) {
+		ret = 0;
+		goto out_unlock;
+	}
+
 	if (state) {
 		ret = sx9500_inc_chan_users(data, chan->channel);
 		if (ret < 0)


