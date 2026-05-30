Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C3A2F25E4;
	Sat, 30 May 2026 16:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780158451; cv=none; b=PhPZ5/42XgtcKnfAgbCGUX7fIk8kAgqEQonuPh5WZUogAU5otVy3dTXvCmfQnQbVT40W8iG7iSaVocZvrNJ5rc9JfXzY5yqYRML2qWGQjjQ+Yvxb9uG1THJ2ka/stkybYAdVxyNkfVKOU7ZeGMCAzepPPbgzHSBrdeuAoIWxfDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780158451; c=relaxed/simple;
	bh=n06M1WExdSWodiYyoWczxlJnAfOGVMe+mBN70JMdd4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s+3gl5tzarzi+EIHqddfrYLHDPUEh1/I4sOrEIxdPQwSqZ990fLu3Hr67ux3y6kW+cV9PKaavPCeCJkvfW63ggf/Xv9jnjt2danIaCneSJLCrA/i9C1uo47I4brcGkMuTzcJv1cVligmwCq4xMOCDMk7BtLd8F+lcdQPSXGFgqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pPismAHo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pPismAHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23FF71F00893;
	Sat, 30 May 2026 16:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780158449;
	bh=Yn71yYxYEAFYS+TMRg7reXtTL72L6kF7jhaKl5UrjDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pPismAHoGk3GmI3k//UQ0HdvrjV/CKcsno3B8g5DoLW+VkU5qJ4MsBA3dIi3zmZVX
	 umNe03HIUhg26B+tZQw0G+Ai+3C2oUza+xcyvMpVAg7ezvchpZtmArzVlkIsFWbj44
	 RrIBL/mLgtnn0aDobIHQK3sQyaNwzvfMt3cQ8M/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Thorsten Leemhuis <linux@leemhuis.info>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 052/969] Revert "drm: Fix use-after-free on framebuffers and property blobs when calling drm_dev_unplug"
Date: Sat, 30 May 2026 17:52:56 +0200
Message-ID: <20260530160301.833820814@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maarten Lankhorst <dev@lankhorst.se>

commit 45ebe43ea00d6b9f5b3e0db9c35b8ca2a96b7e70 upstream.

This reverts commit 6bee098b91417654703e17eb5c1822c6dfd0c01d.

Den 2026-03-25 kl. 22:11, skrev Simona Vetter:
> On Wed, Mar 25, 2026 at 10:26:40AM -0700, Guenter Roeck wrote:
>> Hi,
>>
>> On Fri, Mar 13, 2026 at 04:17:27PM +0100, Maarten Lankhorst wrote:
>>> When trying to do a rather aggressive test of igt's "xe_module_load
>>> --r reload" with a full desktop environment and game running I noticed
>>> a few OOPSes when dereferencing freed pointers, related to
>>> framebuffers and property blobs after the compositor exits.
>>>
>>> Solve this by guarding the freeing in drm_file with drm_dev_enter/exit,
>>> and immediately put the references from struct drm_file objects during
>>> drm_dev_unplug().
>>>
>>
>> With this patch in v6.18.20, I get the warning backtraces below.
>> The backtraces are gone with the patch reverted.
>
> Yeah, this needs to be reverted, reasoning below. Maarten, can you please
> take care of that and feed the revert through the usual channels? I don't
> think it's critical enough that we need to fast-track this into drm.git
> directly.
>
> Quoting the patch here again:
>
>>  drivers/gpu/drm/drm_file.c| 5 ++++-
>>  drivers/gpu/drm/drm_mode_config.c | 9 ++++++---
>>  2 files changed, 10 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/drm_file.c b/drivers/gpu/drm/drm_file.c
>> index ec820686b3021..f52141f842a1f 100644
>> --- a/drivers/gpu/drm/drm_file.c
>> +++ b/drivers/gpu/drm/drm_file.c
>> @@ -233,6 +233,7 @@ static void drm_events_release(struct drm_file *file_priv)
>>  void drm_file_free(struct drm_file *file)
>>  {
>>  struct drm_device *dev;
>> +int idx;
>>
>>  if (!file)
>>  return;
>> @@ -249,9 +250,11 @@ void drm_file_free(struct drm_file *file)
>>
>>  drm_events_release(file);
>>
>> -if (drm_core_check_feature(dev, DRIVER_MODESET)) {
>> +if (drm_core_check_feature(dev, DRIVER_MODESET) &&
>> +drm_dev_enter(dev, &idx)) {
>
> This is misplaced for two reasons:
>
> - Even if we'd want to guarantee that we hold a drm_dev_enter/exit
>   reference during framebuffer teardown, we'd need to do this
>   _consistently over all callsites. Not ad-hoc in just one place that a
>   testcase hits. This also means kerneldoc updates of the relevant hooks
>   and at least a bunch of acks from other driver people to document the
>   consensus.
>
> - More importantly, this is driver responsibilities in general unless we
>   have extremely good reasons to the contrary. Which means this must be
>   placed in xe.
>
>>  drm_fb_release(file);
>>  drm_property_destroy_user_blobs(dev, file);
>> +drm_dev_exit(idx);
>>  }
>>
>>  if (drm_core_check_feature(dev, DRIVER_SYNCOBJ))
>> diff --git a/drivers/gpu/drm/drm_mode_config.c b/drivers/gpu/drm/drm_mode_config.c
>> index 84ae8a23a3678..e349418978f79 100644
>> --- a/drivers/gpu/drm/drm_mode_config.c
>> +++ b/drivers/gpu/drm/drm_mode_config.c
>> @@ -583,10 +583,13 @@ void drm_mode_config_cleanup(struct drm_device *dev)
>>   */
>>  WARN_ON(!list_empty(&dev->mode_config.fb_list));
>>  list_for_each_entry_safe(fb, fbt, &dev->mode_config.fb_list, head) {
>> -struct drm_printer p = drm_dbg_printer(dev, DRM_UT_KMS, "[leaked fb]");
>> +if (list_empty(&fb->filp_head) || drm_framebuffer_read_refcount(fb) > 1) {
>> +struct drm_printer p = drm_dbg_printer(dev, DRM_UT_KMS, "[leaked fb]");
>
> This is also wrong:
>
> - Firstly, it's a completely independent bug, we do not smash two bugfixes
>   into one patch.
>
> - Secondly, it's again a driver bug: drm_mode_cleanup must be called when
>   the last drm_device reference disappears (hence the existence of
>   drmm_mode_config_init), not when the driver gets unbound. The fact that
>   this shows up in a callchain from a devres cleanup means the intel
>   driver gets this wrong (like almost everyone else because historically
>   we didn't know better).
>
>   If we don't follow this rule, then we get races with this code here
>   running concurrently with drm_file fb cleanups, which just does not
>   work. Review pointed that out, but then shrugged it off with a confused
>   explanation:
>
>   https://lore.kernel.org/all/e61e64c796ccfb17ae673331a3df4b877bf42d82.camel@linux.intel.com/
>
>   Yes this also means a lot of the other drm_device teardown that drivers
>   do happens way too early. There is a massive can of worms here of a
>   magnitude that most likely is much, much bigger than what you can
>   backport to stable kernels. Hotunplug is _hard_.

Back to the drawing board, and fixing it in the intel display driver
instead.

Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Fixes: 6bee098b9141 ("drm: Fix use-after-free on framebuffers and property blobs when calling drm_dev_unplug")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Simona Vetter <simona.vetter@ffwll.ch>
Signed-off-by: Maarten Lankhorst <dev@lankhorst.se>
Link: https://patch.msgid.link/20260326082217.39941-2-dev@lankhorst.se
[ Thorsten: adjust to the v6.6.y/v6.6.y backports of 6bee098b9141 ]
Signed-off-by: Thorsten Leemhuis <linux@leemhuis.info>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_file.c        | 5 +----
 drivers/gpu/drm/drm_mode_config.c | 9 +++------
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/drm_file.c b/drivers/gpu/drm/drm_file.c
index 3722c796e632f..d6a0572984b54 100644
--- a/drivers/gpu/drm/drm_file.c
+++ b/drivers/gpu/drm/drm_file.c
@@ -239,7 +239,6 @@ static void drm_events_release(struct drm_file *file_priv)
 void drm_file_free(struct drm_file *file)
 {
 	struct drm_device *dev;
-	int idx;
 
 	if (!file)
 		return;
@@ -265,11 +264,9 @@ void drm_file_free(struct drm_file *file)
 
 	drm_events_release(file);
 
-	if (drm_core_check_feature(dev, DRIVER_MODESET) &&
-	    drm_dev_enter(dev, &idx)) {
+	if (drm_core_check_feature(dev, DRIVER_MODESET)) {
 		drm_fb_release(file);
 		drm_property_destroy_user_blobs(dev, file);
-		drm_dev_exit(idx);
 	}
 
 	if (drm_core_check_feature(dev, DRIVER_SYNCOBJ))
diff --git a/drivers/gpu/drm/drm_mode_config.c b/drivers/gpu/drm/drm_mode_config.c
index 8c844bce4f28a..8525ef8515406 100644
--- a/drivers/gpu/drm/drm_mode_config.c
+++ b/drivers/gpu/drm/drm_mode_config.c
@@ -544,13 +544,10 @@ void drm_mode_config_cleanup(struct drm_device *dev)
 	 */
 	WARN_ON(!list_empty(&dev->mode_config.fb_list));
 	list_for_each_entry_safe(fb, fbt, &dev->mode_config.fb_list, head) {
-		if (list_empty(&fb->filp_head) || drm_framebuffer_read_refcount(fb) > 1) {
-			struct drm_printer p = drm_debug_printer("[leaked fb]");
+		struct drm_printer p = drm_debug_printer("[leaked fb]");
 
-			drm_printf(&p, "framebuffer[%u]:\n", fb->base.id);
-			drm_framebuffer_print_info(&p, 1, fb);
-		}
-		list_del_init(&fb->filp_head);
+		drm_printf(&p, "framebuffer[%u]:\n", fb->base.id);
+		drm_framebuffer_print_info(&p, 1, fb);
 		drm_framebuffer_free(&fb->base.refcount);
 	}
 
-- 
2.53.0



