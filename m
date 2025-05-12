Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91A521770B;
	Mon, 12 May 2025 17:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072113; cv=none; b=ne+Vw6OgS9+Oe1iyRAD+ZPI5x/7dog8FjU5rYZuvutFzV9Rf/hIbE0JTsbRlOhQq8H5Z8pDnHi8L3hKcx7mZ+ZTkH842leZZwsTE9qvVVnsDhznK6mxrJGFXzC6niKo1TClzq4L52jL9l/zwq95yUJuksNML28wHiM5VoneeMU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072113; c=relaxed/simple;
	bh=c5dkxJ6fEgGW2jcHOp76Tf6JxFoFnIKWT3ipwaoalG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k290FlshNHE4ARW79fq0vYSUEsgYF+jhX0/9RK1DTHCMysTcn3EzY+ltbCbfNP2Ip/oG5eY4xX8ZeIwXvv18vISQPHlFe09jTgfESShL5fKai6cuY/N9DsKpek4UAGyHvrilyUSJhEbh4+REReUUlyPrdxndK6ODpHmBXbhxmQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f8CC32Vi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f8CC32Vi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 708CFC4CEE7;
	Mon, 12 May 2025 17:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072112;
	bh=c5dkxJ6fEgGW2jcHOp76Tf6JxFoFnIKWT3ipwaoalG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f8CC32Virk62WMlqk1Y+xG+Z1kfn2ZwmUBpjBOn3pDSrWPAbtWVgXLPetmKyyTNHA
	 e3TheOJdeCklps2xQ0Gd1A8mxc2I7kuFApb8sqBsTDAoRpZv+N1GkPdx5QnBL/La7e
	 GitIBaBjB9rohpKH/AXYEuAMvlJfVm45VqViF7lY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6.14 145/197] USB: usbtmc: use interruptible sleep in usbtmc_read
Date: Mon, 12 May 2025 19:39:55 +0200
Message-ID: <20250512172050.296872554@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

commit 054c5145540e5ad5b80adf23a5e3e2fc281fb8aa upstream.

usbtmc_read() calls usbtmc_generic_read()
which uses interruptible sleep, but usbtmc_read()
itself uses uninterruptble sleep for mutual exclusion
between threads. That makes no sense.
Both should use interruptible sleep.

Fixes: 5b775f672cc99 ("USB: add USB test and measurement class driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20250430134810.226015-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/usbtmc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -1380,7 +1380,10 @@ static ssize_t usbtmc_read(struct file *
 	if (!buffer)
 		return -ENOMEM;
 
-	mutex_lock(&data->io_mutex);
+	retval = mutex_lock_interruptible(&data->io_mutex);
+	if (retval < 0)
+		goto exit_nolock;
+
 	if (data->zombie) {
 		retval = -ENODEV;
 		goto exit;
@@ -1503,6 +1506,7 @@ static ssize_t usbtmc_read(struct file *
 
 exit:
 	mutex_unlock(&data->io_mutex);
+exit_nolock:
 	kfree(buffer);
 	return retval;
 }


