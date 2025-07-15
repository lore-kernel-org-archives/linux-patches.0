Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764522E4984;
	Tue, 15 Jul 2025 13:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586388; cv=none; b=HXWlMxRXItmznGBGsMSUAArLonwxi71i5iFqeMWodXJ6Z3SLNuC1Zx6uYorwQs691pB4XCsX8yssuCE6PZODHWAreNsdMRknuh8Uh2/DZRXOTEIkilmvNvy57a2yt/cb3hMmEDPNRlVCuvh6j1By/yJqK3mQbHHCHw6QHFsQ2uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586388; c=relaxed/simple;
	bh=jP0/Fqz7gNPmC8qrJBw/Kn0yoQ3MLI+RLJby93xY9KA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EV2mfywP5NZXg++2Ql3vShrA/z/eJtsOJNTCcWVsSvokk+n3GAPVO504vAD9iRcopEwoQzQNr3NMM1YWoRVxaKzEtMBz/xlDxrGQmqy1FyKKVHbrgBdfJt/BJs98XfpbdLqauDDqhTA5/wqMc5qgPeDc4bhdTZ+uNvwDDxQI8VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WhPu2SL2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WhPu2SL2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6E9C4CEE3;
	Tue, 15 Jul 2025 13:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586388;
	bh=jP0/Fqz7gNPmC8qrJBw/Kn0yoQ3MLI+RLJby93xY9KA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WhPu2SL2n2lvVV0zEp+dsoDWU9hfg4BgPD56WFVVNNMvwv0JPdp8D9SZqIKoE1Hnb
	 /uvakgIJhvZy8BRj66CtBCekmEdanUsNkLBSqKAPSZjJZa1DRJR0Hd/0Y3g6PDAMqi
	 1j0k6ImP03W9uTbM2xmKweUT02VekoqOUD0SwjKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping Cheng <ping.cheng@wacom.com>,
	Qasim Ijaz <qasdev00@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.4 047/148] HID: wacom: fix memory leak on sysfs attribute creation failure
Date: Tue, 15 Jul 2025 15:12:49 +0200
Message-ID: <20250715130802.202975118@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qasim Ijaz <qasdev00@gmail.com>

commit 1a19ae437ca5d5c7d9ec2678946fb339b1c706bf upstream.

When sysfs_create_files() fails during wacom_initialize_remotes() the
fifo buffer is not freed leading to a memory leak.

Fix this by calling kfifo_free() before returning.

Fixes: 83e6b40e2de6 ("HID: wacom: EKR: have the wacom resources dynamically allocated")
Reviewed-by: Ping Cheng <ping.cheng@wacom.com>
Cc: stable@vger.kernel.org
Signed-off-by: Qasim Ijaz <qasdev00@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_sys.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -2030,6 +2030,7 @@ static int wacom_initialize_remotes(stru
 	if (error) {
 		hid_err(wacom->hdev,
 			"cannot create sysfs group err: %d\n", error);
+		kfifo_free(&remote->remote_fifo);
 		return error;
 	}
 


