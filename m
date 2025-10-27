Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1702D8DB9;
	Mon, 27 Oct 2025 18:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590362; cv=none; b=SW+6Lp0vDsyVvO4bZlodr7dPiQXflgXWn+7JfpBUzvjx5CXWR7T+QSmQINW8OzxtH+Wf5I7nvVMz52NB2Jboz0bXtvgR2Jlor9h8zW7oYI+wXdcbxnWYiuufenxwUTOk3Y1OjyvyaMgwbg6b1Kt8zBcO8G1r8Wi7Fkk+giQloS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590362; c=relaxed/simple;
	bh=SkQ5xBuZ9mRJD+mprRNCS1v+XwZxSPPRlYQ7MeS52V4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aQ7E10IOZMjv4zR5LGQw6vq4wQfRyapcyOXwpWjmyUsqslACt0LpnmxQszR+E5Nxbk2126sH8u8p5kQtnSBxb1MoEBEFznZDEYfbeLxxyczgYbCiN+SPX2aBCLbsSbm4B7SmaQpflAK3+hcykKQy3LYFl86ZM9y0mrOII0OtAIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GVLgw6OJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GVLgw6OJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF6F8C4CEF1;
	Mon, 27 Oct 2025 18:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590362;
	bh=SkQ5xBuZ9mRJD+mprRNCS1v+XwZxSPPRlYQ7MeS52V4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GVLgw6OJn7fqy+wfOLH1Wb2vNzhvzAmuH6BuUOesDLRPpgnoF/8J1H7xxfD6RqwYa
	 rPtzjzoJVYCubY5Hnp5xqQSv5p/iXvUX5izAxRaadDBiIuqeHu/iFLhZJnu+K4xt63
	 f7HUnmloTMp4m46TAnagIfQzujXeZJLnPf/+dBO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	stable <stable@kernel.org>,
	Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 5.4 017/224] driver core/PM: Set power.no_callbacks along with power.no_pm
Date: Mon, 27 Oct 2025 19:32:43 +0100
Message-ID: <20251027183509.457073597@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1441,6 +1441,9 @@ static inline bool device_pm_not_require
 static inline void device_set_pm_not_required(struct device *dev)
 {
 	dev->power.no_pm = true;
+#ifdef CONFIG_PM
+	dev->power.no_callbacks = true;
+#endif
 }
 
 static inline void dev_pm_syscore_device(struct device *dev, bool val)


