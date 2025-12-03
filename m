Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346EE340A76;
	Wed,  3 Dec 2025 15:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777422; cv=none; b=i/s6WpLNI6ErMOTsLQhimJ844CkAlylew5uKahot/r02LTIF+O8o2t5rMbP5c4rACgApkO4oKe4e6hgAkP8eAM3c63A7B9/GSk66pownYavc9r8+L/7DShorZ5M199QLjwk3JgPJET2RY6J3K/mguBI9zjPUt0vcH5uOAi0GAaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777422; c=relaxed/simple;
	bh=iOwqbCiZX+x6hoJ0SU7Z4q88im/TMVaWIxoTKTj7NJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aTD1HMkQsV/F4k9NjJb/E7lCM+sVBAsz0OAgiWf0yrldoPzetdnjGXidX8Z+id4zqg94IN2hWSDYB1yIndYbDELH+WwhuTn2/Gwy/2/LPWOCgRkZwMy9xTiM/NPMR9UXgjGV6ZG3d+RXeH1Iqb44dXFJ/mYFBqGfHbGv30KKssc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PH4tdfKF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PH4tdfKF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF25C116B1;
	Wed,  3 Dec 2025 15:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777422;
	bh=iOwqbCiZX+x6hoJ0SU7Z4q88im/TMVaWIxoTKTj7NJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PH4tdfKFKj3t+O1DWv/ydDWV/kirPbAwQK3zGcGtXoGwGyX2sqGIX2TLFeXlvNNQ4
	 O9MGjqWm3BNUb+zvEeOFdlby6XtU3AxNX5NYPlSAQ+LDOqCkm52L6/YJ3fyrB29pr/
	 V1h+uWTTuMB0Pl3VKVu+j/CaGNGBzSiMqc0Edi3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Artem Shimko <a.shimko.dev@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 033/392] serial: 8250_dw: handle reset control deassert error
Date: Wed,  3 Dec 2025 16:23:03 +0100
Message-ID: <20251203152415.321576879@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


