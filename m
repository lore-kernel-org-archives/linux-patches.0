Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FDE515442C;
	Thu,  3 Jul 2025 15:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555273; cv=none; b=I3jOp8wdlDAiWX2CGIPD754aZpFZgkIzONg6ez7sVMQ3XFZzMvnkx5709hXpijRBwEV/+ueU/HzTOrrjs2du7jKKTCiHXSIprfLdFocffmegWk5fD/g9EYgL0uwWgOdv9O0HHiwLAJYp3kv7LrgNzl07SOKpGG3cPvVWmPCy2aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555273; c=relaxed/simple;
	bh=iFIFxYjD5wByjDNtl7apBl58/FU4tluJmLL9wQpqiOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iLHQz8X5np2uuckimw1RxUA/3i9krotRgyjRtM55RYivtJ2DBkEiNNFkcTwC8UEj23aJ0lzW1Ue3o46Kg0dHf8NTgTft88yQpLlKN9x0iopy91wpLnWyNKcOm+HbcXbzC6tg2hkAwl0sDswYukzCN/UYP8RdBlYCzginfr4slK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WCaPDNnA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WCaPDNnA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 935D3C4CEE3;
	Thu,  3 Jul 2025 15:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555273;
	bh=iFIFxYjD5wByjDNtl7apBl58/FU4tluJmLL9wQpqiOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WCaPDNnAgdch3eTMuofjrDUkRjejLTzbCnSnRR1hXjsGtHam+2LBHS0kr0F0EJWr2
	 ee1Sx0I0diZltk0aEEm7cpHCxrFaQ8N/fA7Ev6uBTb0lNeKrXab51G9I+TGSM5+nps
	 3l7uLOQDcAI2e70DgN/tTvDNbd5EGvwFmk3weTzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping Cheng <ping.cheng@wacom.com>,
	Qasim Ijaz <qasdev00@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.15 196/263] HID: wacom: fix memory leak on sysfs attribute creation failure
Date: Thu,  3 Jul 2025 16:41:56 +0200
Message-ID: <20250703144012.216580001@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qasim Ijaz <qasdev00@gmail.com>

commit 1a19ae437ca5d5c7d9ec2678946fb339b1c706bf upstream.

When sysfs_create_files() fails during wacom_initialize_remotes() the
fifo buffer is not freed leading to a memory leak.

Fix this by calling kfifo_free() before returning.

Fixes: 83e6b40e2de6 ("HID: wacom: EKR: have the wacom resources dynamically allocated")
Reviewed-by: Ping Cheng <ping.cheng@wacom.com>
Cc: stable@vger.kernel.org
Signed-off-by: Qasim Ijaz <qasdev00@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_sys.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -2058,6 +2058,7 @@ static int wacom_initialize_remotes(stru
 	if (error) {
 		hid_err(wacom->hdev,
 			"cannot create sysfs group err: %d\n", error);
+		kfifo_free(&remote->remote_fifo);
 		return error;
 	}
 


