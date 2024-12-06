Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C22D53A7;
	Fri,  6 Dec 2024 15:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498675; cv=none; b=YIjBTBb4OsUwmrfbq6MkFPL6TSTmHMXFIFyK1HH6ynNiYnptyuaDey/58F3Ze+GwTTbbBE0huzolMa2E9FG0EHwCWmHmMnakqXWCELwNhqcaXlj8tlVT6K9pBXrNiTINUzD2QDjtPFF0os7pJEbi01CEH5xkfxhZc+yDWKij9fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498675; c=relaxed/simple;
	bh=M2ANb9yEMD56J8ZIB6Ka3bKHgCEaP04LGHKJIt25ecg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DdXxPZUMsn0kZEvSv0dUebGIgTFtLwAptqvNzdvSKVVncJCSqkxGU96KRz4pvga0+SYoGGi92ZbhMZdWrl0hl8ltiJJTPmr9JrG74roLz2NI3A7METB8cek+TeWvRjQFajsvJs0BkEgFtmlJrm099jOOmHgUzNY9ovpPN8/0PCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lMFdBcgK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lMFdBcgK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF34C4CED1;
	Fri,  6 Dec 2024 15:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498675;
	bh=M2ANb9yEMD56J8ZIB6Ka3bKHgCEaP04LGHKJIt25ecg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lMFdBcgKfAsmyCCiwXmFajDmui7BxAWxDdaheYq6Ny7BWzGWjB2AKnaPXj5V721Vk
	 hF4kHyvHlIpakvHXHfUG56dC7RxlIjqPBbaB6ZH1XAsQ5DjMvY/SFVQmUgxmbjC1nd
	 alISOIhXvoPd/sYopiGoaESIg+6eSzZB7m/6JaEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.6 623/676] media: platform: allegro-dvt: Fix possible memory leak in allocate_buffers_internal()
Date: Fri,  6 Dec 2024 15:37:22 +0100
Message-ID: <20241206143717.702922399@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gaosheng Cui <cuigaosheng1@huawei.com>

commit 0f514068fbc5d4d189c817adc7c4e32cffdc2e47 upstream.

The buffer in the loop should be released under the exception path,
otherwise there may be a memory leak here.

To mitigate this, free the buffer when allegro_alloc_buffer fails.

Fixes: f20387dfd065 ("media: allegro: add Allegro DVT video IP core driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/allegro-dvt/allegro-core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/allegro-dvt/allegro-core.c
+++ b/drivers/media/platform/allegro-dvt/allegro-core.c
@@ -1509,8 +1509,10 @@ static int allocate_buffers_internal(str
 		INIT_LIST_HEAD(&buffer->head);
 
 		err = allegro_alloc_buffer(dev, buffer, size);
-		if (err)
+		if (err) {
+			kfree(buffer);
 			goto err;
+		}
 		list_add(&buffer->head, list);
 	}
 


