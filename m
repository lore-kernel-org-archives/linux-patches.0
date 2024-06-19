Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E4E132129;
	Wed, 19 Jun 2024 13:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802444; cv=none; b=LO8UuqwicCbIPsHzWbZkbM8h9YLI1GnSx/4ChqNukvSQP8S4WhDtaHNLi3SEfwTgm/S5e1+UcJDEUNfQv44Z1kCBjIRnKZZwJNz13smCh/hSMi0J0hGYbTqHEdXlWk0cWuzgbW5OSyWMXvv6bNbF61WFQmEEWDVn0CRyZbL4TLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802444; c=relaxed/simple;
	bh=YD4oFD3ayz8qfMKnX6GjCuAUWbnqIqMku8qsTiUkkOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JsBJCz5OJV745IvgRylqaGI2fmoHrndZSUIQKLBVTB2H3R/m0mpKlZL+nqd411mWF12T1W27u15IJiFI0ybG+2cXTKSbmI0Q8AfeKAncOqkR1HCa0kTCaaO6bRS3mKKw79zZYvdzJruu3ZdPw7e6Wj+RsRhiqeGvFCLPknQEAec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bfucVs3W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bfucVs3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF38FC2BBFC;
	Wed, 19 Jun 2024 13:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802444;
	bh=YD4oFD3ayz8qfMKnX6GjCuAUWbnqIqMku8qsTiUkkOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bfucVs3Wn8ombCZK28pt7GEGdZvvh4NkdTeJwqz0dnchh86fra2HaLucRT5wAAM0Q
	 EBkbR3UeS/yPsnEyHW6lLZF8nM35OA/ihsfeIIcnkeeWp4ZkYLJF1cv2Pk+YWekqrm
	 Pggg/1IqlY0Upadn72dmd2OJQ1OHY9m8PDNQp2oI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	"T.J. Mercier" <tjmercier@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 6.6 199/267] dma-buf: handle testing kthreads creation failure
Date: Wed, 19 Jun 2024 14:55:50 +0200
Message-ID: <20240619125613.971810185@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


