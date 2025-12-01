Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A522E54BB;
	Mon,  1 Dec 2025 11:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588364; cv=none; b=ma3lcOG85BkBIOxOSM87TAbLS7fE5D911jFSMunJNuS1ZW0KvmfIb/8T38x1OSEp2e3934TdOZgx/9Mgx6TTNM7EFtOxK5QDp8s4G5x3p4OVq31fjA/qQdmk4081BnsMhsfSKxKR0a916q66sR1zPQb9qDh9fMiB0ATMRY8NpT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588364; c=relaxed/simple;
	bh=LTXptwxrwpuXy8n7ELKqH2W9c9JYwtvNSvDb8mu1Cec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f4wiEuNhZ/N2UQEU9jrMoyzR0qUZoSninjMDrfa3I5zuMGEbLp4qVH6XMr8Wlc7BsBgG8Qq9JvyENCHxhnqO9Tvr6PBqps4sZVJ40PnWQFx6eazO0la/F7HVFkJkW9MCPpMbCqlLRN5USfBHlPLLIPE+9ZFNURk+fefBB/9Widc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A1yWOWNM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A1yWOWNM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BDD1C4CEF1;
	Mon,  1 Dec 2025 11:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588363;
	bh=LTXptwxrwpuXy8n7ELKqH2W9c9JYwtvNSvDb8mu1Cec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A1yWOWNMIifiWbWGIjpsWZl5iH+W071mDAQmNWyYNDWsBXQ75mh682U53OIB6TJnl
	 /cx5D86UwPavD/EnHTioetHCGsC06g1XDP12zS4wdc8dTvYWjPR4BXJISDN7dZyHl/
	 pbk3QFaLQyc1orVclWuN0Ob8shWDh0yfWNvbEksU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Artem Shimko <a.shimko.dev@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 023/187] serial: 8250_dw: handle reset control deassert error
Date: Mon,  1 Dec 2025 12:22:11 +0100
Message-ID: <20251201112242.093369404@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Shimko <a.shimko.dev@gmail.com>

[ Upstream commit daeb4037adf7d3349b4a1fb792f4bc9824686a4b ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_dw.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -523,7 +523,9 @@ static int dw8250_probe(struct platform_
 	if (IS_ERR(data->rst))
 		return PTR_ERR(data->rst);
 
-	reset_control_deassert(data->rst);
+	err = reset_control_deassert(data->rst);
+	if (err)
+		return dev_err_probe(dev, err, "failed to deassert resets\n");
 
 	err = devm_add_action_or_reset(dev, dw8250_reset_control_assert, data->rst);
 	if (err)


