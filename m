Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CB13C17;
	Fri, 31 Oct 2025 14:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919503; cv=none; b=ecW4LX2eLwrzeXAhpWs2YksHzwwK2veTbgiBrCEnew8gHsvVyE1ZOToT2Qt5aQ6Nyz/PZPncJXhRI04CwqsNd44AyLjwpmhcDQECAjMg3bJIq4fTAOKHdKbMWWsBVmpGpsfdZoSFhE2nJIZ+hp+fudFyaQglIefpBpkuDRVPZMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919503; c=relaxed/simple;
	bh=ppi3t5hKrBhOCwcpZhTGp3Ra+Dix2hFqaoi2yd9KN84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C0DwMtA43P0FJV08TSPBNp/oTRqfLHMswPo3HeSXUb53/a43zYBbiNrEETyIIuQPDzvUs66sOk+NwOuNIg6Hth6UXQFPFv+4qX4lK0l9V8hNhLwa6O1OdcAlx/D5u5Tw6EjKAv6sDZ7uEJQf0XT6MiLn153wQJ7ae8EIiTe0iuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R9GlHwJJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R9GlHwJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 819DFC4CEE7;
	Fri, 31 Oct 2025 14:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919502;
	bh=ppi3t5hKrBhOCwcpZhTGp3Ra+Dix2hFqaoi2yd9KN84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R9GlHwJJvmKGZZndiT2eEFhyHHIQcjsZD9zoGWMe1TLsAonYvLQW3zr+ncOUHfhPe
	 IbY3Wr+Orq42R2sUVUCtVLMXsMbaGJAw7UimaZ4CW2J+uiAqxqwwMt3qbPjhdKZz5U
	 Rtma9ic30FQ/10tXOOgFHmXlfZYrHgC/+wzCOV0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaogang Chen <Xiaogang.Chen@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Amelia Crate <acrate@waldn.net>
Subject: [PATCH 6.12 39/40] udmabuf: fix a buf size overflow issue during udmabuf creation
Date: Fri, 31 Oct 2025 15:01:32 +0100
Message-ID: <20251031140044.967565261@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.939381518@linuxfoundation.org>
References: <20251031140043.939381518@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaogang Chen <xiaogang.chen@amd.com>

[ Upstream commit 021ba7f1babd029e714d13a6bf2571b08af96d0f ]

by casting size_limit_mb to u64  when calculate pglimit.

Signed-off-by: Xiaogang Chen<Xiaogang.Chen@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250321164126.329638-1-xiaogang.chen@amd.com
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Amelia Crate <acrate@waldn.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma-buf/udmabuf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -350,7 +350,7 @@ static long udmabuf_create(struct miscde
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&ubuf->unpin_list);
-	pglimit = (size_limit_mb * 1024 * 1024) >> PAGE_SHIFT;
+	pglimit = ((u64)size_limit_mb * 1024 * 1024) >> PAGE_SHIFT;
 	for (i = 0; i < head->count; i++) {
 		if (!PAGE_ALIGNED(list[i].offset))
 			goto err;


