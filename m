Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0C730EF7E;
	Tue, 21 Jul 2026 19:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663563; cv=none; b=VW+maH7OrBlUCosz79RwL0CgJyOxsebdeogIba0zoi2t5wf3p242pEsRBy9ia/saenpHjIfv5g8XfBq3xnHxFvflbWup6xmwBXfsxww4ClSJUfyXUhEBOsvfSHnI58eHIHhGd0UOEBP8Hw+4TuomK1iTlAJ5O+tFY0yu/7SwALg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663563; c=relaxed/simple;
	bh=LYtQ+9l987i2sTPzBji1pMv0a+WfFbS1AtNvvIxK3h8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NcxC3jcsiSjwZpLYLHrfhKN+av6UTJaKS2XkqElhzc+aVsCkJXvu8luhNoxx4/nMbD1aMpgQSr4iKI8MSyjpZ+5G6kyr6rOoWP8qJbZkcjiHdwiet5KwPS6IXvI8NJYwIkHp0FWMBjiUFG3lLQRCrMNuUxjWGKox0wzT9qzoL9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HhR+rEL8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HhR+rEL8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD221F000E9;
	Tue, 21 Jul 2026 19:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663562;
	bh=BZ5UFHWuMcicaktoWkfSR0kk5Z9f+dLYwwMD5wqYVLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HhR+rEL8iiO705l3lTNJ0Vfg75jKSZXoo1Mq3GMvKKV/xziqhDo1RUfJWU8hz+QJ3
	 9hfKEJb8WyySeq+3YDRVUPb7/WpCWfrP+5tkZC/1fwctpDTgke5+Fq6jXkgzMRQ/PR
	 /utw6itkL882MqMWv4yfyRCz98yusWhDX1QZOau8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 6.12 0868/1276] gpu: host1x: Fix device reference leak in host1x_device_parse_dt() error path
Date: Tue, 21 Jul 2026 17:21:51 +0200
Message-ID: <20260721152505.475268603@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -457,7 +457,7 @@ static int host1x_device_add(struct host
 
 	err = host1x_device_parse_dt(device, driver);
 	if (err < 0) {
-		kfree(device);
+		put_device(&device->dev);
 		return err;
 	}
 


