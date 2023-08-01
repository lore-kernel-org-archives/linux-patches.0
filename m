Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEBBA1FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:38:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B96C433C8;
	Tue,  1 Aug 2023 09:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882707;
	bh=zUJcbluYz7jkBnCTbhh7PZPnRrSGm44td9h0ivLaLhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U/ADt/NCWc1g5HgWKaAO6J7CfpLfz+mlECpdDsZiwD7vUx8qRCF3qjfUq2/tNaHMn
	 Fj1KrgMEkobX7ygW6pniY4Fka7aRCua564BEtib3dMfLl/oUFIRCUoWWsBxrIEOdVQ
	 p7h8Y7aLo1muw7S0i6p3lAxG+OQnwtctoQUqz2wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Rander Wang <rander.wang@linux.intel.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 202/228] soundwire: fix enumeration completion
Date: Tue,  1 Aug 2023 11:21:00 +0200
Message-ID: <20230801091930.165657580@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

commit c40d6b3249b11d60e09d81530588f56233d9aa44 upstream.

The soundwire subsystem uses two completion structures that allow
drivers to wait for soundwire device to become enumerated on the bus and
initialised by their drivers, respectively.

The code implementing the signalling is currently broken as it does not
signal all current and future waiters and also uses the wrong
reinitialisation function, which can potentially lead to memory
corruption if there are still waiters on the queue.

Not signalling future waiters specifically breaks sound card probe
deferrals as codec drivers can not tell that the soundwire device is
already attached when being reprobed. Some codec runtime PM
implementations suffer from similar problems as waiting for enumeration
during resume can also timeout despite the device already having been
enumerated.

Fixes: fb9469e54fa7 ("soundwire: bus: fix race condition with enumeration_complete signaling")
Fixes: a90def068127 ("soundwire: bus: fix race condition with initialization_complete signaling")
Cc: stable@vger.kernel.org      # 5.7
Cc: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc: Rander Wang <rander.wang@linux.intel.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20230705123018.30903-2-johan+linaro@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soundwire/bus.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/soundwire/bus.c
+++ b/drivers/soundwire/bus.c
@@ -884,8 +884,8 @@ static void sdw_modify_slave_status(stru
 			"initializing enumeration and init completion for Slave %d\n",
 			slave->dev_num);
 
-		init_completion(&slave->enumeration_complete);
-		init_completion(&slave->initialization_complete);
+		reinit_completion(&slave->enumeration_complete);
+		reinit_completion(&slave->initialization_complete);
 
 	} else if ((status == SDW_SLAVE_ATTACHED) &&
 		   (slave->status == SDW_SLAVE_UNATTACHED)) {
@@ -893,7 +893,7 @@ static void sdw_modify_slave_status(stru
 			"signaling enumeration completion for Slave %d\n",
 			slave->dev_num);
 
-		complete(&slave->enumeration_complete);
+		complete_all(&slave->enumeration_complete);
 	}
 	slave->status = status;
 	mutex_unlock(&bus->bus_lock);
@@ -1916,7 +1916,7 @@ int sdw_handle_slave_status(struct sdw_b
 				"signaling initialization completion for Slave %d\n",
 				slave->dev_num);
 
-			complete(&slave->initialization_complete);
+			complete_all(&slave->initialization_complete);
 
 			/*
 			 * If the manager became pm_runtime active, the peripherals will be


