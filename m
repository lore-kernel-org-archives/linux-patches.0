Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E90251788;
	Mon, 12 May 2025 17:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071103; cv=none; b=ZBzYtqt/bvk6ZuhMzqirgrlA3me5q1loXtYR9G4MDfZ7rkoOMjX6LHG2F/bA4JxU/0xEbVHdbKABcRm5j2UV/FvUrzxvo9pFukXSb4rY2QvUAVDo6bc2VeZlHw0H0/6oNQ52N2tXryM1vYLiGAa7MVntAM050tHyuoAUpHzJIRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071103; c=relaxed/simple;
	bh=BG9lis//wf3mvsaD4pacNesaZC9v4XJFb1316zhr/DI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XZzQGCvUVxDB1aZY9Wgh2lX0dRM4UB7uFersRVmuN0CimSCIWzZOBuCAuxeMD00atea6+tuZo0FUeuYuWpIe7RmGSATE9wLNjhZsV2O0j618A0SLdVGwreZ+A7qmVjzsuD/pLwlp18fqPukhu/3i4jD0PdFfnBr0KO1pj/DqfxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r+d1LZUa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r+d1LZUa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E33C4CEE7;
	Mon, 12 May 2025 17:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071103;
	bh=BG9lis//wf3mvsaD4pacNesaZC9v4XJFb1316zhr/DI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r+d1LZUaVVY2+98jJCJdC3SPYpRu2TxjQzhSrqOJ3i5z2XsuKedTjlsYV+Zt4cb1z
	 XWhtXJ11w8GJ8HXOYtS5Zb3qXfRU3n90Rj1l/INutwKIhuC0FnfKz27DFAa5gZAB56
	 lrhXQifXVuFhnBB0uFyRX9hkuazgDXVqeO/v6+ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 5.15 41/54] USB: usbtmc: use interruptible sleep in usbtmc_read
Date: Mon, 12 May 2025 19:29:53 +0200
Message-ID: <20250512172017.293717442@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172015.643809034@linuxfoundation.org>
References: <20250512172015.643809034@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


