Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE0814A4FC;
	Wed, 19 Jun 2024 13:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803338; cv=none; b=aCanXdjBaHE5g7I7A+4vemfWLvnhv3bvKgXin62BUC5qhzWUtlqD6K2o1DTQt8AAr8Gikzm8giKESOWgNWBe6FTQPcwF8dfUg4Ews/dzgc1hip5GLYjHPAGlez78HS4mt6vqTPhiQDiEQI1lZKUfxUTSzY9ZjxZLHkRDpiZcMZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803338; c=relaxed/simple;
	bh=7HiSB+sC9K7okOk0LJ3C6cOJfz74Qa1O3p98CU+UhFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VTVk1q0wCidTUJzMpfOCNWofj4NcyaITSGYw9q3JP1lYtTe15bkSdFG8Z3VSK2vw4jto4lsS8wijGNOrt2DPY1YRPHAudEkwdCURTNnOmJhDdgg+Bi09zWVIoYRxjbcK6yebFgY5xGr7j5G0HvxW9PhVUk/rUf3ZQGl/oFNzr6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kDar1KV7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kDar1KV7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020EEC2BBFC;
	Wed, 19 Jun 2024 13:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803338;
	bh=7HiSB+sC9K7okOk0LJ3C6cOJfz74Qa1O3p98CU+UhFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kDar1KV7aV3zWtp3ETkYyZb5qP7getcr+3dFR+V5t0+hAUQj6OI7bI8W0t3vi2v7D
	 +KTf6wyYUPpHeOofWvyJ8rTZGM0KTbzo4e0Kj2gktYIY5qeYpwphjZctguxsRumkB0
	 fMyik3TmH4yAUhoaDo2mijweLCdkszY1BBD4Xc+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	"T.J. Mercier" <tjmercier@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 6.9 233/281] dma-buf: handle testing kthreads creation failure
Date: Wed, 19 Jun 2024 14:56:32 +0200
Message-ID: <20240619125618.928196231@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

commit 6cb05d89fd62a76a9b74bd16211fb0930e89fea8 upstream.

kthread creation may possibly fail inside race_signal_callback(). In
such a case stop the already started threads, put the already taken
references to them and return with error code.

Found by Linux Verification Center (linuxtesting.org).

Fixes: 2989f6451084 ("dma-buf: Add selftests for dma-fence")
Cc: stable@vger.kernel.org
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240522181308.841686-1-pchelkin@ispras.ru
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma-buf/st-dma-fence.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/dma-buf/st-dma-fence.c
+++ b/drivers/dma-buf/st-dma-fence.c
@@ -540,6 +540,12 @@ static int race_signal_callback(void *ar
 			t[i].before = pass;
 			t[i].task = kthread_run(thread_signal_callback, &t[i],
 						"dma-fence:%d", i);
+			if (IS_ERR(t[i].task)) {
+				ret = PTR_ERR(t[i].task);
+				while (--i >= 0)
+					kthread_stop_put(t[i].task);
+				return ret;
+			}
 			get_task_struct(t[i].task);
 		}
 


