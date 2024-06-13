Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA539143C48;
	Thu, 13 Jun 2024 12:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280165; cv=none; b=SJ4w/c83GWavwuf6dfCk/Qr0BwVNEbzuwjnEpZhSABVi1WPyRfNzXxur7slmGWFCi2+QdsziFtDEej+Kz7/DB0DnRoXRGJakpvGxqbc83nfN6k4XlmkE3MrdPygAcg27MYGXKzxbHq6LXztDmIrOTK++948LKDVX171LyGn13Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280165; c=relaxed/simple;
	bh=ixNnmodNJFmINbBrOBqjBi2IumY0rPGcVda3nPXYD+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mV420mvkRMQCZ3zLs6+97l/ihVCOVMraoa/hMRfcHZO7Fk3tyyhfKKwoR34fXsL3PUdLYUWgMDSVzcT4ExW+VH/WjjIlgY/URQtgY0yNF6MUgnnLNNuM6rshb31u1gZub5J8fIXq0fgPeujpDqNVtIrvP8wZaJ06hfTb4jhtgnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C4B8d4a6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C4B8d4a6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27891C2BBFC;
	Thu, 13 Jun 2024 12:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280165;
	bh=ixNnmodNJFmINbBrOBqjBi2IumY0rPGcVda3nPXYD+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C4B8d4a6Fe77crBI1NoSJoRif68suH7e5wpt5rlJM9QCbNB4SUXqrms7AixbZw/uz
	 K2CQpeqZ+Fc0EjrRpr17R4ep0Cm0Q7OpY5G51yMU2888vZnFKMOLnP8Jstpl2nhucz
	 I+34z6a95oyfDRXKppcfBw93Hpvj4P4LLNv05IzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
	Carlos Llamas <cmllamas@google.com>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 5.4 165/202] binder: fix max_thread type inconsistency
Date: Thu, 13 Jun 2024 13:34:23 +0200
Message-ID: <20240613113234.114908278@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
[cmllamas: resolve minor conflicts due to missing commit 421518a2740f]
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -480,7 +480,7 @@ struct binder_proc {
 	struct list_head todo;
 	struct binder_stats stats;
 	struct list_head delivered_death;
-	int max_threads;
+	u32 max_threads;
 	int requested_threads;
 	int requested_threads_started;
 	int tmp_ref;
@@ -5412,7 +5412,7 @@ static long binder_ioctl(struct file *fi
 			goto err;
 		break;
 	case BINDER_SET_MAX_THREADS: {
-		int max_threads;
+		u32 max_threads;
 
 		if (copy_from_user(&max_threads, ubuf,
 				   sizeof(max_threads))) {


