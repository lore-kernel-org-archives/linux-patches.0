Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033A047798F;
	Tue, 16 Jun 2026 16:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628009; cv=none; b=n80GriJ7ZILEo85VYZqhYO4+U8qfqomTYSfBr+HWejAkZYodeEOyBYLE7Fxxg13vvXpKVNNsIdT/tZHYtMNxwV/uEVXx4MVKJ0iRVwWzHcshmQ2V0u8h3wxwELaejJy8ttBlXy4YW7g86G4rcvULzDQczDMinwv30l/LRmQdHdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628009; c=relaxed/simple;
	bh=aRMBjq/t3aaM+Blc4IWyBwrDsYg3K9YEXXVxkyXQiHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJtLjbOMBxwRiP/68A7cP5ZnENC4nMIZO1gF2whD3JH+WZOZrlC5SdeFYLWN0HulfNNMNs/G7oP7kmf8lDj1u0zIIKB/eRmFJks2mdLdO9u9ETPLrHFk++T7UWRAgcdoVxpkoV/W8qy0nKOziE8nBYzi2wFOKbl3kgagOjQy5HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E1LFR+YA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E1LFR+YA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B929B1F000E9;
	Tue, 16 Jun 2026 16:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628007;
	bh=urSiDip98pzM6j1EMx4D0WdPGD1Kbo+D9gd/ZGAgYYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E1LFR+YA/HFcKJTaeUaqza2J+qTRcMzDJaKE9uU9kEFNh7Ue3BR+fA5fjR4cyl+K3
	 q7aQ1y2EBm+m3zx0hhRxmVGtlW7uVPwSmtAHoAzQz9HDc6HvDU8wvgsbrWsbZjnRZv
	 qu0w8jmXGxXnEQZXFJnAJ2kmsnRLPzg9GTi1lLFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corey Minyard <corey@minyard.net>
Subject: [PATCH 6.12 246/261] ipmi:ssif: NULL thread on error
Date: Tue, 16 Jun 2026 20:31:24 +0530
Message-ID: <20260616145056.481376950@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_ssif.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -1907,6 +1907,7 @@ static int ssif_probe(struct i2c_client
 					"kssif%4.4x", thread_num);
 	if (IS_ERR(ssif_info->thread)) {
 		rv = PTR_ERR(ssif_info->thread);
+		ssif_info->thread = NULL;
 		dev_notice(&ssif_info->client->dev,
 			   "Could not start kernel thread: error %d\n",
 			   rv);


