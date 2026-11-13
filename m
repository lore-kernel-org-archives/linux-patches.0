Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585544;
	b=ZVQlq9DTt4LLBbwmfsWSE8XTCYnh5f0Ujzwis5+5njXo3Kodt9ygBvaUCaVWzyGhhOx7
	 7i0l2Gg1wMPI9zCROTaT4tslTffBerdHJSDPYd/airW77G1eQsZM9kjfCYTYlddLd+GEp
	 mz9+b0tLjxnbbgHhdK38kq3Qu0dOpnm9qFRQb4HBevgoKvbTt1CxT1pIqN1pjDWIuhYoB
	 meDtdryc3h3fq9o1vkWFJcNg4FBrhPahMqT3O7JjUFKMr2ekNCSOIXLQGJFj+bM5AxPoS
	 dmrAzdIJS2N7HowV8AqWnyNuwIZA3/jlW39YbjwhJ/IqOjAmUKiHnWifQ3tgKWEWjig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585544;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DmpFt7507PBddpcYIFNXGqu++Q+555cPdRYf21NKMk8=;
	b=PzucgykL13dUZPfrpYenHlstckmVspPmKwTXA+Hza2JLR7EMNtDqNglYcRQzgn4cn0jg
	 6pQT90DL5MbWgRaxsJ1DQELr/k4pljA+gkywDcv7lWr2NetYfz99y21n/lSDrJhUpicGS
	 bkcQQK270lVH6y3Pk5cpoliGXWoNHhURigKrdLBEQcry94zNy/zXMlpAkiG7w2RR44gGL
	 gS1B20dipBywOFC2SrXI1Rw4ibkqpuL1eVtml6slvP62c1dZNlrAbCN5G4kn3YJ5iEjwr
	 mbMui51iNRxGuOW8K/wfsV8LwZIbJdJUf7GWs48yDRTDw/PZJ26AmUowmiTMmAG1BYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qLu6QXVN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5EF5606D473;
	Fri, 13 Nov 2026 15:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qLu6QXVN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF6B1F000C5;
	Fri, 13 Nov 2026 15:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585544;
	bh=DmpFt7507PBddpcYIFNXGqu++Q+555cPdRYf21NKMk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qLu6QXVNB8Gzg3PaZs9IBOjHMAtWGwYwoLeMtz4H7cmQho6jMX4bxxmCbdypmEHb5
	 y4jhafVnJ9WuVDqjn9XYGm5+GtSXSdqpqvUb+ANIIoHreZUVlIPnlbpm0S8Y4egkEs
	 I967JZyn3ymxutJQf1WxoI0Nr/iXYzRqLVF7RM48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 181/507] hwmon: chipcap2: do not discard pending alarms on disable
Date: Fri, 13 Nov 2026 10:48:05 -0500
Message-ID: <20261113153800.613831010@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit 22aecf164e1c0c849808c342c65322d14f45176f ]

cc2_disable() stops processing interrupts before the device is powered
down to ignore the alarms caused by voltage toggling. The handler of an
alarm raised by the last measurement might not have run at that point,
and the alarm is discarded when it finally does.

The sysfs read that triggered the measurement can then report no alarm
although the device raised one.

Wait for the alarm handlers that have already been raised before the
interrupt processing is stopped. This covers the case where the handler
thread has not been scheduled yet; an alarm that has not reached the
interrupt core at that point is discarded.

Fixes: 3af350929e75 ("hwmon: Add support for Amphenol ChipCap 2")
Cc: stable@vger.kernel.org
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20261014-chipcap2_locks-v3-9-27ebfc2c5b9e@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/chipcap2.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/hwmon/chipcap2.c b/drivers/hwmon/chipcap2.c
index 952789fdb9db6..eba6469940ab5 100644
--- a/drivers/hwmon/chipcap2.c
+++ b/drivers/hwmon/chipcap2.c
@@ -146,6 +146,13 @@ static void cc2_disable(struct cc2_data *data)
 {
 	int err;
 
+	/* let the alarms already raised by the last measurement be processed */
+	if (data->irq_low > 0)
+		synchronize_irq(data->irq_low);
+
+	if (data->irq_high > 0)
+		synchronize_irq(data->irq_high);
+
 	/* ignore alarms triggered by voltage toggling when powering up */
 	data->process_irqs = false;
 
-- 
2.53.0



