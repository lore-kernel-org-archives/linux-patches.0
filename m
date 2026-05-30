Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F4F25B095;
	Sat, 30 May 2026 17:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163539; cv=none; b=AwCudequWVXj8c+nZ715cZdjPwWbZaR2Ls6FyGtgwP3LrqT349T9Cw9jurQz+j2dDwppIIp+2XXzLcXdO4sHCs3nrsZabyINUhEoKdw04XgJpf4tX0YLHclIBYw6RQG/z9ycrRNydh8iA4jOypLmAj2N+CeVFJJRSp8bJTdpuIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163539; c=relaxed/simple;
	bh=WrEI/KQkpnRlwX9Y6fSpsgSeKxAfzXDARzkKEbNtOBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VSfAknl/Ww0hspgPdHDV90v/gqKuZhLIpF4CPq7uVRq7wQjftY/eq9jzsQi+8tKadlO2EDa9faUxpmSxvHWguWVV0blD1PcNL3j1labb95vNgvM53lI5Y8v2pLE9dxBV1NqJoRUWv+KHZwBUsWHAk2xcUlnq2bq5iOz4JX8U0rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MC/trEgd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MC/trEgd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D5B91F00893;
	Sat, 30 May 2026 17:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163538;
	bh=W6PjP2adjbKnUFxf4RoBhmHOHj+9DCrcNMPy7nLbFYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MC/trEgdO9Ims7IrzqDC//3gd2bgRSKp6ItbiZ3LZEwKqfylPoTAlWVFJfTk6cYxg
	 /imTInw/LBoCtTNSyKC0vuivLRA7+GF0ap1BoUe+Gu/7ralnen90dMaaKvYfaOGTNl
	 a9DjXQiK8N7ERsJyeF+Ai1gi1s/arFb3eq0ooyW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 288/776] ipmi:ssif: NULL thread on error
Date: Sat, 30 May 2026 18:00:02 +0200
Message-ID: <20260530160248.001585587@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Corey Minyard <corey@minyard.net>

commit a8aebe93a4938c0ca1941eeaae821738f869be3d upstream.

Cleanup code was checking the thread for NULL, but it was possibly
a PTR_ERR() in one spot.

Spotted with static analysis.

Link: https://sourceforge.net/p/openipmi/mailman/message/59324676/
Fixes: 75c486cb1bca ("ipmi:ssif: Clean up kthread on errors")
Cc: <stable@vger.kernel.org> # 91eb7ec72612: ipmi:ssif: Remove unnecessary indention
Cc: stable@vger.kernel.org
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_ssif.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/ipmi/ipmi_ssif.c b/drivers/char/ipmi/ipmi_ssif.c
index e93846f8f2352..4cbfe1858ab4f 100644
--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -1910,6 +1910,7 @@ static int ssif_probe(struct i2c_client *client, const struct i2c_device_id *id)
 					"kssif%4.4x", thread_num);
 	if (IS_ERR(ssif_info->thread)) {
 		rv = PTR_ERR(ssif_info->thread);
+		ssif_info->thread = NULL;
 		dev_notice(&ssif_info->client->dev,
 			   "Could not start kernel thread: error %d\n",
 			   rv);
-- 
2.53.0



