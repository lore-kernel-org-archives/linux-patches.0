Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346A42DE6F1;
	Thu,  3 Jul 2025 15:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556270; cv=none; b=RQHBuZXCeT3Bw6XrcHbcMuEvcmQJ+2LKTrvgFmjVqlUD5zErf85Gn2NS8JKxoBzGrWDENWJ4GM6FyGVEtdkA4A1ZSEybyDz9+RUMkmkRg7oEUTnBybll7GNgKAvLYR/4uCrhaGAWVdc5z7aFEiwOsxGRoE4tY20GJ/kD6WI2ED0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556270; c=relaxed/simple;
	bh=JEBdxJKBI1kB/s+h3MIzqhwigJjCaFZdhhd94Bta+os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fq8V4K0PH7HMVVglIbbknGRuYxG5tlSqXjtEvY7RpUeYM00rhZh6WyQZF9GGapo82OIEkma2xYSIsabVuAs3PVYT5mZBgUpxUf1V+BB9O1PFsaoEjWVYmrBopGtwCBgdd/GW9r9A5Gjo+U053nDGq23MOlE2b+uEo3OVvSu2TKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dbmTJVwm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dbmTJVwm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E798C4CEED;
	Thu,  3 Jul 2025 15:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556270;
	bh=JEBdxJKBI1kB/s+h3MIzqhwigJjCaFZdhhd94Bta+os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dbmTJVwmwdm8vYOvnOki/EU/OcXJCbIp7B5rgdHKc28xNgCa0+gR58W0QRb7GgeG+
	 S50M6BKcJB3svjlLAC/RZ93LBHkBTMdrtHNO/6zC7rjWqV3queU1yo652rtarj4jC2
	 T6ycxZIsHybs1UNsTIShP+wsDAAGNTIvI0WjLNcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping Cheng <ping.cheng@wacom.com>,
	Qasim Ijaz <qasdev00@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.1 098/132] HID: wacom: fix memory leak on kobject creation failure
Date: Thu,  3 Jul 2025 16:43:07 +0200
Message-ID: <20250703143943.245309928@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Qasim Ijaz <qasdev00@gmail.com>

commit 5ae416c5b1e2e816aee7b3fc8347adf70afabb4c upstream.

During wacom_initialize_remotes() a fifo buffer is allocated
with kfifo_alloc() and later a cleanup action is registered
during devm_add_action_or_reset() to clean it up.

However if the code fails to create a kobject and register it
with sysfs the code simply returns -ENOMEM before the cleanup
action is registered leading to a memory leak.

Fix this by ensuring the fifo is freed when the kobject creation
and registration process fails.

Fixes: 83e6b40e2de6 ("HID: wacom: EKR: have the wacom resources dynamically allocated")
Reviewed-by: Ping Cheng <ping.cheng@wacom.com>
Cc: stable@vger.kernel.org
Signed-off-by: Qasim Ijaz <qasdev00@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_sys.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -2012,8 +2012,10 @@ static int wacom_initialize_remotes(stru
 
 	remote->remote_dir = kobject_create_and_add("wacom_remote",
 						    &wacom->hdev->dev.kobj);
-	if (!remote->remote_dir)
+	if (!remote->remote_dir) {
+		kfifo_free(&remote->remote_fifo);
 		return -ENOMEM;
+	}
 
 	error = sysfs_create_files(remote->remote_dir, remote_unpair_attrs);
 


