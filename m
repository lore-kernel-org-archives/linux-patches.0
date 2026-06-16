Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B481233A9EB;
	Tue, 16 Jun 2026 17:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630053; cv=none; b=aVfHWTA54YkH1he7zXC6BiUvyh1YSMz5qB4dEsT8JS9Bh+4SRb1h2VOrwx9GRkjeHpdLcFeyFn++9I+uXhEeWwbB6eyQlWYs8Jt+pdQW77/GNp8aOYS3kFm2P4X707qPKyZqa9wjAUksKtpOzfX86fk92egBN+VLsrfMbKoguhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630053; c=relaxed/simple;
	bh=hQlGI5+HEWF6Xf5k/WUMy4kL7fkvpBVp1tx6Apwcolo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G+tUj7kmGnSkDxeV0P/fGdJuCJJEFOzIi2CLnGb9Y8Tohs7qddtvz0bz/qIIx7+daTo6bjb6mj2vD25rpS6XWPZIoH03mfmqfPKfwgBjmM852xMS3xBMN9bqfaxKI6wQIgn7W+re82qlOxUSECcakCDcob5wfP9GFVVzqTiCSiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p/V3pLBi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p/V3pLBi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B7A1F000E9;
	Tue, 16 Jun 2026 17:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630052;
	bh=xpvIfoNpzZfk4/YasFGa3hhO7RGcIxTASqpSCEkQMrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p/V3pLBifDK+Q/l59XeJ5iMnr1MaBJgySF+Y+cuudDs6FOCn26haOUyoaoa2YYmAI
	 8jPmxK0cO7wuVVw669icY5grpNvBoJht2DVTA2VeB2zxd2AOgeXC8smKu5obNsi9I8
	 oKHQR1Ik4Rg8UFfsnl1vDgcY6e/BM02XNEptFh1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corey Minyard <corey@minyard.net>
Subject: [PATCH 6.6 374/452] ipmi:ssif: NULL thread on error
Date: Tue, 16 Jun 2026 20:30:01 +0530
Message-ID: <20260616145136.646603881@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1883,6 +1883,7 @@ static int ssif_probe(struct i2c_client
 					"kssif%4.4x", thread_num);
 	if (IS_ERR(ssif_info->thread)) {
 		rv = PTR_ERR(ssif_info->thread);
+		ssif_info->thread = NULL;
 		dev_notice(&ssif_info->client->dev,
 			   "Could not start kernel thread: error %d\n",
 			   rv);


