Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787A331E857;
	Mon, 13 Apr 2026 16:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099491; cv=none; b=in4Pmq2SCmCHGsLBIlPgbc9GmrnIfa9APHRHh7abJaj1mkMlEZul35hMTh/rcJcTUap0dblEtVT6lfj7jpeWWqwdpqmC0ry26hNqJkHmc+nDidLdW/bH9tDt/Mua0tODXPj++kcWAP7Mend2JJhjIbW9BEGPU59FhD0k/GExxv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099491; c=relaxed/simple;
	bh=VnkAMlmg8B9bbd8WPRggKI6pPpEortk3iPViNI0vCiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lliMyiCnoGaat609G8Ce6Kv19shufkHcalY7ZjMQs2E8f1o6zjNMa845jcmq1ULvueZgCZwrs9MKD0JprQA3UHeTdmkHTyby1r3VuvxMvd7EdZD7f5EiPSu9maY0yublL+Ve5qF7UcEzY/TFHsHFX1WZNGC8/1ou8O7Ydh3wV5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EviCU0Qe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EviCU0Qe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E04C2BCAF;
	Mon, 13 Apr 2026 16:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099491;
	bh=VnkAMlmg8B9bbd8WPRggKI6pPpEortk3iPViNI0vCiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EviCU0Qe8TeXyBq9wxvqAMMy+jme1sUFlYFG1MvX1XYuyUIvYFyxN1AbqzgUz7t0V
	 o3oVnSi0xAR9DezjjJmumVGiXPCu72f7YPiaBknaGelcA9a7RRNQWInDIMuOkTl5kf
	 N8ksJSxM+hSHc/BVZGQw7IMOnPwD3I1VtYq8/W8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 361/491] hwmon: (pxe1610) Check return value of page-select write in probe
Date: Mon, 13 Apr 2026 18:00:06 +0200
Message-ID: <20260413155832.551124500@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

From: Sanman Pradhan <psanman@juniper.net>

[ Upstream commit ccf70c41e562b29d1c05d1bbf53391785e09c6fb ]

pxe1610_probe() writes PMBUS_PAGE to select page 0 but does not check
the return value. If the write fails, subsequent register reads operate
on an indeterminate page, leading to silent misconfiguration.

Check the return value and propagate the error using dev_err_probe(),
which also handles -EPROBE_DEFER correctly without log spam.

Fixes: 344757bac526 ("hwmon: (pmbus) Add Infineon PXE1610 VR driver")
Signed-off-by: Sanman Pradhan <psanman@juniper.net>
Link: https://lore.kernel.org/r/20260329170925.34581-4-sanman.pradhan@hpe.com
[groeck: Fix "Fixes" SHA]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/pxe1610.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/pmbus/pxe1610.c b/drivers/hwmon/pmbus/pxe1610.c
index 212433eb6cc31..7794e5cf550fc 100644
--- a/drivers/hwmon/pmbus/pxe1610.c
+++ b/drivers/hwmon/pmbus/pxe1610.c
@@ -104,7 +104,10 @@ static int pxe1610_probe(struct i2c_client *client)
 	 * By default this device doesn't boot to page 0, so set page 0
 	 * to access all pmbus registers.
 	 */
-	i2c_smbus_write_byte_data(client, PMBUS_PAGE, 0);
+	ret = i2c_smbus_write_byte_data(client, PMBUS_PAGE, 0);
+	if (ret < 0)
+		return dev_err_probe(&client->dev, ret,
+				     "Failed to set page 0\n");
 
 	/* Read Manufacturer id */
 	ret = i2c_smbus_read_block_data(client, PMBUS_MFR_ID, buf);
-- 
2.53.0



