Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C5B15442C;
	Thu,  3 Jul 2025 15:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555276; cv=none; b=l1QhwDEUCHkfhEyOzcMKf6fdD70zzHI39M5YD4yDtei27cD4qUX5hYF7uVQ8QTq6/b7+ZZBJQx1Sc9gy5HJ+ASrkeQ3lAiv4ilUPJ2d+Tr6RDfr4K+zCajPjdB5Tm9I5uTGtYXvtRR9feSfoPrjpe5DLHOABDnv4xHtgOfDG8Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555276; c=relaxed/simple;
	bh=8RM3dYbanw0/aaLRvv2qquAqjfFLXm6VE5emir9CXlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iVQHsb+ttHgZ++EfZUYHJC2dYZubvvTZIyg6Fxz7SEgME2zmzKvjFqFgKv8gNmZNtRrRScFUiJa43kerkhFvAPctToyqFVFR/53ExsucwRCTTNnW8ti2d5107voc5+3hRWrveVA5Q4qc27qcD22eO2/gHxWWWy9CAoQr7PDfyWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1q91qaHo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1q91qaHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F0CC4CEE3;
	Thu,  3 Jul 2025 15:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555276;
	bh=8RM3dYbanw0/aaLRvv2qquAqjfFLXm6VE5emir9CXlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1q91qaHougwUkACt60WxlThHKfIlEcdv3Ms3hGjK1zFag/enCY8p1m5LLMbDTyUtM
	 fwWqLNL9JM08PHHhMxxIjetU2IXx2qoTP9fARObrWk6Er+KN0ZeKwtZBNtPPN+2iEs
	 oB2ve4sWk5ygTBXD4S3QGlfmKVTW7k47vJvKlAhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping Cheng <ping.cheng@wacom.com>,
	Qasim Ijaz <qasdev00@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.15 197/263] HID: wacom: fix kobject reference count leak
Date: Thu,  3 Jul 2025 16:41:57 +0200
Message-ID: <20250703144012.258766440@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2059,6 +2059,7 @@ static int wacom_initialize_remotes(stru
 		hid_err(wacom->hdev,
 			"cannot create sysfs group err: %d\n", error);
 		kfifo_free(&remote->remote_fifo);
+		kobject_put(remote->remote_dir);
 		return error;
 	}
 


