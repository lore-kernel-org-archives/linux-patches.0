Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31F3351C2E;
	Wed,  8 Apr 2026 18:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673354; cv=none; b=UfkYxyenJOYsbMv1yoFIJYge9C+TOZ7K2kC+UnbDK0QSPQnZrgCndW34Okicv+20DMoQEgWa7Jn20c87r8n6s4fdWulEnAwgut//AxuC3tNiENO7jm3y/PsbIVh53OkZD1K67ULgt+XJekVezoxx2ab1kQZoWZIiYmrGFBgrd60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673354; c=relaxed/simple;
	bh=q5MHcz58saa6vyp8BGyx/QDQRc2BFpoFjNDC5uOUXog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jUKLTxbtDa0LBNcyVkvGBx6mUmq/UC8dORe7Pd6WvNJPGjrwfbj31atKHzBWcKXy7jE2cWGKK2FsnRYi9kNJ5nrNmNLEtYK8LJZ9XfUkfc3C9KWgFg5YmDZZtC1bKeSkg9Dd5Y1QyZnqR3GbN6E1AMZJhP5lW8TFwEBK3ooig1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n+7gObEH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n+7gObEH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B99EC19421;
	Wed,  8 Apr 2026 18:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673353;
	bh=q5MHcz58saa6vyp8BGyx/QDQRc2BFpoFjNDC5uOUXog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n+7gObEHApClgao+Pw+svfeU4Uma32aBjqfGsqqsrAZBFfkK0c0zP3Q3vsxLh3XFU
	 BkN2p+9QFeA7szb0PYi98xnXe6daG4pfy9+WupKi47f+1tJ92pqIX35seO4/YaG+QG
	 ATg/uEKcNeU6R7OvbLAw+7ngnC4Q+2tKkZsCJrck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9a3c54f52bd1edbd975f@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Heitor Alves de Siqueira <halves@igalia.com>
Subject: [PATCH 6.18 199/277] usb: usbtmc: Flush anchored URBs in usbtmc_release
Date: Wed,  8 Apr 2026 20:03:04 +0200
Message-ID: <20260408175941.294625011@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heitor Alves de Siqueira <halves@igalia.com>

commit 8a768552f7a8276fb9e01d49773d2094ace7c8f1 upstream.

When calling usbtmc_release, pending anchored URBs must be flushed or
killed to prevent use-after-free errors (e.g. in the HCD giveback
path). Call usbtmc_draw_down() to allow anchored URBs to be completed.

Fixes: 4f3c8d6eddc2 ("usb: usbtmc: Support Read Status Byte with SRQ per file")
Reported-by: syzbot+9a3c54f52bd1edbd975f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9a3c54f52bd1edbd975f
Cc: stable <stable@kernel.org>
Signed-off-by: Heitor Alves de Siqueira <halves@igalia.com>
Link: https://patch.msgid.link/20260312-usbtmc-flush-release-v1-1-5755e9f4336f@igalia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/usbtmc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -254,6 +254,9 @@ static int usbtmc_release(struct inode *
 	list_del(&file_data->file_elem);
 
 	spin_unlock_irq(&file_data->data->dev_lock);
+
+	/* flush anchored URBs */
+	usbtmc_draw_down(file_data);
 	mutex_unlock(&file_data->data->io_mutex);
 
 	kref_put(&file_data->data->kref, usbtmc_delete);


