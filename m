Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2622AE8D;
	Tue, 11 Nov 2025 00:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822184; cv=none; b=X/EKdVAXdEJ3WH/nx+HeFZp2ghHBzj8L1wHl9OZSaBBeltFcmLFIY/R6R9JKN0G+1ZbbntOl5O3oKNxpsEb/Vh0bMP2EPthyLJX8OopAq/IEsooMLgxMCDaovdU+aO2YI+14B8rvllVju/a/EHW82XR+B1Jh/0/FPOIg03zB7GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822184; c=relaxed/simple;
	bh=ztxRp6pAZC/wQtlbd0wQhRlHFMVB47LS3WqsoLh4d5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OJJEoUdNDja7wJdSvKuhFp4Bll3i3BzZw12G6DcSv1buunqIpB1lATFaAj6aDNU+kPktkaptjMOefcBxisPa7Ww9HvCJpad/guMJjCIHVW/4trZVfbkcGJmsUVH+QUyBSnDyV593AyXFJbOqydNny8PlNXBYaOWMsitz3ewY73g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sTu8m2xa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sTu8m2xa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55551C116B1;
	Tue, 11 Nov 2025 00:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822183;
	bh=ztxRp6pAZC/wQtlbd0wQhRlHFMVB47LS3WqsoLh4d5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sTu8m2xahSS69qUlnzO9IVUW9oCnvShKp0MzC4M4lBn97stR7fqMimyQ5CTZ4NRme
	 AxxodptLvfzXSMbxZpZRtiHob41CU6uNqO5H2QxlVEwB4OFL3NocnIdsFEbvMvtyeh
	 V0+2La66K/6TkYwRhOhUL5kJ10kcVMo89VGu5COE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 050/849] ASoC: Intel: avs: Unprepare a stream when XRUN occurs
Date: Tue, 11 Nov 2025 09:33:40 +0900
Message-ID: <20251111004537.646458496@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit cfca1637bc2b6b1e4f191d2f0b25f12402fbbb26 ]

The pcm->prepare() function may be called multiple times in a row by the
userspace, as mentioned in the documentation. The driver shall take that
into account and prevent redundancy. However, the exact same function is
called during XRUNs and in such case, the particular stream shall be
reset and setup anew.

Fixes: 9114700b496c ("ASoC: Intel: avs: Generic PCM FE operations")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20251023092348.3119313-2-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/pcm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/intel/avs/pcm.c b/sound/soc/intel/avs/pcm.c
index 67ce6675eea75..0d7862910eedd 100644
--- a/sound/soc/intel/avs/pcm.c
+++ b/sound/soc/intel/avs/pcm.c
@@ -754,6 +754,8 @@ static int avs_dai_fe_prepare(struct snd_pcm_substream *substream, struct snd_so
 	data = snd_soc_dai_get_dma_data(dai, substream);
 	host_stream = data->host_stream;
 
+	if (runtime->state == SNDRV_PCM_STATE_XRUN)
+		hdac_stream(host_stream)->prepared = false;
 	if (hdac_stream(host_stream)->prepared)
 		return 0;
 
-- 
2.51.0



