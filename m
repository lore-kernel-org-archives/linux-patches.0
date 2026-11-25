Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623186;
	b=Ny+kwvkXpoIgkQlsa/i9z84B1yJLrcHLbXRJo3rxT6pogk3T7ILUd1fwER0VmEc6Qkg6
	 pZ+RMLCJ/J5sr0pCLMGVKr9cRxmKAvwoEFOMcIk8O3wPmt3deDMkAIjZfx0zDxScnArrF
	 p/73mbDaSoehtJavjHIRLHT9i0Xa4kMVEyyPKZ0zJwq5gFUTyWo0DQNQJ1QPfRz3oezMr
	 aQPA1YDhbroxwLDqHnf7smMis3dcFbznECLEGTyTkgrGtLL9Vxi/qLY4yCYlqR9o8j3C+
	 yWLtqQ1faihgVugaU6IPrHhDoc3B2ePtnm2AL+EJX8QdCxLeJ+khcrQMJbtxJBjDEDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623186;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eW9wM7bs65/Z/73mtoEsXVZ0h5Zs0Y66xpgvp5bU+EI=;
	b=LJgkS13hCvnHd/dIqyDLxGfuQFX/bmSAOC12daxBOpkDWALRl+gxECHxFUv45EGkIslF
	 V3e3LOzAglG/2RYhyH3blrQuhQ/xXwhKsEjhCfTp8q/CZ5edII6mxXYhQxmOI4A4aiFqy
	 cfLRwh8ZhQo6BLkTBxW8I01w3x/H4X9JGzVRFnAjILgEE02WqrWrvH7boM7INWKILxEQx
	 ljqC4ugiM0VeZbODcgOzIWFO1Re4WNjQyg5uH3OrW+fRnQSn9AEdpGJACEd9C2vIK2nbW
	 jgUVIbk9+JwrUjN8j79zCWkkCPj6mSKQGU8xMJU/39cXcb7MPWQ86Wwjx1V01VJiH3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SR1M9g5o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54DDD606A32A;
	Wed, 25 Nov 2026 16:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SR1M9g5o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B6E1F000C0;
	Wed, 25 Nov 2026 16:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623185;
	bh=eW9wM7bs65/Z/73mtoEsXVZ0h5Zs0Y66xpgvp5bU+EI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SR1M9g5oD9zi3DyIRmP3LNgGrc+ME9OVkhPSjf6ZSWKjAoV9kEBlrz6+6H2vEw2GO
	 w44y1eOEcolj8K+afrZF8WuiSFEUVBQQkrcpZR/0By9flfgHmWtMwC8BTBAYWsLiSh
	 8Gkifzv0qYJWsuwb1dQqdrz4WPCgVr4o4LAasNMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rupesh Majhi <zoone.rupert@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 776/990] hwmon: (aht10) Fix update_interval overflow on 64-bit
Date: Wed, 25 Nov 2026 15:35:43 +0100
Message-ID: <20261125143840.229005253@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rupesh Majhi <zoone.rupert@gmail.com>

commit b5c5b67e02406fb48acf57cf2c30a570230fd6aa upstream.

On 64-bit, update_interval writes are clamped to LONG_MAX ms, but
ms_to_ktime() overflows above 9223372036854 ms and the interval wraps.
LONG_MAX becomes -1 ms, so every read starts a new measurement and
update_interval reads back -1.

Clamp to INT_MAX like sht4x, so the limit is the same on all platforms.

Fixes: 8c78f0dee437 ("hwmon: Add AHT10 Temperature and Humidity Sensor Driver")
Cc: stable@vger.kernel.org
Signed-off-by: Rupesh Majhi <zoone.rupert@gmail.com>
Link: https://patch.msgid.link/20261108172651.220121-1-zoone.rupert@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/aht10.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/aht10.c
+++ b/drivers/hwmon/aht10.c
@@ -229,7 +229,7 @@ static int aht10_read_values(struct aht1
 static ssize_t aht10_interval_write(struct aht10_data *data,
 				    long val)
 {
-	data->min_poll_interval = ms_to_ktime(clamp_val(val, 2000, LONG_MAX));
+	data->min_poll_interval = ms_to_ktime(clamp_val(val, 2000, INT_MAX));
 	return 0;
 }
 


