Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DBD3290B7;
	Wed,  8 Apr 2026 19:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674807; cv=none; b=PdO+9UHHIc9Rh1SZ+T+bOQDyliMPumtstZEMYTQDaSYK+IA/4f2WDHMMWUy+iR07njExF0C07nXug6DPFdxzko2xkOHqw/d+dmSZKMeYRpuEmOkZMl1GpC64jVEmfvdvKDMXO1n4qvdiQsI5pRWn6OfDw2y+NF8dK/kKZ2Lx9vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674807; c=relaxed/simple;
	bh=h34YvuH3qIPAjIG+08oZalKuLrz8hfEQ3q8VXqgtjp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jahjfLjL7+TahsSigJNQ6OSwsxlDyclq9JeT9+iq03ZuqlOIap1YudgMS8YEMvWphtXLVI2yAN9QEPGRMgyQKZs/qru/ATjyOWr3K+BwFRAdqjaeJiL95E5D/VY0i/1m9L7Di22NJW0T1yubeygH2nApBCm0WHLHdnmEgY21vX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sj1nowbP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sj1nowbP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C0EC19421;
	Wed,  8 Apr 2026 19:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674807;
	bh=h34YvuH3qIPAjIG+08oZalKuLrz8hfEQ3q8VXqgtjp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sj1nowbPPZZUPuSG2o5PMPJz1voLp9jE1uwhmyaNO7Nt+5eVg7ZkXEWJab+/xFbgu
	 nFpbcBFuA4iTWlEERFxrRO8uDGHM3rEYwP3vf1QAwjmHf2J9bILSs37kil9hgR8Fry
	 LrnnireRW665HEtG1sgHST3E/sRMRazwheJI4hL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9a3c54f52bd1edbd975f@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Heitor Alves de Siqueira <halves@igalia.com>
Subject: [PATCH 6.19 239/311] usb: usbtmc: Flush anchored URBs in usbtmc_release
Date: Wed,  8 Apr 2026 20:03:59 +0200
Message-ID: <20260408175948.318666044@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


