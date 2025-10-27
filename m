Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1D432D7D5;
	Mon, 27 Oct 2025 18:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590964; cv=none; b=YDHj6VjWLNUVq++KUqy+rPkAFWU64jARMZWLS7xh2E2dUsLTQs7v41LKVjwn3yYaoFURxQw3YRjpUb/U6nUPApLt4cJYRdeVXSiCzf7h+GMEXgWfzqPrRg5EdrRtYRWZChilSY234A2mGhoRPrjIFOhVOpv4ZuPqpjvUrZqWDtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590964; c=relaxed/simple;
	bh=JYDSwPRXsRS6WMdk7OzfkukV/xpOmouRS8rb7if69IE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/0mq/YQHkWY9mKTUUmU1+dsOcW7lBm4KbAcna/Gir6J5i1LCYA955+jmKwlovzfmCSfgzrGLcPgwKFhy6uHfqf46eNiaml55hKu4QhnLOJs4jL7LZcdnhNnu73K+L+5rt/Lk+e5PHZvxIFObNeoKRnvV/sTTpXHB3gtHL/8tRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ei/SNbUa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ei/SNbUa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48C5C4CEF1;
	Mon, 27 Oct 2025 18:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590964;
	bh=JYDSwPRXsRS6WMdk7OzfkukV/xpOmouRS8rb7if69IE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ei/SNbUaJVydYM8834kRr2aDWNdiuSFBkqnAu3T+A1jQ3uY+jWrn+l/yyw+xU8T2i
	 mB7qVlmS7BFEkhLKLB1nBD+SHK2X37e4h6bCezbdGF8luHsvWPtYVncDtyjSVr2Xpi
	 7DkfTTXm6dEjP8s93FVmI/PW9u+/hLWoma+nfXvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	stable <stable@kernel.org>,
	Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 5.10 016/332] driver core/PM: Set power.no_callbacks along with power.no_pm
Date: Mon, 27 Oct 2025 19:31:09 +0100
Message-ID: <20251027183525.051657794@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit c2ce2453413d429e302659abc5ace634e873f6f5 upstream.

Devices with power.no_pm set are not expected to need any power
management at all, so modify device_set_pm_not_required() to set
power.no_callbacks for them too in case runtime PM will be enabled
for any of them (which in principle may be done for convenience if
such a device participates in a dependency chain).

Since device_set_pm_not_required() must be called before device_add()
or it would not have any effect, it can update power.no_callbacks
without locking, unlike pm_runtime_no_callbacks() that can be called
after registering the target device.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: stable <stable@kernel.org>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Link: https://lore.kernel.org/r/1950054.tdWV9SEqCh@rafael.j.wysocki
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/device.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -740,6 +740,9 @@ static inline bool device_pm_not_require
 static inline void device_set_pm_not_required(struct device *dev)
 {
 	dev->power.no_pm = true;
+#ifdef CONFIG_PM
+	dev->power.no_callbacks = true;
+#endif
 }
 
 static inline void dev_pm_syscore_device(struct device *dev, bool val)


