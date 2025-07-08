Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668F72DCC03;
	Tue,  8 Jul 2025 16:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993961; cv=none; b=H+xMr3ymlVi2jv2mU+76mdqS1Twb+0BHG8DdJ93UMtWL7M7yFS7sdsBmtKLwY2gNmDFYoNe4+QgtohgnOpCgPP7DT4InIOslETW8tjg7xSJXsw2F25qQpnkZQ1riNGytXZ7FdIJ1Og7kfKAs2TTlQKkzy2xeMfap0NzR8cz8dzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993961; c=relaxed/simple;
	bh=lsbGeY06uz+VHmuR/2JW8q58XY5fGp7wrlg8N61xiDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SbAZ9wPgD0SVZUe5ux13tNwwnoj9Rn+xwbo6LJs69GDVR6tcsMEN86DOy80Yp1QmOMtcob3lSPEhDwYo8WxUe+3pGg+yf8BpOngHdG2sLYI7sYyEXa+mC72TVfNkS0CzhFLfhCAJKAhVI96v+jZNKJi/UcUhifdLZ08N6jOlfUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=er5fqLjB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="er5fqLjB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4436C4CEED;
	Tue,  8 Jul 2025 16:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993961;
	bh=lsbGeY06uz+VHmuR/2JW8q58XY5fGp7wrlg8N61xiDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=er5fqLjBKHM6TU+c9KTUmLEbDMfJM5kaay0ybX7HG8xmHVyD0ikJS5xfdTtBPkKgF
	 XnPRAq0c2/Ldkdk3HLvOKMClgMOZTPKXcl6wm6vqrfHGOA8j6NZo60WmXsK1HXMnZd
	 PaCsJGX5W+21LtoGddwWuUtdVtOhUqT8Ur6/kAO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping Cheng <ping.cheng@wacom.com>,
	Qasim Ijaz <qasdev00@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.15 078/160] HID: wacom: fix memory leak on sysfs attribute creation failure
Date: Tue,  8 Jul 2025 18:21:55 +0200
Message-ID: <20250708162233.704538640@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


