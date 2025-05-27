Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE76A1A3159;
	Tue, 27 May 2025 17:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367501; cv=none; b=D2BsNO9FAxbp91ve/UXFGeVyLliND/PJSAs7b50ignvbRJBXnMbPAbr39CnEtaLPM1jui4tVkHzR0/VKLhR//dTq/nniaWBBdHRPCg+g5rybbg72egxVlllVsW4K0Lw3bWSh+aCOOVz33t66MKU2XW9tgRENspadaDbflucKMLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367501; c=relaxed/simple;
	bh=kwUHv/lQBLaH2nyhgA7Rhc6etEC+AZkGfN9AhZ4bIQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nWW+rACQknGCrjdBTCxIJoO545oNZ5GsPduakHYdEq5Rtky/NSC+iF1PrH9Rwui6U6fJBdGgD+4c7EFgTMAhFZ2PVXOYeDM2itqy/Ht2yQmL3a9io/0vHoDmy5BZ/TOLkJEtleABzNMFtNMYLYHcQMCT4k71cI+yCsdJWxsVVgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wdyoF8uS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wdyoF8uS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AD0BC4CEE9;
	Tue, 27 May 2025 17:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367501;
	bh=kwUHv/lQBLaH2nyhgA7Rhc6etEC+AZkGfN9AhZ4bIQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wdyoF8uScfFl21mB2oOsgRgXMU4Ov+w9jhx87I7hyci4fvo0fUd/Z7CdhLXUaJE0t
	 1J1t3Mr5Fy3F8ozgxnOPLM0MRM7g4N8r8UcCG0ylxoLG7RVq6NpUQjITmmAbqOFGfA
	 TQ5qRbsVUqf6pZk0CLzkcpzuzWhHo+pBpms9YW0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 381/783] drm/xe/oa: Ensure that polled read returns latest data
Date: Tue, 27 May 2025 18:22:58 +0200
Message-ID: <20250527162528.609766787@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>

[ Upstream commit 98c9d27ab30aa9c6451d3a34e6e297171f273e51 ]

In polled mode, user calls poll() for read data to be available before
performing a read(). In the duration between these 2 calls, there may be
new data available in the OA buffer. To ensure user reads all available
data, check for latest data in the OA buffer in polled read.

Signed-off-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250212010255.1423343-1-umesh.nerlige.ramappa@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_oa.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/xe/xe_oa.c b/drivers/gpu/drm/xe/xe_oa.c
index eb6cd91e1e226..abf37d9ab2212 100644
--- a/drivers/gpu/drm/xe/xe_oa.c
+++ b/drivers/gpu/drm/xe/xe_oa.c
@@ -548,6 +548,7 @@ static ssize_t xe_oa_read(struct file *file, char __user *buf,
 			mutex_unlock(&stream->stream_lock);
 		} while (!offset && !ret);
 	} else {
+		xe_oa_buffer_check_unlocked(stream);
 		mutex_lock(&stream->stream_lock);
 		ret = __xe_oa_read(stream, buf, count, &offset);
 		mutex_unlock(&stream->stream_lock);
-- 
2.39.5



