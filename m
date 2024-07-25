Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08D48468;
	Thu, 25 Jul 2024 14:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919074; cv=none; b=Fs9kHpI53E2nIL6MHnF3c6RCtGQetfEZ7vugqjMznZKurP6Fb7IzXsGjs7IMoALhihnkfvqHcjTlsCzBAkM+GPNlSs+8fV6VG2rnKaSUeXR+nQ517rLnpoA+WnUiAl6iwp4RqG9sjyW7/Bnr0GnypqEc972I/uUQDB1gkBabZ2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919074; c=relaxed/simple;
	bh=e6ggF2XX54wXiMfNTzCnoWhtB40o+b5vHO4ajDTNZtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pQXsEB70XCwzfLUqWC5OZDwza7fJN0quSFI7jCy07KzX/LXZpDWIAVliJpI5AXB52PK57AUSfdHH23DzMtBBO6P144Ipa9FZAQ42XLLGPZ9ALqeDD5/CtEBQEKe5mES5w0G9cwKC18W3EofCNAczNbgwzQ5DlSEP0+aUTFPDoFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aVJRvuHp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aVJRvuHp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F128AC116B1;
	Thu, 25 Jul 2024 14:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919074;
	bh=e6ggF2XX54wXiMfNTzCnoWhtB40o+b5vHO4ajDTNZtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aVJRvuHpyJjTeR3GLdEWFurJVFRDF7q3mP+iZBiKeO89yrpif21bMJE2mPIZyhvjB
	 d6AGhmiqB7uUYSqrPmMWOHxj1EPW+4YP7mJ/gC9QPDEAVtOArDDgoTNeUPCdGOZ864
	 oJlyXnCUAGjAGp6uedSlv6YuExH1u3qHm99+MDXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yedidya Benshimol <yedidya.ben.shimol@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 16/87] wifi: iwlwifi: mvm: d3: fix WoWLAN command version lookup
Date: Thu, 25 Jul 2024 16:36:49 +0200
Message-ID: <20240725142739.045317401@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142738.422724252@linuxfoundation.org>
References: <20240725142738.422724252@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yedidya Benshimol <yedidya.ben.shimol@intel.com>

[ Upstream commit b7ffca99313d856f7d1cc89038d9061b128e8e97 ]

After moving from commands to notificaitons in the d3 resume flow,
removing the WOWLAN_GET_STATUSES and REPLY_OFFLOADS_QUERY_CMD causes
the return of the default value when looking up their version.
Returning zero here results in the driver sending the not supported
NON_QOS_TX_COUNTER_CMD.

Signed-off-by: Yedidya Benshimol <yedidya.ben.shimol@intel.com>
Reviewed-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240510170500.8cabfd580614.If3a0db9851f56041f8f5360959354abd5379224a@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index c4c62bcbe67de..f9b004d139501 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -1796,7 +1796,8 @@ static bool iwl_mvm_setup_connection_keep(struct iwl_mvm *mvm,
 
 out:
 	if (iwl_fw_lookup_notif_ver(mvm->fw, LONG_GROUP,
-				    WOWLAN_GET_STATUSES, 0) < 10) {
+				    WOWLAN_GET_STATUSES,
+				    IWL_FW_CMD_VER_UNKNOWN) < 10) {
 		mvmvif->seqno_valid = true;
 		/* +0x10 because the set API expects next-to-use, not last-used */
 		mvmvif->seqno = le16_to_cpu(status->non_qos_seq_ctr) + 0x10;
-- 
2.43.0



