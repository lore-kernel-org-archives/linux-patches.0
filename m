Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14CF8BF4
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:33:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45C4EC4339B;
	Mon, 15 May 2023 16:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684168400;
	bh=zSrNkWFchZ8NLbAjmzbOVqlraRtWxxG7/TQQTwUGr6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eqJh6NPX5UCUXM5JzKo5tF1rFqivOKv9tx7uyHfUKytb5WOxJGCvZs5dt91nqCH6X
	 3kGRqnBV0XIJEbY358pEhMtCHv04HRv8neSXIF+bYQotkd6JJDrnBu3moUA51Vwui+
	 97QlbkKOvGrh511gcPO7mMOBFiJp0rTd6EHmuYyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 038/116] wifi: iwlwifi: mvm: check firmware response size
Date: Mon, 15 May 2023 18:25:35 +0200
Message-Id: <20230515161659.539195970@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161658.228491273@linuxfoundation.org>
References: <20230515161658.228491273@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 13513cec93ac9902d0b896976d8bab3758a9881c ]

Check the firmware response size for responses to the
memory read/write command in debugfs before using it.

Fixes: 2b55f43f8e47 ("iwlwifi: mvm: Add mem debugfs entry")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230417113648.0d56fcaf68ee.I70e9571f3ed7263929b04f8fabad23c9b999e4ea@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 714996187236e..7a830a9f702f7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -1721,6 +1721,11 @@ static ssize_t iwl_dbgfs_mem_read(struct file *file, char __user *user_buf,
 	if (ret < 0)
 		return ret;
 
+	if (iwl_rx_packet_payload_len(hcmd.resp_pkt) < sizeof(*rsp)) {
+		ret = -EIO;
+		goto out;
+	}
+
 	rsp = (void *)hcmd.resp_pkt->data;
 	if (le32_to_cpu(rsp->status) != DEBUG_MEM_STATUS_SUCCESS) {
 		ret = -ENXIO;
@@ -1798,6 +1803,11 @@ static ssize_t iwl_dbgfs_mem_write(struct file *file,
 	if (ret < 0)
 		return ret;
 
+	if (iwl_rx_packet_payload_len(hcmd.resp_pkt) < sizeof(*rsp)) {
+		ret = -EIO;
+		goto out;
+	}
+
 	rsp = (void *)hcmd.resp_pkt->data;
 	if (rsp->status != DEBUG_MEM_STATUS_SUCCESS) {
 		ret = -ENXIO;
-- 
2.39.2



