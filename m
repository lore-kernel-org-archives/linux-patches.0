Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9961714B941;
	Thu, 23 May 2024 13:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470334; cv=none; b=nux1nrTrf4etJtDlrUQCjQd5Zlk6boRNu2nfiH3VYt4M+S/640NiWnPm42FuZIwT6fyhBPh2rZchK0v5clzWMb53UJLnnXtwkvde2vzL/Cwl9opLQOZRt7IyoYkveddRiV7aQdZHY1tlxqgEKFIlVakj50Xce+J6mPFtr4X7uH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470334; c=relaxed/simple;
	bh=RLvW8RwL+BCmIph3FBbHaNhCgzvqb+9LZ8KJWqCljgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aC/Bz0eHhoAFRfdXkgy6l9ifoZ410FRKavJt7kZFWtVSUO1fTrm7/Gf3pNnEHHfcUjfSaUL8MngjT1mE/IQHjwTwVD27/lHDWCczUQkhXInAhHMoQreIp6WCcC+Yi0+qXghRpwi8NJ738PsjCrw6ig2HWGW6+pFEGjzfJjmAWqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G7Td1n+K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G7Td1n+K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D04C3277B;
	Thu, 23 May 2024 13:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470334;
	bh=RLvW8RwL+BCmIph3FBbHaNhCgzvqb+9LZ8KJWqCljgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G7Td1n+KBDV1i0kf90qGW1WOrmYJKi5gALIkF9lXzPpTn48HJMBycc4K5IxQvVSSl
	 XFW3pNYbmau4AeXYb9fJlBjTGWgV3YB2IpVpwr7aRvdS8a368w2fTNRSTkyrk+EFDW
	 trKjTGGlOBLjCyI3Juwgvud9qtXQrLgDyNQfHHHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
	Carlos Llamas <cmllamas@google.com>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 5.15 17/23] binder: fix max_thread type inconsistency
Date: Thu, 23 May 2024 15:13:13 +0200
Message-ID: <20240523130328.603045855@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130327.956341021@linuxfoundation.org>
References: <20240523130327.956341021@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5165,7 +5165,7 @@ static long binder_ioctl(struct file *fi
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


