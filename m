Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49FF21A76B2;
	Tue, 30 Jul 2024 17:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360336; cv=none; b=fJ5/PuxNOauJbN8Vg5ksvIeyGyUehys3bIbFeNDuIaGWkRpDB0gTG/1cHvshMT0X2d2sbEh+XSQN1/PIyGkUyo03Cm2th2NjpjCJYG9zNJvzLgJyYVjd+ZaZoQ0nFvuJhp5T4QNQ7mmBJUE12gxujH+lmYPwil/aLZXMraSBFXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360336; c=relaxed/simple;
	bh=vh1rMt5quOXSyfHrMEPq67gf5LY1GvvQn2UFmmy/wi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bT+DupdEkGpSgMvJc7mH9jruwPbSHWs/RLSl/dWuh02rxQZ8g9dTk/U/PSeaJ0KAmssgJAWfQJEg+jwbFE8MeqBoBPWPzYF8v6X+L28jf1DC70HP4qOhP51yb2qDrYD9qOx5toGw3Jak1+kOpVrHCE0wi/N2Z8lQxpw+JEZCYIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KoOws8IK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KoOws8IK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ADAEC32782;
	Tue, 30 Jul 2024 17:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360336;
	bh=vh1rMt5quOXSyfHrMEPq67gf5LY1GvvQn2UFmmy/wi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KoOws8IKO7vkXSBcWHiTSfuqlXnQZnU2r/jzh4wISx6GuEqzJ+djN9Dt3yySa4Orb
	 eh25eOKzzAD6djQwyZMrr6OJnaSjOxKpItl8PristZ/dY3GKUdvnMNfEUOIzmi5D2A
	 lbFS3Y4x/BvIkFgZdlfH44+jDDgyPW6+OxPIi3fA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.10 668/809] ASoC: SOF: ipc4-topology: Preserve the DMA Link ID for ChainDMA on unprepare
Date: Tue, 30 Jul 2024 17:49:04 +0200
Message-ID: <20240730151751.287564831@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit e6fc5fcaeffa04a3fa1db8dfccdfd4b6001c0446 upstream.

The DMA Link ID is set to the IPC message's primary during dai_config,
which is only during hw_params.
During xrun handling the hw_params is not called and the DMA Link ID
information will be lost.

All other fields in the message expected to be 0 for re-configuration, only
the DMA Link ID needs to be preserved and the in case of repeated
dai_config, it is correctly updated (masked and then set).

Cc: stable@vger.kernel.org
Fixes: ca5ce0caa67f ("ASoC: SOF: ipc4/intel: Add support for chained DMA")
Link: https://github.com/thesofproject/linux/issues/5116
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://patch.msgid.link/20240724081932.24542-3-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/ipc4-topology.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -1358,7 +1358,13 @@ static void sof_ipc4_unprepare_copier_mo
 		ipc4_copier = dai->private;
 
 		if (pipeline->use_chain_dma) {
-			pipeline->msg.primary = 0;
+			/*
+			 * Preserve the DMA Link ID and clear other bits since
+			 * the DMA Link ID is only configured once during
+			 * dai_config, other fields are expected to be 0 for
+			 * re-configuration
+			 */
+			pipeline->msg.primary &= SOF_IPC4_GLB_CHAIN_DMA_LINK_ID_MASK;
 			pipeline->msg.extension = 0;
 		}
 


