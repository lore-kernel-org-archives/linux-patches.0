Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75314207DFA;
	Fri,  6 Dec 2024 15:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498552; cv=none; b=Vzlh2vtmcN6zu5cD0q61YEteFz6vGGEGkhOnQkbb1jBhOSwL8Jimx4RFa8Uu/omox4i1p+zpWW7rSXO0bhlu4KeaALjfH2SKIKi4BAgD/jHBQG6ZBkowqgGSpsx8lpio2MK0cRW0wEHpo87SlgkEhPVEp8bclqKjdkAsac8St+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498552; c=relaxed/simple;
	bh=ySGMrUHiQfZKXM+hrA2XNjeY6shasGXhAyl+ebBqDOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BslP7C8cnc0Iywu4lAD1zhxyqx/6iSPY6seefXHf58hVEy4gI/XAA+APJYX8BJ3AL7Hkh43R9qvucvcA+LVYS4J4aQ9cdA5AJ28H1KRD1Q4liq/J6LAG73mo/8BIm0KiKxPcf+nPqEfPmC72vRNx0tOn5AFMniC6bNsIiRO29z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LUkDD1Ap; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LUkDD1Ap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D96C4CED1;
	Fri,  6 Dec 2024 15:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498552;
	bh=ySGMrUHiQfZKXM+hrA2XNjeY6shasGXhAyl+ebBqDOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LUkDD1Ap0F0MqsYwEs4bE+G+b7vannvz7b3PTKHtLIYuhhnyP2wpt1tImEFREqyCv
	 Wf3WMhVr8ei1CRFdJGi/p7NBPUKWWRxWFEDs2HvaCLrIemCUNoQYjzTGiB4n+rjVKT
	 ZPn9nd+aRnGNzMZmcoXSNf/3zCAjaF4QE4FXj1wg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zetao <lizetao1@huawei.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.6 617/676] media: ts2020: fix null-ptr-deref in ts2020_probe()
Date: Fri,  6 Dec 2024 15:37:16 +0100
Message-ID: <20241206143717.471579988@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zetao <lizetao1@huawei.com>

commit 4a058b34b52ed3feb1f3ff6fd26aefeeeed20cba upstream.

KASAN reported a null-ptr-deref issue when executing the following
command:

  # echo ts2020 0x20 > /sys/bus/i2c/devices/i2c-0/new_device
    KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
    CPU: 53 UID: 0 PID: 970 Comm: systemd-udevd Not tainted 6.12.0-rc2+ #24
    Hardware name: QEMU Standard PC (Q35 + ICH9, 2009)
    RIP: 0010:ts2020_probe+0xad/0xe10 [ts2020]
    RSP: 0018:ffffc9000abbf598 EFLAGS: 00010202
    RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffffc0714809
    RDX: 0000000000000002 RSI: ffff88811550be00 RDI: 0000000000000010
    RBP: ffff888109868800 R08: 0000000000000001 R09: fffff52001577eb6
    R10: 0000000000000000 R11: ffffc9000abbff50 R12: ffffffffc0714790
    R13: 1ffff92001577eb8 R14: ffffffffc07190d0 R15: 0000000000000001
    FS:  00007f95f13b98c0(0000) GS:ffff888149280000(0000) knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: 0000555d2634b000 CR3: 0000000152236000 CR4: 00000000000006f0
    DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
    DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
    Call Trace:
     <TASK>
     ts2020_probe+0xad/0xe10 [ts2020]
     i2c_device_probe+0x421/0xb40
     really_probe+0x266/0x850
    ...

The cause of the problem is that when using sysfs to dynamically register
an i2c device, there is no platform data, but the probe process of ts2020
needs to use platform data, resulting in a null pointer being accessed.

Solve this problem by adding checks to platform data.

Fixes: dc245a5f9b51 ("[media] ts2020: implement I2C client bindings")
Cc: <stable@vger.kernel.org>
Signed-off-by: Li Zetao <lizetao1@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-frontends/ts2020.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/media/dvb-frontends/ts2020.c
+++ b/drivers/media/dvb-frontends/ts2020.c
@@ -553,13 +553,19 @@ static void ts2020_regmap_unlock(void *_
 static int ts2020_probe(struct i2c_client *client)
 {
 	struct ts2020_config *pdata = client->dev.platform_data;
-	struct dvb_frontend *fe = pdata->fe;
+	struct dvb_frontend *fe;
 	struct ts2020_priv *dev;
 	int ret;
 	u8 u8tmp;
 	unsigned int utmp;
 	char *chip_str;
 
+	if (!pdata) {
+		dev_err(&client->dev, "platform data is mandatory\n");
+		return -EINVAL;
+	}
+
+	fe = pdata->fe;
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (!dev) {
 		ret = -ENOMEM;


