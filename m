Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069BC14A632;
	Thu, 23 May 2024 13:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470464; cv=none; b=tXSd2qubL9QAT56GYpJtXV9eKLIYZKfVMnnOV//xxTbGW44rKHLR1M8ufgapFRCApRX7kGU/PopOfkHyxMkb76+QdOSMFqrR/7K/qR99aR8MZzDa9ixL0lOHubtdGdkhhH6iyakfpwPSs2wpKvzbbvUgkWy6BBL8xAg/WqtAbDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470464; c=relaxed/simple;
	bh=zWrLXU3r/XCIiXCbBygD3AZaHVRF5T2Z7C/bBS77CXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XenZrePaRIv3asAAOReniwjVWeJ/l9iKSLRH8QRcM9KHV2kTmbIdEYdHqY1YEWC32MRpr2dzrxR4GsArsEQbcYCSaTiixeuvFewpRSoE6R3SdZ5OnhH54FtBC7GCBuIH4KUCfJd+VtUXUoUXWHaYKuZ/VCq13EkGr3dD2/uEF+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ajqT3+RX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ajqT3+RX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8379EC3277B;
	Thu, 23 May 2024 13:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470463;
	bh=zWrLXU3r/XCIiXCbBygD3AZaHVRF5T2Z7C/bBS77CXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ajqT3+RXvK3wscn1WCjZoaM2Y4/lRfJ3McPpyjWdAxnleyel3FHuwMpEPdDCNQnXl
	 r6BKaNBGuGlxzQ9/8SGZjuhEMQEwB9Kidl4qWBfIrGV7ppilSdappylR3HWk//13tJ
	 d2cFnRt3PUOIMdLkGRGmErlk6KU/6p3k0TPBfwkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
	Carlos Llamas <cmllamas@google.com>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 6.1 36/45] binder: fix max_thread type inconsistency
Date: Thu, 23 May 2024 15:13:27 +0200
Message-ID: <20240523130333.858597025@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130332.496202557@linuxfoundation.org>
References: <20240523130332.496202557@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Llamas <cmllamas@google.com>

commit 42316941335644a98335f209daafa4c122f28983 upstream.

The type defined for the BINDER_SET_MAX_THREADS ioctl was changed from
size_t to __u32 in order to avoid incompatibility issues between 32 and
64-bit kernels. However, the internal types used to copy from user and
store the value were never updated. Use u32 to fix the inconsistency.

Fixes: a9350fc859ae ("staging: android: binder: fix BINDER_SET_MAX_THREADS declaration")
Reported-by: Arve Hjønnevåg <arve@android.com>
Cc: stable@vger.kernel.org
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://lore.kernel.org/r/20240421173750.3117808-1-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c          |    2 +-
 drivers/android/binder_internal.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -5350,7 +5350,7 @@ static long binder_ioctl(struct file *fi
 			goto err;
 		break;
 	case BINDER_SET_MAX_THREADS: {
-		int max_threads;
+		u32 max_threads;
 
 		if (copy_from_user(&max_threads, ubuf,
 				   sizeof(max_threads))) {
--- a/drivers/android/binder_internal.h
+++ b/drivers/android/binder_internal.h
@@ -420,7 +420,7 @@ struct binder_proc {
 	struct list_head todo;
 	struct binder_stats stats;
 	struct list_head delivered_death;
-	int max_threads;
+	u32 max_threads;
 	int requested_threads;
 	int requested_threads_started;
 	int tmp_ref;


