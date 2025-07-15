Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053112EB5BB;
	Tue, 15 Jul 2025 13:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587589; cv=none; b=DfWE0GcJNpP66S98+v4VyZ3K1aqiV85V5e2r1TgE/OJ+PPFdyQEvS3/oWZTM7NzAXt2rTZ+PdzjJFzsYrX//8Gi6nRPthsBxwRukWhl8ztRouXQeg1SkC2CEYlDk0NMRfM8mN8dYZCU8ZXQXRqgS7jIoXvifwq4xLS8YB4E/hxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587589; c=relaxed/simple;
	bh=k3SuYSk7ATVZvtIiMh3LHXU2aIKFTKFP9+XC7cjxw0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qVCMIuUwGKnSkoFwP6oH6WnhaNs2A8DSd38ZWrZEIdy9zzwfuColXS4CDwgCbeYetvXxYIlCxtz2XPK6uinMFCUyJhocxyI9/2O4XV5cmyd+0avarVSCEGD5EQQElyBUSFV7DyG55mptW31T3apuqQ2jo3prgFYH+BtRPA3eVDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zAIiZf4z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zAIiZf4z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82901C4CEE3;
	Tue, 15 Jul 2025 13:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587588;
	bh=k3SuYSk7ATVZvtIiMh3LHXU2aIKFTKFP9+XC7cjxw0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zAIiZf4zvtqRBQfhL363i6xpW7EUgoLXty1GSTYI3MqKtPtn69BITskWAWw/boBPV
	 qymUpitgGx7QOfkFLbeFMPk2SIljNFc0NwAm1U62XxOWkmTYQxxVTVuvrXEbcKI5g6
	 MaUxarDRIoM56dPUbs3bRrDu+nP1KQl5UWgCYaXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping Cheng <ping.cheng@wacom.com>,
	Qasim Ijaz <qasdev00@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.10 061/208] HID: wacom: fix memory leak on sysfs attribute creation failure
Date: Tue, 15 Jul 2025 15:12:50 +0200
Message-ID: <20250715130813.393700198@linuxfoundation.org>
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
 


