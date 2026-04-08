Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9FFE324B1F;
	Wed,  8 Apr 2026 18:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672775; cv=none; b=LOpf1Nfqx4Ka67qP4BZ312pCoMBm0x/UqE2JX589ClveIFceLGRgtTfiGByV8Q/JXNvc8CzWCMFfwGG82V910Fhyun867zPZESUaPR3cplGIG2YJoG4J2I0QArCUkMXlynZhXh242wxzNqoC5EBEQoVw7sKNtzSB6am08jDo5ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672775; c=relaxed/simple;
	bh=5Cwdn5cA0F0ll7zawiZVzEu7kkK2cRTLiypTNasjgZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VWutf6rlwdHWogwfwY2PomTcqH/0DTpLTchmgVfry+O9n4j1daWP+xwLyyM5sLbxgA2z6qsMJjRjcNnKA9BRCQt4SuMKjDZ9FgZ8r//cyHMJBt0oSa4PE6ziDCc7HvcEENH/kTYzN3H6H94OYPWxmglIRqR7YJb5tbChYUwxE8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NSa6xkog; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NSa6xkog"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40458C19421;
	Wed,  8 Apr 2026 18:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672775;
	bh=5Cwdn5cA0F0ll7zawiZVzEu7kkK2cRTLiypTNasjgZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NSa6xkogOfivyqgOO65HGADdMBZPmoOQOJIO5iCg/+eyp3LEbLCKxLjeY8x0wkoPm
	 ficVw0uIAhxYhS/7cBlMyzprsh2yJG0tFAf/8gSQtgY2t6Ocyzt75Vd+XlAFy1heh6
	 AbQHF9SaKUiJu2Om27Ohp04tDm3f2WmztyQ/GmIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.6 105/160] usb: ulpi: fix double free in ulpi_register_interface() error path
Date: Wed,  8 Apr 2026 20:03:12 +0200
Message-ID: <20260408175917.102538180@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 01af542392b5d41fd659d487015a71f627accce3 upstream.

When device_register() fails, ulpi_register() calls put_device() on
ulpi->dev.

The device release callback ulpi_dev_release() drops the OF node
reference and frees ulpi, but the current error path in
ulpi_register_interface() then calls kfree(ulpi) again, causing a
double free.

Let put_device() handle the cleanup through ulpi_dev_release() and
avoid freeing ulpi again in ulpi_register_interface().

Fixes: 289fcff4bcdb1 ("usb: add bus type for USB ULPI")
Cc: stable <stable@kernel.org>
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260401025142.1398996-1-lgs201920130244@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/common/ulpi.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/usb/common/ulpi.c
+++ b/drivers/usb/common/ulpi.c
@@ -331,10 +331,9 @@ struct ulpi *ulpi_register_interface(str
 	ulpi->ops = ops;
 
 	ret = ulpi_register(dev, ulpi);
-	if (ret) {
-		kfree(ulpi);
+	if (ret)
 		return ERR_PTR(ret);
-	}
+
 
 	return ulpi;
 }


