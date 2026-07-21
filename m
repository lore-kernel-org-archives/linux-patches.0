Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F74D44330D;
	Tue, 21 Jul 2026 22:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672327; cv=none; b=Svaj1xrtYSElCPJk8mosXw+TVS4fXUxdfZcSoYAKFTLUL/wKregCW3J2H+B4R5KxXQwUC7uKeu2IH/IqYHLgwSjbldeGuqvC+bOCIFw9ZQ+LDnDVp5X+84elv4d/iAOET7H9IWr20CZrWFvVreui0E84s79mJwgj3tZCbfqzR64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672327; c=relaxed/simple;
	bh=+dltU+MTe9KX/3oay4vYSppZ6Sv/Gx4oCMav8FW5RHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M9UFuqkF3A9DwMscs9eFNOM+NqPqhy2ZWDKzjZbYdbs1W1EenUohBq40+fyceH3ZR9M6/U/I6oRHqZFBDHogG/n1dpAdU/u1rGT8g1Umy6k1oFQhlUpOcAhhsRQYSLXajJRXRBI7W57OXaAj3Wp7pl4BCp3G9FqGPcHR8EVv5/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ipcs5dFQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ipcs5dFQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 957971F00A3A;
	Tue, 21 Jul 2026 22:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672325;
	bh=cubVAU55GtCw1/Q66H0loUOkMve8a41Yk4CK9py+O78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ipcs5dFQMj2dfxog6L3HXa03ci+5lRqKC6/khBW3dBAb1EZdpQJXKlp6YgO04Ihzk
	 yQvircaRpyfiExaG5SuIKktpKz1SDBcFMQ7tm1QMLwc3Ut3bBso2foRns9Sixkgpai
	 Nw7QSZ7Fh9UTP3kcVGfT29xnkhxziq2DPLqhugJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.15 580/843] gpu: host1x: Fix device reference leak in host1x_device_parse_dt() error path
Date: Tue, 21 Jul 2026 17:23:35 +0200
Message-ID: <20260721152419.094932793@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

commit e75717f9aec04355777be41070890c6a815c76df upstream.

After device_initialize(), the embedded struct device in struct
host1x_device should be released through the device core with
put_device().

In host1x_device_add(), if host1x_device_parse_dt() fails, the current
error path frees the object directly with kfree(device). That bypasses
the normal device lifetime handling and leaks the reference held on the
embedded struct device.

The issue was identified by a static analysis tool I developed and
confirmed by manual review.

Fix this by using put_device() in the host1x_device_parse_dt() failure
path.

Fixes: f4c5cf88fbd50 ("gpu: host1x: Provide a proper struct bus_type")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Acked-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20260413141526.2961841-1-lgs201920130244@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/host1x/bus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/host1x/bus.c
+++ b/drivers/gpu/host1x/bus.c
@@ -473,7 +473,7 @@ static int host1x_device_add(struct host
 
 	err = host1x_device_parse_dt(device, driver);
 	if (err < 0) {
-		kfree(device);
+		put_device(&device->dev);
 		return err;
 	}
 


