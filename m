Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596862031A
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zzW5blxf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8FECC433C8;
	Tue, 31 Oct 2023 17:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698771896;
	bh=1Mwy/jmEEX/VZZNz6YEczlT409dZHhokDz0GX07PitA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zzW5blxfFNeSFHTzDTdnxT+iuYAF/oGgaxq0XYvLjie+nOnR43mjY/QmDWSDAIHGb
	 o4vvFztVKnZcryymguY3u3AjvGD55WhQTOGpmOWnd8chn1lWrG/DFqEl3I1gLatxpJ
	 K7d5hiRnZG1MG9yq4BsqAPIEeX5LgoSHmwaKvgBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Schmidt <mschmidt@redhat.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 55/86] iavf: in iavf_down, disable queues when removing the driver
Date: Tue, 31 Oct 2023 18:01:20 +0100
Message-ID: <20231031165920.291542868@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165918.608547597@linuxfoundation.org>
References: <20231031165918.608547597@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Schmidt <mschmidt@redhat.com>

[ Upstream commit 53798666648af3aa0dd512c2380576627237a800 ]

In iavf_down, we're skipping the scheduling of certain operations if
the driver is being removed. However, the IAVF_FLAG_AQ_DISABLE_QUEUES
request must not be skipped in this case, because iavf_close waits
for the transition to the __IAVF_DOWN state, which happens in
iavf_virtchnl_completion after the queues are released.

Without this fix, "rmmod iavf" takes half a second per interface that's
up and prints the "Device resources not yet released" warning.

Fixes: c8de44b577eb ("iavf: do not process adminq tasks when __IAVF_IN_REMOVE_TASK is set")
Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Tested-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://lore.kernel.org/r/20231025183213.874283-1-jacob.e.keller@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 1ae90f8f9941f..326bb5fdf5f90 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1449,9 +1449,9 @@ void iavf_down(struct iavf_adapter *adapter)
 			adapter->aq_required |= IAVF_FLAG_AQ_DEL_FDIR_FILTER;
 		if (!list_empty(&adapter->adv_rss_list_head))
 			adapter->aq_required |= IAVF_FLAG_AQ_DEL_ADV_RSS_CFG;
-		adapter->aq_required |= IAVF_FLAG_AQ_DISABLE_QUEUES;
 	}
 
+	adapter->aq_required |= IAVF_FLAG_AQ_DISABLE_QUEUES;
 	mod_delayed_work(adapter->wq, &adapter->watchdog_task, 0);
 }
 
-- 
2.42.0



