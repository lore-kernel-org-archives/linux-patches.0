Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB15222D67;
	Thu, 12 Dec 2024 16:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020420; cv=none; b=lUsNorRxyBsfamHVV/N1psKQFHAcbX8tlD6VNV4NRG4RYXHQxIDXurwC6sEhrCG8EVR77qe5q+Wzoag4wK65cnPn8AMXesxfXzmj9ncQeAwV1KLs37ePV0HLUkKYgFDZXWJMJXWLhzB5/Bql/zH8h86qpzW41h4toe5TihuPuok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020420; c=relaxed/simple;
	bh=2bkWxhDZZS/pIfK2QHurT7JbMmk7ITlf7Lp3Nc2o4eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AF0Y869njdsDg7z2MTHCRWPCIBXxylAqb8uAZg1xV3sms4zIOu9fCZtqA40HT1px/akfNCB1ZuPxy3bUi4wWaFkneMZ0+LLNyTGtKYznDWTLnmW62T7HI/GkDmNTLIpNtsejUSVZn9K0hExwJRcsaPmAbWkrJ4VMzvLw7l4vU0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hR2FlJbH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hR2FlJbH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C5DDC4CEDF;
	Thu, 12 Dec 2024 16:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020417;
	bh=2bkWxhDZZS/pIfK2QHurT7JbMmk7ITlf7Lp3Nc2o4eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hR2FlJbHAOL8o8MmuHQcHmtgJ9+8+EiYHQmEJeMX1ouvsmiglcFdYyA0oGZyr9jq5
	 +ZiXv2CP1155h3Ck8WarkaAQzpiHE8JXukRZiTLGAfkgN0xIUBA2tR3nTCc1lbiFAo
	 5bZngQoqTMNL38ZQJmxILqhDAdsNb3RdMSZEVwHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zetao <lizetao1@huawei.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.1 463/772] media: ts2020: fix null-ptr-deref in ts2020_probe()
Date: Thu, 12 Dec 2024 15:56:48 +0100
Message-ID: <20241212144409.068548568@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -554,13 +554,19 @@ static int ts2020_probe(struct i2c_clien
 		const struct i2c_device_id *id)
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


