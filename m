Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 479F22210DE;
	Thu, 12 Dec 2024 16:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020436; cv=none; b=TXU0fgpCk97f1eCHgNm811qWUCxlZpbZBTHheCLtmE10hNWwZ6BKv0xPgcIsAekmrwA/D9jSTpDRMJ+GCZnq579ajSn/Ar7e4QJf03JYDXGlvg7niamiH0xIJXJVnXPDznLZgVw5HG42/qt9NVPpJJ5vfaiSiow6CXUgPoRXvRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020436; c=relaxed/simple;
	bh=kf0YkienMpP5zx3JwS01gSJg+MiOqTQbruUYkuQnAOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tDCbH2g+2/Jy1ftyEPUsvqz73oI1dXWIyEYRvp4kRUCkvaG3hAaUFQqJ1ljEQL57otA/oKjNsTrJ8UWRdscE2ukoBry2cYFAG9XS5tlo2qt3v7oStkmzdi2Oh1CrZSpWdF5RkC8oYyEFaEGx0R4w0znaZUNp+aVt1dc9pKQHSCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UMFdi7PI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UMFdi7PI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F58DC4CECE;
	Thu, 12 Dec 2024 16:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020436;
	bh=kf0YkienMpP5zx3JwS01gSJg+MiOqTQbruUYkuQnAOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UMFdi7PIM/Yn06Cchg0JXBZasqbbFYOKqsybhTj+e2zcEF/nYv6ocnBlHv79LXrxA
	 YFFCtjSMD91N1GsO5D4QMffhSjSj54UHv/JfCPSwKp7Rp7JHXYdfxvoG4PCeyZ34xi
	 r4JIgZx5AsLPmrZ2id9NaPC3rCAsTT4tsBsZch2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.1 468/772] media: platform: allegro-dvt: Fix possible memory leak in allocate_buffers_internal()
Date: Thu, 12 Dec 2024 15:56:53 +0100
Message-ID: <20241212144409.272269178@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1510,8 +1510,10 @@ static int allocate_buffers_internal(str
 		INIT_LIST_HEAD(&buffer->head);
 
 		err = allegro_alloc_buffer(dev, buffer, size);
-		if (err)
+		if (err) {
+			kfree(buffer);
 			goto err;
+		}
 		list_add(&buffer->head, list);
 	}
 


