Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B453A524C2;
	Thu, 30 Nov 2023 16:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UNBLkl6N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 458C2C433C8;
	Thu, 30 Nov 2023 16:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361662;
	bh=UhC1S0xmO5+Z3kwieVvlG5vWXxuF9Vxs+mi1SnJVbn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UNBLkl6NidS5QKYgB/S+Jzy2JEcMkUdTmbOBQi01oBbt6lMU4YTGxBzFBohmM8n04
	 iduCJ/iwqOiHZafH5UYuUeiV8zojKVr0ZpoTXVrVimLj9FJ8R9fiUkstTV4gY0TUwB
	 36HAyXmxILNIl311vAQsblZ7spScdiAglDEgiNFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.6 077/112] platform/x86: hp-bioscfg: Fix error handling in hp_add_other_attributes()
Date: Thu, 30 Nov 2023 16:22:04 +0000
Message-ID: <20231130162142.770192701@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

commit f40f939917b2b4cbf18450096c0ce1c58ed59fae upstream.

'attr_name_kobj' is allocated using kzalloc, but on all the error paths
it is not freed, hence we have a memory leak.

Fix the error path before kobject_init_and_add() by adding kfree().

kobject_put() must be always called after passing the object to
kobject_init_and_add(). Only the error path which is immediately next
to kobject_init_and_add() calls kobject_put() and not any other error
path after it.

Fix the error handling after kobject_init_and_add() by moving the
kobject_put() into the goto label err_other_attr_init that is already
used by all the error paths after kobject_init_and_add().

Fixes: a34fc329b189 ("platform/x86: hp-bioscfg: bioscfg")
Cc: stable@vger.kernel.org # 6.6.x: c5dbf0416000: platform/x86: hp-bioscfg: Simplify return check in hp_add_other_attributes()
Cc: stable@vger.kernel.org # 6.6.x: 5736aa9537c9: platform/x86: hp-bioscfg: move mutex_lock() down in hp_add_other_attributes()
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202309201412.on0VXJGo-lkp@intel.com/
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
[ij: Added the stable dep tags]
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20231113200742.3593548-3-harshit.m.mogalapalli@oracle.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/hp/hp-bioscfg/bioscfg.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c b/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c
index a3599498c4e8..6ddca857cc4d 100644
--- a/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/bioscfg.c
@@ -613,14 +613,14 @@ static int hp_add_other_attributes(int attr_type)
 	default:
 		pr_err("Error: Unknown attr_type: %d\n", attr_type);
 		ret = -EINVAL;
-		goto err_other_attr_init;
+		kfree(attr_name_kobj);
+		goto unlock_drv_mutex;
 	}
 
 	ret = kobject_init_and_add(attr_name_kobj, &attr_name_ktype,
 				   NULL, "%s", attr_name);
 	if (ret) {
 		pr_err("Error encountered [%d]\n", ret);
-		kobject_put(attr_name_kobj);
 		goto err_other_attr_init;
 	}
 
@@ -645,6 +645,8 @@ static int hp_add_other_attributes(int attr_type)
 	return 0;
 
 err_other_attr_init:
+	kobject_put(attr_name_kobj);
+unlock_drv_mutex:
 	mutex_unlock(&bioscfg_drv.mutex);
 	kfree(obj);
 	return ret;
-- 
2.43.0



