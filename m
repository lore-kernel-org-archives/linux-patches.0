Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21560399892;
	Tue, 21 Jul 2026 17:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654329; cv=none; b=eA6NMDgeC6swFKRATebZGqN+FB4U3tPgVG2RjYJ2fqjD+VRiNf6sfqUHFfkEwMcJU5cUKZYwdsEZqc71p0q3RYVD8yO7O1g1jNf6m2rfmt27bbDkBNT8pO/apcEhafnrosCQl/W6dU4rTqq2BjOGXmYDe4FeWLDhcuefoEOam8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654329; c=relaxed/simple;
	bh=Jp3/jMFlQgzq58+1tkGCJ2+/TIDx20t+5zQmw935X7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HBKyMSfzuN7fqXjQhy+zoWX9Gsv1DU1/56JNBUKSfTDazFUmFgdrBw3R09dvt30O1TaY/q541Y4VUfCNc+r6s2yAtTLQ+d0BbrlhJ4IsJcd0Wq0q92HsUueSwZagN+E157NBIdMwcs3Ri/Dxjt1znHxOxkiWLYS09RlVflKwZXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tM8hY0uV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tM8hY0uV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8672B1F00A3A;
	Tue, 21 Jul 2026 17:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654328;
	bh=AxH+GmU64ucCvAZa0khG1KQMDAR+WiKFPcc/YclfV6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tM8hY0uVUyskPt4hANTkK155BUO5J7v7XPZ4eQkx5yeGD5DbTrloQILaUDx+HdbHS
	 wjeaQxGWJl5JvMzxi18PBeNatSq6DzBJrx2YVYnWDznsXvSwcWg4tbu9AAuVLuw2om
	 9EQAF8hHBbrDUy1lXYvclj+pyAQFF16KZpdDlfi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 7.1 1619/2077] gpu: host1x: Fix device reference leak in host1x_device_parse_dt() error path
Date: Tue, 21 Jul 2026 17:21:32 +0200
Message-ID: <20260721152630.947390424@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -485,7 +485,7 @@ static int host1x_device_add(struct host
 
 	err = host1x_device_parse_dt(device, driver);
 	if (err < 0) {
-		kfree(device);
+		put_device(&device->dev);
 		return err;
 	}
 


