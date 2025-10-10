Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE5B21579F;
	Fri, 10 Oct 2025 13:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102567; cv=none; b=PX2E5IfvZrFzP+Y8GoWKMHECoBRZi7Cv9PSzTbSf4//reChAqreT3HXcUHBtb7Hx4YXup3gchfeTgq7mEI/RD5mNwzuE8HinvpgF5YVmmzW1gZI5l3gqFx52v2vGMO9KZMJln7NqCRvwY/tlmfju4NrlZV/PWouMe22gnT+K3dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102567; c=relaxed/simple;
	bh=quoHNod05UmMqE/CqjUP22GjUPl0QScJy+SVHehvJDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=es5RuH3TrVvda8tsk5aM24GFR76+JYRJSN11VuEmeV7FFtLyRZno1Sx6y6RpS+hG2MvzTs6Ca6YmxKfRHsHy+Z6rCiX9DeYiiNVqf+vTEm0hHl84u8aw5C0itEGZNQT8y3TZvOlUeHlTdTj2lQiH5kTij5ElF5SbumdOMj88XjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qf/25KoC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qf/25KoC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F07C4CEF1;
	Fri, 10 Oct 2025 13:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102567;
	bh=quoHNod05UmMqE/CqjUP22GjUPl0QScJy+SVHehvJDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qf/25KoC1Ydjjd/BBPZcwvVJSGmJQYhskEokylHeSpI0SmnfbM4xZrf6ogp20IHyd
	 K/dwTEMi+NDmw0MhOq/ta266q+joQSlYr/7mJbdGWlQbrUnWYwvZ4IwLTKwJtJU17B
	 nIVIt/4/TiCLu+aQSgvb8Bia81OP4umepzbZfLy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	stable <stable@kernel.org>,
	Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 6.6 23/28] driver core/PM: Set power.no_callbacks along with power.no_pm
Date: Fri, 10 Oct 2025 15:16:41 +0200
Message-ID: <20251010131331.209613969@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131330.355311487@linuxfoundation.org>
References: <20251010131330.355311487@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -968,6 +968,9 @@ static inline bool device_pm_not_require
 static inline void device_set_pm_not_required(struct device *dev)
 {
 	dev->power.no_pm = true;
+#ifdef CONFIG_PM
+	dev->power.no_callbacks = true;
+#endif
 }
 
 static inline void dev_pm_syscore_device(struct device *dev, bool val)


