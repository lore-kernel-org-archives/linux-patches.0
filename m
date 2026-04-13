Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7602130C361;
	Mon, 13 Apr 2026 16:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098295; cv=none; b=GCsPTePGyuYNowmztkMZrsFazg7NLu9B46+FuVBdkeZOq/PKF8Ha1OzJpEh+KBFfNoA8bkLVSnfbaeD+eAlJQsBnKBHwq2xA7cf6oeXfeDr0Uy5r6G7sH/VO9mMcvfKF0UlTOITRdQmE7eareR3fY6f6wBGqNRhBUK5WNvpnduo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098295; c=relaxed/simple;
	bh=dsV8zlMkXYFjvuelF6YZ+fwZCityvFvRthsnX9qq2PY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q5xpWF0FvEpSaoy6XjuoabkdoeTN+3BlL0Ii10esJRonSpcqBR+sEZ/Fq9cgKSGTLhN6nxReD/8j/7UD0taHfubKxlJVQgImwy+4UAykcVWDYUkfUcQIL4mK8rOLq7BZEAvGVCW0hfCpCGBNi8zk33ZPMUVLcoJIeIr8Uj2CIuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p9cXSRQl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p9cXSRQl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D739C2BCAF;
	Mon, 13 Apr 2026 16:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098295;
	bh=dsV8zlMkXYFjvuelF6YZ+fwZCityvFvRthsnX9qq2PY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p9cXSRQlDuCJ+GCU5QkRi9mFbp0MgQxyEQzxGIDNyFzi0vuqsrrQzbcHl+rmIzuyG
	 cSngEiBKT90eqFUKx85RK4cRokBao+rX7VHxM8fPBGXHU/TMTSyTSNHf2QbPiLJzr6
	 Hwt3IUmqt5k2aB0YlG/N4SWPcz23HhHQVd8S25vI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9a3c54f52bd1edbd975f@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Heitor Alves de Siqueira <halves@igalia.com>
Subject: [PATCH 5.15 468/570] usb: usbtmc: Flush anchored URBs in usbtmc_release
Date: Mon, 13 Apr 2026 17:59:59 +0200
Message-ID: <20260413155847.996782228@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


