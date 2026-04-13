Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E519623C8C7;
	Mon, 13 Apr 2026 17:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099651; cv=none; b=WF0BULD3H3cULFudOhwVLeM3G88YJLyHSrHOvUWlHREYnYkMQ9NU5O54tqN6PZM0tE9IXa3WN9VAe27Gis2BvGy1hj8Vd6FMbBawJc8vqQSRExfZDsJZJG+g8LFxgarivzfZZ24aYnItP2FhFDuctvQu3/8/PirZ/kSRJ4jcmnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099651; c=relaxed/simple;
	bh=G3At/tOmrejQRFU+B8fnzj/k0VRoUcEEA+T+tVX7Op8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bi7Dw7emLntTAP5HIVftqmmEWwM/a6Cd8J/6u8JZHhdcbUVpCDnIiz1AmV9Yngwrzi6skUW+VggmRThtUOkK7ueDaCauMz8eKvk9j4rc3yP2S+Klqp0GMBWOA8w1UMVSbdglJrI6TlVflijI43+asTxDfTBNGPco8pMX8qkJ8Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s7OLHl36; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s7OLHl36"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72675C2BCAF;
	Mon, 13 Apr 2026 17:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099650;
	bh=G3At/tOmrejQRFU+B8fnzj/k0VRoUcEEA+T+tVX7Op8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s7OLHl36RWCE6/xm/BZgchcSPxKlQmg2+E8euHHwrQjXmSnGTJsyR252xaWim1BtQ
	 m7wmkz9Ti71RZuwREh21B5W8so7W0qsypvbxdz3IidHMy0Ru/4WRWbSg9ODYowNAPo
	 t3Kaph4cRVugCSn9HTMtvmmJEt5T7XMNMNN29u+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9a3c54f52bd1edbd975f@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Heitor Alves de Siqueira <halves@igalia.com>
Subject: [PATCH 5.10 389/491] usb: usbtmc: Flush anchored URBs in usbtmc_release
Date: Mon, 13 Apr 2026 18:00:34 +0200
Message-ID: <20260413155833.598508585@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


