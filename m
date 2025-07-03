Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B69F7222561;
	Thu,  3 Jul 2025 15:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556273; cv=none; b=tJdmri50TnG5+MnIKgTl9LeFxfIcf9P4L8OytauYmH0+4sMUaUONpXp7UQJLooRBly284L5tJHFrFLpPMDBW0+n8Z61Knm57522oiU4kIhXq87f8fJ+rPZE8t6xEv7RW/EdZa24VIT6rqJPWvFNJoLI2MiwYlumYK7QsVJy3G9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556273; c=relaxed/simple;
	bh=ViIYdsabI3MUkis4UI9YTveJtYy74LHR2AyAq1OtbYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X4+Q1IcuAhHjDPuIpODRLcijIu7PKgtm8OIO4Ak105MqxZvsu+Tr27G9zAHCRsqNeXN9B+z6fKRgw9b0lBPz9EIdycER8YP8zBJ9zZgwbiPbbTE0zhI2yC5v4S3VA81uHew9UB4YXdxzpZyaLODSCFKy3VPKoyK+RVIc0aIJ0f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MAa6X17K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MAa6X17K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1741C4CEE3;
	Thu,  3 Jul 2025 15:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556273;
	bh=ViIYdsabI3MUkis4UI9YTveJtYy74LHR2AyAq1OtbYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MAa6X17K/bBh3ecUlMBeCug+fqHkatwr/nMiONpCxxx0mCFz2FDjgmGpCxyWZt8Pu
	 LlwKgt0NC6Co3TRDltv+W9fHQtzCkaE8mrwv0gWBex+2PuPcorPODzFzHdrhY4KgCk
	 UJnCFiSkbU1tHYefFlAR3AwNrC2oaEH2rUdYl/u0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping Cheng <ping.cheng@wacom.com>,
	Qasim Ijaz <qasdev00@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.1 099/132] HID: wacom: fix memory leak on sysfs attribute creation failure
Date: Thu,  3 Jul 2025 16:43:08 +0200
Message-ID: <20250703143943.284621694@linuxfoundation.org>
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
@@ -2022,6 +2022,7 @@ static int wacom_initialize_remotes(stru
 	if (error) {
 		hid_err(wacom->hdev,
 			"cannot create sysfs group err: %d\n", error);
+		kfifo_free(&remote->remote_fifo);
 		return error;
 	}
 


