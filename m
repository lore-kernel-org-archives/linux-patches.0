Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA743306F;
	Fri, 24 Nov 2023 18:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fnL0PGJD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01DC4C433C8;
	Fri, 24 Nov 2023 18:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851123;
	bh=XPC56owJdnUFFaxk0EgqWF19/Tv09JkzLKwL2nZTtjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fnL0PGJD9MLwIhfo6M7ZRNIQzbaFyRLm8QPpApDS1uO9VevGOMVHQ24eEgNdri01y
	 QewOfYkZXZoGYvC1E6Do74/k30AA60ztMnnzj4IRmJXE++IvLceUfRuOZ5yxUs3O0c
	 2GuTNfwefNPBy8vZmx+IGu1Py4j5TBZrGPkO1dA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.5 322/491] leds: trigger: netdev: Move size check in set_device_name
Date: Fri, 24 Nov 2023 17:49:18 +0000
Message-ID: <20231124172034.241183981@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Marangi <ansuelsmth@gmail.com>

commit 259e33cbb1712a7dd844fc9757661cc47cb0e39b upstream.

GCC 13.2 complains about array subscript 17 is above array bounds of
'char[16]' with IFNAMSIZ set to 16.

The warning is correct but this scenario is impossible.
set_device_name is called by device_name_store (store sysfs entry) and
netdev_trig_activate.

device_name_store already check if size is >= of IFNAMSIZ and return
-EINVAL. (making the warning scenario impossible)

netdev_trig_activate works on already defined interface, where the name
has already been checked and should already follow the condition of
strlen() < IFNAMSIZ.

Aside from the scenario being impossible, set_device_name can be
improved to both mute the warning and make the function safer.
To make it safer, move size check from device_name_store directly to
set_device_name and prevent any out of bounds scenario.

Cc: stable@vger.kernel.org
Fixes: 28a6a2ef18ad ("leds: trigger: netdev: refactor code setting device name")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202309192035.GTJEEbem-lkp@intel.com/
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Link: https://lore.kernel.org/r/20231007131042.15032-1-ansuelsmth@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/leds/trigger/ledtrig-netdev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index 58f3352539e8..e358e77e4b38 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -221,6 +221,9 @@ static ssize_t device_name_show(struct device *dev,
 static int set_device_name(struct led_netdev_data *trigger_data,
 			   const char *name, size_t size)
 {
+	if (size >= IFNAMSIZ)
+		return -EINVAL;
+
 	cancel_delayed_work_sync(&trigger_data->work);
 
 	mutex_lock(&trigger_data->lock);
@@ -263,9 +266,6 @@ static ssize_t device_name_store(struct device *dev,
 	struct led_netdev_data *trigger_data = led_trigger_get_drvdata(dev);
 	int ret;
 
-	if (size >= IFNAMSIZ)
-		return -EINVAL;
-
 	ret = set_device_name(trigger_data, buf, size);
 
 	if (ret < 0)
-- 
2.43.0



