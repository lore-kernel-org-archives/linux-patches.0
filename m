Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439FD612D7;
	Tue, 20 Feb 2024 21:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463956; cv=none; b=PiOgZF8WWUzJ0w9PsyOk75MX+4ZSd3f5GKBOJWxouWQ4edSgKYFRtIsaQTApEXiifHQ/BVceBVRXH6smH26lwbOn+CXD8CSBGfY3lamv0vyUopzWXTRMgzeeBzTWqLvkr9yM0v9SlO5fnOfKQKJewuVTB4U0Qeu/L+J0lVLU3+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463956; c=relaxed/simple;
	bh=rJOHBmF0um+6UxvsARUfvVH5ZCEDrKv0fnMK0zhD1K4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z8hUHm/fDkImwI0g9FKjR+F+wva8BCzl6VqwvQS6KytOuxJwjITCatPz/GwzwC5jCopOC/taR8qmM/shUy6yXtIJRh5p4xPlqYmdxJ40pMAHs6OknhL3Q5W8ZyOdlCLSF4x7QFJzc5fdbdHP1k2jIDl3G0Q5RsAUoOhy8RQWX5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=casiQPpC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="casiQPpC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B69FDC433C7;
	Tue, 20 Feb 2024 21:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463956;
	bh=rJOHBmF0um+6UxvsARUfvVH5ZCEDrKv0fnMK0zhD1K4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=casiQPpCj7M4IaooyeTXHURPh8KZaYfCrZc2UviZvtd0GFcebNqdni0S/de6emzkz
	 409eXkeMKxF5sO4wwk83k+S9OxYx11LAAdSVOMctpC2QntwRTdiAfRPRjZrMaVPSOD
	 Z3Kovb9yCQ9VNwYvSrsf+i7l9s33jjbo1C5iYNEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guy Kaplan <guy.kaplan@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH 6.6 206/331] wifi: iwlwifi: fix double-free bug
Date: Tue, 20 Feb 2024 21:55:22 +0100
Message-ID: <20240220205644.166115676@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 353d321f63f7dbfc9ef58498cc732c9fe886a596 upstream.

The storage for the TLV PC register data wasn't done like all
the other storage in the drv->fw area, which is cleared at the
end of deallocation. Therefore, the freeing must also be done
differently, explicitly NULL'ing it out after the free, since
otherwise there's a nasty double-free bug here if a file fails
to load after this has been parsed, and we get another free
later (e.g. because no other file exists.) Fix that by adding
the missing NULL assignment.

Cc: stable@vger.kernel.org
Fixes: 5e31b3df86ec ("wifi: iwlwifi: dbg: print pc register data once fw dump occurred")
Reported-by: Guy Kaplan <guy.kaplan@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240123200528.675f3c24ec0d.I6ab4015cd78d82dd95471f840629972ef0331de3@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index ffe2670720c9..abf8001bdac1 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -128,6 +128,7 @@ static void iwl_dealloc_ucode(struct iwl_drv *drv)
 	kfree(drv->fw.ucode_capa.cmd_versions);
 	kfree(drv->fw.phy_integration_ver);
 	kfree(drv->trans->dbg.pc_data);
+	drv->trans->dbg.pc_data = NULL;
 
 	for (i = 0; i < IWL_UCODE_TYPE_MAX; i++)
 		iwl_free_fw_img(drv, drv->fw.img + i);
-- 
2.43.2



