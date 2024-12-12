Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6575D22540B;
	Thu, 12 Dec 2024 17:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025605; cv=none; b=Qgxbou8bfvlIa6RLb+mKxKlQgQVMb5Di39gUyqD1hQvh/EQL+xAndnc2vW00VcO1G/sFffXQ4Z1AvwEuUizW2Mg5PE6NEnrI4HrwizbQlKiboFTVor6nL7m3CiUOnaWoTFqwzRYU158JnYiS7KW7bRhPnLJpXyMhxgYlCfdaZRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025605; c=relaxed/simple;
	bh=IYEpBgdG+gwUcdnzEVjhQBc9drW1sweRrohpva0XKu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hsU0eS/8r7ZDq6TjT9qTxm8IgqNXdR2CU66OtkBPlEIT09DM8yai2ZhhITwIDuxGD3ULvKZPE7BGH6JDD2uq8XH2/HOzw9cDxMp9toIJiQ84zIEkOa0X4UduL2553RvjraMHL7rZRNzpdLV8D3/7UoOufsBE5V0Az+6FWnJ76M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aSJTDUXH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aSJTDUXH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF819C4CECE;
	Thu, 12 Dec 2024 17:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025605;
	bh=IYEpBgdG+gwUcdnzEVjhQBc9drW1sweRrohpva0XKu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aSJTDUXH3kXVxIXu48JDRohKhY8Ltatibh0zWl0Q44PNE7XQBfQj/kpKgXCL/9oyv
	 /8u9pYC67cDiPPzhBGQJ3XbIBF/rmBdYGCgsKke7awrOT6BB4HjNiB+VXJCnCKvX90
	 2F4XPBwW+v8rNjfxNxvlgnLCnkZJMR9BtjIYQeUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 5.4 208/321] media: platform: allegro-dvt: Fix possible memory leak in allocate_buffers_internal()
Date: Thu, 12 Dec 2024 16:02:06 +0100
Message-ID: <20241212144238.199354634@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/staging/media/allegro-dvt/allegro-core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/staging/media/allegro-dvt/allegro-core.c
+++ b/drivers/staging/media/allegro-dvt/allegro-core.c
@@ -1250,8 +1250,10 @@ static int allocate_buffers_internal(str
 		INIT_LIST_HEAD(&buffer->head);
 
 		err = allegro_alloc_buffer(dev, buffer, size);
-		if (err)
+		if (err) {
+			kfree(buffer);
 			goto err;
+		}
 		list_add(&buffer->head, list);
 	}
 


