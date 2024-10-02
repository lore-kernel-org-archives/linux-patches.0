Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A111E892;
	Wed,  2 Oct 2024 14:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880375; cv=none; b=K3SSvNuoVnYsSHsJR1HJP2Ho6l3APbGZwsn0cwt2PBG7fvW/VxuVHyMnxJRiT6g4gbqvBH6zjkbywqp1t4e5wfedaDp5riFeB5RQdPU4GNHqvNqORlRIDDDwil9Daa3FjhsXSuwHVOsyvD0tsj1oUHL15Npjb4cEwfRK1DdfRMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880375; c=relaxed/simple;
	bh=gHt8nUA8dkQk/Hx/36J2KCQl+zGG41+bPI/nthl9GB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E8Amp2OfRIzBrgrxyL0KgKeupEUmxQ6ZlJOKek/tVWWuSr54Ie4Hn1jv/oj3y21XFVLJzSN0EMP+ZE1wy7X8fqUyZxI+H9YuoSg+wbfiYWpMU4bWuCSPhTRssHdt4OoK8StdyXh8d4LFScGBvywK8ebh/zRrbh53PQVxe71a5fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wPRUywKx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wPRUywKx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E88C4CEC2;
	Wed,  2 Oct 2024 14:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880375;
	bh=gHt8nUA8dkQk/Hx/36J2KCQl+zGG41+bPI/nthl9GB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wPRUywKxLigRxd2CQwSfbx8x3krHTJwV6lubIqhCjH0X/YX73keQArUTiCOLgQcjN
	 DyGH2ueGUwx8qVva7g9oUY7fpAA6s7H5JsH2QAJ7GbAJKU7xXJvmlfo8RU0jsJNnOD
	 kbRBgqHGqJL50rDne0xn2OzYO6Ec2rt0Xa+OJ2d4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 406/538] Input: adp5588-keys - fix check on return code
Date: Wed,  2 Oct 2024 15:00:45 +0200
Message-ID: <20241002125808.462205513@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Nuno Sa <nuno.sa@analog.com>

commit eb017f4ea13b1a5ad7f4332279f2e4c67b44bdea upstream.

During adp5588_setup(), we read all the events to clear the event FIFO.
However, adp5588_read() just calls i2c_smbus_read_byte_data() which
returns the byte read in case everything goes well. Hence, we need to
explicitly check for a negative error code instead of checking for
something different than 0.

Fixes: e960309ce318 ("Input: adp5588-keys - bail out on returned error")
Cc: stable@vger.kernel.org
Signed-off-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20240920-fix-adp5588-err-check-v1-1-81f6e957ef24@analog.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/keyboard/adp5588-keys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/keyboard/adp5588-keys.c
+++ b/drivers/input/keyboard/adp5588-keys.c
@@ -627,7 +627,7 @@ static int adp5588_setup(struct adp5588_
 
 	for (i = 0; i < KEYP_MAX_EVENT; i++) {
 		ret = adp5588_read(client, KEY_EVENTA);
-		if (ret)
+		if (ret < 0)
 			return ret;
 	}
 


