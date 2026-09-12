Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71543235358;
	Sat, 12 Sep 2026 07:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198199; cv=none; b=gcoe0jHy+toH/kHHXgWtBRYYsd5U4j7dzhfhfIyc09ZjIos++pW2lqNUz1PpY8+SaxC7x8PyfVFSEhHH6b+RHC4v1zcVM4724SYSqqyUrWcHJK+JpJkjrngQUj6gSB1npEfk3sU5PGx/4FZLJAAhT6h3xRjrsD+jH7Tzh/sHFHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198199; c=relaxed/simple;
	bh=g1FPW+99YhwilPzbb0/stSFuSyBEnHwZXVa/dDpmZa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M/WQSf9rK2ruD1hMszzXQNreNzhSCxeDhcqpHWgBrqnstCYjrGTCrEGazyLFfqMOsA3YzvglMu4hqqFJxsG5066g7Q0KzwhBLRsKgtOdHUtq/WA9cpjyHf52cAQEetf4QzWkzdPlYNkfCE5IZmJXg6S9vrV2FoCqnb+1S8yO5Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vqT3YLyQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vqT3YLyQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E07A91F000FF;
	Sat, 12 Sep 2026 07:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198198;
	bh=hNXsPYp9lnF84zySLWXDoKFZFumd/8ZN7c9VgEiF9RE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vqT3YLyQmc+oP5xg6Nnn9e+xxqWa6D6ZzfCqqaQHUGRxN8q5u+38ta5R/dsvxhigb
	 5uvenYbx1GFtXEjIQ0U8eaivsi4WjqiVuDGIpWVjwVgOMXzvF69ZWtSrnMQvJaQBiZ
	 9vymNEMRAO5kKrSEPjvmDDbZ6cCLPqbjyPRDMSeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Pengyu Luo <mitltlatltl@gmail.com>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0332/1815] usb: typec: ucsi: gaokun: unwind notifier on UCSI register failure
Date: Sat, 12 Sep 2026 08:34:42 +0200
Message-ID: <20260912065656.719875461@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 2c5659a7064e7c4c0c51eb9356bcf6726a85773b ]

gaokun_ucsi_register_worker() registers the EC notifier before calling
ucsi_register(). If ucsi_register() fails, the worker currently only logs
the error and leaves the notifier registered. Later EC events can then
call into an unpublished UCSI instance.

The remove path also unconditionally unregisters both the EC notifier and
the UCSI device even if the delayed worker failed before both publication
steps completed.

Unregister the notifier immediately when ucsi_register() fails, and track
only the fully published state. The remove path then tears down the pair
only if both publication steps completed.

Fixes: 00327d7f2c8c ("usb: typec: ucsi: add Huawei Matebook E Go ucsi driver")
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Pengyu Luo <mitltlatltl@gmail.com>
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260709123239.62930-1-pengpeng@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi_huawei_gaokun.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi_huawei_gaokun.c b/drivers/usb/typec/ucsi/ucsi_huawei_gaokun.c
index ca1b534cb183d..57b37fca150c2 100644
--- a/drivers/usb/typec/ucsi/ucsi_huawei_gaokun.c
+++ b/drivers/usb/typec/ucsi/ucsi_huawei_gaokun.c
@@ -105,6 +105,7 @@ struct gaokun_ucsi {
 	struct notifier_block nb;
 	u16 version;
 	u8 num_ports;
+	bool registered;
 };
 
 /* -------------------------------------------------------------------------- */
@@ -482,8 +483,13 @@ static void gaokun_ucsi_register_worker(struct work_struct *work)
 	}
 
 	ret = ucsi_register(ucsi);
-	if (ret)
+	if (ret) {
 		dev_err_probe(ucsi->dev, ret, "ucsi register failed\n");
+		gaokun_ec_unregister_notify(uec->ec, &uec->nb);
+		return;
+	}
+
+	uec->registered = true;
 }
 
 static int gaokun_ucsi_probe(struct auxiliary_device *adev,
@@ -528,8 +534,11 @@ static void gaokun_ucsi_remove(struct auxiliary_device *adev)
 	int i;
 
 	disable_delayed_work_sync(&uec->work);
-	gaokun_ec_unregister_notify(uec->ec, &uec->nb);
-	ucsi_unregister(uec->ucsi);
+	if (uec->registered) {
+		gaokun_ec_unregister_notify(uec->ec, &uec->nb);
+		ucsi_unregister(uec->ucsi);
+	}
+
 	for (i = 0; i < uec->num_ports; ++i)
 		typec_mux_put(uec->ports[i].typec_mux);
 
-- 
2.53.0



