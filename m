Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE01926F46F;
	Thu,  2 Jul 2026 16:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011428; cv=none; b=ntIgen13qZNs7gy5IMCaupkDoE+O9PkXNGtVla2WSju5XXVjc45x+qBRgZRYrKcBLvgGE2ZOW3Sn/eZsu7Ti12maYW6G3s96SzFLO9tEuQyM3ZyNkOkZcvHQcEnvJjqbaPoR8LQ1rKUj7FwKuRWnCFx+rdTFQPBGMHU85JxCP7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011428; c=relaxed/simple;
	bh=J7FSFFpz90qRx56X8IvBdI8AmRerkycTya8oWjEdjVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MoQ+gu2CRyaWZKJDwkeFh4P6O8AxSeUTbJZTp2CD1V/tX/krlfz3CYzt1h7R8R/G3CxW2r2VkNjgO8wF7n2XrRwu1mQUndSUvpHfZpTadmPcBi51e+OOLf5navikXUQPkvpbrNsELJ0nOgOmmcLWcJ9gLIHCCGyLoY/nYJ1bmwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OJLIKyvb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OJLIKyvb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60BD31F000E9;
	Thu,  2 Jul 2026 16:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011427;
	bh=jb1ZL+g38kpmDukzDj9Yy4kNv+dbK0uUg285TKR5VkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OJLIKyvbJRQQx2iUinyF5tIbodaC6oIqOBI5UnBurIVOIfyGytQqprMe7wpGKi8e+
	 Lqq55kOtuhKoGm2fICnzkdXemkBLvG38VUmKKBJ74pahMUUrKGxQsjAH0gLa3URM5Q
	 jRGcentjaEpJWNcO8b3gq301RH0gqy+k5cQOycYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 106/108] serial: 8250_dw: unregister 8250 port if clk_notifier_register() fails
Date: Thu,  2 Jul 2026 18:21:43 +0200
Message-ID: <20260702155114.310196608@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.110058792@linuxfoundation.org>
References: <20260702155112.110058792@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stepan Ionichev <sozdayvek@gmail.com>

commit 10fc708b4de7f86002d2d735a2dbf3b5b7f65692 upstream.

dw8250_probe() registers the 8250 port via serial8250_register_8250_port()
and then, if the device has a clock, registers a clock notifier. If
clk_notifier_register() fails, probe returns the error but leaves the
8250 port registered. The matching serial8250_unregister_port() lives
in dw8250_remove(), which is not called when probe fails, so the port
slot stays occupied until the device is rebound or the system is
rebooted. The devm-allocated driver data is freed while the port still
references it (via the saved private_data and serial_in/serial_out
callbacks), so any access to that port slot before a rebind is a
use-after-free hazard.

Unregister the port on the clk_notifier_register() error path.

Fixes: cc816969d7b5 ("serial: 8250_dw: Fix common clocks usage race condition")
Cc: stable@vger.kernel.org
Signed-off-by: Stepan Ionichev <sozdayvek@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20260514143746.23671-2-sozdayvek@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_dw.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -846,8 +846,10 @@ static int dw8250_probe(struct platform_
 	 */
 	if (data->clk) {
 		err = clk_notifier_register(data->clk, &data->clk_notifier);
-		if (err)
+		if (err) {
+			serial8250_unregister_port(data->data.line);
 			return dev_err_probe(dev, err, "Failed to set the clock notifier\n");
+		}
 		queue_work(system_unbound_wq, &data->clk_work);
 	}
 


