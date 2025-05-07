Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CFE1E1DF6;
	Wed,  7 May 2025 19:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644874; cv=none; b=pDNUMAixPzPxc3igmgO3bV9LMfcvz55BUJmFaYpnCcGs84eBcxHoFLQCgw6cwIuRAU/jwneUO5vuWa/N+02NUq6XvZ9qMhAz68ZqWSpKDu4yOcCZONC9xiX9lhj4azGIRbO4o/eDE/9xm0+14ue8PAk9YTpu7FpLUGavrMUIJ7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644874; c=relaxed/simple;
	bh=OileND7weJx1KL0H2FOAgYQh7bwqx9oPkE66zoZnEyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UTtMk8u1Rmcc9Wi5WeD6ud0Qs1RHSBL7cmkRUOHnBrV1A7hva+IO8uDCd7L5PnwZhmLfE2poE8JBdYxSZjk13BNqjSGHVRxfQHsqhNjTmmsQp8eq68nT5LuqvSOEPr5z+7RxGxw5uQwAglthBzmoh+bbOk1t01QjjJjDgzrwjVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QDbPnYoS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QDbPnYoS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06120C4CEE2;
	Wed,  7 May 2025 19:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644874;
	bh=OileND7weJx1KL0H2FOAgYQh7bwqx9oPkE66zoZnEyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QDbPnYoSQbBwZ4x3gfQpggj8hYEXuFzjK9zaZH0RktH5R1KckpDC0lBEM6bqB5W98
	 1dif3rMWOZfBts9d7PUQO81X7P371pbaim+hEOm9F4RREuGReYDXQzev5ygMuiZS/i
	 2FGClv4gqVnHTfL9JEUir8jIUzEQYfKd534Mh5Kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Subject: [PATCH 6.6 005/129] drm/fdinfo: Protect against driver unbind
Date: Wed,  7 May 2025 20:39:01 +0200
Message-ID: <20250507183813.744381554@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>

commit 5b1834d6202f86180e451ad1a2a8a193a1da18fc upstream.

If we unbind a driver from the PCI device with an active DRM client,
subsequent read of the fdinfo data associated with the file descriptor in
question will not end well.

Protect the path with a drm_dev_enter/exit() pair.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Fixes: 3f09a0cd4ea3 ("drm: Add common fdinfo helper")
Cc: <stable@vger.kernel.org> # v6.5+
Signed-off-by: Christian König <christian.koenig@amd.com>
Link: https://lore.kernel.org/r/20250418162512.72324-1-tvrtko.ursulin@igalia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_file.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/drm_file.c
+++ b/drivers/gpu/drm/drm_file.c
@@ -1015,6 +1015,10 @@ void drm_show_fdinfo(struct seq_file *m,
 	struct drm_file *file = f->private_data;
 	struct drm_device *dev = file->minor->dev;
 	struct drm_printer p = drm_seq_file_printer(m);
+	int idx;
+
+	if (!drm_dev_enter(dev, &idx))
+		return;
 
 	drm_printf(&p, "drm-driver:\t%s\n", dev->driver->name);
 	drm_printf(&p, "drm-client-id:\t%llu\n", file->client_id);
@@ -1029,6 +1033,8 @@ void drm_show_fdinfo(struct seq_file *m,
 
 	if (dev->driver->show_fdinfo)
 		dev->driver->show_fdinfo(&p, file);
+
+	drm_dev_exit(idx);
 }
 EXPORT_SYMBOL(drm_show_fdinfo);
 


