Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5422EAD1B;
	Thu,  3 Jul 2025 14:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554302; cv=none; b=eF4wI9gID130SiZWlme2aQcgQCB7VM9BtioEltsFCs24S2merkxc/laCCcEuiC89PYu56u/eq352oMQpgK/U1AV5PHs9n+2J7CVFYGlUxPjJKVoARMalKXEGySEsVpEzE4ohv56Lipclv+/95KRxf9nBH8M9jZIICOabVLJm4As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554302; c=relaxed/simple;
	bh=6+xSFem/qFCuWboc7AFJ5pEIuT6n2H9PlJXFQtNDvs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uAPRA0ooTPsrJzSG3KblBm3wZ0mYPtetfqUweRYTgDAwg1gB1jiossMZsyT6gfed/C8iBBzcLac8mNCyJhgit14ch+s9Eds7+E32ZYjwKWQS7s0e5uaBfoWcVMVUubWCFDwHO41u1oGZ9picGozmBsFs2Xi13dXV8cL9zBVkUak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vdm29UjI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vdm29UjI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9214C4CEE3;
	Thu,  3 Jul 2025 14:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554302;
	bh=6+xSFem/qFCuWboc7AFJ5pEIuT6n2H9PlJXFQtNDvs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vdm29UjIGtuUihfF7HCDP9I3iwBS3HjJGDAiST+wV2HeJAkHEtr+XLAfWaFCTIX8P
	 wGb2Aj65UnR3jREHUvD5lX2NHhACVgIN80VwqjzkmmBcu38M1uoTFdeOqGPiZTJHak
	 BnN6c2vBH7CEgacrFA4j5SOPhMFof4ErC1Azp0+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping Cheng <ping.cheng@wacom.com>,
	Qasim Ijaz <qasdev00@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.12 143/218] HID: wacom: fix memory leak on kobject creation failure
Date: Thu,  3 Jul 2025 16:41:31 +0200
Message-ID: <20250703144001.843109755@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2021,8 +2021,10 @@ static int wacom_initialize_remotes(stru
 
 	remote->remote_dir = kobject_create_and_add("wacom_remote",
 						    &wacom->hdev->dev.kobj);
-	if (!remote->remote_dir)
+	if (!remote->remote_dir) {
+		kfifo_free(&remote->remote_fifo);
 		return -ENOMEM;
+	}
 
 	error = sysfs_create_files(remote->remote_dir, remote_unpair_attrs);
 


