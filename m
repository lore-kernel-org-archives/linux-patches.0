Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208D4E571;
	Mon, 14 Oct 2024 14:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916435; cv=none; b=Xcl2s86Fi9ARwOf4YbzKkfU7SZQmA8itANeKoVC5aMxGHojzeCwmM3hhnrkKoAaN5C68kYc5r/0pVgu6jlJ+jf5r5TSTlTcq4SwhubzV2VR9DqxYdsy5qPWe/ML2f8aP+abzn/vIASEbO64JRvk2jQWoSA8m84YmcNQ5N35yW6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916435; c=relaxed/simple;
	bh=MVt3keIZPJM5aDW4GS9kGEy+4VAndCx0Swsr0Frffpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PBMGeXRCsLnFseLdKmuCJ1ExdpX4ZXkGWWsefVSZ+8auk7dpgUYhW1WLo+uY/ZC5/f6puk2N7HG5tvBvyo/J3ce9DmS2LomYxVFdSU7A54m9znynyAx0Dxhw0fcx4+lnP7Q06j9+8BhfqD2yJ7LdfnYe0u4GymrFnMZ0h0X1D1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EhRncy71; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EhRncy71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F690C4CEC7;
	Mon, 14 Oct 2024 14:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916435;
	bh=MVt3keIZPJM5aDW4GS9kGEy+4VAndCx0Swsr0Frffpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EhRncy71wCTTWlQOudkkjUKphZ8QCI5nYh2nqZRE0opEspuyQsyqSFwxbjKBZHyKD
	 hPs4OHynd7d/9A4PrrHhw0STh+bR1YtWf/aBKAc+UfgTqcZRJtHMencHj+QEvsZimu
	 8FUiSjB5kgZ4qjqflyHF/CwCcx2t1pynznm+u5Cc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>
Subject: [PATCH 6.11 182/214] thermal: core: Reference count the zone in thermal_zone_get_by_id()
Date: Mon, 14 Oct 2024 16:20:45 +0200
Message-ID: <20241014141052.083543357@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit a42a5839f400e929c489bb1b58f54596c4535167 upstream.

There are places in the thermal netlink code where nothing prevents
the thermal zone object from going away while being accessed after it
has been returned by thermal_zone_get_by_id().

To address this, make thermal_zone_get_by_id() get a reference on the
thermal zone device object to be returned with the help of get_device(),
under thermal_list_lock, and adjust all of its callers to this change
with the help of the cleanup.h infrastructure.

Fixes: 1ce50e7d408e ("thermal: core: genetlink support for events/cmd/sampling")
Cc: 6.8+ <stable@vger.kernel.org> # 6.8+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Link: https://patch.msgid.link/6112242.lOV4Wx5bFT@rjwysocki.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/thermal_core.c    |    1 +
 drivers/thermal/thermal_core.h    |    3 +++
 drivers/thermal/thermal_netlink.c |    9 +++------
 3 files changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -737,6 +737,7 @@ struct thermal_zone_device *thermal_zone
 	mutex_lock(&thermal_list_lock);
 	list_for_each_entry(tz, &thermal_tz_list, node) {
 		if (tz->id == id) {
+			get_device(&tz->device);
 			match = tz;
 			break;
 		}
--- a/drivers/thermal/thermal_core.h
+++ b/drivers/thermal/thermal_core.h
@@ -194,6 +194,9 @@ int for_each_thermal_governor(int (*cb)(
 
 struct thermal_zone_device *thermal_zone_get_by_id(int id);
 
+DEFINE_CLASS(thermal_zone_get_by_id, struct thermal_zone_device *,
+	     if (_T) put_device(&_T->device), thermal_zone_get_by_id(id), int id)
+
 static inline bool cdev_is_power_actor(struct thermal_cooling_device *cdev)
 {
 	return cdev->ops->get_requested_power && cdev->ops->state2power &&
--- a/drivers/thermal/thermal_netlink.c
+++ b/drivers/thermal/thermal_netlink.c
@@ -443,7 +443,6 @@ static int thermal_genl_cmd_tz_get_trip(
 {
 	struct sk_buff *msg = p->msg;
 	const struct thermal_trip_desc *td;
-	struct thermal_zone_device *tz;
 	struct nlattr *start_trip;
 	int id;
 
@@ -452,7 +451,7 @@ static int thermal_genl_cmd_tz_get_trip(
 
 	id = nla_get_u32(p->attrs[THERMAL_GENL_ATTR_TZ_ID]);
 
-	tz = thermal_zone_get_by_id(id);
+	CLASS(thermal_zone_get_by_id, tz)(id);
 	if (!tz)
 		return -EINVAL;
 
@@ -488,7 +487,6 @@ out_cancel_nest:
 static int thermal_genl_cmd_tz_get_temp(struct param *p)
 {
 	struct sk_buff *msg = p->msg;
-	struct thermal_zone_device *tz;
 	int temp, ret, id;
 
 	if (!p->attrs[THERMAL_GENL_ATTR_TZ_ID])
@@ -496,7 +494,7 @@ static int thermal_genl_cmd_tz_get_temp(
 
 	id = nla_get_u32(p->attrs[THERMAL_GENL_ATTR_TZ_ID]);
 
-	tz = thermal_zone_get_by_id(id);
+	CLASS(thermal_zone_get_by_id, tz)(id);
 	if (!tz)
 		return -EINVAL;
 
@@ -514,7 +512,6 @@ static int thermal_genl_cmd_tz_get_temp(
 static int thermal_genl_cmd_tz_get_gov(struct param *p)
 {
 	struct sk_buff *msg = p->msg;
-	struct thermal_zone_device *tz;
 	int id, ret = 0;
 
 	if (!p->attrs[THERMAL_GENL_ATTR_TZ_ID])
@@ -522,7 +519,7 @@ static int thermal_genl_cmd_tz_get_gov(s
 
 	id = nla_get_u32(p->attrs[THERMAL_GENL_ATTR_TZ_ID]);
 
-	tz = thermal_zone_get_by_id(id);
+	CLASS(thermal_zone_get_by_id, tz)(id);
 	if (!tz)
 		return -EINVAL;
 


