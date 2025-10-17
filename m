Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813E91D5CE0;
	Fri, 17 Oct 2025 15:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714851; cv=none; b=r/cdTYBLuEZXpKyNZlOpGFqpKPlP19e2765LCSDzr1EdUz8MNLuI4jpxhDf14Q0BEgLm5u09FJEKFHLl3Vrmi6q1+OsIsVcN6zZpQNRpbTM6RIREiDna2pLK45vBiuIoNMafJnCQ8s8+2lHHVR7XgR3elcWud1mK2QRiX7TMnVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714851; c=relaxed/simple;
	bh=7e2dm3xsPWc1XsjLq52KVCx+5p3EnBfUpD4I+vrDvAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MAKXVMiqirhvJtwmWwrWRVZj9QCArk9lYpTl4IPecVy63V/SE0iQIcub7/H6r5E4NJilxjkLl1YYbB9x9BvEnP6iSrfF2WVdONl/WNSJ7mmhZm8hYA1uG6eTl2W9Nm1NuyZt00dhr8RuBzk1HmcIC8/J2pMYkGKgAD+U+abpzUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VKTxYvOW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VKTxYvOW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1035C4CEE7;
	Fri, 17 Oct 2025 15:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714851;
	bh=7e2dm3xsPWc1XsjLq52KVCx+5p3EnBfUpD4I+vrDvAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VKTxYvOWiqQ0/1HM0Vc3EzEuRJdwgy3iHLMStgqEEINmhp+42RJNzVWf7XrHmwc+b
	 4zoM1yRvudLs1W9Jw+k1dQETGwBY5fiH9yI6CM850S90Zgc6gJHN/p2tT58tD4onpd
	 Y4oeRB67ZeCEUgsCJ2ZgUBNzWduQU5Wn7JVMelmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Norris <briannorris@chromium.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.17 011/371] PM: runtime: Update kerneldoc return codes
Date: Fri, 17 Oct 2025 16:49:46 +0200
Message-ID: <20251017145202.204198889@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Norris <briannorris@chromium.org>

commit fed7eaa4f037361fe4f3d4170649d6849a25998d upstream.

APIs based on __pm_runtime_idle() (pm_runtime_idle(), pm_request_idle())
do not return 1 when already suspended. They return -EAGAIN. This is
already covered in the docs, so the entry for "1" is redundant and
conflicting.

(pm_runtime_put() and pm_runtime_put_sync() were previously incorrect,
but that's fixed in "PM: runtime: pm_runtime_put{,_sync}() returns 1
when already suspended", to ensure consistency with APIs like
pm_runtime_put_autosuspend().)

RPM_GET_PUT APIs based on __pm_runtime_suspend() do return 1 when
already suspended, but the language is a little unclear -- it's not
really an "error", so it seems better to list as a clarification before
the 0/success case. Additionally, they only actually return 1 when the
refcount makes it to 0; if the usage counter is still non-zero, we
return 0.

pm_runtime_put(), etc., also don't appear at first like they can ever
see "-EAGAIN: Runtime PM usage_count non-zero", because in non-racy
conditions, pm_runtime_put() would drop its reference count, see it's
non-zero, and return early (in __pm_runtime_idle()). However, it's
possible to race with another actor that increments the usage_count
afterward, since rpm_idle() is protected by a separate lock; in such a
case, we may see -EAGAIN.

Because this case is only seen in the presence of concurrent actors, it
makes sense to clarify that this is when "usage_count **became**
non-zero", by way of some racing actor.

Lastly, pm_runtime_put_sync_suspend() duplicated some -EAGAIN language.
Fix that.

Fixes: 271ff96d6066 ("PM: runtime: Document return values of suspend-related API functions")
Link: https://lore.kernel.org/linux-pm/aJ5pkEJuixTaybV4@google.com/
Signed-off-by: Brian Norris <briannorris@chromium.org>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: 6.17+ <stable@vger.kernel.org> # 6.17+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/pm_runtime.h |   56 ++++++++++++++++++++++++---------------------
 1 file changed, 31 insertions(+), 25 deletions(-)

--- a/include/linux/pm_runtime.h
+++ b/include/linux/pm_runtime.h
@@ -350,13 +350,12 @@ static inline int pm_runtime_force_resum
  * * 0: Success.
  * * -EINVAL: Runtime PM error.
  * * -EACCES: Runtime PM disabled.
- * * -EAGAIN: Runtime PM usage_count non-zero, Runtime PM status change ongoing
- *            or device not in %RPM_ACTIVE state.
+ * * -EAGAIN: Runtime PM usage counter non-zero, Runtime PM status change
+ *            ongoing or device not in %RPM_ACTIVE state.
  * * -EBUSY: Runtime PM child_count non-zero.
  * * -EPERM: Device PM QoS resume latency 0.
  * * -EINPROGRESS: Suspend already in progress.
  * * -ENOSYS: CONFIG_PM not enabled.
- * * 1: Device already suspended.
  * Other values and conditions for the above values are possible as returned by
  * Runtime PM idle and suspend callbacks.
  */
@@ -370,14 +369,15 @@ static inline int pm_runtime_idle(struct
  * @dev: Target device.
  *
  * Return:
+ * * 1: Success; device was already suspended.
  * * 0: Success.
  * * -EINVAL: Runtime PM error.
  * * -EACCES: Runtime PM disabled.
- * * -EAGAIN: Runtime PM usage_count non-zero or Runtime PM status change ongoing.
+ * * -EAGAIN: Runtime PM usage counter non-zero or Runtime PM status change
+ *            ongoing.
  * * -EBUSY: Runtime PM child_count non-zero.
  * * -EPERM: Device PM QoS resume latency 0.
  * * -ENOSYS: CONFIG_PM not enabled.
- * * 1: Device already suspended.
  * Other values and conditions for the above values are possible as returned by
  * Runtime PM suspend callbacks.
  */
@@ -396,14 +396,15 @@ static inline int pm_runtime_suspend(str
  * engaging its "idle check" callback.
  *
  * Return:
+ * * 1: Success; device was already suspended.
  * * 0: Success.
  * * -EINVAL: Runtime PM error.
  * * -EACCES: Runtime PM disabled.
- * * -EAGAIN: Runtime PM usage_count non-zero or Runtime PM status change ongoing.
+ * * -EAGAIN: Runtime PM usage counter non-zero or Runtime PM status change
+ *            ongoing.
  * * -EBUSY: Runtime PM child_count non-zero.
  * * -EPERM: Device PM QoS resume latency 0.
  * * -ENOSYS: CONFIG_PM not enabled.
- * * 1: Device already suspended.
  * Other values and conditions for the above values are possible as returned by
  * Runtime PM suspend callbacks.
  */
@@ -433,13 +434,12 @@ static inline int pm_runtime_resume(stru
  * * 0: Success.
  * * -EINVAL: Runtime PM error.
  * * -EACCES: Runtime PM disabled.
- * * -EAGAIN: Runtime PM usage_count non-zero, Runtime PM status change ongoing
- *            or device not in %RPM_ACTIVE state.
+ * * -EAGAIN: Runtime PM usage counter non-zero, Runtime PM status change
+ *            ongoing or device not in %RPM_ACTIVE state.
  * * -EBUSY: Runtime PM child_count non-zero.
  * * -EPERM: Device PM QoS resume latency 0.
  * * -EINPROGRESS: Suspend already in progress.
  * * -ENOSYS: CONFIG_PM not enabled.
- * * 1: Device already suspended.
  */
 static inline int pm_request_idle(struct device *dev)
 {
@@ -464,15 +464,16 @@ static inline int pm_request_resume(stru
  * equivalent pm_runtime_autosuspend() for @dev asynchronously.
  *
  * Return:
+ * * 1: Success; device was already suspended.
  * * 0: Success.
  * * -EINVAL: Runtime PM error.
  * * -EACCES: Runtime PM disabled.
- * * -EAGAIN: Runtime PM usage_count non-zero or Runtime PM status change ongoing.
+ * * -EAGAIN: Runtime PM usage counter non-zero or Runtime PM status change
+ *            ongoing.
  * * -EBUSY: Runtime PM child_count non-zero.
  * * -EPERM: Device PM QoS resume latency 0.
  * * -EINPROGRESS: Suspend already in progress.
  * * -ENOSYS: CONFIG_PM not enabled.
- * * 1: Device already suspended.
  */
 static inline int pm_request_autosuspend(struct device *dev)
 {
@@ -540,15 +541,16 @@ static inline int pm_runtime_resume_and_
  * equal to 0, queue up a work item for @dev like in pm_request_idle().
  *
  * Return:
+ * * 1: Success. Usage counter dropped to zero, but device was already suspended.
  * * 0: Success.
  * * -EINVAL: Runtime PM error.
  * * -EACCES: Runtime PM disabled.
- * * -EAGAIN: Runtime PM usage_count non-zero or Runtime PM status change ongoing.
+ * * -EAGAIN: Runtime PM usage counter became non-zero or Runtime PM status
+ *            change ongoing.
  * * -EBUSY: Runtime PM child_count non-zero.
  * * -EPERM: Device PM QoS resume latency 0.
  * * -EINPROGRESS: Suspend already in progress.
  * * -ENOSYS: CONFIG_PM not enabled.
- * * 1: Device already suspended.
  */
 static inline int pm_runtime_put(struct device *dev)
 {
@@ -565,15 +567,16 @@ DEFINE_FREE(pm_runtime_put, struct devic
  * equal to 0, queue up a work item for @dev like in pm_request_autosuspend().
  *
  * Return:
+ * * 1: Success. Usage counter dropped to zero, but device was already suspended.
  * * 0: Success.
  * * -EINVAL: Runtime PM error.
  * * -EACCES: Runtime PM disabled.
- * * -EAGAIN: Runtime PM usage_count non-zero or Runtime PM status change ongoing.
+ * * -EAGAIN: Runtime PM usage counter became non-zero or Runtime PM status
+ *            change ongoing.
  * * -EBUSY: Runtime PM child_count non-zero.
  * * -EPERM: Device PM QoS resume latency 0.
  * * -EINPROGRESS: Suspend already in progress.
  * * -ENOSYS: CONFIG_PM not enabled.
- * * 1: Device already suspended.
  */
 static inline int __pm_runtime_put_autosuspend(struct device *dev)
 {
@@ -590,15 +593,16 @@ static inline int __pm_runtime_put_autos
  * in pm_request_autosuspend().
  *
  * Return:
+ * * 1: Success. Usage counter dropped to zero, but device was already suspended.
  * * 0: Success.
  * * -EINVAL: Runtime PM error.
  * * -EACCES: Runtime PM disabled.
- * * -EAGAIN: Runtime PM usage_count non-zero or Runtime PM status change ongoing.
+ * * -EAGAIN: Runtime PM usage counter became non-zero or Runtime PM status
+ *            change ongoing.
  * * -EBUSY: Runtime PM child_count non-zero.
  * * -EPERM: Device PM QoS resume latency 0.
  * * -EINPROGRESS: Suspend already in progress.
  * * -ENOSYS: CONFIG_PM not enabled.
- * * 1: Device already suspended.
  */
 static inline int pm_runtime_put_autosuspend(struct device *dev)
 {
@@ -619,14 +623,15 @@ static inline int pm_runtime_put_autosus
  * if it returns an error code.
  *
  * Return:
+ * * 1: Success. Usage counter dropped to zero, but device was already suspended.
  * * 0: Success.
  * * -EINVAL: Runtime PM error.
  * * -EACCES: Runtime PM disabled.
- * * -EAGAIN: Runtime PM usage_count non-zero or Runtime PM status change ongoing.
+ * * -EAGAIN: Runtime PM usage counter became non-zero or Runtime PM status
+ *            change ongoing.
  * * -EBUSY: Runtime PM child_count non-zero.
  * * -EPERM: Device PM QoS resume latency 0.
  * * -ENOSYS: CONFIG_PM not enabled.
- * * 1: Device already suspended.
  * Other values and conditions for the above values are possible as returned by
  * Runtime PM suspend callbacks.
  */
@@ -646,15 +651,15 @@ static inline int pm_runtime_put_sync(st
  * if it returns an error code.
  *
  * Return:
+ * * 1: Success. Usage counter dropped to zero, but device was already suspended.
  * * 0: Success.
  * * -EINVAL: Runtime PM error.
  * * -EACCES: Runtime PM disabled.
- * * -EAGAIN: Runtime PM usage_count non-zero or Runtime PM status change ongoing.
- * * -EAGAIN: usage_count non-zero or Runtime PM status change ongoing.
+ * * -EAGAIN: Runtime PM usage counter became non-zero or Runtime PM status
+ *            change ongoing.
  * * -EBUSY: Runtime PM child_count non-zero.
  * * -EPERM: Device PM QoS resume latency 0.
  * * -ENOSYS: CONFIG_PM not enabled.
- * * 1: Device already suspended.
  * Other values and conditions for the above values are possible as returned by
  * Runtime PM suspend callbacks.
  */
@@ -677,15 +682,16 @@ static inline int pm_runtime_put_sync_su
  * if it returns an error code.
  *
  * Return:
+ * * 1: Success. Usage counter dropped to zero, but device was already suspended.
  * * 0: Success.
  * * -EINVAL: Runtime PM error.
  * * -EACCES: Runtime PM disabled.
- * * -EAGAIN: Runtime PM usage_count non-zero or Runtime PM status change ongoing.
+ * * -EAGAIN: Runtime PM usage counter became non-zero or Runtime PM status
+ *            change ongoing.
  * * -EBUSY: Runtime PM child_count non-zero.
  * * -EPERM: Device PM QoS resume latency 0.
  * * -EINPROGRESS: Suspend already in progress.
  * * -ENOSYS: CONFIG_PM not enabled.
- * * 1: Device already suspended.
  * Other values and conditions for the above values are possible as returned by
  * Runtime PM suspend callbacks.
  */


