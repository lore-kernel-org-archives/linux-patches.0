Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06EDD322C8A;
	Mon, 27 Oct 2025 19:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593551; cv=none; b=R1e3g7OGnFJCmaJlCoi9SVDBkigBnsPqYo5RVf46yXOsBecK276V1ud4sv2OJ6z+lhq3ZB2zaX1PosMk01LnFepB8banFCFKcOT4i1MJn0qQxWwHF9jJRMsqry1YR+uOOBpbhkjwwevOPxiJZDagh3lUYWh5/WLkQT7U2XkLWiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593551; c=relaxed/simple;
	bh=2MS1yJOphfZjQnzyRgMPJ+N6mpcrxQz1dA0e80ehnME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A1XV2b/SPnY7X0ehXg+TfEL7NhMKMj51fRMeZRnHIsx/FS58H1/espDKqG5K4wPVIGQIGymCYHt2l8W//w+SXV6yTrcXC7aXtVJO0b8NsK54ABKfg/RtqoSQE4UgHyBsFrSEPwrrz/IzGmiz3KkjCrLQ3cLZ0ExZkuG+87+7N0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ghduVcXT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ghduVcXT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF0FC4CEF1;
	Mon, 27 Oct 2025 19:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593550;
	bh=2MS1yJOphfZjQnzyRgMPJ+N6mpcrxQz1dA0e80ehnME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ghduVcXT6McQLSvzPdm/BqjKS92jws/Sq+0B4HRMvnqml9GQciOu3mWl1y9pwT5UT
	 Dq1BKcowEN2VGn8/GglEQk6dl7rWzmATMg1eVXiXXg43YmwmD8BgfTxs4YBYY0Ua0U
	 9Yq0nJ6J/wgboLVWYyL9+NhYewpO/e7j4Kb6Xw4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Artem Shimko <a.shimko.dev@gmail.com>
Subject: [PATCH 6.17 170/184] serial: 8250_dw: handle reset control deassert error
Date: Mon, 27 Oct 2025 19:37:32 +0100
Message-ID: <20251027183519.502449684@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Shimko <a.shimko.dev@gmail.com>

commit daeb4037adf7d3349b4a1fb792f4bc9824686a4b upstream.

Check the return value of reset_control_deassert() in the probe
function to prevent continuing probe when reset deassertion fails.

Previously, reset_control_deassert() was called without checking its
return value, which could lead to probe continuing even when the
device reset wasn't properly deasserted.

The fix checks the return value and returns an error with dev_err_probe()
if reset deassertion fails, providing better error handling and
diagnostics.

Fixes: acbdad8dd1ab ("serial: 8250_dw: simplify optional reset handling")
Cc: stable <stable@kernel.org>
Signed-off-by: Artem Shimko <a.shimko.dev@gmail.com>
Link: https://patch.msgid.link/20251019095131.252848-1-a.shimko.dev@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_dw.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -635,7 +635,9 @@ static int dw8250_probe(struct platform_
 	if (IS_ERR(data->rst))
 		return PTR_ERR(data->rst);
 
-	reset_control_deassert(data->rst);
+	err = reset_control_deassert(data->rst);
+	if (err)
+		return dev_err_probe(dev, err, "failed to deassert resets\n");
 
 	err = devm_add_action_or_reset(dev, dw8250_reset_control_assert, data->rst);
 	if (err)


