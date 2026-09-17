Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBBDB4FD29C;
	Thu, 17 Sep 2026 17:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667163; cv=none; b=hX6ljBhnfLzXD9pdKV0hvx2047xQJ4Yg6fvHBCD/iJk4A6J243LxiGXfDjCozHeZ78dO7uyiTvikThNiLSKTfIdZFMzIVuR8SwuH0HG2KX53ZGN3Mm9CUqhhthJnT0lRlTp+Tpts23BsMS1Aanv+MKR0o3cPAx6vGp2bVb+CJz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667163; c=relaxed/simple;
	bh=1H/fsx+J5aco314ob4zZDfiwy3NVd9oqe7Kv52H9NXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BGR8RBWZTODGyhM6iST9vrgGh46QbOdl1EAWi+UnaivdAOm/scHHgOAnJQ0SRuqFUmXRUVQjdIHLcv9tj0SRKUEQiiTxiUoxAHelir3/qfC8mnwh8Ta2udnxhzrgWDyxO/Aqh9yWpCwrOq+etQK/ZcTP+WPxUhZDs4HfRfEcJIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X+OLWoGG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X+OLWoGG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D9341F000FF;
	Thu, 17 Sep 2026 17:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667161;
	bh=5YYAU1qkDVe/jMRDLHPyuQWa50q0jEaxbzyx7g/qi+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X+OLWoGGAOoxvV/o62yGqgSJKCToXR+IvRhN0/WZfda335xaNS2vhq49PEItvlQkC
	 /Tcw/MFZMJWVPAe0yFXrDKvRszEMLX/OkbqhduIfzIy/SxC0yNiZ0Swa/SCDCLJ4CS
	 rKIQJWZWgJUh85WpYG5uPA7IGUg1Fq43Fl6m9ZPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Naveen Krishna Chatradhi <naveenkrishna.chatradhi@amd.com>,
	Akshay Gupta <Akshay.Gupta@amd.com>,
	Griffin Kroah-Hartman <griffin@kroah.com>
Subject: [PATCH 6.18 1249/1250] misc: amd-sbi: Add null check for devm_kasprintf()
Date: Thu, 17 Sep 2026 16:17:24 +0100
Message-ID: <20260917151626.154634896@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Griffin Kroah-Hartman <griffin@kroah.com>

commit 1bb5c324b872c2e71fa1b12a5f59615b994501da upstream.

Add two checks for devm_kasprintf() errors in create_misc_rmi_device(),
returning -ENOMEM if the function failed.

Assisted-by: gkh_clanker_t1000
CC: Arnd Bergmann <arnd@arndb.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Naveen Krishna Chatradhi <naveenkrishna.chatradhi@amd.com>
CC: Akshay Gupta <Akshay.Gupta@amd.com>
Signed-off-by: Griffin Kroah-Hartman <griffin@kroah.com>
Link: https://patch.msgid.link/20260709132052.211683-1-griffin@kroah.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/amd-sbi/rmi-core.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/misc/amd-sbi/rmi-core.c
+++ b/drivers/misc/amd-sbi/rmi-core.c
@@ -471,6 +471,8 @@ int create_misc_rmi_device(struct sbrmi_
 							 GFP_KERNEL,
 							 "sbrmi-%x",
 							 data->dev_static_addr);
+	if (!data->sbrmi_misc_dev.name)
+		return -ENOMEM;
 	data->sbrmi_misc_dev.minor	= MISC_DYNAMIC_MINOR;
 	data->sbrmi_misc_dev.fops	= &sbrmi_fops;
 	data->sbrmi_misc_dev.parent	= dev;
@@ -478,6 +480,8 @@ int create_misc_rmi_device(struct sbrmi_
 							 GFP_KERNEL,
 							 "sbrmi-%x",
 							 data->dev_static_addr);
+	if (!data->sbrmi_misc_dev.nodename)
+		return -ENOMEM;
 	data->sbrmi_misc_dev.mode	= 0600;
 
 	return misc_register(&data->sbrmi_misc_dev);


