Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F386DB67E;
	Wed,  8 Apr 2026 18:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672289; cv=none; b=qZBTHlDr/JAG3qak/N+ZPnCLvkyyzvUwWtwG8d3qo3z3+5JdjiHerIerJVQEMQ5jFbFwt4/fhEKyrJyjM9JY6Kgx5wm73ZiPvDoc71ZZkaqqSfIgHUP8ZYSlm7Q95T8rIlvxkrVaHkM5T1pAbmg9sRGrAoGde5i6DkF3b4aYvx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672289; c=relaxed/simple;
	bh=ikBq+Uj/w9p0ueBu8W5BJAWTp3YKGNT41hPRcCNd8v8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gMkwfxraA2FHNRySaWlBJTR+IdSIwQFAbKgInzaC9bcoDDb0PDyORk3n7i3IzZr1TPQgkum3GFbd2/HBQJZyuVX38Hq4UA9+z3d/HSBHJZ0eMrHOJ/OZSBnZwx5nddMUAaURngZAaauh7F7qWp/llzr1FtktrpwYymt0LH3mt2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h8StLeed; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h8StLeed"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A7F2C19421;
	Wed,  8 Apr 2026 18:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672288;
	bh=ikBq+Uj/w9p0ueBu8W5BJAWTp3YKGNT41hPRcCNd8v8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h8StLeedEhjCHMT5kM4f8Xh0FPdOz0EZtU0qmkL8N+46sdF/M9I3XgkRrsjXOSnXB
	 S5keZvULTRpfNqtbSem3fDwc3fH3fnhWCHcsu6P2cWQmTdl1lRgt8yWqhAYHopTlGj
	 rU4bUNdjrMWs+JUF0dL11wu/Y8SmlWmu/ua2ZMtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9a3c54f52bd1edbd975f@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Heitor Alves de Siqueira <halves@igalia.com>
Subject: [PATCH 6.1 229/312] usb: usbtmc: Flush anchored URBs in usbtmc_release
Date: Wed,  8 Apr 2026 20:02:26 +0200
Message-ID: <20260408175942.309234503@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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


