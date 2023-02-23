Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6924258F
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 13:12:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE29C4339B;
	Thu, 23 Feb 2023 13:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677157956;
	bh=QcCbxXXtoVbGVt6RptA+ZzTzyyKRNhQjmdnc1BIyMoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y9npWFNZwKs6XxYiV+ALjWVTKMCCBUr1pwvbXMblQMt/f6S4FIXdiSNU+B4OZIp8z
	 +mrf6J5CU3IEM/zXnrafFCf3IUmshyf6UzkCXbAUzCEcGmiLJkaTHHwbEsFFxnu98/
	 7LvfUxd1T3B7QzdDSVbHF7dr+2tf/XmOZypB324g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	lee@kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Todd Kjos <tkjos@google.com>,
	stable <stable@kernel.org>,
	Alessandro Astone <ales.astone@gmail.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 5.15 27/36] binder: Gracefully handle BINDER_TYPE_FDA objects with num_fds=0
Date: Thu, 23 Feb 2023 14:07:03 +0100
Message-Id: <20230223130430.322049293@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130429.072633724@linuxfoundation.org>
References: <20230223130429.072633724@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alessandro Astone <ales.astone@gmail.com>

commit ef38de9217a04c9077629a24652689d8fdb4c6c6 upstream.

Some android userspace is sending BINDER_TYPE_FDA objects with
num_fds=0. Like the previous patch, this is reproducible when
playing a video.

Before commit 09184ae9b575 BINDER_TYPE_FDA objects with num_fds=0
were 'correctly handled', as in no fixup was performed.

After commit 09184ae9b575 we aggregate fixup and skip regions in
binder_ptr_fixup structs and distinguish between the two by using
the skip_size field: if it's 0, then it's a fixup, otherwise skip.
When processing BINDER_TYPE_FDA objects with num_fds=0 we add a
skip region of skip_size=0, and this causes issues because now
binder_do_deferred_txn_copies will think this was a fixup region.

To address that, return early from binder_translate_fd_array to
avoid adding an empty skip region.

Fixes: 09184ae9b575 ("binder: defer copies of pre-patched txn data")
Acked-by: Todd Kjos <tkjos@google.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Alessandro Astone <ales.astone@gmail.com>
Link: https://lore.kernel.org/r/20220415120015.52684-1-ales.astone@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2527,6 +2527,9 @@ static int binder_translate_fd_array(str
 	struct binder_proc *proc = thread->proc;
 	int ret;
 
+	if (fda->num_fds == 0)
+		return 0;
+
 	fd_buf_size = sizeof(u32) * fda->num_fds;
 	if (fda->num_fds >= SIZE_MAX / sizeof(u32)) {
 		binder_user_error("%d:%d got transaction with invalid number of fds (%lld)\n",


