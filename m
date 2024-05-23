Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917501D545;
	Thu, 23 May 2024 13:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470492; cv=none; b=o3SyW4xia2SNaQMdVOrVPjZmAVnhLB4Lr0xW7rfYZatS2YiZrPZq6TOCwjdsZV3LSBvWcTUTCaz3bRsD5iFCjgY61HfOfs27f7X/9f/iC7a0GkHnRpoOlb9IvnxdqBKAq3Y8tkaVv8YkaRVBKMATGbPUw6Zo8i+E38hu+06s3GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470492; c=relaxed/simple;
	bh=bMaYevDg4KhNqxeeY3hVZT0+YJAureBfs5Y8eILKsKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qg0SCkc1wtcK8YDhUxmtalygbpvoPCh/GA6wi8pTuusn9OHQnu2kcVqDjpX7ugsdy0wolavzYhnCwGAJ77SSRww3UmSpAZ3eWcXXAkUTmNG7oVmEpxxcaxKEve0sqrv6HNbMQKdR4pTBIqNx8h1Qp0y4dMjcGh/D9J3THYd6O00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=THtZtPlN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="THtZtPlN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18615C2BD10;
	Thu, 23 May 2024 13:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470492;
	bh=bMaYevDg4KhNqxeeY3hVZT0+YJAureBfs5Y8eILKsKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=THtZtPlNdiTjO3qVhXRctrKzU/qFxzWE88MaBP9l0tY32rF2U8lJAmXM/Ai/vhdvo
	 9JGAfcToWaARqM3h6WOofdp3TE/lDnGtlj/ssMghtPXdlLgrceTF3wuvh8V8JGd1/L
	 +3MuWKT8VmmmrPtMaMJK4XAE8KnYXfiNRxAae+EQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
	Carlos Llamas <cmllamas@google.com>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 6.8 10/23] binder: fix max_thread type inconsistency
Date: Thu, 23 May 2024 15:13:37 +0200
Message-ID: <20240523130330.136870998@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130329.745905823@linuxfoundation.org>
References: <20240523130329.745905823@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5367,7 +5367,7 @@ static long binder_ioctl(struct file *fi
 			goto err;
 		break;
 	case BINDER_SET_MAX_THREADS: {
-		int max_threads;
+		u32 max_threads;
 
 		if (copy_from_user(&max_threads, ubuf,
 				   sizeof(max_threads))) {
--- a/drivers/android/binder_internal.h
+++ b/drivers/android/binder_internal.h
@@ -421,7 +421,7 @@ struct binder_proc {
 	struct list_head todo;
 	struct binder_stats stats;
 	struct list_head delivered_death;
-	int max_threads;
+	u32 max_threads;
 	int requested_threads;
 	int requested_threads_started;
 	int tmp_ref;


