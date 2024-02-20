Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F83A14F9DA;
	Tue, 20 Feb 2024 21:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465145; cv=none; b=UqugWVelFrq4gsOtYCEFgMIDc6UjidBbdFqxyT5Kx8nxQJvZ6g+Z6tOC+8/Ki3kjt9Rwhbif3xfNuabRqCYbwo9A2i4fd37eEFeH87XZUp53ABLDmvc7iXdN0K+RU/JHeELnTBvEV41Gwque2QPcsw+2W66/w9HUkIf8ytgTL1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465145; c=relaxed/simple;
	bh=fV+WJdfqWkB9ai/tHVu/A002IjuX+/PG1FNPfDXPDmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kearbzrh6ymbJ7LGYdBGN1kCllkRFXmPIh0XlSBxPrZSYVRoFq7uMdPX2DYQaoizxNGeez7M965UCStgb+R5b/SRv9oNKCD9A2agAwN8okGkv4fi1BGfvMDfLYlwnJdZ9JH0UaPcHNPbObbf9u33UWZ1e1W6exUXmrEqoe7mPbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tJAy0TsT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tJAy0TsT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D8BC433C7;
	Tue, 20 Feb 2024 21:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465145;
	bh=fV+WJdfqWkB9ai/tHVu/A002IjuX+/PG1FNPfDXPDmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tJAy0TsT5l0qEyPvu85U5S/BCVXwdNs0VegTXMFbfX/3kWkLmS+g6GQGmhxQf4PPZ
	 OjFinUvD4UY+w5AjaYxMUtzVosa1UwRrF8/BJh9gBC3eoqcH8mhAx3agaVdAnm+Z2q
	 BS43ic7UacKYqvGx/Vmsf8hsmyyhZfRZSz6e/tBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guy Kaplan <guy.kaplan@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH 6.7 250/309] wifi: iwlwifi: fix double-free bug
Date: Tue, 20 Feb 2024 21:56:49 +0100
Message-ID: <20240220205640.994869742@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -128,6 +128,7 @@ static void iwl_dealloc_ucode(struct iwl
 	kfree(drv->fw.ucode_capa.cmd_versions);
 	kfree(drv->fw.phy_integration_ver);
 	kfree(drv->trans->dbg.pc_data);
+	drv->trans->dbg.pc_data = NULL;
 
 	for (i = 0; i < IWL_UCODE_TYPE_MAX; i++)
 		iwl_free_fw_img(drv, drv->fw.img + i);


