Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0143B8412;
	Tue, 21 Jul 2026 21:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670077; cv=none; b=Yyn8MbfWx99+lRvnfwWNYmDSp4Z+VF9s8DCrJCfPLO0OlKp9+K7F6Iw1j8zmqg6/tyyTThObLEIRi8ozTUNkpBuhSPZa9+dX33dRFIsRR4+1kDvhl0FvnkIQibenbadMQQNbrc/ReGZD79IDx289i2c+HUOAC3Mlu0SkMjR7gIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670077; c=relaxed/simple;
	bh=J93LXLiBsLggDh3zjaurX95AjN2Fj33sXCLR8iCCBHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cxpaSysuQ/AzVbJbyJz4arxHrVieIUSwNqz58jxMysbrl8flk/8hd+dRBaDs49lL1ByJcdjtrkmwsIDLz5op8NUn1pDojTunzwFN2sWDOjxCSzqv+uw6DPSgdkSo8ukPedt7ucFbXC+FVSWulvOENopsGowOnIJHml2ouFHxBRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZpuvbW4Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZpuvbW4Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6411F000E9;
	Tue, 21 Jul 2026 21:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670076;
	bh=o/oQH1FyypqguplP/0/FIYfPTSD+/Hn4/UrwKYwtXJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZpuvbW4QAO6igXNrT/5eD8+c/4zvw4Q9+zgCQbF/ao4PCTPvGqFL2Zw306toi0rFz
	 vQ4qXwy+pHcJ6kA4gIcrZB+wLexYnsBJyelak0Cu4lK6fvT4z1ykxGlxuwYkiafCr2
	 OUlihBdfFMKxyejw3BwjLg9+/DYL00NQh+UiUjko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 6.1 0752/1067] gpu: host1x: Fix device reference leak in host1x_device_parse_dt() error path
Date: Tue, 21 Jul 2026 17:22:33 +0200
Message-ID: <20260721152441.396915197@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
@@ -474,7 +474,7 @@ static int host1x_device_add(struct host
 
 	err = host1x_device_parse_dt(device, driver);
 	if (err < 0) {
-		kfree(device);
+		put_device(&device->dev);
 		return err;
 	}
 


