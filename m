Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACCB514BFA2;
	Fri,  6 Dec 2024 14:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496053; cv=none; b=Bc4/kA4N0XAIt30FL4mMo40f+efQAg9qhmN8WOvwrMreH5iYf0COVsn+L4EBPSmqRj9SRwI/l24JFQGsN6Yg3t/QVeBqomlwG8w7zAnWscG3cDBGB3cp4RnBy400lLtAXUDnYAA087ykUbKBqAP+BuDNVUSgOXbC7LNaY9r66PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496053; c=relaxed/simple;
	bh=2wiMYqvPuSW7K4ePfgDuHZjRPpsfmdzQhd/JruqoV4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZS5PjyOPK8IvMO2J51ikcjwC0V0JQ89q7+KXO4Ewg+AzVQ48+Hv12xL6zGf28gSjwUPC7fF01Mt93v3NDOSqLbI2hXOxoffXKLmIb57IQcphUIHt43G62ztAnVRp6lqSoVpy9A3XA8Ij57VjV9RmQezvrNKQecR72RKEuthCCkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gkr6TuLt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gkr6TuLt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B28C4CEDC;
	Fri,  6 Dec 2024 14:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496053;
	bh=2wiMYqvPuSW7K4ePfgDuHZjRPpsfmdzQhd/JruqoV4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gkr6TuLtyem21rumFpjuAtm7QOJKuoznyIh838Sl1U0zj6Vt8cM1NXPDOcKtcasXl
	 yz5kyCOdf7aXzRqmxcA7mwOEWSQQDb4Wsn46lZlIq7ibBxFXnFCIEfHJqS947VHkmd
	 GqSavZ1pV+mHDFyzKZ0bst9ThE8gLEhqhEyT5FdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.12 037/146] media: platform: allegro-dvt: Fix possible memory leak in allocate_buffers_internal()
Date: Fri,  6 Dec 2024 15:36:08 +0100
Message-ID: <20241206143529.093947568@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


