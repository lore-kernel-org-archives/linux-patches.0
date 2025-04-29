Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEFC1C6B4;
	Tue, 29 Apr 2025 17:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947164; cv=none; b=jkL8v5Uv4WG9iHTqgSJPBAh9yszFJqnefvvPaR7pml78lGQIXy6NhAKHSP1V9JMt2sWPZRi8Ct1VM8ZzvJAT4oXVtFspwb4qY9TsUYgChnnlenB6lIy8AzjhLy0AV8eVj7+UJyr4sTH5ET0BbSdv+h1Kcf9moAtxUSQeWvMFS0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947164; c=relaxed/simple;
	bh=UxZWHBx0AUNYtZWefu8O+aCqt+z9Dis+2fFd7N8bYU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vDHI+zGJ0xRfAXgR4hqbP9z8XNpWzffkzwRaSHwizXGvHkF/sU3+axECjSR88516kZasnHWbYDPoPo5Vj9Yy3o23ysk2LI5PsMgAzvc+82t+Pu0BCUiEf3Mm/AvfBbGdC7heDbyrEuglss/m/ny1TEtvaeUkFJtzMaOScPQGk3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=troQZlUq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="troQZlUq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA06C4CEE3;
	Tue, 29 Apr 2025 17:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947163;
	bh=UxZWHBx0AUNYtZWefu8O+aCqt+z9Dis+2fFd7N8bYU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=troQZlUq6uDldcGSf3H2wjhpXXajpVqo/W2d9Gh6iLB+nP3IxeXz5YI0MnzIO5RSR
	 8tTEUp6OWNKkb1SMOZSNii+Mg6Qxe1M4fWg0/t4KnMoltmpXw/m3BbBzZWMJm7rZ4o
	 W3N/P9xNiJwhomj580+l4ZpPHLLQ1fkHCsJBVEKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miroslav Franc <mfranc@suse.cz>,
	=?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Feng Liu <Feng.Liu3@windriver.com>,
	He Zhe <Zhe.He@windriver.com>
Subject: [PATCH 5.10 191/286] s390/dasd: fix double module refcount decrement
Date: Tue, 29 Apr 2025 18:41:35 +0200
Message-ID: <20250429161115.824900268@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miroslav Franc <mfranc@suse.cz>

commit c3116e62ddeff79cae342147753ce596f01fcf06 upstream.

Once the discipline is associated with the device, deleting the device
takes care of decrementing the module's refcount.  Doing it manually on
this error path causes refcount to artificially decrease on each error
while it should just stay the same.

Fixes: c020d722b110 ("s390/dasd: fix panic during offline processing")
Signed-off-by: Miroslav Franc <mfranc@suse.cz>
Signed-off-by: Jan Höppner <hoeppner@linux.ibm.com>
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Link: https://lore.kernel.org/r/20240209124522.3697827-3-sth@linux.ibm.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[Minor context change fixed]
Signed-off-by: Feng Liu <Feng.Liu3@windriver.com>
Signed-off-by: He Zhe <Zhe.He@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/block/dasd.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -3637,12 +3637,11 @@ int dasd_generic_set_online(struct ccw_d
 		dasd_delete_device(device);
 		return -EINVAL;
 	}
+	device->base_discipline = base_discipline;
 	if (!try_module_get(discipline->owner)) {
-		module_put(base_discipline->owner);
 		dasd_delete_device(device);
 		return -EINVAL;
 	}
-	device->base_discipline = base_discipline;
 	device->discipline = discipline;
 
 	/* check_device will allocate block device if necessary */
@@ -3650,8 +3649,6 @@ int dasd_generic_set_online(struct ccw_d
 	if (rc) {
 		pr_warn("%s Setting the DASD online with discipline %s failed with rc=%i\n",
 			dev_name(&cdev->dev), discipline->name, rc);
-		module_put(discipline->owner);
-		module_put(base_discipline->owner);
 		dasd_delete_device(device);
 		return rc;
 	}


