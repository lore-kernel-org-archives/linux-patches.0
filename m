Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A95256C9E;
	Wed,  3 Dec 2025 15:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776046; cv=none; b=htz9ddufFiPSanUslMH2xqZok3I03J+mAMCYY5OJzMAaZB2qrSpDc/d8HQ8UkeR+ZXLoFf7loYRv01Kd/dgcflGS6SmtgMIlrX6By//n3hnyT/uWvajSED7vBEV6qulftjI/LwI9qZpfLivIZiNkPN0NKKQhFql3D/TebS9B6GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776046; c=relaxed/simple;
	bh=bpMAjWxSnVfQXB9CnlCv719ED03le4WMjbRhS2AEGG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bg8kdGBa7z7Npb5BVstlgYo+e6qJKKMC4nG40s2Rgzf1By6jnCpSJdKpv+kmA69lw2Jrp9XJ0/Rt3qlnOKQT2GEwRmstmLolsUEQQjecXQiJmI2swQ4LF7b1S+wwv20YnrcYYPqvt9GIDAWVjnT5sFtaBfSkGovlk1lRHupcedg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tg3nSE/c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tg3nSE/c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84589C4CEF5;
	Wed,  3 Dec 2025 15:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776046;
	bh=bpMAjWxSnVfQXB9CnlCv719ED03le4WMjbRhS2AEGG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tg3nSE/c+nLe+t9ZoDf8lvxXaRysFM5UVDmK52O4dyZfOL2b8MSZdru4DueOLsvzF
	 M3fbKzQWiMDIw+OLLfYfaeTa8SxjtROPHkWydA7EDLJJkhvj73uMBusVQ4iwbr/ocs
	 vRxBAbqaYTR3QCR4MUb3hg8VEur/Olk44liWBLFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Artem Shimko <a.shimko.dev@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 031/300] serial: 8250_dw: handle reset control deassert error
Date: Wed,  3 Dec 2025 16:23:55 +0100
Message-ID: <20251203152401.613740925@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -580,7 +580,9 @@ static int dw8250_probe(struct platform_
 	if (IS_ERR(data->rst))
 		return PTR_ERR(data->rst);
 
-	reset_control_deassert(data->rst);
+	err = reset_control_deassert(data->rst);
+	if (err)
+		return dev_err_probe(dev, err, "failed to deassert resets\n");
 
 	err = devm_add_action_or_reset(dev, dw8250_reset_control_assert, data->rst);
 	if (err)


