Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F3844C8C;
	Tue, 27 Aug 2024 14:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770114; cv=none; b=O0RDJMu1TKwBo5a6uvYySV9Eoo4+1vXcSWFL4mwpZLIPrRkwyEEDxea4AR7WFYVIXyWMYfeHIA9HuSo2xdlvThNn89Al/HDoYstvEM18iOTEZrHPN+IkS8DaoUUvWv3WLyOUX8+IlXmvR8xnKkGue/K8/KKEh4M8UWxxDxcRQTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770114; c=relaxed/simple;
	bh=4Pw4AyynVktEPN8UyBDtPGjShlFiLD84AfybzLDKdok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PrIPcNiNpqPM/hK4nYOHrJt0N9oEF1Nqmm2DmbA5yDQhgk15YGLfYp4T1tvokyal4Ppa3khWwd6eiF4WXlC/DtTXYG9RU61XS0pS7iX6VRfEvGvia+Bu85NUPy8WvobiQQAu/GDft4dgTLqeN+yDgKMFVzgeD0r7yWsmOBmrvmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e+9gAGSS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e+9gAGSS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68204C61047;
	Tue, 27 Aug 2024 14:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770113;
	bh=4Pw4AyynVktEPN8UyBDtPGjShlFiLD84AfybzLDKdok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e+9gAGSS7im5ekZIFW0mLv63In7nfHt4EgxjW5RsiluXJUDhuJi05Ich+paBYFvvK
	 ID3uJVsYO0/zjIuFvhmebxntgzG6rIVS2PRHtW2hdW6rhcrtlHuvNx8tXjt7aZwPJY
	 lfTQZCI2xpRhu41d2k+lgpkMG2PS5o9hzGL1Ovuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 132/341] hwmon: (ltc2992) Avoid division by zero
Date: Tue, 27 Aug 2024 16:36:03 +0200
Message-ID: <20240827143848.441700084@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

[ Upstream commit 10b02902048737f376104bc69e5212466e65a542 ]

Do not allow setting shunt resistor to 0. This results in a division by
zero when performing current value computations based on input voltages
and connected resistor values.

Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Link: https://lore.kernel.org/r/20231011135754.13508-1-antoniu.miclaus@analog.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ltc2992.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/ltc2992.c b/drivers/hwmon/ltc2992.c
index 589bcd07ce7f7..001799bc28ed6 100644
--- a/drivers/hwmon/ltc2992.c
+++ b/drivers/hwmon/ltc2992.c
@@ -875,8 +875,12 @@ static int ltc2992_parse_dt(struct ltc2992_state *st)
 		}
 
 		ret = fwnode_property_read_u32(child, "shunt-resistor-micro-ohms", &val);
-		if (!ret)
+		if (!ret) {
+			if (!val)
+				return dev_err_probe(&st->client->dev, -EINVAL,
+						     "shunt resistor value cannot be zero\n");
 			st->r_sense_uohm[addr] = val;
+		}
 	}
 
 	return 0;
-- 
2.43.0



