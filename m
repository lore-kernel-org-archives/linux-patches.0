Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3DD81C57B3;
	Tue, 27 Aug 2024 15:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771450; cv=none; b=cPL2p6ezPAprtY0wpMoVll+Sop63MqML4NWVpnkbdbQvLwzoSQXHHhSk4p0RghVdNF0+DMHhYKSIaZDhm3x74mjZU1u78Z01Rp7i0KyF9rNhDEnW0ft46j2F0NuFuFiHeyhHdgOCHrfYv3bXGVxeBEJCQ7wStw3VMuXxuZeIV88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771450; c=relaxed/simple;
	bh=udcUllFi1qsojGYREb32bn70LQzVwyzjJnW/X2snJWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CVPRMGQ6hYene+4FSB+42RPL3hGdGZzvKjvU0lPKVytModm8OacufYd/9DB7QUUwJ3+/YOFvUmB34C0YQ6z9Kb0mGIjA6euaYsg37mmR2OswcLFq3k9JjoaXjQK3WGotyNUl6/f+5A3om+S3Yhm9IkKY9OJygmmvuBZlGKNj6uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gPrNbpeN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gPrNbpeN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A066C4AF67;
	Tue, 27 Aug 2024 15:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771450;
	bh=udcUllFi1qsojGYREb32bn70LQzVwyzjJnW/X2snJWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gPrNbpeNBiWDr2maFlJ6SqNhZhzfN40eCsobnRMyyTXFlzaYIFtSb84dQxO3con8d
	 IZgJe6ZV4451MsBeEwLJka8nIogd29NxalXPrHVpOAbL9f/ZuQmpe3H6J9zWW9S1H/
	 GVEcqPobnl9/Ayfkux80eLBJBU7fh9UYkrak9xzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Winter <wintera@linux.ibm.com>,
	Thorsten Winkler <twinkler@linux.ibm.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 191/273] s390/iucv: Fix vargs handling in iucv_alloc_device()
Date: Tue, 27 Aug 2024 16:38:35 +0200
Message-ID: <20240827143840.675640948@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandra Winter <wintera@linux.ibm.com>

[ Upstream commit 0124fb0ebf3b0ef89892d42147c9387be3105318 ]

iucv_alloc_device() gets a format string and a varying number of
arguments. This is incorrectly forwarded by calling dev_set_name() with
the format string and a va_list, while dev_set_name() expects also a
varying number of arguments.

Symptoms:
Corrupted iucv device names, which can result in log messages like:
sysfs: cannot create duplicate filename '/devices/iucv/hvc_iucv1827699952'

Fixes: 4452e8ef8c36 ("s390/iucv: Provide iucv_alloc_device() / iucv_release_device()")
Link: https://bugzilla.suse.com/show_bug.cgi?id=1228425
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Thorsten Winkler <twinkler@linux.ibm.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Link: https://patch.msgid.link/20240821091337.3627068-1-wintera@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/iucv/iucv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
index b7bf34a5eb37a..1235307020075 100644
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -86,13 +86,15 @@ struct device *iucv_alloc_device(const struct attribute_group **attrs,
 {
 	struct device *dev;
 	va_list vargs;
+	char buf[20];
 	int rc;
 
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (!dev)
 		goto out_error;
 	va_start(vargs, fmt);
-	rc = dev_set_name(dev, fmt, vargs);
+	vsnprintf(buf, sizeof(buf), fmt, vargs);
+	rc = dev_set_name(dev, "%s", buf);
 	va_end(vargs);
 	if (rc)
 		goto out_error;
-- 
2.43.0



