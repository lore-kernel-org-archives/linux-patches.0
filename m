Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6093F2EBDF6;
	Tue, 15 Jul 2025 13:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587618; cv=none; b=RYgGfe5Qds2H1nDLTpcmJ3EOHsXhpxFYUfXrBxym+Ei3YKa6Km9QDLuMHUe+E/DiG3v8xBmTaMeUITQEi7WQTBn4HsNPmL3Wdr4/R+MWlXm6jvpMFTh+c/vJ9yf4SCwT7sqPLbUfffk3d5huQ/Oj7VcI+A7QRYj9CiGs3liGsng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587618; c=relaxed/simple;
	bh=44k/kjn6Mxx4tUv60zTn0+X4YcgTmqZe7VAAf+VFZr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o2rMUR4v/RgQ1YndUx0BJmmQ7AVEqoAwKsjeVbiA880HX/wDFASxIanT0COZIvosyEbIrRNzeskg6st7nyM4LLwkOFvLkDK6oEElGWztWy6P6eFkRmr8Oz139eJxXKWI7gGz5hZTADa62U4Yn6WUL9j9mIc4Wt3RPxqZGJVaUDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F5Z3tOXi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F5Z3tOXi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93805C4CEE3;
	Tue, 15 Jul 2025 13:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587617;
	bh=44k/kjn6Mxx4tUv60zTn0+X4YcgTmqZe7VAAf+VFZr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F5Z3tOXiGkXlOH/YBCUd3ofMkWTFOQnlHS8ZrzJtnQ0xKyIuZEMq52UwDfWM3liUH
	 UGlag+KNZnW97sdmTcyBawFwVsp3wVXHwefAKJvZbmM9t9X66ljVeVubwwEXgaIoEV
	 aSpsNhcRUxvP00CBm8yyjbv272Y4ND2/sJhTp/5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping Cheng <ping.cheng@wacom.com>,
	Qasim Ijaz <qasdev00@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.10 062/208] HID: wacom: fix kobject reference count leak
Date: Tue, 15 Jul 2025 15:12:51 +0200
Message-ID: <20250715130813.436080149@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qasim Ijaz <qasdev00@gmail.com>

commit 85a720f4337f0ddf1603c8b75a8f1ffbbe022ef9 upstream.

When sysfs_create_files() fails in wacom_initialize_remotes() the error
is returned and the cleanup action will not have been registered yet.

As a result the kobject???s refcount is never dropped, so the
kobject can never be freed leading to a reference leak.

Fix this by calling kobject_put() before returning.

Fixes: 83e6b40e2de6 ("HID: wacom: EKR: have the wacom resources dynamically allocated")
Acked-by: Ping Cheng <ping.cheng@wacom.com>
Cc: stable@vger.kernel.org
Signed-off-by: Qasim Ijaz <qasdev00@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_sys.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -2031,6 +2031,7 @@ static int wacom_initialize_remotes(stru
 		hid_err(wacom->hdev,
 			"cannot create sysfs group err: %d\n", error);
 		kfifo_free(&remote->remote_fifo);
+		kobject_put(remote->remote_dir);
 		return error;
 	}
 


