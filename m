Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF27244AB61;
	Tue, 21 Jul 2026 21:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668455; cv=none; b=Q1sOngdRYpMZyxIb4TkT7Usq3VVm47oCLNXqAbMKr8oW1yd7LKOtuenj6tT+XWXH0Om0bC5y9rqbMhSfC94uqRVkbST2qyPCygdw6sBngrUxdalzNZzT8/XZkILpU/kGcXgradZeKdMsnJnkAGyBxLIOH6JkPdxQevA0kkPYgxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668455; c=relaxed/simple;
	bh=j0tZbKDSJMOWQsBfsH9Ayyga/cAnKjUiQHiG140lkyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+MGkllhUv3dSft/m+xTb9/zC/+BIRJKadDCoc/IxoX0/ML3eeil2yKFM17Dfy8BDSDatiIojSVzQ1maF6TXzTOom0PW64C2RQQfyXpXx8pwg9pRuqjt0McYkzMlCdQK/AGSGHLPHxEtwbghEBmyYaKKXeRjDwDryrvBNSKT6Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tiG8zsr+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tiG8zsr+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 406FB1F000E9;
	Tue, 21 Jul 2026 21:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668454;
	bh=QvZxuN6qrO0FkqB6sJLoaAjULWNpyFgxT7xxTL1GOek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tiG8zsr+ie2vtnNPicsKW/ZVtZzzr6cVwNuR3+nXEhcCXR2PWTjr7tymkpV4Yz/wv
	 LaSIMw+/A1Q3BJ6Y9BfevCz57pkGB4YHUQ6n+daAQYr4mWmK/Ufas3CECAGw+64KwQ
	 0PPSoP5ZkqoFhS8O1sAGX7idbSza3KbJKCwwN1u8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 0181/1067] USB: serial: keyspan_pda: fix information leak
Date: Tue, 21 Jul 2026 17:13:02 +0200
Message-ID: <20260721152428.640690536@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 6bfc8d01ac4068eced509f8fc74d0cd205e4dcec upstream.

The write() callback is supposed to return the number of characters
accepted or a negative errno. Since the addition of write fifo support
the keyspan_pda implementation will however return the number characters
submitted to the device if the write urb is not already in use. If this
number is larger than the number of characters passed to write(), the
line discipline continues writing data from beyond the tty write buffer.

Fix the information leak by making sure that keyspan_pda_write_start()
returns zero on success as intended.

Fixes: 034e38e8f687 ("USB: serial: keyspan_pda: add write-fifo support")
Cc: stable@vger.kernel.org	# 5.11
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/keyspan_pda.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -514,7 +514,7 @@ static int keyspan_pda_write_start(struc
 	if (count == room)
 		schedule_work(&priv->unthrottle_work);
 
-	return count;
+	return 0;
 }
 
 static void keyspan_pda_write_bulk_callback(struct urb *urb)


