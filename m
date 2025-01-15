Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44C11DB151;
	Wed, 15 Jan 2025 10:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938339; cv=none; b=POHpk2u+TgCfZ7WMTQseWOCz3/rBFcHO5xI3XTXPpJf8R82ID5992mfaG0Q4FQm8AfVFIM8+mkUrep959cZinZWNRzzTSPU4FJtY630sDoxDMVxwfXJrilQ22AgExxv/uwGzUExtYMarHT9smXEDeXW0F3df6okfyhoJbtAxNqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938339; c=relaxed/simple;
	bh=syV8TVZKaCSbVPHCX+QYEgGwl8zd+Qv8ZlXHeIhGlCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sXmks47h5ZdJHjiHLa3BUNxBk10Hf68KuvuWiKuPXRQFppQQdhsFPqHRLyRtO0RZ+TLps4OV9NGhI8ggi1QkRZXqWj1AlVDROcqypGPYHL8eWMUW4YpriQiqEr8Hf1lEFF6yXnHMml0LxOsW5ZthM9BbOh9SlzXCH7kdj4P/juU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j8npawyz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j8npawyz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C85E5C4CEDF;
	Wed, 15 Jan 2025 10:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938336;
	bh=syV8TVZKaCSbVPHCX+QYEgGwl8zd+Qv8ZlXHeIhGlCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j8npawyzcLm+4gwGu3bswJJcg8t06qy6D/8pYaUBOmJI7IQKYl5N/iNgUuSY0nVcM
	 o/wki8aVmYXNW4jG5MnEvs6WIQw7gl25hrcj0hMlVnYcaR7zHd23JDx3h1zcLVuIUq
	 GFpiTQ+eHkTW4JqxsteWlshNpmM+jRx7SrZ6Jrh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.12 152/189] usb: typec: tcpm/tcpci_maxim: fix error code in max_contaminant_read_resistance_kohm()
Date: Wed, 15 Jan 2025 11:37:28 +0100
Message-ID: <20250115103612.477220425@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit b9711ff7cde0cfbcdd44cb1fac55b6eec496e690 upstream.

If max_contaminant_read_adc_mv() fails, then return the error code.  Don't
return zero.

Fixes: 02b332a06397 ("usb: typec: maxim_contaminant: Implement check_contaminant callback")
Cc: stable <stable@kernel.org>
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: André Draszik <andre.draszik@linaro.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/f1bf3768-419e-40dd-989c-f7f455d6c824@stanley.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/maxim_contaminant.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/tcpm/maxim_contaminant.c
+++ b/drivers/usb/typec/tcpm/maxim_contaminant.c
@@ -135,7 +135,7 @@ static int max_contaminant_read_resistan
 
 		mv = max_contaminant_read_adc_mv(chip, channel, sleep_msec, raw, true);
 		if (mv < 0)
-			return ret;
+			return mv;
 
 		/* OVP enable */
 		ret = regmap_update_bits(regmap, TCPC_VENDOR_CC_CTRL2, CCOVPDIS, 0);
@@ -157,7 +157,7 @@ static int max_contaminant_read_resistan
 
 	mv = max_contaminant_read_adc_mv(chip, channel, sleep_msec, raw, true);
 	if (mv < 0)
-		return ret;
+		return mv;
 	/* Disable current source */
 	ret = regmap_update_bits(regmap, TCPC_VENDOR_CC_CTRL2, SBURPCTRL, 0);
 	if (ret < 0)


