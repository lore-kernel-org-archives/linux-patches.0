Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1961F4071DA;
	Sun,  7 Jun 2026 10:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827462; cv=none; b=KW6pGHo0xmnhfS+ozKW6azanhPH4bHtvMrfyWeklUdOwpdRHyRjETmN/p55aLPKhrhzfFi1+MFzjOui4euYMRtiySE4mklB8N7tJ5vDtX6+6z9lnYv5oKV487sNinTfrqpu1eh6kbgpcX2HaRUSSDOJBZVK2PoqkqrIliHjRelE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827462; c=relaxed/simple;
	bh=1timZgcX5VtzFc249Xcd6LYZqXKg17aiTEH35OT67/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=feGbKrxpNdC+LF+gX+3XFSVVRWoq3+x3hINU8kYADbUI74nX1OKZhcktYsYWj8IgzLmtqGvjrZj5BplgNq0GNUIYZvcyMeSNnNMuhJq7efg5xsVyBTeNfxvBOZgH4cBJFTgoT86oeK52IKV9joLK9dGPc7LLoMGd8CQz37s9NZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kxBmP1aV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kxBmP1aV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504691F00893;
	Sun,  7 Jun 2026 10:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827461;
	bh=8ZQd2jagax9ku8Wnjpafwn8qZLHlHHznD7OKh24IbiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kxBmP1aVr7d5V8E3WCHG4OEIz0RXywQMC6gMNWpm8JIDthwCERjeoUmn+ELqSi449
	 Dcdh+ZR6a1ZNNwKGZemuW5938Ny/1+AxPrzrNTOxkec1kc0qtGjpQJaoBVmgcX1jlO
	 O6il9wIy04pSLQAa58WSQpHWX1GndMY8IOWh5Hks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Vecera <ivecera@redhat.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 095/332] dpll: export __dpll_device_change_ntf() for use under dpll_lock
Date: Sun,  7 Jun 2026 11:57:44 +0200
Message-ID: <20260607095731.639607098@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit 20040b2a3cb992f84d3db4c086b909eb9b906b31 ]

Export __dpll_device_change_ntf() so that drivers can send device
change notifications from within device callbacks, which are already
called under dpll_lock. Using dpll_device_change_ntf() in that
context would deadlock.

Add lockdep_assert_held() to catch misuse without the lock held.

Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://patch.msgid.link/20260526074525.1451008-2-ivecera@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: d733f519f644 ("dpll: zl3073x: use __dpll_device_change_ntf() and remove change_work")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/dpll_netlink.c | 13 +++++++++++--
 include/linux/dpll.h        |  1 +
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/dpll/dpll_netlink.c b/drivers/dpll/dpll_netlink.c
index 95ae786e98aab3..72aa5f4d5d3114 100644
--- a/drivers/dpll/dpll_netlink.c
+++ b/drivers/dpll/dpll_netlink.c
@@ -771,12 +771,21 @@ int dpll_device_delete_ntf(struct dpll_device *dpll)
 	return dpll_device_event_send(DPLL_CMD_DEVICE_DELETE_NTF, dpll);
 }
 
-static int
-__dpll_device_change_ntf(struct dpll_device *dpll)
+/**
+ * __dpll_device_change_ntf - notify that the dpll device has been changed
+ * @dpll: registered dpll pointer
+ *
+ * Context: caller must hold dpll_lock. Suitable for use inside device
+ *          callbacks which are already invoked under dpll_lock.
+ * Return: 0 if succeeds, error code otherwise.
+ */
+int __dpll_device_change_ntf(struct dpll_device *dpll)
 {
+	lockdep_assert_held(&dpll_lock);
 	dpll_device_notify(dpll, DPLL_DEVICE_CHANGED);
 	return dpll_device_event_send(DPLL_CMD_DEVICE_CHANGE_NTF, dpll);
 }
+EXPORT_SYMBOL_GPL(__dpll_device_change_ntf);
 
 /**
  * dpll_device_change_ntf - notify that the dpll device has been changed
diff --git a/include/linux/dpll.h b/include/linux/dpll.h
index 8f97120ee7b37d..a77d5741dd3932 100644
--- a/include/linux/dpll.h
+++ b/include/linux/dpll.h
@@ -274,6 +274,7 @@ void dpll_pin_on_pin_unregister(struct dpll_pin *parent, struct dpll_pin *pin,
 int dpll_pin_ref_sync_pair_add(struct dpll_pin *pin,
 			       struct dpll_pin *ref_sync_pin);
 
+int __dpll_device_change_ntf(struct dpll_device *dpll);
 int dpll_device_change_ntf(struct dpll_device *dpll);
 
 int __dpll_pin_change_ntf(struct dpll_pin *pin);
-- 
2.53.0



