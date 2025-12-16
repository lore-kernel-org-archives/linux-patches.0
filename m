Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95471313E13;
	Tue, 16 Dec 2025 11:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884274; cv=none; b=TmCfYpWe2WUYkqVtEXxfpbACxjv7vfdwkqmBs2QV7pnF6I1E+HmyRs4twOpHENuV5ryEEBdl+hd6hF4DAlh4q4n2MbP45uAbcTKrb05MixLe3Cj2EtMI4ENqpEARGvcQ+4dA81O2+4vrnntYYZWXLdfr06CXXed8YKfY0X9feKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884274; c=relaxed/simple;
	bh=asazDP7T7C/4OaEg8B8GAo8FOI6af5xLEw91expF0KA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d7T4Zo04o0wNL7yRsoPVLvKIyQphvkCQwMLlmM6DwQw2oG9aQo25KER69Vby6wSX/miPldgHVtidGRn0H+DUfPaDrLvz6yLW7uKo8xJ48QyJQfMOCfs19guXMqpURyMyMJMcdkwwbt3uc7jilhUgHMfGcJm31lfgaRktAa7fu5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JoN8wQSM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JoN8wQSM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 135E2C4CEF1;
	Tue, 16 Dec 2025 11:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884274;
	bh=asazDP7T7C/4OaEg8B8GAo8FOI6af5xLEw91expF0KA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JoN8wQSMzYOWQHuGflfyKyWxjVM2Rd5RTQpezP77OfoMjFug/jl6xRaNXCnE591YG
	 rVRLYQzS+bf6P3SdOdwdpqFYl8g/HIK+NufZUHf0cVGL4HhLH6+p+ZJheAhz9rv5vh
	 2rk+q1LZBSCdE9xPaOe0fmSxp/s5NInMDma8wSZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Leach <mike.leach@linaro.org>,
	James Clark <james.clark@linaro.org>,
	Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 145/354] coresight: Change device mode to atomic type
Date: Tue, 16 Dec 2025 12:11:52 +0100
Message-ID: <20251216111326.170079685@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit 693d1eaca940f277af24c74873ef2313816ff444 ]

The device mode is defined as local type. This type cannot promise
SMP-safe access.

Change to atomic type and impose relax ordering, which ensures the
SMP-safe synchronisation and the ordering between the mode setting and
relevant operations.

Fixes: 22fd532eaa0c ("coresight: etm3x: adding operation mode for etm_enable()")
Reviewed-by: Mike Leach <mike.leach@linaro.org>
Tested-by: James Clark <james.clark@linaro.org>
Signed-off-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20251111-arm_coresight_power_management_fix-v6-1-f55553b6c8b3@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/coresight.h | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/include/linux/coresight.h b/include/linux/coresight.h
index 59f99b7da43f5..0165a0b403cb9 100644
--- a/include/linux/coresight.h
+++ b/include/linux/coresight.h
@@ -245,15 +245,11 @@ struct coresight_trace_id_map {
  *		by @coresight_ops.
  * @access:	Device i/o access abstraction for this device.
  * @dev:	The device entity associated to this component.
- * @mode:	This tracer's mode, i.e sysFS, Perf or disabled. This is
- *		actually an 'enum cs_mode', but is stored in an atomic type.
- *		This is always accessed through local_read() and local_set(),
- *		but wherever it's done from within the Coresight device's lock,
- *		a non-atomic read would also work. This is the main point of
- *		synchronisation between code happening inside the sysfs mode's
- *		coresight_mutex and outside when running in Perf mode. A compare
- *		and exchange swap is done to atomically claim one mode or the
- *		other.
+ * @mode:	The device mode, i.e sysFS, Perf or disabled. This is actually
+ *		an 'enum cs_mode' but stored in an atomic type. Access is always
+ *		through atomic APIs, ensuring SMP-safe synchronisation between
+ *		racing from sysFS and Perf mode. A compare-and-exchange
+ *		operation is done to atomically claim one mode or the other.
  * @refcnt:	keep track of what is in use. Only access this outside of the
  *		device's spinlock when the coresight_mutex held and mode ==
  *		CS_MODE_SYSFS. Otherwise it must be accessed from inside the
@@ -282,7 +278,7 @@ struct coresight_device {
 	const struct coresight_ops *ops;
 	struct csdev_access access;
 	struct device dev;
-	local_t	mode;
+	atomic_t mode;
 	int refcnt;
 	bool orphan;
 	/* sink specific fields */
@@ -607,13 +603,14 @@ static inline bool coresight_is_percpu_sink(struct coresight_device *csdev)
 static inline bool coresight_take_mode(struct coresight_device *csdev,
 				       enum cs_mode new_mode)
 {
-	return local_cmpxchg(&csdev->mode, CS_MODE_DISABLED, new_mode) ==
-	       CS_MODE_DISABLED;
+	int curr = CS_MODE_DISABLED;
+
+	return atomic_try_cmpxchg_acquire(&csdev->mode, &curr, new_mode);
 }
 
 static inline enum cs_mode coresight_get_mode(struct coresight_device *csdev)
 {
-	return local_read(&csdev->mode);
+	return atomic_read_acquire(&csdev->mode);
 }
 
 static inline void coresight_set_mode(struct coresight_device *csdev,
@@ -629,7 +626,7 @@ static inline void coresight_set_mode(struct coresight_device *csdev,
 	WARN(new_mode != CS_MODE_DISABLED && current_mode != CS_MODE_DISABLED &&
 	     current_mode != new_mode, "Device already in use\n");
 
-	local_set(&csdev->mode, new_mode);
+	atomic_set_release(&csdev->mode, new_mode);
 }
 
 extern struct coresight_device *
-- 
2.51.0



