Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019758;
	b=l2TliOLUE1I981FxGXjCKwFPPoJo63a3oMKomUWsHDj9LO9fbEqtLgf/5uPz+3Q+pE6M
	 t9LDkXrECJvzxybHVKYR8yftDeGV6vhx5CbUcWq7nxXxBKyw43WZvWhqSKec4qxmuOo+k
	 dC4Y0xQMjGYk7Me0OTxEXI50nDhlxuHKQkic83NvYIkAe5Fs1/vksv6ny7WefE1JnMI8q
	 oLgZ/tdguZM+yxwNvEXowvtuznwIKn4CCVX5kAPYG3W3k24lGJYmW26iDP+ZtQGtzQ/hS
	 vPvb74LR76f6laLbHqtXfrEm1XVNxhH2bKhwqmLQzGdq+vXnlsCuVTTjgg8Sqm5EFaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019758;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LWd5SFWjBKF6kFuATsncFPzHXOnkKxcmZriLH86nRvU=;
	b=AOsf/clUeH9q6DaWs7hudY+o5/FQ9NOCbtl+ymPhhF/sEN5JLZ56FfxeRV/SMMynQ91j
	 Ls2oPE4hokm1C75d4vsIA7NhkYqA+83kcepT22p5L/Wdr98MVFQ53XAU+fdHGy8T347CK
	 l3+vnZquUYCgl+ZY58mBJUQRSC2rQKckkO0ce6YXJtnP5j40jpEDbDPx0lg0PcdywhLQs
	 RQiesEwui45FcPPXasMtQnJIexyORimCi25GlSMbn5zgLaetNejW8rTNGERn62fOqGXlo
	 JF3VmB44HDssB7h+8ReRB8S3/+b9uLIGTI+1YzD1xqosG45DZRHQOyE/N1DeW/DcUfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=14xitdMV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CD9606A320;
	Wed, 18 Nov 2026 16:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=14xitdMV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60CEE1F000C5;
	Wed, 18 Nov 2026 16:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019757;
	bh=LWd5SFWjBKF6kFuATsncFPzHXOnkKxcmZriLH86nRvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=14xitdMVw68Y9mrLMTHhWE4Ixt+RlcmLWXrTSzcStaoBh31k2ZbopHxVLgm23kt/l
	 1QbLESS6WiAK6XkXXkWKmC7CMOZfvFCDcQxxssY9n07G/cmUIvio2wGaE/prnt5MNK
	 Z/BjfHI+61gAaCAYbZGIhzEVC7LwAa+yLLkc7XC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1711/2651] serial: qcom-geni: power the console back up on system resume
Date: Wed, 18 Nov 2026 15:49:11 +0100
Message-ID: <20261118150349.228056849@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: David Heidelberg <david@ixit.cz>

[ Upstream commit e95442c31ae65b57ddffdfa609531c549055f308 ]

The console holds a runtime PM reference on its port, which keeps the
port powered while the tty is closed. On system suspend
pm_runtime_force_suspend() powers the port down regardless, but a single
reference makes pm_runtime_need_not_resume() report the port as not in
use, so it is marked runtime suspended instead of being flagged for
pm_runtime_force_resume(). On system resume the port therefore stays
powered down while uart_resume_port() goes on to program the termios
settings and re-enable the console.

If the tty has been opened before, uart_resume_port() ends up in
startup(), whose runtime PM reference powers the port up again, and only
the register writes made before that are lost. If the tty has never been
opened (no getty on the port, /dev/console backed by another console),
nothing powers the port back up and the console stays dead after the
first suspend.

Resume the port explicitly before uart_resume_port() when the console
was force suspended.

Assisted-by: LLM
Fixes: aee1f94dab13 ("serial: qcom-geni: remove .pm callback, use runtime PM in startup/shutdown")
Signed-off-by: David Heidelberg <david@ixit.cz>
Link: https://patch.msgid.link/20260918-qcom-geni-pm-v1-1-cb587e215607@ixit.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/qcom_geni_serial.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/tty/serial/qcom_geni_serial.c b/drivers/tty/serial/qcom_geni_serial.c
index a851b8f0ef047..dbb1bb7160cc1 100644
--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -2128,6 +2128,12 @@ static int qcom_geni_serial_resume(struct device *dev)
 			return ret;
 	}
 
+	if (console_suspend_enabled && uart_console(uport)) {
+		ret = pm_runtime_resume(dev);
+		if (ret < 0)
+			return ret;
+	}
+
 	ret = uart_resume_port(private_data->drv, uport);
 	if (uart_console(uport)) {
 		geni_icc_set_tag(&port->se, QCOM_ICC_TAG_ALWAYS);
-- 
2.53.0



