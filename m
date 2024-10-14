Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670631798C;
	Mon, 14 Oct 2024 15:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918322; cv=none; b=hAGQqg86EiacJnJn76O+pR3IXMfR1ccEwBltaTtF0TF5m1uV5K3BrjZGA5QdXRlJuWvKN4tTJMG4+9+eGfRw5ND1knxOpWwCoU2L6FFaeCDugA/YdjPMbWWlSGQ3piKzSK5tL327TIbWjg6LUeH5aUZ8NVkgsd4cOtbirN2NIxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918322; c=relaxed/simple;
	bh=A/QAb1GmxP9j5AH52DZMRCXAWLWm39BdqGKGtHYaQ08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bY1C85rAOsJ9SAFtvtfqWjUkZOqyn33Cn3ANJ7GLhsAprKqSgZMmoiYIv9AiEbxex2Z9fE4bkTDH/3+AQJAX+aZcBBYuExXZC0EZGaSiaoMDz7Dx1WES04MAyhDNGbYoVrsbRiIkO7hwfX8Gm7O5nAzWP492OFfef0ZLb9yzJVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sohdY6cf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sohdY6cf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C048EC4CEC3;
	Mon, 14 Oct 2024 15:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918322;
	bh=A/QAb1GmxP9j5AH52DZMRCXAWLWm39BdqGKGtHYaQ08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sohdY6cfcicDBhnJo6iOCAKPlIUmWmj5+DphacohOh+lN/WRl1MJnzI67NIysXQAH
	 S/N3Kta68mD1riQ6VZ91k4daFFYA/qIp075iGpMBvPp4mmbdp7PpcQKV3lg6bz0n3j
	 XmBkcWQrkUlRD+DSAfKfSNzv6l/zHet79r3b+xeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 287/798] Input: adp5588-keys - fix check on return code
Date: Mon, 14 Oct 2024 16:14:01 +0200
Message-ID: <20241014141229.219657496@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/input/keyboard/adp5588-keys.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/keyboard/adp5588-keys.c b/drivers/input/keyboard/adp5588-keys.c
index 1b0279393df4..5acaffb7f6e1 100644
--- a/drivers/input/keyboard/adp5588-keys.c
+++ b/drivers/input/keyboard/adp5588-keys.c
@@ -627,7 +627,7 @@ static int adp5588_setup(struct adp5588_kpad *kpad)
 
 	for (i = 0; i < KEYP_MAX_EVENT; i++) {
 		ret = adp5588_read(client, KEY_EVENTA);
-		if (ret)
+		if (ret < 0)
 			return ret;
 	}
 
-- 
2.46.2



