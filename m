Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63AAF41F5EA;
	Mon, 17 Aug 2026 14:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977932; cv=none; b=gXjDTIkNL4RSlxaIE7A8SygRrcCOs7oUvH/Ht5rIMzezvMBNTOYhEorOUsvCByZ8+hu8+XFVsvD4szxo6RJufpdLj9SpORZxr9S4m8/+v67fwK5LXhfz3WkFkUpdSH7LkYmBC4wNGcnf4GYBQEJMXiM57VdG2A2hZMCu7SfxBwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977932; c=relaxed/simple;
	bh=a+fNBYg/uIWYzCWlupalK5CR+d1EizPn+0aRORLRzPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CXPpFIeWN3UaY4LfDmkGwdvb4OlYAAf3Rqut8i6svaxD7WFvKw9Af4WUqVctX5wpiI5WfRsn9xr19qYdhDKvvztptR79e0+mqNjAgh3P304trkRywLKAayOzWqvZhTUlrCcAhbdndQMfnVqHr0thWMsrYabjpo+YKr3mp80i/RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=trnmEnZq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="trnmEnZq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD8811F00A3A;
	Mon, 17 Aug 2026 14:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977931;
	bh=AWCrZfNwiZG3QJPr+FAXD+AkJkaOmRqhvTsX3UVG78s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=trnmEnZqYbXAG8yBI7E6hfaH+KlHkuLYQ/Gq4z/L44UcfDkt6BIdkwTglQ1OY/Tz7
	 l34aWsUAuhLIBWvI35BgQG4KXvkBUR1ALpD6VcLcM1Q4OToJDUNh6X9od1mw/kKmnh
	 1sSfIuH1jA5JJjUZWjXmfsgczsTI7p7qox4JW9WY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 036/181] vhost/vdpa: reject overflowing PA map page counts on 32-bit
Date: Mon, 17 Aug 2026 15:32:10 +0200
Message-ID: <20260817132536.796680435@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

[ Upstream commit 0619aaa34c0c2a2dcb07f0e9c8a34e7efb8c4cdf ]

vhost_vdpa_pa_map() adds the IOVA page offset to the user-controlled map
size before computing the number of pages to pin. On 32-bit systems,
where unsigned long is narrower than u64, that addition can overflow and
the code can pin and map fewer pages than the requested IOTLB range.

Reject sizes that overflow the unsigned long page-count calculation.

Fixes: 22af48cf91aa ("vdpa: factor out vhost_vdpa_pa_map() and vhost_vdpa_pa_unmap()")
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <CAMuQ4bX-iDvcUOPPY+NLz95tkRJYwWqvzAr=U48uNaub_HZLGw@mail.gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vdpa.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 2464c9de67712..a47fdcb61bf36 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -1102,6 +1102,7 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
 	unsigned int gup_flags = FOLL_LONGTERM;
 	unsigned long npages, cur_base, map_pfn, last_pfn = 0;
 	unsigned long lock_limit, sz2pin, nchunks, i;
+	unsigned long page_offset;
 	u64 start = iova;
 	long pinned;
 	int ret = 0;
@@ -1114,7 +1115,13 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
 	if (perm & VHOST_ACCESS_WO)
 		gup_flags |= FOLL_WRITE;
 
-	npages = PFN_UP(size + (iova & ~PAGE_MASK));
+	page_offset = iova & ~PAGE_MASK;
+	if (size > ULONG_MAX - page_offset) {
+		ret = -EINVAL;
+		goto free;
+	}
+
+	npages = PFN_UP(size + page_offset);
 	if (!npages) {
 		ret = -EINVAL;
 		goto free;
-- 
2.53.0



